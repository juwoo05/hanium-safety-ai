package kopo.poly.controller.api;

import kopo.poly.client.AiPipelineClient;
import kopo.poly.dto.response.UploadResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

// 브라우저 → Spring → FastAPI(/upload) → S3로 사진을 올리는 프록시.
// FastAPI의 INTERNAL_API_KEY를 브라우저에 노출하지 않기 위해 Spring이 중계한다.
@RestController
public class UploadApiController {

    private final AiPipelineClient aiPipelineClient;

    public UploadApiController(AiPipelineClient aiPipelineClient) {
        this.aiPipelineClient = aiPipelineClient;
    }

    @PostMapping("/api/uploads")
    public UploadResponse upload(@RequestParam("file") MultipartFile file) {
        return new UploadResponse(aiPipelineClient.upload(file).s3Key());
    }
}
