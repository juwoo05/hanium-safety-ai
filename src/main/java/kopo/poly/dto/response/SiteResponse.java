package kopo.poly.dto.response;

import kopo.poly.entity.Site;
import kopo.poly.entity.enums.RiskLevel;

public record SiteResponse(
        Long id,
        String name,
        String zone,
        RiskLevel lastRiskLevel
) {
    public static SiteResponse from(Site site, RiskLevel lastRiskLevel) {
        return new SiteResponse(site.getId(), site.getName(), site.getZone(), lastRiskLevel);
    }
}
