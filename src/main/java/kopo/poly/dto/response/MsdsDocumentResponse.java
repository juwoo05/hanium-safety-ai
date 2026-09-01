package kopo.poly.dto.response;

import kopo.poly.entity.MsdsDocument;
import kopo.poly.entity.enums.MsdsSourceType;

import java.time.LocalDate;
import java.time.LocalDateTime;

// 점검/조치에 첨부되어 저장된 MSDS 문서 응답.
public record MsdsDocumentResponse(
        Long id,
        Long inspectionId,
        Long safetyActionId,
        String chemicalName,
        String casNo,
        String productName,
        MsdsSourceType sourceType,
        String sourceTypeLabel,
        String sourceName,
        String sourceUrl,
        String documentUrl,
        LocalDate revisionDate,
        int confidence,
        boolean verified,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
    public static MsdsDocumentResponse from(MsdsDocument d) {
        MsdsSourceType type = d.getSourceType() != null ? d.getSourceType() : MsdsSourceType.UNKNOWN;
        return new MsdsDocumentResponse(
                d.getId(),
                d.getInspection() != null ? d.getInspection().getId() : null,
                d.getSafetyActionId(),
                d.getChemicalName(),
                d.getCasNo(),
                d.getProductName(),
                type,
                type.getLabel(),
                d.getSourceName(),
                d.getSourceUrl(),
                d.getDocumentUrl(),
                d.getRevisionDate(),
                d.getConfidence(),
                d.isVerified(),
                d.getCreatedAt(),
                d.getUpdatedAt()
        );
    }
}
