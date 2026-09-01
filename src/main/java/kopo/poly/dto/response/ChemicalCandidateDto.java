package kopo.poly.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

// ai-pipeline/schemas.py의 ChemicalCandidate와 1:1 대응.
// AI가 물질을 확정하지 못하면 이 후보들을 사용자에게 보여주고 선택하게 한다.
public record ChemicalCandidateDto(
        @JsonProperty("chemical_name") String chemicalName,
        @JsonProperty("cas_no") String casNo,
        @JsonProperty("product_name") String productName,
        int confidence
) {
}
