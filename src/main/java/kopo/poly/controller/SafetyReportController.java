package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.SafetyReportCommentRequestDTO;
import kopo.poly.dto.request.SafetyReportCreateRequestDTO;
import kopo.poly.dto.request.SafetyReportStatusChangeRequestDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.ISafetyReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/report-board")
@RequiredArgsConstructor
public class SafetyReportController {

    private final ISafetyReportService reportService;
    private final UserRepository userRepository;

    @GetMapping
    public String list(@RequestParam(required = false) String keyword,
                        @RequestParam(required = false) String status,
                        @RequestParam(required = false) String category,
                        @RequestParam(required = false) String riskLevel,
                        Model model) {
        ReportStatus statusEnum = parseEnum(ReportStatus.class, status);
        ReportCategory categoryEnum = parseEnum(ReportCategory.class, category);
        ReportRiskLevel riskLevelEnum = parseEnum(ReportRiskLevel.class, riskLevel);

        model.addAttribute("reports", reportService.getReports(keyword, statusEnum, categoryEnum, riskLevelEnum));
        model.addAttribute("stats", reportService.getStats());
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentStatus", status);
        return "report-board/report-board";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam Long id, HttpSession session, Model model) {
        reportService.increaseView(id);
        model.addAttribute("report", reportService.getReportDetail(id));
        model.addAttribute("comments", reportService.getComments(id));
        model.addAttribute("timelines", reportService.getTimeline(id));
        model.addAttribute("canManageStatus", isPrimeContractor(loginUserId(session)));
        return "report-board/report-board-detail";
    }

    @PostMapping
    public String create(@ModelAttribute SafetyReportCreateRequestDTO request, HttpSession session) {
        Long reportId = reportService.createReport(request, loginUserId(session));
        return "redirect:/report-board/detail?id=" + reportId;
    }

    @PostMapping("/{id}/comments")
    public String addComment(@PathVariable Long id, @ModelAttribute SafetyReportCommentRequestDTO request, HttpSession session) {
        reportService.addComment(id, request, loginUserId(session));
        return "redirect:/report-board/detail?id=" + id;
    }

    // 댓글 작성자 본인 또는 원청만 삭제 가능 (서비스 계층에서 검증).
    @PostMapping("/{id}/comments/{commentId}/delete")
    public String deleteComment(@PathVariable Long id, @PathVariable Long commentId, HttpSession session) {
        reportService.deleteComment(id, commentId, loginUserId(session));
        return "redirect:/report-board/detail?id=" + id;
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id, @ModelAttribute SafetyReportStatusChangeRequestDTO request, HttpSession session) {
        Long loginUserId = loginUserId(session);
        if (loginUserId == null) {
            return "redirect:/login";
        }
        reportService.changeStatus(id, request.getStatus(), loginUserId);
        return "redirect:/report-board/detail?id=" + id;
    }

    private Long loginUserId(HttpSession session) {
        return (Long) session.getAttribute("LOGIN_USER_ID");
    }

    private boolean isPrimeContractor(Long userId) {
        return userId != null && userRepository.findById(userId)
                .map(User::getRole)
                .filter(role -> role == UserRole.원청)
                .isPresent();
    }

    private <E extends Enum<E>> E parseEnum(Class<E> type, String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Enum.valueOf(type, value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
