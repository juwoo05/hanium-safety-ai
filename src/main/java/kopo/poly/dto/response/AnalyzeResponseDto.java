package kopo.poly.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDateTime;
import java.util.List;

// ai-pipeline/schemas.py의 AnalyzeResponse와 1:1 대응
public record AnalyzeResponseDto(
        @JsonProperty("inspection_id") String inspectionId,
        @JsonProperty("risk_items") List<RiskItemDto> riskItems,
        @JsonProperty("analyzed_at") LocalDateTime analyzedAt
) {
}
