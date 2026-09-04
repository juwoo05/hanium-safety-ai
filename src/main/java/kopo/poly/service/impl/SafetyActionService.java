package kopo.poly.service.impl;

import kopo.poly.dto.request.ActionCreateRequestDTO;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.Site;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.SiteMembershipRepository;
import kopo.poly.repository.SiteRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.ISafetyActionService;
import kopo.poly.specification.SafetyActionSpecifications;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class SafetyActionService implements ISafetyActionService {

    private final SafetyActionRepository safetyActionRepository;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final UserRepository userRepository;
    private final SiteRepository siteRepository;
    private final SiteMembershipRepository siteMembershipRepository;

    public SafetyActionService(
            SafetyActionRepository safetyActionRepository,
            AiSafetyInspectionRepository inspectionRepository,
            UserRepository userRepository,
            SiteRepository siteRepository,
            SiteMembershipRepository siteMembershipRepository
    ) {
        this.safetyActionRepository = safetyActionRepository;
        this.inspectionRepository = inspectionRepository;
        this.userRepository = userRepository;
        this.siteRepository = siteRepository;
        this.siteMembershipRepository = siteMembershipRepository;
    }

    @Override
    @Transactional
    public SafetyAction createManual(ActionCreateRequestDTO request) {
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

    @Override
    public List<SafetyAction> findByStatus(ActionStatus status) {
        return safetyActionRepository.findByStatus(status);
    }

    // 조치 관리 목록 화면의 필터/검색. 파라미터가 전부 null이면 로그인 사용자가 볼 수 있는 범위 내 전체 조치를 최신순으로 반환한다.
    @Override
    public List<SafetyAction> search(String keyword, ActionStatus status, RiskLevel riskLevel, String siteName, Long loginUserId) {
        return safetyActionRepository.findAll(
                SafetyActionSpecifications.search(keyword, status, riskLevel, siteName)
                        .and(accessScope(loginUserId)),
                Sort.by(Sort.Direction.DESC, "createdAt")
        );
    }

    // 원청은 자신이 소유한 현장, 하청은 자신이 소속(공유 코드로 입장)된 현장 범위로만 조회하도록 제한한다.
    // 현장에 매칭 안 되는 수동 등록 조치는 담당자·등록자 본인 것만 예외적으로 허용한다.
    private Specification<SafetyAction> accessScope(Long loginUserId) {
        User user = userRepository.findById(loginUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다."));

        List<String> allowedSiteNames = user.getRole() == UserRole.하청
                ? siteMembershipRepository.findByUserIdOrderByJoinedAtDesc(loginUserId).stream()
                        .map(membership -> membership.getSite().getName())
                        .toList()
                : siteRepository.findByOwnerIdOrderByNameAsc(loginUserId).stream()
                        .map(Site::getName)
                        .toList();

        return SafetyActionSpecifications.withinAccessScope(allowedSiteNames, loginUserId);
    }

    // 리포트 헤더와 동일한 이유로, 담당자 실명을 보여주려면 users 테이블을 별도 조회해야 한다.
    @Override
    public String resolveUserName(Long userId) {
        return userId == null ? null : userRepository.findById(userId).map(User::getUsername).orElse(null);
    }

    @Override
    public List<SafetyAction> findByInspectionId(Long inspectionId) {
        AiSafetyInspection inspection = inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));
        return safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection);
    }

    // 신고 게시판(조치 기한 초과) 자동 등록 대상: 완료되지 않았는데 기한이 지난 조치
    @Override
    public List<SafetyAction> findOverdue() {
        return safetyActionRepository.findByStatusNotAndDueDateBefore(ActionStatus.COMPLETED, LocalDate.now());
    }

    @Override
    @Transactional
    public SafetyAction updateStatus(Long actionId, ActionStatus newStatus) {
        if (newStatus == ActionStatus.COMPLETED) {
            throw new IllegalArgumentException("완료 처리는 승인 절차를 통해서만 가능합니다.");
        }
        SafetyAction action = requireAction(actionId);
        action.updateStatus(newStatus);
        return action;
    }

    @Override
    public SafetyAction findById(Long actionId) {
        return requireAction(actionId);
    }

    @Override
    @Transactional
    public SafetyAction submitForApproval(Long actionId) {
        SafetyAction action = requireAction(actionId);
        if (action.getStatus() != ActionStatus.IN_PROGRESS) {
            throw new IllegalArgumentException("진행중인 조치만 승인 요청할 수 있습니다.");
        }
        action.updateStatus(ActionStatus.PENDING_APPROVAL);
        return action;
    }

    @Override
    @Transactional
    public SafetyAction approveCompletion(Long actionId) {
        SafetyAction action = requireAction(actionId);
        if (action.getStatus() != ActionStatus.PENDING_APPROVAL) {
            throw new IllegalArgumentException("승인 대기 중인 조치만 승인할 수 있습니다.");
        }
        action.updateStatus(ActionStatus.COMPLETED);
        return action;
    }

    @Override
    @Transactional
    public SafetyAction rejectCompletion(Long actionId) {
        SafetyAction action = requireAction(actionId);
        if (action.getStatus() != ActionStatus.PENDING_APPROVAL) {
            throw new IllegalArgumentException("승인 대기 중인 조치만 반려할 수 있습니다.");
        }
        action.updateStatus(ActionStatus.IN_PROGRESS);
        return action;
    }

    @Override
    @Transactional
    public void delete(Long actionId) {
        SafetyAction action = requireAction(actionId);
        safetyActionRepository.delete(action);
    }

    private SafetyAction requireAction(Long actionId) {
        return safetyActionRepository.findById(actionId)
                .orElseThrow(() -> new NoSuchElementException("조치를 찾을 수 없습니다: " + actionId));
    }
}
