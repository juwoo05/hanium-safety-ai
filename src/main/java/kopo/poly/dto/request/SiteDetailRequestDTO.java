package kopo.poly.dto.request;

import java.time.LocalDate;

public record SiteDetailRequestDTO(
        String name,
        String address,
        String workType,
        LocalDate periodStart,
        LocalDate periodEnd
) {
}
