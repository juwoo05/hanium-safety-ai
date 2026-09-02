package kopo.poly.dto.response;

import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.enums.DocumentType;

import java.time.LocalDateTime;
import java.util.Map;

public record DocumentResponseDTO(
        Long id,
        Long inspectionId,
        Long siteId,
        String location,
        DocumentType docType,
        Map<String, Object> formData,
        boolean aiGenerated,
        LocalDateTime updatedAt
) {
    public static DocumentResponseDTO from(SafetyDocument document) {
        return new DocumentResponseDTO(
                document.getId(),
                document.getInspection() != null ? document.getInspection().getId() : null,
                document.getSite() != null ? document.getSite().getId() : null,
                document.getInspection() != null
                        ? document.getInspection().getLocation()
                        : document.getSite() != null ? document.getSite().getName() : null,
                document.getDocType(),
                document.getFormData(),
                document.isAiGenerated(),
                document.getUpdatedAt()
        );
    }
}
