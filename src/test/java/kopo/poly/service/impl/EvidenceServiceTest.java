package kopo.poly.service.impl;

import kopo.poly.dto.EvidenceItemDto;
import kopo.poly.dto.EvidenceRequestDto;
import kopo.poly.dto.EvidenceResponseDto;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.service.AiPipelineClient;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EvidenceServiceTest {

    @Mock
    private AiPipelineClient aiPipelineClient;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private SafetyActionRepository safetyActionRepository;

    @InjectMocks
    private EvidenceService evidenceService;

    @Test
    void 저장된_조치_제목들을_검색어로_묶어서_FastAPI에_증거자료를_요청한다() {
        AiSafetyInspection inspection = AiSafetyInspection.builder()
                .id(1L).location("3동 지하 1층").workType("외벽 마감 작업")
                .riskLevel(RiskLevel.HIGH).requestedBy(1L).build();
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));

        SafetyAction action = SafetyAction.builder()
                .title("안전난간 미설치").category("AI 자동 감지").riskLevel(RiskLevel.HIGH)
                .discoveredAt(LocalDateTime.now()).dueDate(LocalDate.now().plusDays(7))
                .description("설치 안 됨").status(ActionStatus.REQUESTED).createdBy(1L).build();
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of(action));

        EvidenceItemDto item = new EvidenceItemDto("산업안전보건법", "요약", "산업안전보건법", "law", 98);
        when(aiPipelineClient.searchEvidence(org.mockito.ArgumentMatchers.any()))
                .thenReturn(new EvidenceResponseDto(List.of(item)));

        List<EvidenceItemDto> result = evidenceService.searchForInspection(1L, "law");

        ArgumentCaptor<EvidenceRequestDto> captor = ArgumentCaptor.forClass(EvidenceRequestDto.class);
        verify(aiPipelineClient).searchEvidence(captor.capture());
        assertThat(captor.getValue().query()).contains("안전난간 미설치");
        assertThat(captor.getValue().category()).isEqualTo("law");
        assertThat(result).containsExactly(item);
    }

    @Test
    void 존재하지_않는_리포트를_조회하면_예외가_발생한다() {
        when(inspectionRepository.findById(999L)).thenReturn(Optional.empty());

        org.junit.jupiter.api.Assertions.assertThrows(
                java.util.NoSuchElementException.class,
                () -> evidenceService.searchForInspection(999L, "law")
        );
    }
}
