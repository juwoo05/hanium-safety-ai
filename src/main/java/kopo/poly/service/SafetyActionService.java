package kopo.poly.service;

import kopo.poly.dto.request.ActionCreateRequest;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class SafetyActionService {

    private final SafetyActionRepository safetyActionRepository;
    private final AiSafetyInspectionRepository inspectionRepository;

    public SafetyActionService(
            SafetyActionRepository safetyActionRepository,
            AiSafetyInspectionRepository inspectionRepository
    ) {
        this.safetyActionRepository = safetyActionRepository;
        this.inspectionRepository = inspectionRepository;
    }

    @Transactional
    public SafetyAction createManual(ActionCreateRequest request) {
        AiSafetyInspection inspection = request.inspectionId() != null
                ? inspectionRepository.findById(request.inspectionId())
                        .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + request.inspectionId()))
                : null;

        return safetyActionRepository.save(
                SafetyAction.builder()
                        .inspection(inspection)
                        .title(request.title())
                        .category(request.category())
                        .riskLevel(request.riskLevel())
                        .reporterId(request.reporterId())
                        .discoveredAt(request.discoveredDate().atStartOfDay())
                        .dueDate(request.dueDate())
                        .description(request.description())
                        .recommendation(request.recommendation())
                        .regulationRef(request.regulationRef())
                        .memo(request.memo())
                        .status(ActionStatus.REQUESTED)
                        .createdBy(request.createdBy())
                        .build()
        );
    }

    public List<SafetyAction> findByStatus(ActionStatus status) {
        return safetyActionRepository.findByStatus(status);
    }

    public List<SafetyAction> findByInspectionId(Long inspectionId) {
        AiSafetyInspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));
        return safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection);
    }

    // 신고 게시판(조치 기한 초과) 자동 등록 대상: 완료되지 않았는데 기한이 지난 조치
    public List<SafetyAction> findOverdue() {
        return safetyActionRepository.findByStatusNotAndDueDateBefore(ActionStatus.COMPLETED, LocalDate.now());
    }

    @Transactional
    public SafetyAction updateStatus(Long actionId, ActionStatus newStatus) {
        SafetyAction action = safetyActionRepository.findById(actionId)
                .orElseThrow(() -> new NoSuchElementException("조치를 찾을 수 없습니다: " + actionId));
        action.updateStatus(newStatus);
        return action;
    }
}
