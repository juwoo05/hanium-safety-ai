package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import kopo.poly.entity.converter.RiskLevelConverter;
import kopo.poly.entity.converter.StringListJsonConverter;
import kopo.poly.entity.enums.RiskLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(
        name = "ai_safety_inspections",
        indexes = {
                @Index(name = "idx_ai_inspections_requested_by", columnList = "requested_by"),
                @Index(name = "idx_ai_inspections_work_type", columnList = "work_type"),
                @Index(name = "idx_ai_inspections_risk_level", columnList = "risk_level"),
                @Index(name = "idx_ai_inspections_created_at", columnList = "created_at")
        }
)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiSafetyInspection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "prompt_text", nullable = false, columnDefinition = "TEXT")
    private String promptText;

    @Convert(converter = StringListJsonConverter.class)
    @Column(name = "image_urls", columnDefinition = "JSON")
    private List<String> imageUrls;

    @Column(name = "image_thumbnail_url", length = 500)
    private String imageThumbnailUrl;

    @Column(nullable = false, length = 200)
    private String location;

    @Column(name = "work_type", nullable = false, length = 100)
    private String workType;

    @Convert(converter = RiskLevelConverter.class)
    @Column(name = "risk_level", nullable = false, length = 10)
    @Builder.Default
    private RiskLevel riskLevel = RiskLevel.SAFE;

    @Column(name = "ai_response_title", length = 255)
    private String aiResponseTitle;

    @Column(name = "ai_response_content", columnDefinition = "LONGTEXT")
    private String aiResponseContent;

    // users 테이블은 다른 팀원 담당 모듈이라 연관관계 대신 ID만 보관한다.
    @Column(name = "requested_by", nullable = false)
    private Long requestedBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
