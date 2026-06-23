package kopo.poly.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/landing"})
    public String landing() { return "landing"; }

    @GetMapping("/login")
    public String login() { return "login"; }

    @PostMapping("/login")
    public String loginPost() { return "redirect:/dashboard"; }

    @GetMapping("/signup")
    public String signup() { return "signup"; }

    @PostMapping("/signup")
    public String signupPost() { return "redirect:/login"; }

    @GetMapping("/find-id")
    public String findId() { return "find-id"; }

    @PostMapping("/find-id")
    public String findIdPost() { return "find-id"; }

    @GetMapping("/find-password")
    public String findPassword() { return "find-password"; }

    @PostMapping("/find-password")
    public String findPasswordPost() { return "find-password"; }

    @GetMapping("/dashboard")
    public String dashboard() { return "contractor-dashboard"; }

    @GetMapping("/dashboard/sub")
    public String subDashboard() { return "subcontractor-dashboard"; }

    @GetMapping("/actions")
    public String actions() { return "action-management"; }

    @GetMapping("/actions/new")
    public String actionsNew() { return "action-registration"; }

    @PostMapping("/actions/new")
    public String actionsNewPost() { return "redirect:/actions"; }

    @GetMapping("/upload")
    public String upload() { return "upload"; }

    @PostMapping("/upload")
    public String uploadPost() { return "upload"; }

    @GetMapping("/actions/detail")
    public String actionsDetail() { return "report-detail"; }

    @GetMapping("/analytics")
    public String analytics() { return "analytics"; }

    @GetMapping("/notifications")
    public String notifications() { return "notifications"; }

    @GetMapping("/mypage")
    public String mypage() { return "mypage"; }

    @PostMapping("/mypage")
    public String mypagePost() { return "redirect:/mypage"; }
}
