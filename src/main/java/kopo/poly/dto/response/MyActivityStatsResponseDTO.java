package kopo.poly.dto.response;

import java.util.List;

public record MyActivityStatsResponseDTO(
        long totalUploads,
        long riskDetected,
        long actionsCompleted,
        int safetyScore,
        long thisMonthUploads,
        double actionCompletionRate,
        List<Integer> monthlyUploads
) {
}
