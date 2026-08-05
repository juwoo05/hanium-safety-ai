package kopo.poly.service;

import kopo.poly.dto.EvidenceItemDto;

import java.util.List;

public interface IEvidenceService {

    // 해당 리포트에서 AI가 감지한 위험요소명을 검색어로 삼아 KB에서 관련 법규/사고사례/지침을 찾는다.
    List<EvidenceItemDto> searchForInspection(Long inspectionId, String category);
}
