package kopo.poly.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

// FastAPI POST /analyze 요청 (ai-pipeline/schemas.py의 AnalyzeRequest와 1:1 대응, snake_case)
public record AnalyzeRequestDto(
        @JsonProperty("site_id") String siteId,
        @JsonProperty("image_s3_key") String imageS3Key,
        @JsonProperty("work_info") String workInfo
) {
}
