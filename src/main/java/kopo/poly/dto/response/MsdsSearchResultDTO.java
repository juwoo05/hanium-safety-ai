package kopo.poly.dto.response;

import kopo.poly.entity.enums.MsdsSourceType;

import java.time.LocalDate;

// MSDS provider(KOSHA/제조사/내부/mock)가 반환하는 검색 결과 1건.
// 화면에는 물질명, CAS No., 개정일, 출처명, 문서 URL, 신뢰도, 확인 상태를 보여준다.
public record MsdsSearchResultDTO(
        String chemicalName,
        String casNo,
        String productName,
        MsdsSourceType sourceType,
        String sourceName,
        String sourceUrl,
        String documentUrl,
        LocalDate revisionDate,
        int confidence,
        boolean verified
) {
}
