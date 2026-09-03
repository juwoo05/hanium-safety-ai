package kopo.poly.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;

// FastAPI POST /msds/detect 요청 (ai-pipeline/schemas.py의 MsdsDetectRequest와 1:1 대응, snake_case)
public record MsdsDetectRequestDTO(
        @JsonProperty("image_s3_key") String imageS3Key,
        @JsonProperty("work_info") String workInfo
) {
}
