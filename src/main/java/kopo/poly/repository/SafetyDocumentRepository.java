package kopo.poly.repository;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyDocument;
import kopo.poly.entity.enums.DocumentType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SafetyDocumentRepository extends JpaRepository<SafetyDocument, Long> {
    List<SafetyDocument> findByInspectionOrderByCreatedAtDesc(AiSafetyInspection inspection);
    Optional<SafetyDocument> findByInspectionAndDocType(AiSafetyInspection inspection, DocumentType docType);
}
