package kopo.poly.repository;

import kopo.poly.entity.ReportBoard;
import kopo.poly.entity.RiskItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReportBoardRepository extends JpaRepository<ReportBoard, Long> {
    List<ReportBoard> findAllByOrderByAutoRegisteredAtDesc();
    boolean existsByRiskItem(RiskItem riskItem);
}