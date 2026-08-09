package kopo.poly.repository;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.time.LocalDate;
import java.util.List;

public interface SafetyActionRepository extends JpaRepository<SafetyAction, Long>, JpaSpecificationExecutor<SafetyAction> {
    List<SafetyAction> findByInspectionOrderByCreatedAtDesc(AiSafetyInspection inspection);
    List<SafetyAction> findByStatus(ActionStatus status);

    // 신고 게시판(조치 기한 초과) 자동 등록용: 완료되지 않았는데 기한이 지난 조치 목록
    List<SafetyAction> findByStatusNotAndDueDateBefore(ActionStatus status, LocalDate date);

    // 마이페이지 활동 통계: 담당자(reporter)로 배정된 조치 목록
    List<SafetyAction> findByReporterId(Long reporterId);
}
