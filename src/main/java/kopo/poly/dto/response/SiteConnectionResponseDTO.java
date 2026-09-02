package kopo.poly.dto.response;

import kopo.poly.entity.Site;

import java.time.LocalDate;

// 하청이 공유 코드로 조회/입장한 현장의 상세 정보 (원청 건설사명 포함)
public record SiteConnectionResponseDTO(
        Long id,
        String name,
        String address,
        String workType,
        LocalDate periodStart,
        LocalDate periodEnd,
        String ownerCompanyName
) {
    public static SiteConnectionResponseDTO from(Site site, String ownerCompanyName) {
        return new SiteConnectionResponseDTO(
                site.getId(), site.getName(), site.getAddress(), site.getWorkType(),
                site.getPeriodStart(), site.getPeriodEnd(), ownerCompanyName
        );
    }
}
