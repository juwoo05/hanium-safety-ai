package kopo.poly.repository;

import kopo.poly.entity.ActionHistory;
import kopo.poly.entity.RiskItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ActionHistoryRepository extends JpaRepository<ActionHistory, Long> {
    List<ActionHistory> findByRiskItemOrderByCreatedAtDesc(RiskItem riskItem);
}