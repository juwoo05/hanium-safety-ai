package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.service.INotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final INotificationService notificationService;

    @GetMapping
    public String notifications(@RequestParam(name = "filter", defaultValue = "all") String filter,
                                 HttpSession session, Model model) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            return "redirect:/login";
        }
        model.addAttribute("notifications", notificationService.getNotifications(loginUserId, filter));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(loginUserId));
        model.addAttribute("currentFilter", filter);
        return "notification/notifications";
    }

    @PostMapping("/read-all")
    public String readAll(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId != null) {
            notificationService.markAllRead(loginUserId);
        }
        return "redirect:/notifications";
    }

    @PostMapping("/{id}/read")
    @ResponseBody
    public ResponseEntity<Void> read(@PathVariable Long id, HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId != null) {
            notificationService.markRead(id, loginUserId);
        }
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/redirect")
    public String redirectToTarget(@PathVariable Long id, HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            return "redirect:/login";
        }
        return "redirect:" + notificationService.markReadAndGetTargetUrl(id, loginUserId);
    }
}
