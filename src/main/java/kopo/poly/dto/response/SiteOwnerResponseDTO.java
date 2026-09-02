package kopo.poly.dto.response;

import kopo.poly.entity.Site;

import java.time.LocalDate;
import java.time.LocalDateTime;

// 원청이 "건설사 및 현장 연동" 화면에서 보는 내 현장 정보. 공유 코드가 포함되므로 소유자 본인에게만 내려준다.
public record SiteOwnerResponseDTO(
        Long id,
        String name,
        String address,
        String workType,
        LocalDate periodStart,
        LocalDate periodEnd,
        String inviteCode,
        LocalDateTime createdAt
) {
    public static SiteOwnerResponseDTO from(Site site) {
        return new SiteOwnerResponseDTO(
                site.getId(), site.getName(), site.getAddress(), site.getWorkType(),
                site.getPeriodStart(), site.getPeriodEnd(), site.getInviteCode(), site.getCreatedAt()
        );
    }
}
