package kopo.poly.service;

import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.Site;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SiteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SiteService {

    private final SiteRepository siteRepository;
    private final AiSafetyInspectionRepository inspectionRepository;

    public SiteService(SiteRepository siteRepository, AiSafetyInspectionRepository inspectionRepository) {
        this.siteRepository = siteRepository;
        this.inspectionRepository = inspectionRepository;
    }

    // 각 현장의 최근 위험도는 그 현장에서 가장 최근에 실시된 점검 결과를 보여준다.
    // 점검 이력이 없는 신규 현장은 null(위험도 배지 없음)로 내려간다.
    public List<SiteResponse> list() {
        return siteRepository.findAllByOrderByNameAsc().stream()
                .map(site -> SiteResponse.from(
                        site,
                        inspectionRepository.findFirstByLocationOrderByCreatedAtDesc(site.getName())
                                .map(inspection -> inspection.getRiskLevel())
                                .orElse(null)
                ))
                .toList();
    }

    @Transactional
    public Site create(SiteCreateRequest request) {
        if (request.name() == null || request.name().isBlank()) {
            throw new IllegalArgumentException("현장 이름을 입력해주세요.");
        }
        return siteRepository.save(Site.builder().name(request.name().trim()).zone(request.zone()).build());
    }
}
