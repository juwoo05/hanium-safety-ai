package kopo.poly.repository;

import kopo.poly.entity.Company;
import kopo.poly.entity.Inspection;
import kopo.poly.entity.RiskItem;
import kopo.poly.entity.enums.RiskStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RiskItemRepository extends JpaRepository<RiskItem, Long> {
    List<RiskItem> findByInspection(Inspection inspection);
    List<RiskItem> findByAssignedCompanyAndStatus(Company company, RiskStatus status);
    List<RiskItem> findByStatus(RiskStatus status);
}