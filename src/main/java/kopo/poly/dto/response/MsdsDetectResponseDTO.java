package kopo.poly.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

// ai-pipeline/schemas.py의 MsdsDetectResponse와 1:1 대응
public record MsdsDetectResponseDTO(
        @JsonProperty("detected_keywords") List<String> detectedKeywords,
        @JsonProperty("chemical_candidates") List<ChemicalCandidateDTO> chemicalCandidates
) {
}
