package kopo.poly.repository;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.MsdsDocument;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MsdsDocumentRepository extends JpaRepository<MsdsDocument, Long> {

    List<MsdsDocument> findByInspectionOrderByCreatedAtDesc(AiSafetyInspection inspection);

    List<MsdsDocument> findBySafetyActionIdOrderByCreatedAtDesc(Long safetyActionId);

    List<MsdsDocument> findByCreatedByOrderByCreatedAtDesc(Long createdBy);

    boolean existsByInspectionAndCasNoAndDocumentUrl(AiSafetyInspection inspection, String casNo, String documentUrl);
}
