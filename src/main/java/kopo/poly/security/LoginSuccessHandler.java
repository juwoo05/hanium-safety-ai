package kopo.poly.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.service.IMailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;

// 로그인 성공 시 역할별 대시보드로 보내고 기존 컨트롤러들이 참조하는 LOGIN_USER_ID 세션 속성 넣기.
// 2단계 인증이 켜진 계정은 여기서 바로 로그인 완료 처리하지 않고 이메일 코드 검증 단계로 보낸다.
@Slf4j
@Component
@RequiredArgsConstructor
public class LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    public static final String LOGIN_USER_ID = "LOGIN_USER_ID";

    public static final String PENDING_2FA_USER_ID = "PENDING_2FA_USER_ID";
    public static final String PENDING_2FA_CODE = "PENDING_2FA_CODE";
    public static final String PENDING_2FA_EXPIRES_AT = "PENDING_2FA_EXPIRES_AT";
    public static final String PENDING_2FA_SUB = "PENDING_2FA_SUB";
    private static final int CODE_TTL_MINUTES = 5;
    private static final SecureRandom RANDOM = new SecureRandom();

    private final IMailService mailService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        CustomUserDetails principal = (CustomUserDetails) authentication.getPrincipal();

        boolean sub = authentication.getAuthorities().stream()
                .anyMatch(a -> ("ROLE_" + UserRole.하청.name()).equals(a.getAuthority()));

        if (principal.isTwoFactorEnabled()) {
            // 아이디/비밀번호는 맞았지만 아직 로그인을 완료시키지 않는다 — 컨텍스트를 비워두면
            // 이번 요청 끝에서 세션에는 "인증 안 됨" 상태가 저장된다.
            SecurityContextHolder.clearContext();

            String code = String.format("%06d", RANDOM.nextInt(1_000_000));
            HttpSession session = request.getSession();
            session.setAttribute(PENDING_2FA_USER_ID, principal.getId());
            session.setAttribute(PENDING_2FA_CODE, code);
            session.setAttribute(PENDING_2FA_EXPIRES_AT, LocalDateTime.now().plusMinutes(CODE_TTL_MINUTES));
            session.setAttribute(PENDING_2FA_SUB, sub);

            boolean sent = mailService.sendTwoFactorCode(principal.getEmail(), code, CODE_TTL_MINUTES);
            if (!sent) {
                log.info("[2단계 인증] {} 인증 코드 = {} ({}분간 유효)", principal.getEmail(), code, CODE_TTL_MINUTES);
            }
            getRedirectStrategy().sendRedirect(request, response, "/login/verify-2fa");
            return;
        }

        request.getSession().setAttribute(LOGIN_USER_ID, principal.getId());
        getRedirectStrategy().sendRedirect(request, response, sub ? "/dashboard/sub" : "/dashboard");
    }
}
