package kopo.poly.service;

import kopo.poly.dto.request.DocumentSaveRequest;
import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.enums.DocumentType;

import java.util.List;
import java.util.Map;

public interface ISafetyDocumentService {

    // 같은 리포트·같은 양식 종류는 최신 내용으로 덮어써서 저장(업서트)한다.
    SafetyDocument save(DocumentSaveRequest request, Long createdBy);

    List<SafetyDocument> findByInspectionId(Long inspectionId);

    // "보고서" 메뉴 진입 시 이전에 작성해둔 보고서 목록을 보여주기 위한 조회
    List<SafetyDocument> findMine(Long userId);

    // "AI 자동 작성" 버튼: 이 리포트에 실제로 저장된 감지 위험요소/조치 데이터를 양식 필드로 매핑한다.
    Map<String, Object> buildDraft(Long inspectionId, DocumentType docType);
}
