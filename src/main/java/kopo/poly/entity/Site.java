package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

// AI 안전점검 접수 마법사의 "위치 선택" 단계에서 고르는 현장 마스터 데이터.
@Entity
@Table(name = "sites")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Site {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 50)
    private String zone;

    @Column(length = 255)
    private String address;

    // 공사 구분(예: 건축공사, 리모델링공사)
    @Column(name = "work_type", length = 100)
    private String workType;

    @Column(name = "period_start")
    private LocalDate periodStart;

    @Column(name = "period_end")
    private LocalDate periodEnd;

    // users 테이블은 다른 팀원 담당이라 연관관계 대신 ID만 보관한다. 이 현장을 등록한(=관리하는) 원청.
    @Column(name = "owner_id")
    private Long ownerId;

    // 하청이 현장에 입장할 때 입력하는 공유 코드. 자체 발급하는 랜덤 코드다.
    @Column(name = "invite_code", unique = true, length = 20)
    private String inviteCode;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public void regenerateInviteCode(String code) {
        this.inviteCode = code;
    }

    public void updateDetails(String name, String address, String workType, LocalDate periodStart, LocalDate periodEnd) {
        this.name = name;
        this.address = address;
        this.workType = workType;
        this.periodStart = periodStart;
        this.periodEnd = periodEnd;
    }
}
