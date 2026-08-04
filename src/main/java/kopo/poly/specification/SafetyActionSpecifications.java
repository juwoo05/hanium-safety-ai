package kopo.poly.specification;

import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.StringUtils;

public final class SafetyActionSpecifications {

    private SafetyActionSpecifications() {
    }

    // 현장 필터는 Site와 SafetyAction 사이에 FK가 없다. inspection이 있으면 inspection.location,
    // 없으면(수동 등록) SafetyAction 자체의 location과 비교해 느슨하게 매칭한다.
    public static Specification<SafetyAction> search(String keyword, ActionStatus status, RiskLevel riskLevel, String siteName) {
        return (root, query, cb) -> {
            Predicate predicate = cb.conjunction();
            if (StringUtils.hasText(keyword)) {
                predicate = cb.and(predicate, cb.like(root.get("title"), "%" + keyword.trim() + "%"));
            }
            if (status != null) {
                predicate = cb.and(predicate, cb.equal(root.get("status"), status));
            }
            if (riskLevel != null) {
                predicate = cb.and(predicate, cb.equal(root.get("riskLevel"), riskLevel));
            }
            if (StringUtils.hasText(siteName)) {
                var inspection = root.<SafetyAction, AiSafetyInspection>join("inspection", JoinType.LEFT);
                predicate = cb.and(predicate, cb.or(
                        cb.equal(inspection.get("location"), siteName),
                        cb.equal(root.get("location"), siteName)
                ));
            }
            return predicate;
        };
    }
}
