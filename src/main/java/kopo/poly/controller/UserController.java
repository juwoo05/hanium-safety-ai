package kopo.poly.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.SignupRequestDTO;
import kopo.poly.entity.User;
import kopo.poly.security.CustomUserDetails;
import kopo.poly.security.LoginSuccessHandler;
import kopo.poly.service.IMailService;
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Slf4j
@Controller
@RequiredArgsConstructor
public class UserController {

    private static final String SIGNUP_EMAIL = "SIGNUP_VERIFY_EMAIL";
    private static final String SIGNUP_CODE = "SIGNUP_VERIFY_CODE";
    private static final String SIGNUP_EXPIRES_AT = "SIGNUP_VERIFY_EXPIRES_AT";
    private static final String SIGNUP_VERIFIED_EMAIL = "SIGNUP_VERIFIED_EMAIL";

    private static final String RESET_EMAIL = "PW_RESET_EMAIL";
    private static final String RESET_CODE = "PW_RESET_CODE";
    private static final String RESET_EXPIRES_AT = "PW_RESET_EXPIRES_AT";
    private static final String RESET_VERIFIED = "PW_RESET_VERIFIED";
    private static final int CODE_TTL_MINUTES = 5;

    private static final SecureRandom RANDOM = new SecureRandom();

    private final IUserService userService;
    private final IMailService mailService;

    // === 로그인 ===
    @GetMapping("/login")
    public String login(@RequestParam(required = false) String error,
                        @RequestParam(required = false) String logout,
                        @RequestParam(required = false) String expired,
                        Model model) {
        if (error != null) {
            model.addAttribute("loginError", "이메일 또는 비밀번호가 올바르지 않습니다.");
        }
        if (logout != null) {
            model.addAttribute("loginMessage", "로그아웃되었습니다.");
        }
        if (expired != null) {
            model.addAttribute("loginError", "세션이 만료되었습니다. 다시 로그인해주세요.");
        }
        return "auth/login";
    }

