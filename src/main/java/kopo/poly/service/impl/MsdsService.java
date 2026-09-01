package kopo.poly.service.impl;

import kopo.poly.dto.request.MsdsAttachRequest;
import kopo.poly.dto.request.MsdsDetectRequestDto;
import kopo.poly.dto.response.MsdsDetectResponseDto;
import kopo.poly.dto.response.MsdsDocumentResponse;
import kopo.poly.dto.response.MsdsSearchResultDto;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.MsdsDocument;
import kopo.poly.entity.enums.MsdsSourceType;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.MsdsDocumentRepository;
import kopo.poly.service.AiPipelineClient;
import kopo.poly.service.IMsdsService;
import kopo.poly.service.MsdsProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class MsdsService implements IMsdsService {

    private final MsdsProvider msdsProvider;
    private final AiPipelineClient aiPipelineClient;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final MsdsDocumentRepository msdsDocumentRepository;

    public MsdsService(
            MsdsProvider msdsProvider,
            AiPipelineClient aiPipelineClient,
            AiSafetyInspectionRepository inspectionRepository,
            MsdsDocumentRepository msdsDocumentRepository
    ) {
        this.msdsProvider = msdsProvider;
        this.aiPipelineClient = aiPipelineClient;
        this.inspectionRepository = inspectionRepository;
        this.msdsDocumentRepository = msdsDocumentRepository;
    }

    @Override
    public MsdsDetectResponseDto detectFromImage(String imageS3Key, String workInfo) {
        if (imageS3Key == null || imageS3Key.isBlank()) {
            return new MsdsDetectResponseDto(List.of(), List.of());
        }
        return aiPipelineClient.detectMsds(new MsdsDetectRequestDto(imageS3Key, workInfo != null ? workInfo : ""));
    }

    @Override
    public MsdsDetectResponseDto detectFromInspection(Long inspectionId) {
        AiSafetyInspection inspection = getInspection(inspectionId);
        String imageKey = firstImageKey(inspection);
        if (imageKey == null) {
            // 등록된 현장 사진이 없으면 AI 인식은 건너뛰고 빈 후보를 돌려준다(사용자가 직접 검색).
            return new MsdsDetectResponseDto(List.of(), List.of());
        }
        return aiPipelineClient.detectMsds(new MsdsDetectRequestDto(imageKey, inspection.getWorkType()));
    }

    @Override
    public List<MsdsSearchResultDto> search(String query) {
        if (query == null || query.isBlank()) {
            return List.of();
        }
        return msdsProvider.search(query.trim());
    }

    @Override
    @Transactional
    public MsdsDocumentResponse attach(MsdsAttachRequest request, Long createdBy) {
        if (request.chemicalName() == null || request.chemicalName().isBlank()) {
            throw new IllegalArgumentException("물질명은 필수입니다.");
        }

        // inspectionId / safetyActionId 없이도 저장 가능(독립 MSDS 조회 화면에서 "내 자료함"에 담는 경우).
        AiSafetyInspection inspection = request.inspectionId() != null
                ? getInspection(request.inspectionId())
                : null;

        MsdsSourceType sourceType = request.sourceType() != null ? request.sourceType() : MsdsSourceType.UNKNOWN;

        MsdsDocument saved = msdsDocumentRepository.save(
                MsdsDocument.builder()
                        .inspection(inspection)
                        .safetyActionId(request.safetyActionId())
                        .chemicalName(request.chemicalName().trim())
                        .casNo(blankToNull(request.casNo()))
                        .productName(blankToNull(request.productName()))
                        .sourceType(sourceType)
                        .sourceName(blankToNull(request.sourceName()))
                        .sourceUrl(blankToNull(request.sourceUrl()))
                        .documentUrl(blankToNull(request.documentUrl()))
                        .revisionDate(request.revisionDate())
                        .confidence(clampConfidence(request.confidence()))
                        .verified(Boolean.TRUE.equals(request.verified()))
                        .createdBy(createdBy)
                        .build()
        );
        return MsdsDocumentResponse.from(saved);
    }

    @Override
    public List<MsdsDocumentResponse> findByInspectionId(Long inspectionId) {
        AiSafetyInspection inspection = getInspection(inspectionId);
        return msdsDocumentRepository.findByInspectionOrderByCreatedAtDesc(inspection).stream()
                .map(MsdsDocumentResponse::from)
                .toList();
    }

    @Override
    public List<MsdsDocumentResponse> findMine(Long createdBy) {
        return msdsDocumentRepository.findByCreatedByOrderByCreatedAtDesc(createdBy).stream()
                .map(MsdsDocumentResponse::from)
                .toList();
    }

    @Override
    @Transactional
    public MsdsDocumentResponse setVerified(Long msdsId, boolean verified) {
        MsdsDocument doc = msdsDocumentRepository.findById(msdsId)
                .orElseThrow(() -> new NoSuchElementException("MSDS 문서를 찾을 수 없습니다: " + msdsId));
        doc.markVerified(verified);
        return MsdsDocumentResponse.from(doc);
    }

    private AiSafetyInspection getInspection(Long inspectionId) {
        return inspectionRepository.findById(inspectionId)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + inspectionId));
    }

    private String firstImageKey(AiSafetyInspection inspection) {
        List<String> urls = inspection.getImageUrls();
        return (urls != null && !urls.isEmpty()) ? urls.get(0) : null;
    }

    private static String blankToNull(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    private static int clampConfidence(Integer confidence) {
        if (confidence == null) {
            return 0;
        }
        return Math.max(0, Math.min(100, confidence));
    }
}
