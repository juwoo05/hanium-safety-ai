package kopo.poly.security;

import kopo.poly.entity.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

// 메인 인증
@Getter
public class CustomUserDetails implements UserDetails {

    private final Long id;
    private final String email;
    private final String name; // UserDetails 의 getUsername() 은 이메일을 반환하므로 별도 필드로 둠
    private final String companyName;
    private final String password;
    private final boolean deleted;
    private final boolean twoFactorEnabled;
    private final Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(User user) {
        this.id = user.getId();
        this.email = user.getEmail();
        this.name = user.getUsername();
        this.companyName = user.getCompanyName();
        this.password = user.getPassword();
        this.deleted = user.getDeletedAt() != null;
        this.twoFactorEnabled = user.isTwoFactorEnabled();
        this.authorities = List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    // 탈퇴 처리된 계정 로그인 방지
    @Override
    public boolean isEnabled() {
        return !deleted;
    }
}
