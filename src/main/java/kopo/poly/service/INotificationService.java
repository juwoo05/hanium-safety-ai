package kopo.poly.service;

import kopo.poly.dto.response.NotificationResponseDTO;
import kopo.poly.entity.Notification;
import kopo.poly.entity.enums.NotificationSeverity;
import kopo.poly.entity.enums.NotificationType;

import java.time.LocalDateTime;
import java.util.List;

public interface INotificationService {

    List<NotificationResponseDTO> getNotifications(Long receiverId, String filter);

    long getUnreadCount(Long receiverId);

    void markAllRead(Long receiverId);

    void markRead(Long notificationId, Long receiverId);

    String markReadAndGetTargetUrl(Long notificationId, Long receiverId);

    Notification create(Long receiverId, NotificationType type, String title, String message,
                         NotificationSeverity severity, String targetUrl, String relatedType, Long relatedId);

    void notifyReportRegisteredToPrimeContractors(Long reportId, String reportTitle);

    void notifyReportStatusChanged(Long reporterId, Long reportId, String reportTitle,
                                    String statusLabel, NotificationSeverity severity);

    void notifyActionAssigned(Long assigneeUserId, Long actionId, String actionTitle, LocalDateTime dueDate);

    void notifyActionDueSoonOrOverdue(Long assigneeUserId, Long actionId, String actionTitle,
                                       LocalDateTime dueDate, boolean overdue);

    void notifyHighRiskInspection(Long receiverId, Long inspectionId, String inspectionTitle);
}
