package kopo.poly.service;

import kopo.poly.dto.request.AnalyzeRequestDTO;
import kopo.poly.dto.response.AnalyzeResponseDTO;
import kopo.poly.dto.response.ErrorResponseDTO;
import kopo.poly.dto.request.EvidenceRequestDTO;
import kopo.poly.dto.response.EvidenceResponseDTO;
import kopo.poly.dto.request.MsdsDetectRequestDTO;
import kopo.poly.dto.response.MsdsDetectResponseDTO;
import kopo.poly.dto.response.AiUploadResponseDTO;
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

    public AnalyzeResponseDTO analyze(AnalyzeRequestDTO request) {
        try {
            return aiPipelineRestClient.post()
                    .uri("/analyze")
                    .body(request)
                    .retrieve()
                    .body(AnalyzeResponseDTO.class);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("AI 분석 요청이 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            // FastAPI 서버 자체에 연결이 안 되는 경우(미기동, 네트워크 문제 등)
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    public EvidenceResponseDTO searchEvidence(EvidenceRequestDTO request) {
        try {
            return aiPipelineRestClient.post()
                    .uri("/evidence")
                    .body(request)
                    .retrieve()
                    .body(EvidenceResponseDTO.class);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("증거자료 검색이 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    public MsdsDetectResponseDTO detectMsds(MsdsDetectRequestDTO request) {
        try {
            return aiPipelineRestClient.post()
                    .uri("/msds/detect")
                    .body(request)
                    .retrieve()
                    .body(MsdsDetectResponseDTO.class);
        } catch (RestClientResponseException e) {
            throw new AiPipelineException("MSDS 물질 인식이 실패했습니다: " + extractDetail(e), e);
        } catch (RestClientException e) {
            throw new AiPipelineException("AI 분석 서버에 연결할 수 없습니다: " + e.getMessage(), e);
        }
    }

    public AiUploadResponseDTO upload(MultipartFile file) {
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
                    .body(AiUploadResponseDTO.class);
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
            ErrorResponseDTO error = e.getResponseBodyAs(ErrorResponseDTO.class);
            return error != null ? error.error() + " - " + error.detail() : e.getMessage();
        } catch (Exception parseFailure) {
            return e.getMessage();
        }
    }
}
