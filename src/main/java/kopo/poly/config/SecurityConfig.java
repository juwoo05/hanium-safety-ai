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
import org.springframework.security.web.access.AccessDeniedHandlerImpl;
import org.springframework.security.web.csrf.CsrfException;

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
                .csrf(csrf -> csrf.ignoringRequestMatchers("/api/**"))
                // 세션 타임아웃 후 "로그인 유지" 쿠키가 백그라운드에서 새 세션(=새 CSRF 토큰)을 조용히
                // 발급하는 경우, 화면에는 예전 세션의 CSRF 토큰이 그대로 남아있어 폼 제출(로그아웃 등) 시
                // CsrfException(=AccessDeniedException)이 발생한다. 이걸 그대로 403 에러 페이지로 보여주는
                // 대신 로그인 페이지로 안내한다. 그 외의 진짜 인가 거부(AccessDeniedException)는 기본 처리를 따른다.
                .exceptionHandling(exceptionHandling -> exceptionHandling
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            if (accessDeniedException instanceof CsrfException) {
                                response.sendRedirect(request.getContextPath() + "/login?expired");
                                return;
                            }
                            new AccessDeniedHandlerImpl().handle(request, response, accessDeniedException);
                        })
                );

        return http.build();
    }
}
