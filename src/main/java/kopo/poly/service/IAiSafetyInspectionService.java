package kopo.poly.service;

import kopo.poly.dto.request.AnalysisRequestDTO;
import kopo.poly.entity.AiSafetyInspection;

import java.util.List;

public interface IAiSafetyInspectionService {

    AiSafetyInspection requestAnalysis(AnalysisRequestDTO request);

    AiSafetyInspection getById(Long id);

    List<AiSafetyInspection> findByRequestedBy(Long requestedBy);

    // 리포트 헤더에 담당자 실명을 보여주기 위한 조회
    String resolveUserName(Long userId);
}
