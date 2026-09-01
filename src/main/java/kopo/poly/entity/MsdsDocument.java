package kopo.poly.entity;

import jakarta.persistence.Column;
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
import kopo.poly.entity.enums.MsdsSourceType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

// 사진에서 인식한 화학물질/제품에 대해 사용자가 확인·첨부한 MSDS/SDS 문서.
// 점검(inspection) 또는 개별 조치(safetyActionId)에 연결된다.
@Entity
@Table(
        name = "msds_documents",
        indexes = {
                @Index(name = "idx_msds_documents_inspection_id", columnList = "inspection_id"),
                @Index(name = "idx_msds_documents_safety_action_id", columnList = "safety_action_id"),
                @Index(name = "idx_msds_documents_cas_no", columnList = "cas_no")
        }
)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MsdsDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inspection_id")
    @OnDelete(action = OnDeleteAction.SET_NULL)
    private AiSafetyInspection inspection;

    // safety_actions 도 같은 모듈이지만, MSDS는 점검 단위 첨부가 기본이고 조치 첨부는 선택이라
    // 연관관계 대신 ID만 보관한다(첨부 정책이 유연해도 스키마가 단순).
    @Column(name = "safety_action_id")
    private Long safetyActionId;

    @Column(name = "chemical_name", nullable = false, length = 200)
    private String chemicalName;

    @Column(name = "cas_no", length = 30)
    private String casNo;

    @Column(name = "product_name", length = 200)
    private String productName;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_type", nullable = false, length = 20)
    @Builder.Default
    private MsdsSourceType sourceType = MsdsSourceType.UNKNOWN;

    @Column(name = "source_name", length = 200)
    private String sourceName;

    @Column(name = "source_url", length = 1000)
    private String sourceUrl;

    // 실제 MSDS/SDS 문서(PDF 등) 위치. 미리보기·다운로드·인쇄에 사용한다.
    @Column(name = "document_url", length = 1000)
    private String documentUrl;

    @Column(name = "revision_date")
    private LocalDate revisionDate;

    // AI/검색 신뢰도 0~100
    @Column(nullable = false)
    @Builder.Default
    private int confidence = 0;

    // 현장관리자가 "이 물질/문서가 맞다"고 확인했는지 여부
    @Column(nullable = false)
    @Builder.Default
    private boolean verified = false;

    @Column(name = "created_by", nullable = false)
    private Long createdBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public void markVerified(boolean verified) {
        this.verified = verified;
    }
}
