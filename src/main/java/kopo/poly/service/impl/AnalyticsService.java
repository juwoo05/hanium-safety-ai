package kopo.poly.service.impl;

import kopo.poly.dto.response.AnalyticsSummaryResponseDTO;
import kopo.poly.dto.response.AnalyticsSummaryResponseDTO.CategoryCount;
import kopo.poly.dto.response.AnalyticsSummaryResponseDTO.CompanyCompletion;
import kopo.poly.dto.response.AnalyticsSummaryResponseDTO.MonthlyRiskCount;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.IAnalyticsService;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AnalyticsService implements IAnalyticsService {

    private static final int CATEGORY_TOP_N = 5;
    private static final String UNASSIGNED_COMPANY = "미지정";

    private final AiSafetyInspectionRepository inspectionRepository;
    private final SafetyActionRepository safetyActionRepository;
    private final UserRepository userRepository;

    public AnalyticsService(
            AiSafetyInspectionRepository inspectionRepository,
            SafetyActionRepository safetyActionRepository,
            UserRepository userRepository
    ) {
        this.inspectionRepository = inspectionRepository;
        this.safetyActionRepository = safetyActionRepository;
        this.userRepository = userRepository;
    }

    @Override
    public AnalyticsSummaryResponseDTO summarize(int year) {
        List<SafetyAction> actions = safetyActionRepository.findAll();

        long total = actions.size();
        long completed = actions.stream().filter(a -> a.getStatus() == ActionStatus.COMPLETED).count();

        return new AnalyticsSummaryResponseDTO(
                inspectionRepository.count(),
                total,
                total == 0 ? 0.0 : completed * 100.0 / total,
                averageActionDays(actions),
                monthlyTrend(actions, year),
                riskDistribution(actions),
                categoryBreakdown(actions),
                companyRanking(actions)
        );
    }

    private double averageActionDays(List<SafetyAction> actions) {
        List<SafetyAction> completed = actions.stream()
                .filter(a -> a.getStatus() == ActionStatus.COMPLETED)
                .toList();
        if (completed.isEmpty()) {
            return 0.0;
        }
        double totalDays = completed.stream()
                .mapToLong(a -> Duration.between(a.getDiscoveredAt(), a.getUpdatedAt()).toDays())
                .sum();
        return totalDays / completed.size();
    }

    private List<MonthlyRiskCount> monthlyTrend(List<SafetyAction> actions, int year) {
        List<SafetyAction> thisYear = actions.stream()
                .filter(a -> a.getDiscoveredAt().getYear() == year)
                .toList();

        List<MonthlyRiskCount> result = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            int m = month;
            List<SafetyAction> monthActions = thisYear.stream()
                    .filter(a -> a.getDiscoveredAt().getMonthValue() == m)
                    .toList();
            result.add(new MonthlyRiskCount(
                    month,
                    monthActions.stream().filter(a -> a.getRiskLevel() == RiskLevel.HIGH).count(),
                    monthActions.stream().filter(a -> a.getRiskLevel() == RiskLevel.MEDIUM).count(),
                    monthActions.stream().filter(a -> a.getRiskLevel() == RiskLevel.SAFE).count()
            ));
        }
        return result;
    }

    private Map<String, Long> riskDistribution(List<SafetyAction> actions) {
        Map<String, Long> distribution = new LinkedHashMap<>();
        for (RiskLevel level : RiskLevel.values()) {
            distribution.put(level.getLabel(), actions.stream().filter(a -> a.getRiskLevel() == level).count());
        }
        return distribution;
    }

    private List<CategoryCount> categoryBreakdown(List<SafetyAction> actions) {
        return actions.stream()
                .collect(Collectors.groupingBy(SafetyAction::getCategory, Collectors.counting()))
                .entrySet().stream()
                .map(e -> new CategoryCount(e.getKey(), e.getValue()))
                .sorted(Comparator.comparingLong(CategoryCount::count).reversed())
                .limit(CATEGORY_TOP_N)
                .toList();
    }

    // SafetyAction은 createdBy(사용자 ID)만 갖고 있어 회사명을 알려면 users 테이블을 별도 조회해야 한다.
    private List<CompanyCompletion> companyRanking(List<SafetyAction> actions) {
        List<Long> userIds = actions.stream().map(SafetyAction::getCreatedBy).distinct().toList();
        Map<Long, String> companyByUserId = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(User::getId, u -> u.getCompanyName() != null ? u.getCompanyName() : UNASSIGNED_COMPANY));

        Map<String, List<SafetyAction>> byCompany = actions.stream()
                .collect(Collectors.groupingBy(a -> companyByUserId.getOrDefault(a.getCreatedBy(), UNASSIGNED_COMPANY)));

        return byCompany.entrySet().stream()
                .map(e -> {
                    long total = e.getValue().size();
                    long completed = e.getValue().stream().filter(a -> a.getStatus() == ActionStatus.COMPLETED).count();
                    double rate = total == 0 ? 0.0 : completed * 100.0 / total;
                    return new CompanyCompletion(e.getKey(), total, completed, rate);
                })
                .sorted(Comparator.comparingDouble(CompanyCompletion::completionRate).reversed())
                .toList();
    }
}
