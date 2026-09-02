package kopo.poly.service.impl;

import kopo.poly.dto.request.SiteCreateRequestDTO;
import kopo.poly.dto.request.SiteDetailRequestDTO;
import kopo.poly.dto.response.ConnectedSubcontractorResponseDTO;
import kopo.poly.dto.response.SiteConnectionResponseDTO;
import kopo.poly.dto.response.SiteOwnerResponseDTO;
import kopo.poly.dto.response.SiteResponseDTO;
import kopo.poly.entity.Site;
import kopo.poly.entity.SiteMembership;
import kopo.poly.entity.User;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SiteMembershipRepository;
import kopo.poly.repository.SiteRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.ISiteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class SiteService implements ISiteService {

    // 사람이 손으로 입력하는 코드라 헷갈리는 문자(0/O, 1/I/L)는 뺐다.
    private static final String INVITE_CODE_CHARS = "23456789ABCDEFGHJKMNPQRSTUVWXYZ";
    private static final int INVITE_CODE_LENGTH = 6;
    private static final String INVITE_CODE_PREFIX = "SITE-";
    private static final SecureRandom RANDOM = new SecureRandom();

    private final SiteRepository siteRepository;
    private final SiteMembershipRepository siteMembershipRepository;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final UserRepository userRepository;

    public SiteService(
            SiteRepository siteRepository,
            SiteMembershipRepository siteMembershipRepository,
            AiSafetyInspectionRepository inspectionRepository,
            UserRepository userRepository
    ) {
        this.siteRepository = siteRepository;
        this.siteMembershipRepository = siteMembershipRepository;
        this.inspectionRepository = inspectionRepository;
        this.userRepository = userRepository;
    }

    // 각 현장의 최근 위험도는 그 현장에서 가장 최근에 실시된 점검 결과를 보여준다.
    // 점검 이력이 없는 신규 현장은 null(위험도 배지 없음)로 내려간다.
    @Override
    @Transactional(readOnly = true)
    public List<SiteResponseDTO> list(Long userId) {
        return siteRepository.findAllByOrderByNameAsc().stream()
                .filter(site -> canAccess(site, userId))
                .map(this::toSiteResponse)
                .toList();
    }

    @Override
    @Transactional
    public Site create(SiteCreateRequestDTO request, Long ownerId) {
        if (request.name() == null || request.name().isBlank()) {
            throw new IllegalArgumentException("현장 이름을 입력해주세요.");
        }
        return siteRepository.save(Site.builder()
                .name(request.name().trim())
                .zone(request.zone())
                .ownerId(ownerId)
                .inviteCode(generateUniqueInviteCode())
                .build());
    }

    @Override
    @Transactional
    public Site createWithDetail(SiteDetailRequestDTO request, Long ownerId) {
        if (request.name() == null || request.name().isBlank()) {
            throw new IllegalArgumentException("현장 이름을 입력해주세요.");
        }
        return siteRepository.save(Site.builder()
                .name(request.name().trim())
                .address(request.address())
                .workType(request.workType())
                .periodStart(request.periodStart())
                .periodEnd(request.periodEnd())
                .ownerId(ownerId)
                .inviteCode(generateUniqueInviteCode())
                .build());
    }

    @Override
    @Transactional(readOnly = true)
    public List<SiteOwnerResponseDTO> myOwnedSites(Long ownerId) {
        return siteRepository.findByOwnerIdOrderByNameAsc(ownerId).stream()
                .map(SiteOwnerResponseDTO::from)
                .toList();
    }

    @Override
    @Transactional
    public SiteOwnerResponseDTO regenerateInviteCode(Long siteId, Long ownerId) {
        Site site = requireOwnedSite(siteId, ownerId);
        site.regenerateInviteCode(generateUniqueInviteCode());
        return SiteOwnerResponseDTO.from(siteRepository.save(site));
    }

    @Override
    @Transactional
    public SiteConnectionResponseDTO joinByInviteCode(String inviteCode, Long userId) {
        if (inviteCode == null || inviteCode.isBlank()) {
            throw new IllegalArgumentException("공유 코드를 입력해주세요.");
        }
        Site site = siteRepository.findByInviteCode(normalizeCode(inviteCode))
                .orElseThrow(() -> new IllegalArgumentException("유효하지 않은 공유 코드입니다."));

        if (!siteMembershipRepository.existsBySiteAndUserId(site, userId)) {
            siteMembershipRepository.save(SiteMembership.builder().site(site).userId(userId).build());
        }
        return toConnectionResponse(site);
    }

    @Override
    @Transactional(readOnly = true)
    public List<SiteConnectionResponseDTO> joinedSites(Long userId) {
        return siteMembershipRepository.findByUserIdOrderByJoinedAtDesc(userId).stream()
                .map(SiteMembership::getSite)
                .map(this::toConnectionResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ConnectedSubcontractorResponseDTO> connectedSubcontractors(Long ownerId) {
        List<SiteMembership> memberships = siteMembershipRepository.findBySiteOwnerIdOrderByJoinedAtDesc(ownerId);
        List<Long> userIds = memberships.stream().map(SiteMembership::getUserId).distinct().toList();
        var usersById = userRepository.findAllById(userIds).stream()
                .collect(java.util.stream.Collectors.toMap(User::getId, u -> u));

        return memberships.stream()
                .map(m -> {
                    User u = usersById.get(m.getUserId());
                    return new ConnectedSubcontractorResponseDTO(
                            u != null ? u.getCompanyName() : "알 수 없음",
                            u != null ? u.getUsername() : "알 수 없음",
                            m.getSite().getName(),
                            m.getJoinedAt()
                    );
                })
                .toList();
    }

    // 소유자가 지정된 현장은 그 원청만 삭제할 수 있다. 소유자가 없는(구버전 방식으로 만든) 현장은 원청이면 누구나 정리할 수 있다.
    @Override
    @Transactional
    public void delete(Long siteId, Long requestUserId) {
        Site site = siteRepository.findById(siteId)
                .orElseThrow(() -> new NoSuchElementException("현장을 찾을 수 없습니다."));
        if (site.getOwnerId() != null && !site.getOwnerId().equals(requestUserId)) {
            throw new NoSuchElementException("현장을 찾을 수 없습니다.");
        }
        siteMembershipRepository.deleteBySite(site);
        siteRepository.delete(site);
    }

    // 소유자 본인 것이 아니면 존재 여부를 굳이 알려주지 않고 그냥 "없음"으로 처리한다.
    private Site requireOwnedSite(Long siteId, Long ownerId) {
        Site site = siteRepository.findById(siteId)
                .orElseThrow(() -> new NoSuchElementException("현장을 찾을 수 없습니다."));
        if (!ownerId.equals(site.getOwnerId())) {
            throw new NoSuchElementException("현장을 찾을 수 없습니다.");
        }
        return site;
    }

    private SiteResponseDTO toSiteResponse(Site site) {
        return SiteResponseDTO.from(
                site,
                inspectionRepository.findFirstByLocationOrderByCreatedAtDesc(site.getName())
                        .map(inspection -> inspection.getRiskLevel())
                        .orElse(null)
        );
    }

    private boolean canAccess(Site site, Long userId) {
        return site.getOwnerId() == null
                || site.getOwnerId().equals(userId)
                || siteMembershipRepository.existsBySiteAndUserId(site, userId);
    }

    private SiteConnectionResponseDTO toConnectionResponse(Site site) {
        String ownerCompanyName = site.getOwnerId() == null ? null
                : userRepository.findById(site.getOwnerId()).map(User::getCompanyName).orElse(null);
        return SiteConnectionResponseDTO.from(site, ownerCompanyName);
    }

    private String normalizeCode(String code) {
        return code.trim().toUpperCase();
    }

    private String generateUniqueInviteCode() {
        String code;
        do {
            StringBuilder sb = new StringBuilder(INVITE_CODE_LENGTH);
            for (int i = 0; i < INVITE_CODE_LENGTH; i++) {
                sb.append(INVITE_CODE_CHARS.charAt(RANDOM.nextInt(INVITE_CODE_CHARS.length())));
            }
            code = INVITE_CODE_PREFIX + sb;
        } while (siteRepository.existsByInviteCode(code));
        return code;
    }
}
