package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.EnumType;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import kopo.poly.entity.converter.RiskLevelConverter;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
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

@Entity
@Table(
        name = "safety_actions",
        indexes = {
                @Index(name = "idx_safety_actions_inspection_id", columnList = "inspection_id"),
                @Index(name = "idx_safety_actions_status", columnList = "status"),
                @Index(name = "idx_safety_actions_reporter_id", columnList = "reporter_id"),
                @Index(name = "idx_safety_actions_created_by", columnList = "created_by"),
                @Index(name = "idx_safety_actions_due_date", columnList = "due_date")
        }
)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SafetyAction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // AI 안전점검 결과와 연결되는 조치 (같은 모듈 소관이라 실제 연관관계로 매핑)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inspection_id")
    @OnDelete(action = OnDeleteAction.SET_NULL)
    private AiSafetyInspection inspection;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, length = 100)
    private String category;

    @Convert(converter = RiskLevelConverter.class)
    @Column(name = "risk_level", nullable = false, length = 10)
    @Builder.Default
    private RiskLevel riskLevel = RiskLevel.MEDIUM;

    // users 테이블은 다른 팀원 담당 모듈이라 연관관계 대신 ID만 보관한다.
    @Column(name = "reporter_id")
    private Long reporterId;

    @Column(name = "discovered_at", nullable = false)
    private LocalDateTime discoveredAt;

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String recommendation;

    @Column(name = "regulation_ref", columnDefinition = "TEXT")
    private String regulationRef;

    @Column(columnDefinition = "TEXT")
    private String memo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private ActionStatus status = ActionStatus.REQUESTED;

    // users 테이블은 다른 팀원 담당 모듈이라 연관관계 대신 ID만 보관한다.
    @Column(name = "created_by", nullable = false)
    private Long createdBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public void updateStatus(ActionStatus status) {
        this.status = status;
    }
}
