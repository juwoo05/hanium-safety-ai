package kopo.poly.controller;

import kopo.poly.entity.enums.UserRole;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/landing"})
    public String landing() { return "landing"; }

    // 사이드바 로고/메뉴가 역할 구분 없이 항상 "/dashboard"로 링크되어 있어서,
    // 하청 사용자가 눌러도 원청 대시보드로 가지 않도록 여기서 역할을 보고 갈라준다.
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {
        boolean sub = authentication != null && authentication.getAuthorities().stream()
                .anyMatch(a -> ("ROLE_" + UserRole.하청.name()).equals(a.getAuthority()));
        return sub ? "redirect:/dashboard/sub" : "dashboard/contractor-dashboard";
    }

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

    // 보고서 상세의 "안전양식 자동 작성"에서 진입하는 AI 결과보고서 생성 4단계 위저드.
    @GetMapping("/actions/detail/report")
    public String aiReport() { return "action/ai-report"; }

    @GetMapping("/analytics")
    public String analytics() { return "analytics/analytics"; }

    // /notifications 는 kopo.poly.controller.NotificationController 에서 처리한다.

    @GetMapping("/mypage")
    public String mypage() { return "mypage/mypage"; }

    @PostMapping("/mypage")
    public String mypagePost() { return "redirect:/mypage"; }

    // /report-board, /report-board/detail 은 kopo.poly.controller.SafetyReportController 에서 처리한다.
}
