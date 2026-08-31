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

    /** 알림 페이지를 마지막으로 방문한 이후 새로 도착한 알림 개수 (헤더 종 배지용). */
    long getUnseenCount(Long receiverId);

    /** 알림 페이지 방문 시각을 현재로 갱신한다. 개별 알림의 읽음 상태는 바꾸지 않는다. */
    void markNotificationsSeen(Long receiverId);

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
