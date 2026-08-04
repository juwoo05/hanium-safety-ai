package kopo.poly.service;

import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.Site;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SiteRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SiteServiceTest {

    @Mock
    private SiteRepository siteRepository;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @InjectMocks
    private SiteService siteService;

    @Test
    void 점검_이력이_있는_현장은_최근_위험도를_함께_반환한다() {
        Site site = Site.builder().id(1L).name("3동 건물 외벽").zone("A구역").build();
        when(siteRepository.findAllByOrderByNameAsc()).thenReturn(List.of(site));
        when(inspectionRepository.findFirstByLocationOrderByCreatedAtDesc("3동 건물 외벽"))
                .thenReturn(Optional.of(AiSafetyInspection.builder().riskLevel(RiskLevel.HIGH).build()));

        List<SiteResponse> result = siteService.list();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).lastRiskLevel()).isEqualTo(RiskLevel.HIGH);
    }

    @Test
    void 점검_이력이_없는_신규_현장은_위험도가_null이다() {
        Site site = Site.builder().id(2L).name("신규 현장").zone(null).build();
        when(siteRepository.findAllByOrderByNameAsc()).thenReturn(List.of(site));
        when(inspectionRepository.findFirstByLocationOrderByCreatedAtDesc("신규 현장")).thenReturn(Optional.empty());

        List<SiteResponse> result = siteService.list();

        assertThat(result.get(0).lastRiskLevel()).isNull();
    }

    @Test
    void 이름이_비어있으면_현장_등록에_실패한다() {
        org.junit.jupiter.api.Assertions.assertThrows(
                IllegalArgumentException.class,
                () -> siteService.create(new SiteCreateRequest("  ", "A구역"))
        );
    }
}
