package kopo.poly.service.impl;

import kopo.poly.dto.response.EvidenceItemDto;
import kopo.poly.dto.request.EvidenceRequestDto;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.service.AiPipelineClient;
import kopo.poly.service.IEvidenceService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class EvidenceService implements IEvidenceService {

    private final AiPipelineClient aiPipelineClient;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final SafetyActionRepository safetyActionRepository;

    public EvidenceService(
            AiPipelineClient aiPipelineClient,
            AiSafetyInspectionRepository inspectionRepository,
            SafetyActionRepository safetyActionRepository
    ) {
        this.aiPipelineClient = aiPipelineClient;
        this.inspectionRepository = inspectionRepository;
        this.safetyActionRepository = safetyActionRepository;
    }

    // 해당 리포트에서 AI가 감지한 위험요소명을 검색어로 삼아 KB에서 관련 법규/사고사례/지침을 찾는다.
    @Override
    public List<EvidenceItemDto> searchForInspection(Long inspectionId, String category) {
        AiSafetyInspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));

        String query = buildQuery(inspection);
        return aiPipelineClient.searchEvidence(new EvidenceRequestDto(query, category)).items();
    }

    private String buildQuery(AiSafetyInspection inspection) {
        List<SafetyAction> actions = safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection);
        String riskNames = actions.stream().map(SafetyAction::getTitle).collect(Collectors.joining(", "));

        StringBuilder query = new StringBuilder();
        if (!riskNames.isBlank()) {
            query.append(riskNames).append(" ");
        } else if (inspection.getAiResponseTitle() != null) {
            query.append(inspection.getAiResponseTitle()).append(" ");
        }
        query.append(inspection.getWorkType());
        return query.toString().trim();
    }
}