    // 탈퇴 계정 복구. 로그인이 막혀 세션이 없으므로 이메일+비밀번호로 본인 확인한다.
    // (UI 연결 없이 API만 존재 — 탈퇴 취소 화면은 아직 없음)
    @PostMapping("/api/auth/reactivate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reactivate(@RequestParam String email, @RequestParam String password) {
        try {
            userService.reactivate(email, password);
            return ResponseEntity.ok(Map.of("ok", true, "message", "계정이 복구되었습니다."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.ok(Map.of("ok", false, "message", e.getMessage()));
        }
    }

    // === 로그인 2단계 인증 ===
    // 아이디/비밀번호는 맞았지만 아직 세션 인증이 완료되지 않은 상태에서만 진입 가능
    // (LoginSuccessHandler가 2단계 인증 대상 계정에 한해 PENDING_2FA_USER_ID를 세션에 심어둔다).
    @GetMapping("/login/verify-2fa")
    public String verify2faForm(HttpSession session, Model model) {
        if (session.getAttribute(LoginSuccessHandler.PENDING_2FA_USER_ID) == null) {
            return "redirect:/login";
        }
        return "auth/verify-2fa";
    }

    @PostMapping("/login/verify-2fa")
    public String verify2faSubmit(@RequestParam String code,
                                  HttpSession session,
                                  HttpServletRequest request,
                                  HttpServletResponse response,
                                  Model model) {
        Long pendingUserId = (Long) session.getAttribute(LoginSuccessHandler.PENDING_2FA_USER_ID);
        String issued = (String) session.getAttribute(LoginSuccessHandler.PENDING_2FA_CODE);
        LocalDateTime expiresAt = (LocalDateTime) session.getAttribute(LoginSuccessHandler.PENDING_2FA_EXPIRES_AT);
        Boolean sub = (Boolean) session.getAttribute(LoginSuccessHandler.PENDING_2FA_SUB);

        if (pendingUserId == null || issued == null || expiresAt == null) {
            return "redirect:/login";
        }
        if (LocalDateTime.now().isAfter(expiresAt)) {
            clearPending2fa(session);
            model.addAttribute("verifyError", "인증 코드가 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/login";
        }
        if (!issued.equals(isBlank(code) ? "" : code.trim())) {
            model.addAttribute("verifyError", "인증 코드가 올바르지 않습니다.");
            return "auth/verify-2fa";
        }

        User user;
        try {
            user = userService.getProfile(pendingUserId);
        } catch (NoSuchElementException e) {
            clearPending2fa(session);
            return "redirect:/login";
        }

        CustomUserDetails principal = new CustomUserDetails(user);
        UsernamePasswordAuthenticationToken authToken =
                new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authToken);
        SecurityContextHolder.setContext(context);
        SecurityContextRepository contextRepository = new HttpSessionSecurityContextRepository();
        contextRepository.saveContext(context, request, response);

        session.setAttribute(LoginSuccessHandler.LOGIN_USER_ID, pendingUserId);
        clearPending2fa(session);

        return "redirect:" + (Boolean.TRUE.equals(sub) ? "/dashboard/sub" : "/dashboard");
    }

    private void clearPending2fa(HttpSession session) {
        session.removeAttribute(LoginSuccessHandler.PENDING_2FA_USER_ID);
        session.removeAttribute(LoginSuccessHandler.PENDING_2FA_CODE);
        session.removeAttribute(LoginSuccessHandler.PENDING_2FA_EXPIRES_AT);
        session.removeAttribute(LoginSuccessHandler.PENDING_2FA_SUB);
    }

    // === 회원가입 ===
    @GetMapping("/signup")
    public String signup() {
        return "auth/signup";
    }

    @PostMapping("/signup")
    public String signupPost(@ModelAttribute SignupRequestDTO request, HttpSession session, Model model) {
        if (isBlank(request.getName()) || isBlank(request.getEmail()) || isBlank(request.getPassword())) {
            return signupError(model, "필수 항목을 모두 입력해주세요.");
        }
        if (!request.getPassword().equals(request.getPasswordConfirm())) {
            return signupError(model, "비밀번호가 일치하지 않습니다.");
        }
        if (request.getPassword().length() < 6) {
            return signupError(model, "비밀번호는 6자 이상이어야 합니다.");
        }
        // 인증 완료 여부 재확인
        String verified = (String) session.getAttribute(SIGNUP_VERIFIED_EMAIL);
        if (verified == null || !verified.equalsIgnoreCase(request.getEmail().trim())) {
            return signupError(model, "이메일 인증을 완료해주세요.");
        }
        if (userService.isEmailTaken(request.getEmail())) {
            return signupError(model, "이미 사용 중인 이메일입니다.");
        }

        userService.signup(request);
        clearSignupSession(session);
        return "redirect:/login?signup";
    }

    private String signupError(Model model, String message) {
        model.addAttribute("signupError", message);
        return "auth/signup";
    }

    // 회원가입 이메일 인증 코드 발송
    @PostMapping("/api/auth/send-verify-code")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendSignupCode(@RequestParam String email, HttpSession session) {
        String target = isBlank(email) ? "" : email.trim();

        if (target.isBlank() || !target.contains("@")) {
            return ResponseEntity.ok(Map.of("ok", false, "message", "올바른 이메일을 입력해주세요."));
        }
        if (userService.isEmailTaken(target)) {
            return ResponseEntity.ok(Map.of("ok", false, "message", "이미 사용 중인 이메일입니다."));
        }

        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        session.setAttribute(SIGNUP_EMAIL, target);
        session.setAttribute(SIGNUP_CODE, code);
        session.setAttribute(SIGNUP_EXPIRES_AT, LocalDateTime.now().plusMinutes(CODE_TTL_MINUTES));
        // 이메일을 바꿔 다시 요청하면 이전 인증은 무효
        session.removeAttribute(SIGNUP_VERIFIED_EMAIL);

        boolean sent = mailService.sendSignupVerifyCode(target, code, CODE_TTL_MINUTES);
        if (!sent) {
            // 메일 계정 미설정 등으로 발송이 안 되면 로컬 확인용으로 로그에 남김
            log.info("[회원가입 인증] {} 인증 코드 = {} ({}분간 유효)", target, code, CODE_TTL_MINUTES);
            return ResponseEntity.ok(Map.of("ok", false, "message", "메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요."));
        }

        return ResponseEntity.ok(Map.of(
                "ok", true,
                "message", "인증 코드를 보냈습니다. 메일함을 확인해주세요. (" + CODE_TTL_MINUTES + "분 이내 입력)"));
    }

    // 회원가입 이메일 인증 코드 검증
    @PostMapping("/api/auth/verify-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifySignupCode(@RequestParam String email,
                                                                @RequestParam String code,
                                                                HttpSession session) {
        String target = isBlank(email) ? "" : email.trim();
        String issuedTo = (String) session.getAttribute(SIGNUP_EMAIL);
        String issued = (String) session.getAttribute(SIGNUP_CODE);
        LocalDateTime expiresAt = (LocalDateTime) session.getAttribute(SIGNUP_EXPIRES_AT);

        if (issuedTo == null || issued == null || expiresAt == null || !issuedTo.equalsIgnoreCase(target)) {
            return ResponseEntity.ok(Map.of("ok", false, "message", "인증 코드를 먼저 요청해주세요."));
        }
        if (LocalDateTime.now().isAfter(expiresAt)) {
            clearSignupSession(session);
            return ResponseEntity.ok(Map.of("ok", false, "message", "인증 코드가 만료되었습니다. 다시 요청해주세요."));
        }
        if (!issued.equals(isBlank(code) ? "" : code.trim())) {
            return ResponseEntity.ok(Map.of("ok", false, "message", "인증 코드가 올바르지 않습니다."));
        }

        session.removeAttribute(SIGNUP_CODE);
        session.removeAttribute(SIGNUP_EXPIRES_AT);
        session.setAttribute(SIGNUP_VERIFIED_EMAIL, issuedTo);

        return ResponseEntity.ok(Map.of("ok", true, "message", "이메일 인증이 완료되었습니다."));
    }

    private void clearSignupSession(HttpSession session) {
        session.removeAttribute(SIGNUP_EMAIL);
        session.removeAttribute(SIGNUP_CODE);
        session.removeAttribute(SIGNUP_EXPIRES_AT);
        session.removeAttribute(SIGNUP_VERIFIED_EMAIL);
    }

    // === 아이디(이메일) 찾기  ===
    @GetMapping("/find-id")
    public String findId() {
        return "auth/find-id";
    }

    @PostMapping("/find-id")
    public String findIdPost(@RequestParam String name, @RequestParam String company, Model model) {
        // 동명이인이 같은 회사에 있으면 여러 건이 나올 수 있어 전부 보여줌
        List<String> emails = userService.findEmailsByNameAndCompany(name.trim(), company.trim());

        if (emails.isEmpty()) {
            model.addAttribute("findIdError", "일치하는 가입 정보를 찾을 수 없습니다.");
            return "auth/find-id";
        }
        model.addAttribute("foundEmails", emails.stream().map(this::maskEmail).toList());
        return "auth/find-id";
    }

    // 아이디 찾기 결과를 전체 노출이 아닌 일부 마스킹으로 처리함
    private String maskEmail(String email) {
        int at = email.indexOf('@');
        if (at <= 0) {
            return "****";
        }
        String local = email.substring(0, at);
        String domain = email.substring(at);
        if (local.length() <= 2) {
            return local.charAt(0) + "*" + domain;
        }
        return local.substring(0, 2) + "*".repeat(local.length() - 2) + domain;
    }

    // === 비밀번호 찾기 ===
    @GetMapping("/find-password")
    public String findPassword(Model model) {
        model.addAttribute("step", 1);
        return "auth/find-password";
    }

    // 1단계. 가입 이메일 확인 후 인증 코드 발급
    @PostMapping("/find-password/send-code")
    public String sendCode(@RequestParam String email, HttpSession session, Model model) {
        String target = email.trim();

        if (!userService.isEmailTaken(target)) {
            model.addAttribute("step", 1);
            model.addAttribute("findPwError", "등록되지 않은 이메일입니다.");
            return "auth/find-password";
        }

        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        session.setAttribute(RESET_EMAIL, target);
        session.setAttribute(RESET_CODE, code);
        session.setAttribute(RESET_EXPIRES_AT, LocalDateTime.now().plusMinutes(CODE_TTL_MINUTES));
        session.setAttribute(RESET_VERIFIED, false);

        boolean sent = mailService.sendPasswordResetCode(target, code, CODE_TTL_MINUTES);
        if (!sent) {
            // 메일 로컬 개발용 확인
            log.info("[비밀번호 재설정] {} 인증 코드 = {} ({}분간 유효)", target, code, CODE_TTL_MINUTES);
            model.addAttribute("findPwError", "메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
        }

        model.addAttribute("step", 2);
        model.addAttribute("targetEmail", target);
        return "auth/find-password";
    }

    // 2단계. 인증 코드 검증
    @PostMapping("/find-password/verify-code")
    public String verifyCode(@RequestParam String code, HttpSession session, Model model) {
        String email = (String) session.getAttribute(RESET_EMAIL);
        String issued = (String) session.getAttribute(RESET_CODE);
        LocalDateTime expiresAt = (LocalDateTime) session.getAttribute(RESET_EXPIRES_AT);

        if (email == null || issued == null || expiresAt == null) {
            return restartWithError(model, "인증 정보가 없습니다. 처음부터 다시 시도해주세요.");
        }
        if (LocalDateTime.now().isAfter(expiresAt)) {
            clearResetSession(session);
            return restartWithError(model, "인증 코드가 만료되었습니다. 다시 요청해주세요.");
        }
        if (!issued.equals(code.trim())) {
            model.addAttribute("step", 2);
            model.addAttribute("targetEmail", email);
            model.addAttribute("findPwError", "인증 코드가 올바르지 않습니다.");
            return "auth/find-password";
        }

        session.setAttribute(RESET_VERIFIED, true);
        model.addAttribute("step", 3);
        return "auth/find-password";
    }

    // 3단계. 새 비밀번호 저장
    @PostMapping("/find-password/reset")
    public String resetPassword(@RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                HttpSession session, Model model) {
        String email = (String) session.getAttribute(RESET_EMAIL);
        boolean verified = Boolean.TRUE.equals(session.getAttribute(RESET_VERIFIED));

        if (email == null || !verified) {
            clearResetSession(session);
            return restartWithError(model, "이메일 인증이 필요합니다. 처음부터 다시 시도해주세요.");
        }
        if (newPassword.length() < 6) {
            model.addAttribute("step", 3);
            model.addAttribute("findPwError", "비밀번호는 6자 이상이어야 합니다.");
            return "auth/find-password";
        }
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("step", 3);
            model.addAttribute("findPwError", "비밀번호가 일치하지 않습니다.");
            return "auth/find-password";
        }

        userService.resetPassword(email, newPassword);
        clearResetSession(session);

        model.addAttribute("step", 4);
        return "auth/find-password";
    }

    private String restartWithError(Model model, String message) {
        model.addAttribute("step", 1);
        model.addAttribute("findPwError", message);
        return "auth/find-password";
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute(RESET_EMAIL);
        session.removeAttribute(RESET_CODE);
        session.removeAttribute(RESET_EXPIRES_AT);
        session.removeAttribute(RESET_VERIFIED);
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
