package kopo.poly.dto.request;

import kopo.poly.entity.enums.RiskLevel;

import java.time.LocalDate;

// Wizard Steps 5단계(조치 등록)에서 현장관리자가 직접 입력한 조치 사항.
// AI가 자동 생성한 조치(AiSafetyInspectionService)와 달리 사람이 수동으로 등록하는 경로다.
public record ActionCreateRequest(
        Long inspectionId,
        String title,
        String category,
        RiskLevel riskLevel,
        Long reporterId,
        LocalDate discoveredDate,
        LocalDate dueDate,
        String description,
        String recommendation,
        String regulationRef,
        String memo,
        String location,
        Long createdBy
) {
}
