package kopo.poly.dto.request;

// ai-pipeline/schemas.py의 EvidenceRequest와 1:1 대응
public record EvidenceRequestDto(
        String query,
        String category
) {
}
