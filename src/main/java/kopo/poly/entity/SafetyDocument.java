package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import kopo.poly.entity.converter.StringObjectMapJsonConverter;
import kopo.poly.entity.enums.DocumentType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

// AI 서류 작성 화면에서 생성/저장되는 안전양식(안전점검일지, 위험성평가서, 조치결과보고서, 작업허가서).
@Entity
@Table(
        name = "safety_documents",
        indexes = {
                @Index(name = "idx_safety_documents_inspection_id", columnList = "inspection_id"),
                @Index(name = "idx_safety_documents_doc_type", columnList = "doc_type")
        }
)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SafetyDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inspection_id")
    @OnDelete(action = OnDeleteAction.SET_NULL)
    private AiSafetyInspection inspection;

    @Enumerated(EnumType.STRING)
    @Column(name = "doc_type", nullable = false, length = 30)
    private DocumentType docType;

    @Convert(converter = StringObjectMapJsonConverter.class)
    @Column(name = "form_data", nullable = false, columnDefinition = "JSON")
    @Builder.Default
    private Map<String, Object> formData = new LinkedHashMap<>();

    @Column(name = "ai_generated", nullable = false)
    @Builder.Default
    private boolean aiGenerated = false;

    // users 테이블은 다른 팀원 담당 모듈이라 연관관계 대신 ID만 보관한다.
    @Column(name = "created_by", nullable = false)
    private Long createdBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public void updateForm(Map<String, Object> formData, boolean aiGenerated) {
        this.formData = formData;
        this.aiGenerated = aiGenerated;
    }
}
