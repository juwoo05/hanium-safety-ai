package kopo.poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import kopo.poly.entity.converter.UserRoleConverter;
import kopo.poly.entity.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    @Convert(converter = UserRoleConverter.class)
    @Column(nullable = false)
    private UserRole role;

    @Column(name = "company_id")
    private Long companyId;

    @Column(name = "company_name", length = 100)
    private String companyName;

    // 원청 건설사 정보. "건설사 및 현장 연동" 화면에서 원청이 입력/수정한다.
    @Column(name = "company_biz_no", length = 20)
    private String companyBizNo;

    @Column(name = "company_ceo_name", length = 50)
    private String companyCeoName;

    @Column(name = "company_address", length = 255)
    private String companyAddress;

    @Column(length = 100)
    private String email;

    @Column(name = "profile_image_url", length = 500)
    private String profileImageUrl;

    @Column(name = "create_at")
    private LocalDateTime createAt;

    @Column(name = "reg_at")
    private LocalDateTime regAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "two_factor_enabled", nullable = false)
    @Builder.Default
    private boolean twoFactorEnabled = false;

    // 알림 페이지를 마지막으로 방문(확인)한 시각. 헤더 종 아이콘의 배지는 이 시각 이후 생성된
    // 알림 개수만 센다. 개별 알림의 읽음 상태(read)와는 무관하며, 알림 페이지 방문 시 갱신된다.
    @Column(name = "notifications_seen_at")
    private LocalDateTime notificationsSeenAt;

    public void changePassword(String encodedPassword) {
        this.password = encodedPassword;
        this.updatedAt = LocalDateTime.now();
    }

    public void updateProfile(String username, String companyName) {
        this.username = username;
        this.companyName = companyName;
        this.updatedAt = LocalDateTime.now();
    }

    public void updateCompanyProfile(String companyName, String companyBizNo, String companyCeoName, String companyAddress) {
        this.companyName = companyName;
        this.companyBizNo = companyBizNo;
        this.companyCeoName = companyCeoName;
        this.companyAddress = companyAddress;
        this.updatedAt = LocalDateTime.now();
    }

    public void setTwoFactorEnabled(boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
        this.updatedAt = LocalDateTime.now();
    }

    public void withdraw() {
        this.deletedAt = LocalDateTime.now();
    }

    public void markNotificationsSeen() {
        this.notificationsSeenAt = LocalDateTime.now();
    }
}
