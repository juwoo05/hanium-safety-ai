package kopo.poly.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "report_boards")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportBoard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "risk_item_id", nullable = false)
    private RiskItem riskItem;

    @Column(name = "auto_registered_at", nullable = false)
    private LocalDateTime autoRegisteredAt;

    @Column(length = 200)
    private String reason;
}