package kopo.poly.dto.response;

import java.util.List;

// ai-pipeline/schemas.py의 EvidenceResponse와 1:1 대응
public record EvidenceResponseDTO(
        List<EvidenceItemDTO> items
) {
}
