package kopo.poly.service;

// FastAPI AI 파이프라인(ai-pipeline) 호출 실패 시 던지는 예외.
public class AiPipelineException extends RuntimeException {

    public AiPipelineException(String message) {
        super(message);
    }

    public AiPipelineException(String message, Throwable cause) {
        super(message, cause);
    }
}
