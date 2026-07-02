package kopo.poly.repository;

import kopo.poly.entity.Inspection;
import kopo.poly.entity.Site;
import kopo.poly.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InspectionRepository extends JpaRepository<Inspection, Long> {
    List<Inspection> findBySiteOrderByInspectedAtDesc(Site site);
    List<Inspection> findByInspectorOrderByInspectedAtDesc(User inspector);
}