package kopo.poly.client;

import kopo.poly.client.dto.AnalyzeRequestDto;
import kopo.poly.client.dto.AnalyzeResponseDto;
import kopo.poly.client.dto.ErrorResponseDto;
import kopo.poly.client.dto.EvidenceRequestDto;
import kopo.poly.client.dto.EvidenceResponseDto;
import kopo.poly.client.dto.UploadResponseDto;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Component
public class AiPipelineClient {

    private final RestClient aiPipelineRestClient;

    public AiPipelineClient(RestClient aiPipelineRestClient) {
        this.aiPipelineRestClient = aiPipelineRestClient;
    }

    public AnalyzeResponseDto analyze(AnalyzeRequestDto request) {
        try {
            return aiPipelineRestClient.post()
                    .uri("/analyze")
                    .body(request)
                    .retrieve()
                    .body(AnalyzeResponseDto.class);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("AI 분석 요청이 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            // FastAPI 서버 자체에 연결이 안 되는 경우(미기동, 네트워크 문제 등)
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    public EvidenceResponseDto searchEvidence(EvidenceRequestDto request) {
        try {
            return aiPipelineRestClient.post()
                    .uri("/evidence")
                    .body(request)
                    .retrieve()
                    .body(EvidenceResponseDto.class);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("증거자료 검색이 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    public UploadResponseDto upload(MultipartFile file) {
        try {
            MultipartBodyBuilder builder = new MultipartBodyBuilder();
            builder.part("file", file.getBytes())
                    .filename(file.getOriginalFilename())
                    .contentType(MediaType.APPLICATION_OCTET_STREAM);

            return aiPipelineRestClient.post()
                    .uri("/upload")
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(builder.build())
                    .retrieve()
                    .body(UploadResponseDto.class);
        } catch (IOException e) {
            throw new AiPipelineException("업로드할 파일을 읽는 중 오류가 발생했습니다: " + e.getMessage(), e);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("사진 업로드가 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    private String extractDetail(RestClientResponseException e) {
        try {
            ErrorResponseDto error = e.getResponseBodyAs(ErrorResponseDto.class);
            return error != null ? error.error() + " - " + error.detail() : e.getMessage();
        } catch (Exception parseFailure) {
            return e.getMessage();
        }
    }
}
