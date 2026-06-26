package kopo.poly.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/landing"})
    public String landing() { return "landing"; }

    @GetMapping("/login")
    public String login() { return "auth/login"; }

    @PostMapping("/login")
    public String loginPost() { return "redirect:/dashboard"; }

    @GetMapping("/signup")
    public String signup() { return "auth/signup"; }

    @PostMapping("/signup")
    public String signupPost() { return "redirect:/login"; }

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

    @GetMapping("/notifications")
    public String notifications() { return "notification/notifications"; }

    @GetMapping("/mypage")
    public String mypage() { return "mypage/mypage"; }

    @PostMapping("/mypage")
    public String mypagePost() { return "redirect:/mypage"; }
}
