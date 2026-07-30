package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class PageController {

    private final IUserService userService;

    @GetMapping({"/", "/landing"})
    public String landing() { return "landing"; }

    @GetMapping("/login")
    public String login() { return "auth/login"; }

    @PostMapping("/login")
    public String loginPost(@RequestParam String email, @RequestParam String password,
                             HttpSession session, Model model) {
        return userService.login(email, password)
                .map(user -> {
                    session.setAttribute("LOGIN_USER_ID", user.getId());
                    return "redirect:" + dashboardPathFor(user);
                })
                .orElseGet(() -> {
                    model.addAttribute("loginError", "이메일 또는 비밀번호가 올바르지 않습니다.");
                    return "auth/login";
                });
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/signup")
    public String signup() { return "auth/signup"; }

    @PostMapping("/signup")
    public String signupPost(@ModelAttribute SignupRequestDTO request, HttpSession session, Model model) {
        if (!request.getPassword().equals(request.getPasswordConfirm())) {
            model.addAttribute("signupError", "비밀번호가 일치하지 않습니다.");
            return "auth/signup";
        }
        if (userService.isUsernameTaken(request.getUserId()) || userService.isEmailTaken(request.getEmail())) {
            model.addAttribute("signupError", "이미 사용 중인 아이디 또는 이메일입니다.");
            return "auth/signup";
        }
        User user = userService.signup(request);
        session.setAttribute("LOGIN_USER_ID", user.getId());
        return "redirect:" + dashboardPathFor(user);
    }

    private String dashboardPathFor(User user) {
        return user.getRole() == UserRole.하청 ? "/dashboard/sub" : "/dashboard";
    }

    @GetMapping("/find-id")
    public String findId() { return "auth/find-id"; }

    @PostMapping("/find-id")
    public String findIdPost() { return "auth/find-id"; }

    @GetMapping("/find-password")
    public String findPassword() { return "auth/find-password"; }

    @PostMapping("/find-password")
    public String findPasswordPost() { return "auth/find-password"; }

    @GetMapping("/dashboard")
    public String dashboard() { return "dashboard/contractor-dashboard"; }

    @GetMapping("/dashboard/sub")
    public String subDashboard() { return "dashboard/subcontractor-dashboard"; }

    @GetMapping("/actions")
    public String actions() { return "action/action-management"; }

    @GetMapping("/actions/new")
    public String actionsNew() { return "action/action-registration"; }

    @PostMapping("/actions/new")
    public String actionsNewPost() { return "redirect:/actions"; }

    @GetMapping("/upload")
    public String upload() { return "upload/upload"; }

    @PostMapping("/upload")
    public String uploadPost() { return "upload/upload"; }

    @GetMapping("/actions/detail")
    public String actionsDetail() { return "action/report-detail"; }

    @GetMapping("/analytics")
    public String analytics() { return "analytics/analytics"; }

    // /notifications 는 kopo.poly.controller.NotificationController 에서 처리한다.

    @GetMapping("/mypage")
    public String mypage() { return "mypage/mypage"; }

    @PostMapping("/mypage")
    public String mypagePost() { return "redirect:/mypage"; }

    // /report-board, /report-board/detail 은 kopo.poly.controller.SafetyReportController 에서 처리한다.
}
