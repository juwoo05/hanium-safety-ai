package kopo.poly.dto.response;

import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record ActionResponse(
        Long id,
        Long inspectionId,
        String title,
        String category,
        RiskLevel riskLevel,
        String description,
        String recommendation,
        String regulationRef,
        ActionStatus status,
        LocalDate dueDate,
        LocalDateTime discoveredAt
) {
    public static ActionResponse from(SafetyAction action) {
        return new ActionResponse(
                action.getId(),
                action.getInspection() != null ? action.getInspection().getId() : null,
                action.getTitle(),
                action.getCategory(),
                action.getRiskLevel(),
                action.getDescription(),
                action.getRecommendation(),
                action.getRegulationRef(),
                action.getStatus(),
                action.getDueDate(),
                action.getDiscoveredAt()
        );
    }
}
