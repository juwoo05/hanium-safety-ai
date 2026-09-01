package kopo.poly.service.impl;

import kopo.poly.dto.request.DocumentSaveRequest;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.DocumentType;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.SafetyDocumentRepository;
import kopo.poly.service.ISafetyDocumentService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SafetyDocumentService implements ISafetyDocumentService {

    private final SafetyDocumentRepository safetyDocumentRepository;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final SafetyActionRepository safetyActionRepository;

    public SafetyDocumentService(
            SafetyDocumentRepository safetyDocumentRepository,
            AiSafetyInspectionRepository inspectionRepository,
            SafetyActionRepository safetyActionRepository
    ) {
        this.safetyDocumentRepository = safetyDocumentRepository;
        this.inspectionRepository = inspectionRepository;
        this.safetyActionRepository = safetyActionRepository;
    }

    // 같은 리포트·같은 양식 종류는 최신 내용으로 덮어써서 저장(업서트)한다.
    // createdBy는 컨트롤러가 세션에서 확인한 로그인 사용자 ID를 전달한다(클라이언트가 위조 불가).
    @Override
    @Transactional
    public SafetyDocument save(DocumentSaveRequest request, Long createdBy) {
        AiSafetyInspection inspection = request.inspectionId() != null
                ? inspectionRepository.findById(request.inspectionId())
                        .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + request.inspectionId()))
                : null;

        Optional<SafetyDocument> existing = inspection != null
                ? safetyDocumentRepository.findByInspectionAndDocType(inspection, request.docType())
                : Optional.empty();

        if (existing.isPresent()) {
            SafetyDocument document = existing.get();
            document.updateForm(request.formData(), request.aiGenerated());
            return document;
        }

        return safetyDocumentRepository.save(
                SafetyDocument.builder()
                        .inspection(inspection)
                        .docType(request.docType())
                        .formData(request.formData())
                        .aiGenerated(request.aiGenerated())
                        .createdBy(createdBy)
                        .build()
        );
    }

    @Override
    public List<SafetyDocument> findByInspectionId(Long inspectionId) {
        AiSafetyInspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));
        return safetyDocumentRepository.findByInspectionOrderByCreatedAtDesc(inspection);
    }

    @Override
    public List<SafetyDocument> findMine(Long userId) {
        return safetyDocumentRepository.findByCreatedByOrderByUpdatedAtDesc(userId);
    }

    // "AI 자동 작성" 버튼: 이 리포트에 실제로 저장된 감지 위험요소/조치 데이터를 양식 필드로 매핑한다.
    // 담당자명·회사명처럼 이 도메인에 저장돼 있지 않은 값은 지어내지 않고 비워둔다.
    @Override
    public Map<String, Object> buildDraft(Long inspectionId, DocumentType docType) {
        AiSafetyInspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));
        List<SafetyAction> actions = safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection);

        Map<String, Object> draft = new LinkedHashMap<>();
        draft.put("siteName", inspection.getLocation());

        switch (docType) {
            case INSPECTION_LOG -> {
                draft.put("overallResult", overallResultLabel(inspection.getRiskLevel()));
                List<Map<String, Object>> items = new ArrayList<>();
                for (SafetyAction action : actions) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("name", action.getTitle());
                    item.put("result", action.getRiskLevel() == RiskLevel.SAFE ? "good" : "bad");
                    item.put("note", buildNote(action));
                    items.add(item);
                }
                draft.put("items", items);
            }
            case RISK_ASSESSMENT -> {
                draft.put("assessmentPurpose",
                        inspection.getLocation() + " " + inspection.getWorkType()
                                + " 현장의 AI 위험요소 분석 결과를 기반으로 위험성을 평가하고 개선대책을 수립한다.");
                List<Map<String, Object>> items = new ArrayList<>();
                for (SafetyAction action : actions) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("name", action.getTitle());
                    item.put("level", action.getRiskLevel() == RiskLevel.SAFE ? "양호" : "개선 필요");
                    item.put("note", buildNote(action));
                    items.add(item);
                }
                draft.put("items", items);
            }
            case ACTION_REPORT -> {
                String completedAction = actions.stream()
                        .filter(a -> a.getStatus() == ActionStatus.COMPLETED)
                        .map(a -> a.getTitle() + ": " + a.getDescription())
                        .collect(Collectors.joining(" "));
                draft.put("completedAction", completedAction);

                String preventionPlan = actions.stream()
                        .map(SafetyAction::getRecommendation)
                        .filter(r -> r != null && !r.isBlank())
                        .distinct()
                        .collect(Collectors.joining(" "));
                draft.put("preventionPlan", preventionPlan);
            }
            case WORK_PERMIT -> {
                draft.put("workType", inspection.getWorkType());
                draft.put("workScope", inspection.getLocation());
                String safetyPrecaution = actions.stream()
                        .map(SafetyAction::getRegulationRef)
                        .filter(r -> r != null && !r.isBlank())
                        .distinct()
                        .collect(Collectors.joining(", "));
                draft.put("safetyPrecaution",
                        safetyPrecaution.isBlank()
                                ? ""
                                : "작업 전 다음 근거 법규에 따른 안전조치를 확인한다: " + safetyPrecaution);
            }
        }
        return draft;
    }

    private String overallResultLabel(RiskLevel riskLevel) {
        return switch (riskLevel) {
            case HIGH -> "불량";
            case MEDIUM -> "조치중";
            case SAFE -> "양호";
        };
    }

    private String buildNote(SafetyAction action) {
        String note = action.getDescription();
        if (action.getRecommendation() != null && !action.getRecommendation().isBlank()) {
            note += " — 권장조치: " + action.getRecommendation();
        }
        return note;
    }
}
