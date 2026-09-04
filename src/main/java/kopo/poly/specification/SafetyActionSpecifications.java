package kopo.poly.specification;

import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.StringUtils;

import java.util.List;

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

    // 로그인 사용자가 볼 수 있는 범위로 제한한다: 자신이 소속/소유한 현장(allowedSiteNames)의 조치이거나,
    // 현장 매칭이 안 되는 수동 등록 조치라도 자신이 담당자·등록자인 경우는 허용한다.
    public static Specification<SafetyAction> withinAccessScope(List<String> allowedSiteNames, Long scopeUserId) {
        return (root, query, cb) -> {
            var inspection = root.<SafetyAction, AiSafetyInspection>join("inspection", JoinType.LEFT);
            Predicate ownMatch = cb.or(
                    cb.equal(root.get("reporterId"), scopeUserId),
                    cb.equal(root.get("createdBy"), scopeUserId)
            );
            if (allowedSiteNames.isEmpty()) {
                return ownMatch;
            }
            Predicate siteMatch = cb.or(
                    inspection.get("location").in(allowedSiteNames),
                    root.get("location").in(allowedSiteNames)
            );
            return cb.or(siteMatch, ownMatch);
        };
    }
}
