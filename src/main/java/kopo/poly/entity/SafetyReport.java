package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "safety_reports")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SafetyReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ReportCategory category;

    @Enumerated(EnumType.STRING)
    @Column(name = "risk_level", nullable = false, length = 10)
    private ReportRiskLevel riskLevel;

    @Column(length = 200)
    private String location;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ReportStatus status;

    @Column(nullable = false)
    @Builder.Default
    private boolean anonymous = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reporter_id", columnDefinition = "bigint unsigned")
    private User reporter;

    @Column(name = "reporter_name_snapshot", length = 100)
    private String reporterNameSnapshot;

    @Column(nullable = false)
    @Builder.Default
    private long views = 0L;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    public void increaseView() {
        this.views += 1;
    }

    public void changeStatus(ReportStatus newStatus, LocalDateTime at) {
        this.status = newStatus;
        this.updatedAt = at;
        if (newStatus == ReportStatus.COMPLETED) {
            this.completedAt = at;
        }
    }
}
