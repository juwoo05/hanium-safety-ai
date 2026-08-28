package kopo.poly.config;

import jakarta.servlet.DispatcherType;
import kopo.poly.security.LoginSuccessHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final LoginSuccessHandler loginSuccessHandler;

    /**
     * 비밀번호는 BCrypt 로만 저장한다. 평문 저장/비교 금지.
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        // JSP 뷰(/WEB-INF/views/**)로의 FORWARD, 에러 페이지 ERROR 디스패치는
                        // 컨테이너 내부 이동이라 인가 대상이 아니다. 이 규칙이 없으면
                        // 로그인 페이지 렌더링조차 거부되어 /login 무한 리다이렉트가 발생한다.
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        // Figma export SafeMate React 프론트엔드(정적 SPA)는 자체 화면 흐름/인증 상태를 갖는다.
                        .requestMatchers("/app", "/app/**").permitAll()
                        .requestMatchers("/", "/landing", "/login", "/login/verify-2fa", "/signup").permitAll()
                        .requestMatchers("/find-id", "/find-password/**").permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        // 이 프로젝트의 로그인 아이디는 이메일이다.
                        .usernameParameter("email")
                        .passwordParameter("password")
                        .successHandler(loginSuccessHandler)
                        .failureUrl("/login?error")
                        .permitAll()
                )
                .rememberMe(remember -> remember
                        .key("hanium-safety-ai-remember-me")
                        .rememberMeParameter("remember")
                        .tokenValiditySeconds(60 * 60 * 24 * 14)
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )
                // 기존 화면들이 /api/** 를 CSRF 토큰 없이 fetch 로 호출하고 있어 해당 경로만 예외로 둔다.
                // 폼 기반 화면(로그인/회원가입/비밀번호 재설정)은 CSRF 보호를 유지한다.
                .csrf(csrf -> csrf.ignoringRequestMatchers("/api/**"));

        return http.build();
    }
}
