package kopo.poly.service;

import kopo.poly.dto.response.AnalyticsSummaryResponse;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AnalyticsServiceTest {

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private SafetyActionRepository safetyActionRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private AnalyticsService analyticsService;

    private SafetyAction 조치(Long createdBy, RiskLevel riskLevel, ActionStatus status, String category,
                            LocalDateTime discoveredAt, LocalDateTime updatedAt) {
        return SafetyAction.builder()
                .title("테스트 조치").category(category).riskLevel(riskLevel)
                .discoveredAt(discoveredAt).dueDate(LocalDate.now().plusDays(7))
                .description("설명").status(status).createdBy(createdBy).updatedAt(updatedAt)
                .build();
    }

    @Test
    void 완료율과_평균_조치기간과_회사별_순위를_실데이터_기준으로_계산한다() {
        LocalDateTime jan5 = LocalDateTime.of(2026, 1, 5, 9, 0);
        LocalDateTime feb1 = LocalDateTime.of(2026, 2, 1, 9, 0);

        List<SafetyAction> actions = List.of(
                조치(1L, RiskLevel.HIGH, ActionStatus.COMPLETED, "추락 위험", jan5, jan5.plusDays(2)),
                조치(1L, RiskLevel.MEDIUM, ActionStatus.COMPLETED, "전기 위험", jan5, jan5.plusDays(4)),
                조치(2L, RiskLevel.SAFE, ActionStatus.REQUESTED, "추락 위험", feb1, feb1)
        );
        when(safetyActionRepository.findAll()).thenReturn(actions);
        when(inspectionRepository.count()).thenReturn(2L);
        when(userRepository.findAllById(List.of(1L, 2L))).thenReturn(List.of(
                User.builder().id(1L).username("kim").password("x").role(UserRole.원청).companyName("(주)한국건설").build(),
                User.builder().id(2L).username("lee").password("x").role(UserRole.하청).companyName("대성철골").build()
        ));

        AnalyticsSummaryResponse result = analyticsService.summarize(2026);

        assertThat(result.totalUploads()).isEqualTo(2L);
        assertThat(result.totalDetections()).isEqualTo(3L);
        assertThat(result.completionRate()).isCloseTo(66.67, org.assertj.core.data.Offset.offset(0.01));
        assertThat(result.avgActionDays()).isEqualTo(3.0);

        assertThat(result.monthlyTrend()).hasSize(12);
        assertThat(result.monthlyTrend().get(0).high()).isEqualTo(1L);
        assertThat(result.monthlyTrend().get(0).medium()).isEqualTo(1L);
        assertThat(result.monthlyTrend().get(1).safe()).isEqualTo(1L);

        assertThat(result.riskDistribution().get("고위험")).isEqualTo(1L);
        assertThat(result.riskDistribution().get("중위험")).isEqualTo(1L);
        assertThat(result.riskDistribution().get("안전")).isEqualTo(1L);

        assertThat(result.categoryBreakdown()).extracting("category").contains("추락 위험", "전기 위험");

        assertThat(result.companyRanking()).hasSize(2);
        var topCompany = result.companyRanking().get(0);
        assertThat(topCompany.companyName()).isEqualTo("(주)한국건설");
        assertThat(topCompany.completionRate()).isEqualTo(100.0);
    }

    @Test
    void 조치가_하나도_없으면_완료율과_평균기간은_0이다() {
        when(safetyActionRepository.findAll()).thenReturn(List.of());
        when(inspectionRepository.count()).thenReturn(0L);
        when(userRepository.findAllById(List.of())).thenReturn(List.of());

        AnalyticsSummaryResponse result = analyticsService.summarize(2026);

        assertThat(result.completionRate()).isEqualTo(0.0);
        assertThat(result.avgActionDays()).isEqualTo(0.0);
        assertThat(result.companyRanking()).isEmpty();
    }
}
