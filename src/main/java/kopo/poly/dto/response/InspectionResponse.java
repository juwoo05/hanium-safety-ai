package kopo.poly.dto.response;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.enums.RiskLevel;

import java.time.LocalDateTime;
import java.util.List;

public record InspectionResponse(
        Long id,
        String location,
        String workType,
        RiskLevel riskLevel,
        String aiResponseTitle,
        String aiResponseContent,
        List<String> imageUrls,
        Long requestedBy,
        LocalDateTime createdAt
) {
    public static InspectionResponse from(AiSafetyInspection inspection) {
        return new InspectionResponse(
                inspection.getId(),
                inspection.getLocation(),
                inspection.getWorkType(),
                inspection.getRiskLevel(),
                inspection.getAiResponseTitle(),
                inspection.getAiResponseContent(),
                inspection.getImageUrls(),
                inspection.getRequestedBy(),
                inspection.getCreatedAt()
        );
    }
}
