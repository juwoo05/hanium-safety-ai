package kopo.poly.client.dto;

import java.util.List;

// ai-pipeline/schemas.py의 EvidenceResponse와 1:1 대응
public record EvidenceResponseDto(
        List<EvidenceItemDto> items
) {
}
