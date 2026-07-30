package kopo.poly.service.impl;

import kopo.poly.dto.NotificationResponseDTO;
import kopo.poly.entity.Notification;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.NotificationSeverity;
import kopo.poly.entity.enums.NotificationType;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.NotificationRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.INotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService implements INotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public List<NotificationResponseDTO> getNotifications(Long receiverId, String filter) {
        List<Notification> notifications = switch (normalizeFilter(filter)) {
            case "unread" -> notificationRepository.findByReceiverIdAndReadFalseOrderByCreatedAtDesc(receiverId);
            case "danger" -> notificationRepository.findByReceiverIdAndTypeOrderByCreatedAtDesc(receiverId, NotificationType.DANGER);
            case "action" -> notificationRepository.findByReceiverIdAndTypeOrderByCreatedAtDesc(receiverId, NotificationType.ACTION);
            case "report" -> notificationRepository.findByReceiverIdAndTypeOrderByCreatedAtDesc(receiverId, NotificationType.REPORT);
            default -> notificationRepository.findByReceiverIdOrderByCreatedAtDesc(receiverId);
        };
        return notifications.stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public long getUnreadCount(Long receiverId) {
        return notificationRepository.countByReceiverIdAndReadFalse(receiverId);
    }

    @Override
    @Transactional
    public void markAllRead(Long receiverId) {
        notificationRepository.markAllReadByReceiverId(receiverId, LocalDateTime.now());
    }

    @Override
    @Transactional
    public void markRead(Long notificationId, Long receiverId) {
        notificationRepository.findByIdAndReceiverId(notificationId, receiverId).ifPresent(n -> {
            if (!n.isRead()) {
                n.markRead(LocalDateTime.now());
            }
        });
    }

    @Override
    @Transactional
    public String markReadAndGetTargetUrl(Long notificationId, Long receiverId) {
        String targetUrl = notificationRepository.findByIdAndReceiverId(notificationId, receiverId)
                .map(n -> {
                    if (!n.isRead()) {
                        n.markRead(LocalDateTime.now());
                    }
                    return n.getTargetUrl();
                })
                .orElse(null);
        return isSafeInternalPath(targetUrl) ? targetUrl : "/notifications";
    }

    @Override
    @Transactional
    public Notification create(Long receiverId, NotificationType type, String title, String message,
                                NotificationSeverity severity, String targetUrl, String relatedType, Long relatedId) {
        User receiver = receiverId != null ? userRepository.findById(receiverId).orElse(null) : null;
        Notification notification = Notification.builder()
                .receiver(receiver)
                .type(type)
                .title(title)
                .message(message)
                .severity(severity)
                .targetUrl(targetUrl)
                .relatedType(relatedType)
                .relatedId(relatedId)
                .read(false)
                .createdAt(LocalDateTime.now())
                .build();
        return notificationRepository.save(notification);
    }

    @Override
    @Transactional
    public void notifyReportRegisteredToPrimeContractors(Long reportId, String reportTitle) {
        List<User> receivers = userRepository.findByRole(UserRole.원청);
        for (User receiver : receivers) {
            create(receiver.getId(), NotificationType.REPORT,
                    "새 신고가 접수되었습니다",
                    reportTitle + " 신고가 접수되었습니다. 확인이 필요합니다.",
                    NotificationSeverity.MEDIUM,
                    "/report-board/detail?id=" + reportId,
                    "SAFETY_REPORT", reportId);
        }
    }

    @Override
    @Transactional
    public void notifyReportStatusChanged(Long reporterId, Long reportId, String reportTitle,
                                           String statusLabel, NotificationSeverity severity) {
        if (reporterId == null) {
            return;
        }
        create(reporterId, NotificationType.REPORT,
                "신고 처리 상태가 변경되었습니다",
                reportTitle + " 신고가 '" + statusLabel + "' 상태로 변경되었습니다.",
                severity,
                "/report-board/detail?id=" + reportId,
                "SAFETY_REPORT", reportId);
    }

    @Override
    @Transactional
    public void notifyActionAssigned(Long assigneeUserId, Long actionId, String actionTitle, LocalDateTime dueDate) {
        if (assigneeUserId == null) {
            return;
        }
        String dueDateText = dueDate != null ? " · 마감 " + dueDate.toLocalDate() : "";
        create(assigneeUserId, NotificationType.ACTION,
                "새 조치가 배정되었습니다",
                actionTitle + " 조치가 배정되었습니다" + dueDateText,
                NotificationSeverity.MEDIUM,
                "/actions/detail?id=" + actionId,
                "SAFETY_ACTION", actionId);
    }

    /**
     * safety_actions의 due_date가 임박하거나 초과했을 때 담당자에게 알림을 생성한다.
     * safety_actions 엔티티는 이번 범위에 포함되지 않으므로, 향후 배치/스케줄러 연동 지점에서
     * 호출할 수 있도록 서비스 메서드만 준비해둔다.
     */
    @Override
    @Transactional
    public void notifyActionDueSoonOrOverdue(Long assigneeUserId, Long actionId, String actionTitle,
                                              LocalDateTime dueDate, boolean overdue) {
        if (assigneeUserId == null) {
            return;
        }
        String title = overdue ? "조치 기한이 초과되었습니다" : "조치 마감이 임박했습니다";
        NotificationSeverity severity = overdue ? NotificationSeverity.HIGH : NotificationSeverity.MEDIUM;
        create(assigneeUserId, NotificationType.ACTION,
                title,
                actionTitle + " 조치의 마감 기한(" + dueDate.toLocalDate() + ")을 확인해주세요.",
                severity,
                "/actions/detail?id=" + actionId,
                "SAFETY_ACTION", actionId);
    }

    /**
     * ai_safety_inspections의 risk_level이 고위험으로 감지되었을 때 담당자에게 알림을 생성한다.
     * ai_safety_inspections 엔티티는 이번 범위에 포함되지 않으므로, AI 분석 파이프라인 연동 지점에서
     * 호출할 수 있도록 서비스 메서드만 준비해둔다.
     */
    @Override
    @Transactional
    public void notifyHighRiskInspection(Long receiverId, Long inspectionId, String inspectionTitle) {
        if (receiverId == null) {
            return;
        }
        create(receiverId, NotificationType.DANGER,
                inspectionTitle,
                "AI가 고위험 요소를 감지했습니다. 즉시 확인이 필요합니다.",
                NotificationSeverity.HIGH,
                "/actions/detail?id=" + inspectionId,
                "AI_SAFETY_INSPECTION", inspectionId);
    }

    private boolean isSafeInternalPath(String path) {
        return path != null && path.startsWith("/") && !path.startsWith("//") && !path.startsWith("/\\");
    }

    private NotificationResponseDTO toResponse(Notification n) {
        return NotificationResponseDTO.builder()
                .id(n.getId())
                .type(n.getType())
                .typeLabel(typeLabel(n.getType()))
                .severity(n.getSeverity())
                .title(n.getTitle())
                .message(n.getMessage())
                .targetUrl(n.getTargetUrl())
                .read(n.isRead())
                .dateGroupLabel(dateGroupLabel(n.getCreatedAt()))
                .relativeTime(relativeTime(n.getCreatedAt()))
                .build();
    }

    private String typeLabel(NotificationType type) {
        return switch (type) {
            case DANGER -> "위험 알림";
            case ACTION -> "조치 알림";
            case REPORT -> "신고 알림";
            case SYSTEM -> "시스템 알림";
        };
    }

    private String dateGroupLabel(LocalDateTime createdAt) {
        LocalDate today = LocalDate.now();
        LocalDate date = createdAt.toLocalDate();
        if (date.isEqual(today)) {
            return "오늘";
        }
        if (date.isEqual(today.minusDays(1))) {
            return "어제";
        }
        return date.format(DateTimeFormatter.ofPattern("MM.dd"));
    }

    private String relativeTime(LocalDateTime createdAt) {
        Duration duration = Duration.between(createdAt, LocalDateTime.now());
        long minutes = duration.toMinutes();
        if (minutes < 1) {
            return "방금 전";
        }
        if (minutes < 60) {
            return minutes + "분 전";
        }
        long hours = duration.toHours();
        if (hours < 24) {
            return hours + "시간 전";
        }
        LocalDate today = LocalDate.now();
        if (createdAt.toLocalDate().isEqual(today.minusDays(1))) {
            return "어제 " + createdAt.format(DateTimeFormatter.ofPattern("HH:mm"));
        }
        return createdAt.format(DateTimeFormatter.ofPattern("MM-dd HH:mm"));
    }

    private String normalizeFilter(String filter) {
        return filter == null ? "all" : filter.toLowerCase();
    }
}
