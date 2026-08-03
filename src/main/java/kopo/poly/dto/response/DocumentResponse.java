package kopo.poly.dto.response;

import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.enums.DocumentType;

import java.time.LocalDateTime;
import java.util.Map;

public record DocumentResponse(
        Long id,
        Long inspectionId,
        DocumentType docType,
        Map<String, Object> formData,
        boolean aiGenerated,
        LocalDateTime updatedAt
) {
    public static DocumentResponse from(SafetyDocument document) {
        return new DocumentResponse(
                document.getId(),
                document.getInspection() != null ? document.getInspection().getId() : null,
                document.getDocType(),
                document.getFormData(),
                document.isAiGenerated(),
                document.getUpdatedAt()
        );
    }
}
