package kopo.poly.dto.response;

import kopo.poly.client.dto.EvidenceItemDto;

public record EvidenceItemResponse(
        String title,
        String snippet,
        String source,
        String category,
        int relevance
) {
    public static EvidenceItemResponse from(EvidenceItemDto dto) {
        return new EvidenceItemResponse(dto.title(), dto.snippet(), dto.source(), dto.category(), dto.relevance());
    }
}
