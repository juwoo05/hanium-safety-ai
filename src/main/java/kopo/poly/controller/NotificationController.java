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

import java.util.Map;

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

        // 알림 페이지 방문 = 확인 완료. 헤더 종 배지만 초기화하고 개별 알림은 안 읽음 상태로 둔다.
        notificationService.markNotificationsSeen(loginUserId);
        return "notification/notifications";
    }

    @GetMapping("/unseen-count")
    @ResponseBody
    public Map<String, Long> unseenCount(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        long count = loginUserId != null ? notificationService.getUnseenCount(loginUserId) : 0L;
        return Map.of("count", count);
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
