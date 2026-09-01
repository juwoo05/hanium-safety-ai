package kopo.poly.service.impl;

import kopo.poly.dto.request.MsdsAttachRequest;
import kopo.poly.dto.response.ChemicalCandidateDto;
import kopo.poly.dto.response.MsdsDetectResponseDto;
import kopo.poly.dto.response.MsdsDocumentResponse;
import kopo.poly.dto.response.MsdsSearchResultDto;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.MsdsDocument;
import kopo.poly.entity.enums.MsdsSourceType;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.MsdsDocumentRepository;
import kopo.poly.service.AiPipelineClient;
import kopo.poly.service.MsdsProvider;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MsdsServiceTest {

    @Mock private MsdsProvider msdsProvider;
    @Mock private AiPipelineClient aiPipelineClient;
    @Mock private AiSafetyInspectionRepository inspectionRepository;
    @Mock private MsdsDocumentRepository msdsDocumentRepository;

    @InjectMocks private MsdsService msdsService;

    private AiSafetyInspection 점검(List<String> imageUrls) {
        return AiSafetyInspection.builder()
                .id(1L).promptText("p").location("3동 지하").workType("도장 작업")
                .imageUrls(imageUrls).requestedBy(1L)
                .build();
    }

    @Test
    void 업로드한_사진키로_FastAPI에_물질_인식을_요청한다() {
        MsdsDetectResponseDto expected = new MsdsDetectResponseDto(
                List.of("톨루엔"), List.of(new ChemicalCandidateDto("톨루엔", "108-88-3", "락카 신너", 88)));
        when(aiPipelineClient.detectMsds(any())).thenReturn(expected);

        MsdsDetectResponseDto result = msdsService.detectFromImage("site-photos/a.jpg", "도장 작업");

        assertThat(result.chemicalCandidates()).hasSize(1);
        assertThat(result.chemicalCandidates().get(0).casNo()).isEqualTo("108-88-3");
    }

    @Test
    void 사진키가_없으면_FastAPI를_호출하지_않고_빈_결과를_반환한다() {
        MsdsDetectResponseDto result = msdsService.detectFromImage("  ", null);

        assertThat(result.chemicalCandidates()).isEmpty();
        verify(aiPipelineClient, never()).detectMsds(any());
    }

    @Test
    void 점검_사진으로도_물질_인식을_요청한다() {
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(점검(List.of("site-photos/a.jpg"))));
        when(aiPipelineClient.detectMsds(any())).thenReturn(new MsdsDetectResponseDto(List.of(), List.of()));

        msdsService.detectFromInspection(1L);

        verify(aiPipelineClient).detectMsds(any());
    }

    @Test
    void 등록된_사진이_없으면_FastAPI를_호출하지_않고_빈_결과를_반환한다() {
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(점검(List.of())));

        MsdsDetectResponseDto result = msdsService.detectFromInspection(1L);

        assertThat(result.detectedKeywords()).isEmpty();
        assertThat(result.chemicalCandidates()).isEmpty();
        verify(aiPipelineClient, never()).detectMsds(any());
    }

    @Test
    void 검색은_provider에_위임하고_빈_검색어는_빈_목록을_반환한다() {
        when(msdsProvider.search("톨루엔")).thenReturn(List.of(new MsdsSearchResultDto(
                "톨루엔", "108-88-3", "락카 신너", MsdsSourceType.KOSHA, "안전보건공단 MSDS",
                "http://x", "http://x", null, 95, false)));

        assertThat(msdsService.search("톨루엔")).hasSize(1);
        assertThat(msdsService.search("  ")).isEmpty();
        verify(msdsProvider, never()).search("  ");
    }

    @Test
    void MSDS를_점검에_첨부하면_확인상태는_기본_false_이고_신뢰도는_0_100으로_보정된다() {
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(점검(List.of())));
        when(msdsDocumentRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        MsdsAttachRequest req = new MsdsAttachRequest(
                1L, null, "톨루엔", "108-88-3", "락카 신너",
                MsdsSourceType.KOSHA, "안전보건공단 MSDS", "http://s", "http://d", null, 250, null);

        MsdsDocumentResponse res = msdsService.attach(req, 7L);

        assertThat(res.chemicalName()).isEqualTo("톨루엔");
        assertThat(res.sourceTypeLabel()).isEqualTo("KOSHA 참고자료");
        assertThat(res.confidence()).isEqualTo(100);
        assertThat(res.verified()).isFalse();
    }

    @Test
    void 물질명이_없으면_첨부에_실패한다() {
        assertThatThrownBy(() -> msdsService.attach(
                new MsdsAttachRequest(1L, null, " ", null, null, null, null, null, null, null, null, null), 7L))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void 대상_없이도_내_자료함에_저장할_수_있다() {
        when(msdsDocumentRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        MsdsDocumentResponse res = msdsService.attach(
                new MsdsAttachRequest(null, null, "아세톤", "67-64-1", null,
                        MsdsSourceType.KOSHA, null, null, "http://d", null, 80, null), 7L);

        assertThat(res.chemicalName()).isEqualTo("아세톤");
        assertThat(res.inspectionId()).isNull();
    }

    @Test
    void 내가_저장한_MSDS_목록을_조회한다() {
        when(msdsDocumentRepository.findByCreatedByOrderByCreatedAtDesc(7L)).thenReturn(List.of(
                MsdsDocument.builder().id(1L).chemicalName("톨루엔").sourceType(MsdsSourceType.KOSHA).createdBy(7L).build()));

        assertThat(msdsService.findMine(7L)).hasSize(1);
    }

    @Test
    void 확인상태를_토글할_수_있다() {
        MsdsDocument doc = MsdsDocument.builder().id(5L).chemicalName("톨루엔").createdBy(1L).build();
        when(msdsDocumentRepository.findById(5L)).thenReturn(Optional.of(doc));

        MsdsDocumentResponse res = msdsService.setVerified(5L, true);

        assertThat(res.verified()).isTrue();
    }
}
