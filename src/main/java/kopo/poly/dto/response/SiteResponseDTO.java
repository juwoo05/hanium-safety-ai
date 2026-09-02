package kopo.poly.dto.response;

import kopo.poly.entity.Site;
import kopo.poly.entity.enums.RiskLevel;

public record SiteResponseDTO(
        Long id,
        String name,
        String zone,
        RiskLevel lastRiskLevel
) {
    public static SiteResponseDTO from(Site site, RiskLevel lastRiskLevel) {
        return new SiteResponseDTO(site.getId(), site.getName(), site.getZone(), lastRiskLevel);
    }
}
