package kopo.poly.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kopo.poly.controller.NotificationController;
import kopo.poly.controller.SafetyReportController;
import kopo.poly.entity.enums.UserRole;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

// 로그인 성공 시 역할별 대시보드로 보내고 기존 컨트롤러들이 참조하는 LOGIN_USER_ID 세션 속성 넣기
@Component
public class LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    public static final String LOGIN_USER_ID = "LOGIN_USER_ID";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        CustomUserDetails principal = (CustomUserDetails) authentication.getPrincipal();
        request.getSession().setAttribute(LOGIN_USER_ID, principal.getId());

        boolean sub = authentication.getAuthorities().stream()
                .anyMatch(a -> ("ROLE_" + UserRole.하청.name()).equals(a.getAuthority()));

        getRedirectStrategy().sendRedirect(request, response, sub ? "/dashboard/sub" : "/dashboard");
    }
}
