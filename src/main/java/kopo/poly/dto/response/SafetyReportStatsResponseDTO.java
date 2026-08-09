package kopo.poly.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SafetyReportStatsResponseDTO {
    private long total;
    private long inProgress;
    private long completed;
    private long highRisk;
}
