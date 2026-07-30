package kopo.poly.repository;

import kopo.poly.entity.SafetyReport;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface SafetyReportRepository extends JpaRepository<SafetyReport, Long>, JpaSpecificationExecutor<SafetyReport> {

    long countByStatus(ReportStatus status);

    long countByRiskLevel(ReportRiskLevel riskLevel);
}
