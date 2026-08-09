package kopo.poly.dto.response;

import java.util.List;

public record MyActivityStatsResponse(
        long totalUploads,
        long riskDetected,
        long actionsCompleted,
        int safetyScore,
        long thisMonthUploads,
        double actionCompletionRate,
        List<Integer> monthlyUploads
) {
}
