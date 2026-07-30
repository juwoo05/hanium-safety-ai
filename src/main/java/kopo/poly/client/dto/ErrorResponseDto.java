package kopo.poly.client.dto;

// ai-pipeline/schemas.py의 ErrorResponse와 1:1 대응 (FastAPI가 500 응답 시 내려주는 본문)
public record ErrorResponseDto(String error, String detail) {
}
