package kopo.poly.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import kopo.poly.dto.response.WeatherResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

// 기상청 단기예보 조회서비스(공공데이터포털, VilageFcstInfoService_2.0) 연동.
// 대시보드에 서울(고정 격자좌표) 오늘 날씨 요약만 보여주면 되므로, 가장 가까운 예보 시각 한 슬롯과
// 오늘의 최고/최저기온만 뽑아 간단히 정리한다.
@Slf4j
@Component
public class WeatherClient {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.BASIC_ISO_DATE;
    private static final int[] BASE_HOURS = {2, 5, 8, 11, 14, 17, 20, 23};

    private final RestClient weatherRestClient;
    private final String serviceKey;
    private final int nx;
    private final int ny;
    private final ObjectMapper objectMapper = JsonMapper.builder()
            .enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
            .disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
            .build();

    public WeatherClient(
            RestClient weatherRestClient,
            @Value("${weather.api.key}") String serviceKey,
            @Value("${weather.api.nx}") int nx,
            @Value("${weather.api.ny}") int ny
    ) {
        this.weatherRestClient = weatherRestClient;
        this.serviceKey = serviceKey;
        this.nx = nx;
        this.ny = ny;
    }

    public WeatherResponse getTodayForecast() {
        LocalDateTime baseDateTime = LocalDateTime.now().minusMinutes(10);
        String baseDate = resolveBaseDate(baseDateTime);
        String baseTime = resolveBaseTime(baseDateTime);

        String raw;
        try {
            raw = weatherRestClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/getVilageFcst")
                            .queryParam("authKey", serviceKey)
                            .queryParam("pageNo", 1)
                            .queryParam("numOfRows", 1000)
                            .queryParam("dataType", "JSON")
                            .queryParam("base_date", baseDate)
                            .queryParam("base_time", baseTime)
                            .queryParam("nx", nx)
                            .queryParam("ny", ny)
                            .build())
                    .retrieve()
                    .body(String.class);
        } catch (RestClientException e) {
            log.warn("기상청 단기예보 서비스 호출 실패", e);
            throw new WeatherException("기상청 단기예보 서비스에 연결할 수 없습니다.", e);
        }

        WeatherApiResponse parsed;
        try {
            parsed = objectMapper.readValue(raw, WeatherApiResponse.class);
        } catch (Exception e) {
            throw new WeatherException("기상청 응답을 해석하지 못했습니다.", e);
        }

        Header header = parsed.response() != null ? parsed.response().header() : null;
        if (header != null && header.resultCode() != null && !"00".equals(header.resultCode())) {
            throw new WeatherException("기상청 서비스 오류: " + header.resultMsg());
        }

        Body body = parsed.response() != null ? parsed.response().body() : null;
        List<WeatherItem> items = (body != null && body.items() != null && body.items().item() != null)
                ? body.items().item()
                : List.of();
        if (items.isEmpty()) {
            throw new WeatherException("기상청 예보 데이터가 비어있습니다.");
        }

        // fcstDate+fcstTime 기준으로 묶은 뒤, 지금 이후로 가장 가까운 슬롯 하나를 고른다.
        Map<String, Map<String, String>> slots = new TreeMap<>();
        for (WeatherItem item : items) {
            slots.computeIfAbsent(item.fcstDate() + item.fcstTime(), k -> new LinkedHashMap<>())
                    .put(item.category(), item.fcstValue());
        }

        String nowKey = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
        String chosenKey = slots.keySet().stream()
                .filter(key -> key.compareTo(nowKey) >= 0)
                .findFirst()
                .orElse(slots.keySet().iterator().next());
        Map<String, String> chosen = slots.get(chosenKey);

        String today = LocalDate.now().format(DATE_FORMAT);
        Integer todayMax = findFirstValue(items, "TMX", today);
        Integer todayMin = findFirstValue(items, "TMN", today);

        return new WeatherResponse(
                skyConditionLabel(chosen.get("SKY")),
                precipitationTypeLabel(chosen.get("PTY")),
                parseIntOrNull(chosen.get("POP")),
                parseIntOrNull(chosen.get("TMP")),
                todayMin,
                todayMax,
                chosenKey.substring(0, 8),
                chosenKey.substring(8)
        );
    }

    private Integer findFirstValue(List<WeatherItem> items, String category, String date) {
        return items.stream()
                .filter(item -> category.equals(item.category()) && date.equals(item.fcstDate()))
                .map(item -> parseIntOrNull(item.fcstValue()))
                .filter(v -> v != null)
                .findFirst()
                .orElse(null);
    }

    private Integer parseIntOrNull(String value) {
        if (value == null) {
            return null;
        }
        try {
            return (int) Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String skyConditionLabel(String code) {
        if (code == null) return "-";
        return switch (code) {
            case "1" -> "맑음";
            case "3" -> "구름많음";
            case "4" -> "흐림";
            default -> "-";
        };
    }

    private String precipitationTypeLabel(String code) {
        if (code == null) return "없음";
        return switch (code) {
            case "0" -> "없음";
            case "1" -> "비";
            case "2" -> "비/눈";
            case "3" -> "눈";
            case "4" -> "소나기";
            default -> "없음";
        };
    }

    // 단기예보는 02,05,08,11,14,17,20,23시에 발표되고 발표 후 약 10분 뒤 조회 가능하다.
    private String resolveBaseDate(LocalDateTime reference) {
        LocalDate date = reference.toLocalDate();
        if (reference.getHour() < BASE_HOURS[0]) {
            date = date.minusDays(1);
        }
        return date.format(DATE_FORMAT);
    }

    private String resolveBaseTime(LocalDateTime reference) {
        int hour = reference.getHour();
        int chosen = BASE_HOURS[BASE_HOURS.length - 1];
        for (int i = BASE_HOURS.length - 1; i >= 0; i--) {
            if (BASE_HOURS[i] <= hour) {
                chosen = BASE_HOURS[i];
                break;
            }
        }
        return String.format("%02d00", chosen);
    }

    // 기상청 응답 JSON 파싱 전용 내부 구조 (data.go.kr 공통 response/header/body 포맷)
    private record WeatherApiResponse(Response response) {
    }

    private record Response(Header header, Body body) {
    }

    private record Header(String resultCode, String resultMsg) {
    }

    private record Body(Items items) {
    }

    private record Items(List<WeatherItem> item) {
    }

    private record WeatherItem(String baseDate, String baseTime, String category,
                                String fcstDate, String fcstTime, String fcstValue) {
    }
}
