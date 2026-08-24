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

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

// 기상청 API허브(apihub.kma.go.kr) 초단기예보 조회(getUltraSrtFcst) 연동.
// 이 계정은 아직 단기예보(getVilageFcst)는 활용신청이 안 되어 있고 초단기예보만 승인된 상태라,
// 향후 6시간 이내 예보만 제공하는 이 오퍼레이션을 사용한다. 일 최저/최고기온·강수확률은
// 이 오퍼레이션에 없는 항목이라 응답에 포함하지 않는다.
@Slf4j
@Component
public class WeatherClient {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.BASIC_ISO_DATE;

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
        // 초단기예보는 매시 30분에 발표되고 약 10~15분 뒤 조회 가능하다.
        LocalDateTime baseDateTime = LocalDateTime.now().minusMinutes(45);
        String baseDate = baseDateTime.format(DATE_FORMAT);
        String baseTime = String.format("%02d30", baseDateTime.getHour());

        String raw;
        try {
            raw = weatherRestClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/getUltraSrtFcst")
                            .queryParam("authKey", serviceKey)
                            .queryParam("pageNo", 1)
                            .queryParam("numOfRows", 100)
                            .queryParam("dataType", "JSON")
                            .queryParam("base_date", baseDate)
                            .queryParam("base_time", baseTime)
                            .queryParam("nx", nx)
                            .queryParam("ny", ny)
                            .build())
                    .retrieve()
                    .body(String.class);
        } catch (RestClientException e) {
            // RestClientException 메시지/스택트레이스에는 인증키가 담긴 요청 URL이 그대로 포함되므로
            // 예외 객체나 e.getMessage()를 로그에 남기지 않고 예외 종류만 남긴다.
            log.warn("기상청 초단기예보 서비스 호출 실패: {}", e.getClass().getSimpleName());
            throw new WeatherException("기상청 초단기예보 서비스에 연결할 수 없습니다.");
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

        return new WeatherResponse(
                skyConditionLabel(chosen.get("SKY")),
                precipitationTypeLabel(chosen.get("PTY")),
                chosen.getOrDefault("RN1", "-"),
                parseIntOrNull(chosen.get("T1H")),
                chosenKey.substring(0, 8),
                chosenKey.substring(8)
        );
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
            case "5" -> "빗방울";
            case "6" -> "빗방울눈날림";
            case "7" -> "눈날림";
            default -> "없음";
        };
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
