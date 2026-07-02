package kopo.poly.repository;

import kopo.poly.entity.Inspection;
import kopo.poly.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ReportRepository extends JpaRepository<Report, Long> {
    Optional<Report> findByInspection(Inspection inspection);
    Optional<Report> findByShareToken(String shareToken);
}