package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Controller
@RequiredArgsConstructor
public class UserController {

    private static final String RESET_EMAIL = "PW_RESET_EMAIL";
    private static final String RESET_CODE = "PW_RESET_CODE";
    private static final String RESET_EXPIRES_AT = "PW_RESET_EXPIRES_AT";
    private static final String RESET_VERIFIED = "PW_RESET_VERIFIED";
    private static final int CODE_TTL_MINUTES = 5;

    private static final SecureRandom RANDOM = new SecureRandom();

    private final IUserService userService;

    // === 로그인 ===
    @GetMapping("/login")
    public String login(@RequestParam(required = false) String error,
                        @RequestParam(required = false) String logout,
                        Model model) {
        if (error != null) {
            model.addAttribute("loginError", "이메일 또는 비밀번호가 올바르지 않습니다.");
        }
        if (logout != null) {
            model.addAttribute("loginMessage", "로그아웃되었습니다.");
        }
        return "auth/login";
    }

    // === 회원가입 ===
    @GetMapping("/signup")
    public String signup() {
        return "auth/signup";
    }

    @PostMapping("/signup")
    public String signupPost(@ModelAttribute SignupRequestDTO request, Model model) {
        if (isBlank(request.getName()) || isBlank(request.getEmail()) || isBlank(request.getPassword())) {
            return signupError(model, "필수 항목을 모두 입력해주세요.");
        }
        if (!request.getPassword().equals(request.getPasswordConfirm())) {
            return signupError(model, "비밀번호가 일치하지 않습니다.");
        }
        if (request.getPassword().length() < 6) {
            return signupError(model, "비밀번호는 6자 이상이어야 합니다.");
        }
        if (userService.isEmailTaken(request.getEmail())) {
            return signupError(model, "이미 사용 중인 이메일입니다.");
        }
        // username이 unique 컬럼이라 동명이인은 가입할 수 없어서 나중에 바꿔야 할 것 같음
        if (userService.isNameTaken(request.getName())) {
            return signupError(model, "이미 등록된 이름입니다. 관리자에게 문의해주세요.");
        }

        userService.signup(request);
        return "redirect:/login?signup";
    }

    private String signupError(Model model, String message) {
        model.addAttribute("signupError", message);
        return "auth/signup";
    }

    // 회원가입 이메일 중복확인 버튼
    @GetMapping("/api/auth/check-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkEmail(@RequestParam String email) {
        boolean available = !isBlank(email) && !userService.isEmailTaken(email);
        return ResponseEntity.ok(Map.of("available", available));
    }

    // === 아이디(이메일) 찾기  ===
    @GetMapping("/find-id")
    public String findId() {
        return "auth/find-id";
    }

    @PostMapping("/find-id")
    public String findIdPost(@RequestParam String name, @RequestParam String company, Model model) {
        Optional<String> email = userService.findEmailByNameAndCompany(name.trim(), company.trim());

        if (email.isEmpty()) {
            model.addAttribute("findIdError", "일치하는 가입 정보를 찾을 수 없습니다.");
            return "auth/find-id";
        }
        model.addAttribute("foundEmail", maskEmail(email.get()));
        return "auth/find-id";
    }

    // 아이디 찾기 결과를 전체 노출이 아닌 일부 마스킹으로 처리함
    // 전체 노출이 나은지 일부 마스킹이 나은지
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

        // 메일/SMS 발송 연동 전까지는 서버 로그로 코드 확인 부탁
        log.info("[비밀번호 재설정] {} 인증 코드 = {} ({}분간 유효)", target, code, CODE_TTL_MINUTES);

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
