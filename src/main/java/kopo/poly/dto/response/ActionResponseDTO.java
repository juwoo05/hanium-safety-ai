package kopo.poly.dto.response;

import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record ActionResponseDTO(
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
        LocalDateTime discoveredAt,
        String location,
        Long reporterId,
        String reporterName,
        LocalDateTime updatedAt,
        String thumbnailUrl
) {
    public static ActionResponseDTO from(SafetyAction action) {
        return from(action, null);
    }

    public static ActionResponseDTO from(SafetyAction action, String reporterName) {
        return new ActionResponseDTO(
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
                action.getDiscoveredAt(),
                action.getInspection() != null ? action.getInspection().getLocation() : action.getLocation(),
                action.getReporterId(),
                reporterName,
                action.getUpdatedAt(),
                firstImageUrl(action)
        );
    }

    private static String firstImageUrl(SafetyAction action) {
        if (action.getInspection() == null || action.getInspection().getImageUrls() == null
                || action.getInspection().getImageUrls().isEmpty()) {
            return null;
        }
        return action.getInspection().getImageUrls().get(0);
    }
}
