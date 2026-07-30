package kopo.poly.repository;

import kopo.poly.entity.SafetyReportTimeline;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SafetyReportTimelineRepository extends JpaRepository<SafetyReportTimeline, Long> {
    List<SafetyReportTimeline> findByReportIdOrderByCreatedAtAsc(Long reportId);
}
