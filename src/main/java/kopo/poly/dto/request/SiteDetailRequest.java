package kopo.poly.dto.request;

import java.time.LocalDate;

public record SiteDetailRequest(
        String name,
        String address,
        String workType,
        LocalDate periodStart,
        LocalDate periodEnd
) {
}
