package kopo.poly.dto.response;

// ai-pipeline/schemas.py의 ErrorResponse와 1:1 대응 (FastAPI가 500 응답 시 내려주는 본문)
public record ErrorResponseDTO(String error, String detail) {
}
