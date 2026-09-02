package kopo.poly.service.impl;

import kopo.poly.dto.request.SiteCreateRequestDTO;
import kopo.poly.dto.request.SiteDetailRequestDTO;
import kopo.poly.dto.response.SiteConnectionResponseDTO;
import kopo.poly.dto.response.SiteOwnerResponseDTO;
import kopo.poly.dto.response.SiteResponseDTO;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.Site;
import kopo.poly.entity.SiteMembership;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SiteMembershipRepository;
import kopo.poly.repository.SiteRepository;
import kopo.poly.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SiteServiceTest {

    @Mock
    private SiteRepository siteRepository;

    @Mock
    private SiteMembershipRepository siteMembershipRepository;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private SiteService siteService;

    @Test
    void 점검_이력이_있는_현장은_최근_위험도를_함께_반환한다() {
        Site site = Site.builder().id(1L).name("3동 건물 외벽").zone("A구역").build();
        when(siteRepository.findAllByOrderByNameAsc()).thenReturn(List.of(site));
        when(inspectionRepository.findFirstByLocationOrderByCreatedAtDesc("3동 건물 외벽"))
                .thenReturn(Optional.of(AiSafetyInspection.builder().riskLevel(RiskLevel.HIGH).build()));

        List<SiteResponseDTO> result = siteService.list(10L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).lastRiskLevel()).isEqualTo(RiskLevel.HIGH);
    }

    @Test
    void 점검_이력이_없는_신규_현장은_위험도가_null이다() {
        Site site = Site.builder().id(2L).name("신규 현장").zone(null).build();
        when(siteRepository.findAllByOrderByNameAsc()).thenReturn(List.of(site));
        when(inspectionRepository.findFirstByLocationOrderByCreatedAtDesc("신규 현장")).thenReturn(Optional.empty());

        List<SiteResponseDTO> result = siteService.list(10L);

        assertThat(result.get(0).lastRiskLevel()).isNull();
    }

    @Test
    void 이름이_비어있으면_현장_등록에_실패한다() {
        assertThrows(IllegalArgumentException.class, () -> siteService.create(new SiteCreateRequestDTO("  ", "A구역"), 10L));
    }

    @Test
    void 현장을_상세정보와_함께_등록하면_소유자와_공유코드가_함께_저장된다() {
        when(siteRepository.existsByInviteCode(any())).thenReturn(false);
        when(siteRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Site created = siteService.createWithDetail(
                new SiteDetailRequestDTO("3동 외벽", "서울시 강남구", "건축공사", null, null), 10L);

        assertThat(created.getOwnerId()).isEqualTo(10L);
        assertThat(created.getInviteCode()).startsWith("SITE-");
    }

    @Test
    void 원청은_자신이_등록한_현장만_공유코드와_함께_조회한다() {
        Site mine = Site.builder().id(1L).name("내 현장").ownerId(10L).inviteCode("SITE-ABC123").build();
        when(siteRepository.findByOwnerIdOrderByNameAsc(10L)).thenReturn(List.of(mine));

        List<SiteOwnerResponseDTO> result = siteService.myOwnedSites(10L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).inviteCode()).isEqualTo("SITE-ABC123");
    }

    @Test
    void 소유자가_아니면_공유코드를_재발급할_수_없다() {
        Site site = Site.builder().id(1L).name("남의 현장").ownerId(99L).build();
        when(siteRepository.findById(1L)).thenReturn(Optional.of(site));

        assertThrows(java.util.NoSuchElementException.class, () -> siteService.regenerateInviteCode(1L, 10L));
    }

    @Test
    void 유효한_공유코드를_입력하면_현장에_소속된다() {
        Site site = Site.builder().id(1L).name("3동 외벽").inviteCode("SITE-ABC123").ownerId(10L).build();
        when(siteRepository.findByInviteCode("SITE-ABC123")).thenReturn(Optional.of(site));
        when(siteMembershipRepository.existsBySiteAndUserId(site, 20L)).thenReturn(false);
        when(userRepository.findById(10L)).thenReturn(Optional.of(
                User.builder().id(10L).role(UserRole.원청).companyName("대한안전건설").build()));

        SiteConnectionResponseDTO result = siteService.joinByInviteCode("site-abc123", 20L);

        assertThat(result.id()).isEqualTo(1L);
        assertThat(result.ownerCompanyName()).isEqualTo("대한안전건설");
    }

    @Test
    void 존재하지_않는_공유코드로_입장하면_실패한다() {
        when(siteRepository.findByInviteCode("SITE-ZZZZZZ")).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> siteService.joinByInviteCode("SITE-ZZZZZZ", 20L));
    }

    @Test
    void 하청이_입장한_현장_목록을_조회한다() {
        Site site = Site.builder().id(1L).name("3동 외벽").ownerId(10L).build();
        SiteMembership membership = SiteMembership.builder().site(site).userId(20L).build();
        when(siteMembershipRepository.findByUserIdOrderByJoinedAtDesc(20L)).thenReturn(List.of(membership));
        when(userRepository.findById(10L)).thenReturn(Optional.of(
                User.builder().id(10L).role(UserRole.원청).companyName("대한안전건설").build()));

        List<SiteConnectionResponseDTO> result = siteService.joinedSites(20L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).name()).isEqualTo("3동 외벽");
    }
}
