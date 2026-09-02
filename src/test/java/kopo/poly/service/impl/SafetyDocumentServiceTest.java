package kopo.poly.service.impl;

import kopo.poly.dto.request.DocumentSaveRequestDTO;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.Site;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.DocumentType;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.SafetyDocumentRepository;
import kopo.poly.repository.SiteMembershipRepository;
import kopo.poly.repository.SiteRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SafetyDocumentServiceTest {

    @Mock
    private SafetyDocumentRepository safetyDocumentRepository;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private SafetyActionRepository safetyActionRepository;

    @Mock
    private SiteRepository siteRepository;

    @Mock
    private SiteMembershipRepository siteMembershipRepository;

    @InjectMocks
    private SafetyDocumentService safetyDocumentService;

    private AiSafetyInspection 리포트(RiskLevel riskLevel) {
        return AiSafetyInspection.builder()
                .id(1L)
                .location("3동 지하 1층")
                .workType("외벽 마감 작업")
                .riskLevel(riskLevel)
                .requestedBy(1L)
                .build();
    }

    private SafetyAction 조치(String title, RiskLevel riskLevel, ActionStatus status, String recommendation, String regulationRef) {
        return SafetyAction.builder()
                .title(title)
                .category("AI 자동 감지")
                .riskLevel(riskLevel)
                .discoveredAt(LocalDateTime.now())
                .dueDate(LocalDate.now().plusDays(7))
                .description(title + " 감지됨")
                .recommendation(recommendation)
                .regulationRef(regulationRef)
                .status(status)
                .createdBy(1L)
                .build();
    }

    @Test
    void 안전점검일지_초안은_저장된_조치를_점검항목으로_매핑하고_위험도로_종합결과를_결정한다() {
        AiSafetyInspection inspection = 리포트(RiskLevel.HIGH);
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of(
                조치("안전난간 미설치", RiskLevel.HIGH, ActionStatus.REQUESTED, "즉시 설치", "산안법 제38조"),
                조치("안전모 착용", RiskLevel.SAFE, ActionStatus.COMPLETED, null, null)
        ));

        Map<String, Object> draft = safetyDocumentService.buildDraft(1L, DocumentType.INSPECTION_LOG, 1L);

        assertThat(draft.get("siteName")).isEqualTo("3동 지하 1층");
        assertThat(draft.get("overallResult")).isEqualTo("불량");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) draft.get("items");
        assertThat(items).hasSize(2);
        assertThat(items.get(0).get("result")).isEqualTo("bad");
        assertThat(items.get(0).get("note")).asString().contains("권장조치: 즉시 설치");
        assertThat(items.get(1).get("result")).isEqualTo("good");
    }

    @Test
    void 조치결과보고서_초안은_완료된_조치만_완료내역에_포함하고_권장조치를_재발방지계획으로_모은다() {
        AiSafetyInspection inspection = 리포트(RiskLevel.MEDIUM);
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of(
                조치("임시 배선 노출", RiskLevel.HIGH, ActionStatus.COMPLETED, "배선 보호 커버 설치", "전기사업법 제67조"),
                조치("안전모 미착용", RiskLevel.MEDIUM, ActionStatus.REQUESTED, "착용 교육 강화", null)
        ));

        Map<String, Object> draft = safetyDocumentService.buildDraft(1L, DocumentType.ACTION_REPORT, 1L);

        assertThat(draft.get("completedAction")).asString().contains("임시 배선 노출").doesNotContain("안전모 미착용");
        assertThat(draft.get("preventionPlan")).asString().contains("배선 보호 커버 설치").contains("착용 교육 강화");
    }

    @Test
    void 작업허가서_초안은_현장정보와_근거법규를_안전주의사항에_담는다() {
        AiSafetyInspection inspection = 리포트(RiskLevel.HIGH);
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of(
                조치("안전난간 미설치", RiskLevel.HIGH, ActionStatus.REQUESTED, null, "산안법 제38조")
        ));

        Map<String, Object> draft = safetyDocumentService.buildDraft(1L, DocumentType.WORK_PERMIT, 1L);

        assertThat(draft.get("workType")).isEqualTo("외벽 마감 작업");
        assertThat(draft.get("workScope")).isEqualTo("3동 지하 1층");
        assertThat(draft.get("safetyPrecaution")).asString().contains("산안법 제38조");
    }

    @Test
    void TBM일지_초안은_현장정보와_위험요소를_요약필드로_채운다() {
        AiSafetyInspection inspection = 리포트(RiskLevel.MEDIUM);
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of(
                조치("안전난간 미설치", RiskLevel.HIGH, ActionStatus.REQUESTED, "즉시 설치", "산안법 제38조")
        ));

        Map<String, Object> draft = safetyDocumentService.buildDraft(1L, DocumentType.TBM_LOG, 1L);

        assertThat(draft.get("siteName")).isEqualTo("3동 지하 1층");
        assertThat(draft.get("subType")).isEqualTo("작업 전");
        assertThat(draft.get("summary")).asString().contains("외벽 마감 작업").contains("안전난간 미설치");
        assertThat(draft.get("note")).asString().contains("즉시 설치");
    }

    @Test
    void 신규_서류타입_초안도_예외없이_최소필드를_반환한다() {
        AiSafetyInspection inspection = 리포트(RiskLevel.SAFE);
        when(inspectionRepository.findById(1L)).thenReturn(Optional.of(inspection));
        when(safetyActionRepository.findByInspectionOrderByCreatedAtDesc(inspection)).thenReturn(List.of());

        for (DocumentType type : List.of(
                DocumentType.SAFETY_EDU_LOG, DocumentType.PPE_ISSUE_LOG, DocumentType.SAFETY_EXPENSE_LOG)) {
            Map<String, Object> draft = safetyDocumentService.buildDraft(1L, type, 1L);
            assertThat(draft.get("siteName")).isEqualTo("3동 지하 1층");
            assertThat(draft.get("summary")).asString().isNotBlank();
        }
    }

    @Test
    void 존재하지_않는_리포트로_초안을_요청하면_예외가_발생한다() {
        when(inspectionRepository.findById(999L)).thenReturn(Optional.empty());

        org.junit.jupiter.api.Assertions.assertThrows(
                java.util.NoSuchElementException.class,
                () -> safetyDocumentService.buildDraft(999L, DocumentType.INSPECTION_LOG, 1L)
        );
    }

    @Test
    void 독립서류를_다시_저장하면_새로_추가하지_않고_기존문서를_갱신한다() {
        Site site = Site.builder().id(10L).name("강남 복합시설 신축공사").ownerId(1L).build();
        SafetyDocument existing = SafetyDocument.builder()
                .id(20L)
                .site(site)
                .docType(DocumentType.TBM_LOG)
                .formData(Map.of("summary", "기존 내용"))
                .createdBy(1L)
                .build();
        DocumentSaveRequestDTO request = new DocumentSaveRequestDTO(
                null,
                10L,
                DocumentType.TBM_LOG,
                Map.of("summary", "수정 내용"),
                true
        );
        when(siteRepository.findById(10L)).thenReturn(Optional.of(site));
        when(safetyDocumentRepository.findBySiteAndDocTypeAndCreatedBy(site, DocumentType.TBM_LOG, 1L))
                .thenReturn(Optional.of(existing));

        SafetyDocument result = safetyDocumentService.save(request, 1L);

        assertThat(result.getId()).isEqualTo(20L);
        assertThat(result.getFormData()).containsEntry("summary", "수정 내용");
        assertThat(result.isAiGenerated()).isTrue();
    }

    @Test
    void 소유하거나_참여하지_않은_현장의_독립서류는_작성할_수_없다() {
        Site site = Site.builder().id(10L).name("타사 현장").ownerId(2L).build();
        when(siteRepository.findById(10L)).thenReturn(Optional.of(site));
        when(siteMembershipRepository.existsBySiteAndUserId(site, 1L)).thenReturn(false);

        org.junit.jupiter.api.Assertions.assertThrows(
                java.util.NoSuchElementException.class,
                () -> safetyDocumentService.buildStandaloneDraft(10L, DocumentType.TBM_LOG, 1L)
        );
    }

    @Test
    void 문서유형이나_내용이_없으면_저장을_거부한다() {
        DocumentSaveRequestDTO request = new DocumentSaveRequestDTO(null, 10L, null, null, false);

        org.junit.jupiter.api.Assertions.assertThrows(
                IllegalArgumentException.class,
                () -> safetyDocumentService.save(request, 1L)
        );
    }

    @Test
    void 내_보고서_상세를_조회한다() {
        SafetyDocument document = SafetyDocument.builder()
                .id(30L)
                .docType(DocumentType.ACTION_REPORT)
                .formData(Map.of("completedAction", "안전난간 설치 완료"))
                .createdBy(1L)
                .build();
        when(safetyDocumentRepository.findByIdAndCreatedBy(30L, 1L)).thenReturn(Optional.of(document));

        SafetyDocument result = safetyDocumentService.findMineById(30L, 1L);

        assertThat(result.getId()).isEqualTo(30L);
        assertThat(result.getDocType()).isEqualTo(DocumentType.ACTION_REPORT);
    }

    @Test
    void 내_보고서를_삭제한다() {
        SafetyDocument document = SafetyDocument.builder()
                .id(31L)
                .docType(DocumentType.TBM_LOG)
                .formData(Map.of("summary", "작업 전 TBM"))
                .createdBy(1L)
                .build();
        when(safetyDocumentRepository.findByIdAndCreatedBy(31L, 1L)).thenReturn(Optional.of(document));

        safetyDocumentService.deleteMine(31L, 1L);

        verify(safetyDocumentRepository).delete(document);
    }
}
