package kopo.poly.service;

import kopo.poly.dto.request.ActionCreateRequest;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;

import java.util.List;

public interface ISafetyActionService {

    SafetyAction createManual(ActionCreateRequest request);

    List<SafetyAction> findByStatus(ActionStatus status);

    // 조치 관리 목록 화면의 필터/검색. 파라미터가 전부 null이면 전체 조치를 최신순으로 반환한다.
    List<SafetyAction> search(String keyword, ActionStatus status, RiskLevel riskLevel, String siteName);

    // 담당자 실명을 보여주기 위한 조회
    String resolveUserName(Long userId);

    List<SafetyAction> findByInspectionId(Long inspectionId);

    // 신고 게시판(조치 기한 초과) 자동 등록 대상: 완료되지 않았는데 기한이 지난 조치
    List<SafetyAction> findOverdue();

    // REQUESTED/IN_PROGRESS/PENDING_APPROVAL 사이 이동만 허용. COMPLETED는 승인 절차(approveCompletion)로만 도달 가능.
    SafetyAction updateStatus(Long actionId, ActionStatus newStatus);

    SafetyAction findById(Long actionId);

    // 하청: 조치를 마치고 원청 승인을 요청한다. IN_PROGRESS 상태에서만 가능.
    SafetyAction submitForApproval(Long actionId);

    // 원청: 승인 요청을 승인해 완료 처리한다. PENDING_APPROVAL 상태에서만 가능.
    SafetyAction approveCompletion(Long actionId);

    // 원청: 승인 요청을 반려해 다시 진행중으로 되돌린다. PENDING_APPROVAL 상태에서만 가능.
    SafetyAction rejectCompletion(Long actionId);

    // 조치 항목을 영구 삭제한다. 되돌릴 수 없으므로 호출부에서 신중히 사용할 것.
    void delete(Long actionId);
}
