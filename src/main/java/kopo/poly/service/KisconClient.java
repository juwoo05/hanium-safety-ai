package kopo.poly.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import kopo.poly.dto.response.KisconCompanyResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

// 국토교통부_키스콘 건설업체정보 서비스(공공데이터포털, ConAdminInfoSvc1/GongsiReg) 연동.
// 이 API는 사업자등록번호/업체명으로 직접 조회가 안 되고 공시기간+지역으로만 검색되므로,
// 최근 3년 공시 목록을 가져온 뒤 업체명(ncrGsKname)에 검색어가 포함되는 항목만 걸러서 돌려준다.
@Component
public class KisconClient {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.BASIC_ISO_DATE;
    private static final int NUM_OF_ROWS = 100;

    private final RestClient kisconRestClient;
    private final String serviceKey;
    private final ObjectMapper objectMapper = JsonMapper.builder()
            // data.go.kr 계열 API는 결과가 1건이면 item이 배열이 아니라 단일 객체로 내려온다.
            .enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
            // 응답에 문서화되지 않은 필드(ncrGsSeq, ncrOffTel 등)가 더 내려오므로 무시한다.
            .disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
            .build();

    public KisconClient(RestClient kisconRestClient, @Value("${kiscon.service-key}") String serviceKey) {
        this.kisconRestClient = kisconRestClient;
        this.serviceKey = serviceKey;
    }

    public List<KisconCompanyResponse> searchByCompanyName(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            throw new IllegalArgumentException("검색할 건설업체명을 입력해주세요.");
        }
        String needle = keyword.trim();

        LocalDate today = LocalDate.now();
        String eDate = today.format(DATE_FORMAT);
        String sDate = today.minusYears(3).format(DATE_FORMAT);

        String raw;
        try {
            raw = kisconRestClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/GongsiReg")
                            .queryParam("serviceKey", serviceKey)
                            .queryParam("pageNo", 1)
                            .queryParam("numOfRows", NUM_OF_ROWS)
                            .queryParam("sDate", sDate)
                            .queryParam("eDate", eDate)
                            .queryParam("_type", "json")
                            .build())
                    .retrieve()
                    .body(String.class);
        } catch (RestClientException e) {
            throw new KisconException("KISCON 서비스에 연결할 수 없습니다: " + e.getMessage(), e);
        }

        KisconApiResponse parsed;
        try {
            parsed = objectMapper.readValue(raw, KisconApiResponse.class);
        } catch (Exception e) {
            throw new KisconException("KISCON 응답을 해석하지 못했습니다.", e);
        }

        Header header = parsed.response() != null ? parsed.response().header() : null;
        if (header != null && header.resultCode() != null && !"00".equals(header.resultCode())) {
            throw new KisconException("KISCON 서비스 오류: " + header.resultMsg());
        }

        Body body = parsed.response() != null ? parsed.response().body() : null;
        List<KisconItem> items = (body != null && body.items() != null && body.items().item() != null)
                ? body.items().item()
                : List.of();

        return items.stream()
                .filter(item -> item.ncrGsKname() != null && item.ncrGsKname().contains(needle))
                .map(item -> new KisconCompanyResponse(
                        item.ncrGsKname(),
                        formatBizNo(item.ncrMasterNum()),
                        item.ncrGsMaster(),
                        item.ncrGsAddr()
                ))
                .distinct()
                .toList();
    }

    private String formatBizNo(String rawBizNo) {
        if (rawBizNo == null) {
            return null;
        }
        String digits = rawBizNo.replaceAll("[^0-9]", "");
        if (digits.length() != 10) {
            return rawBizNo;
        }
        return digits.substring(0, 3) + "-" + digits.substring(3, 5) + "-" + digits.substring(5);
    }

    // KISCON 응답 JSON 파싱 전용 내부 구조 (data.go.kr 공통 response/header/body 포맷)
    private record KisconApiResponse(Response response) {
    }

    private record Response(Header header, Body body) {
    }

    private record Header(String resultCode, String resultMsg) {
    }

    private record Body(Items items, Integer totalCount) {
    }

    private record Items(List<KisconItem> item) {
    }

    private record KisconItem(
            String ncrGsKname,
            String ncrMasterNum,
            String ncrGsMaster,
            String ncrGsAddr,
            String ncrAreaName,
            String ncrAreaDetailName,
            String ncrGsDate,
            String ncrItemName
    ) {
    }
}
