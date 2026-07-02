package kopo.poly.entity;

import jakarta.persistence.*;
import kopo.poly.entity.enums.RiskStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "risk_items")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RiskItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inspection_id", nullable = false)
    private Inspection inspection;

    @Column(name = "risk_name", nullable = false, length = 200)
    private String riskName;

    // 프론트 action-registration 위험 등급 (HIGH / MEDIUM / LOW)
    @Column(name = "risk_level", length = 10)
    private String riskLevel;

    // 프론트 action-registration 현장 위치 (예: 3동 옥상)
    @Column(length = 200)
    private String location;

    @Column(name = "legal_basis", columnDefinition = "TEXT")
    private String legalBasis;

    @Column(name = "action_required", columnDefinition = "TEXT")
    private String actionRequired;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private RiskStatus status = RiskStatus.PENDING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assigned_company_id")
    private Company assignedCompany;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "completed_image_url", length = 500)
    private String completedImageUrl;

    @Column(nullable = false)
    private LocalDateTime createdAt;
}