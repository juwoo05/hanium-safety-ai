package kopo.poly.service;

import kopo.poly.dto.request.ActionCreateRequest;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.specification.SafetyActionSpecifications;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class SafetyActionService {

    private final SafetyActionRepository safetyActionRepository;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final UserRepository userRepository;

    public SafetyActionService(
            SafetyActionRepository safetyActionRepository,
            AiSafetyInspectionRepository inspectionRepository,
            UserRepository userRepository
    ) {
        this.safetyActionRepository = safetyActionRepository;
        this.inspectionRepository = inspectionRepository;
        this.userRepository = userRepository;
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
                        .location(inspection == null ? request.location() : null)
                        .status(ActionStatus.REQUESTED)
                        .createdBy(request.createdBy())
                        .build()
        );
    }

    public List<SafetyAction> findByStatus(ActionStatus status) {
        return safetyActionRepository.findByStatus(status);
    }

    // 조치 관리 목록 화면의 필터/검색. 파라미터가 전부 null이면 전체 조치를 최신순으로 반환한다.
    public List<SafetyAction> search(String keyword, ActionStatus status, RiskLevel riskLevel, String siteName) {
        return safetyActionRepository.findAll(
                SafetyActionSpecifications.search(keyword, status, riskLevel, siteName),
                Sort.by(Sort.Direction.DESC, "createdAt")
        );
    }

    // 리포트 헤더와 동일한 이유로, 담당자 실명을 보여주려면 users 테이블을 별도 조회해야 한다.
    public String resolveUserName(Long userId) {
        return userId == null ? null : userRepository.findById(userId).map(User::getUsername).orElse(null);
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
