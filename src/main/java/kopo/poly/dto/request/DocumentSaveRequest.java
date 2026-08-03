package kopo.poly.dto.request;

import kopo.poly.entity.enums.DocumentType;

import java.util.Map;

// AI 서류 작성 화면에서 안전양식을 저장할 때 사용하는 요청.
// createdBy는 클라이언트가 위조할 수 없도록 요청 본문이 아닌 세션(LOGIN_USER_ID)에서 가져온다.
public record DocumentSaveRequest(
        Long inspectionId,
        DocumentType docType,
        Map<String, Object> formData,
        boolean aiGenerated
) {
}
