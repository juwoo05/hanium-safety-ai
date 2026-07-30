package kopo.poly.repository;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.enums.RiskLevel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AiSafetyInspectionRepository extends JpaRepository<AiSafetyInspection, Long> {
    List<AiSafetyInspection> findByRequestedByOrderByCreatedAtDesc(Long requestedBy);
    List<AiSafetyInspection> findByRiskLevelOrderByCreatedAtDesc(RiskLevel riskLevel);
}
