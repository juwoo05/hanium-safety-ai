package kopo.poly.dto.response;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.enums.RiskLevel;

import java.time.LocalDateTime;
import java.util.List;

public record InspectionResponseDTO(
        Long id,
        String location,
        String workType,
        RiskLevel riskLevel,
        String aiResponseTitle,
        String aiResponseContent,
        List<String> imageUrls,
        Long requestedBy,
        String requestedByName,
        LocalDateTime createdAt
) {
    public static InspectionResponseDTO from(AiSafetyInspection inspection) {
        return from(inspection, null);
    }

    public static InspectionResponseDTO from(AiSafetyInspection inspection, String requestedByName) {
        return new InspectionResponseDTO(
                inspection.getId(),
                inspection.getLocation(),
                inspection.getWorkType(),
                inspection.getRiskLevel(),
                inspection.getAiResponseTitle(),
                inspection.getAiResponseContent(),
                inspection.getImageUrls(),
                inspection.getRequestedBy(),
                requestedByName,
                inspection.getCreatedAt()
        );
    }
}
