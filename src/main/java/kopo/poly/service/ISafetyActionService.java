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

    SafetyAction updateStatus(Long actionId, ActionStatus newStatus);
}
