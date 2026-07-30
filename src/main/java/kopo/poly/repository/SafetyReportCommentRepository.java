package kopo.poly.repository;

import kopo.poly.entity.SafetyReportComment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SafetyReportCommentRepository extends JpaRepository<SafetyReportComment, Long> {
    List<SafetyReportComment> findByReportIdOrderByCreatedAtAsc(Long reportId);
}
