package kopo.poly.specification;

import jakarta.persistence.criteria.Predicate;
import kopo.poly.entity.SafetyReport;
import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.StringUtils;

public final class SafetyReportSpecifications {

    private SafetyReportSpecifications() {
    }

    public static Specification<SafetyReport> search(String keyword, ReportStatus status,
                                                       ReportCategory category, ReportRiskLevel riskLevel) {
        return (root, query, cb) -> {
            Predicate predicate = cb.conjunction();
            if (StringUtils.hasText(keyword)) {
                String like = "%" + keyword.trim() + "%";
                predicate = cb.and(predicate, cb.or(
                        cb.like(root.get("title"), like),
                        cb.like(root.get("location"), like),
                        cb.like(root.get("description"), like)
                ));
            }
            if (status != null) {
                predicate = cb.and(predicate, cb.equal(root.get("status"), status));
            }
            if (category != null) {
                predicate = cb.and(predicate, cb.equal(root.get("category"), category));
            }
            if (riskLevel != null) {
                predicate = cb.and(predicate, cb.equal(root.get("riskLevel"), riskLevel));
            }
            return predicate;
        };
    }
}
