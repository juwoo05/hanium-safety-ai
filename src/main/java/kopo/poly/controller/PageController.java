package kopo.poly.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/landing"})
    public String landing() { return "landing"; }

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
