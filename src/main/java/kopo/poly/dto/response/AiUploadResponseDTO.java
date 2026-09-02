package kopo.poly.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

// ai-pipeline/schemas.py의 UploadResponse와 1:1 대응
public record AiUploadResponseDTO(@JsonProperty("s3_key") String s3Key) {
}
