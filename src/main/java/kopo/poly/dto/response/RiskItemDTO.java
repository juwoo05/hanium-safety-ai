package kopo.poly.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

// ai-pipeline/schemas.py의 RiskItem과 1:1 대응
public record RiskItemDTO(
        @JsonProperty("risk_name") String riskName,
        @JsonProperty("legal_basis") String legalBasis,
        @JsonProperty("action_required") String actionRequired
) {
}
