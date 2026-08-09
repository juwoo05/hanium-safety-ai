package kopo.poly.dto.response;

// ai-pipeline/schemas.py의 EvidenceItem과 1:1 대응
public record EvidenceItemDto(
        String title,
        String snippet,
        String source,
        String category,
        int relevance
) {
}
