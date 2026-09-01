package kopo.poly.dto.request;

import kopo.poly.entity.enums.MsdsSourceType;

import java.time.LocalDate;

// 검색/선택한 MSDS를 특정 점검(inspection) 또는 조치(safetyActionId)에 첨부할 때 사용.
// createdBy는 클라이언트가 위조할 수 없도록 요청 본문이 아닌 세션(LOGIN_USER_ID)에서 가져온다.
public record MsdsAttachRequest(
        Long inspectionId,
        Long safetyActionId,
        String chemicalName,
        String casNo,
        String productName,
        MsdsSourceType sourceType,
        String sourceName,
        String sourceUrl,
        String documentUrl,
        LocalDate revisionDate,
        Integer confidence,
        Boolean verified
) {
}
