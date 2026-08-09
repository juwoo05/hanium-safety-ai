package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

// 하청이 공유 코드로 입장한 현장 소속 기록. 하청 한 명이 여러 현장(프로젝트)에 소속될 수 있어 다대다 조인 테이블로 둔다.
@Entity
@Table(
        name = "site_memberships",
        uniqueConstraints = @UniqueConstraint(name = "uk_site_memberships_site_user", columnNames = {"site_id", "user_id"}),
        indexes = @Index(name = "idx_site_memberships_user_id", columnList = "user_id")
)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteMembership {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Site는 같은 모듈 소관이라 실제 연관관계로 매핑.
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "site_id", nullable = false)
    private Site site;

    // users 테이블은 다른 팀원 담당이라 연관관계 대신 ID만 보관한다.
    @Column(name = "user_id", nullable = false)
    private Long userId;

    @CreationTimestamp
    @Column(name = "joined_at", nullable = false, updatable = false)
    private LocalDateTime joinedAt;
}
