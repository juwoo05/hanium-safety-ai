package kopo.poly.dto.response;

import java.util.List;
import java.util.Map;

public record AnalyticsSummaryResponse(
        long totalUploads,
        long totalDetections,
        double completionRate,
        double avgActionDays,
        List<MonthlyRiskCount> monthlyTrend,
        Map<String, Long> riskDistribution,
        List<CategoryCount> categoryBreakdown,
        List<CompanyCompletion> companyRanking
) {
    public record MonthlyRiskCount(int month, long high, long medium, long safe) {
    }

    public record CategoryCount(String category, long count) {
    }

    public record CompanyCompletion(String companyName, long total, long completed, double completionRate) {
    }
}
