package kopo.poly.dto;

import kopo.poly.entity.enums.NotificationSeverity;
import kopo.poly.entity.enums.NotificationType;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class NotificationResponseDTO {
    private Long id;
    private NotificationType type;
    private String typeLabel;
    private NotificationSeverity severity;
    private String title;
    private String message;
    private String targetUrl;
    private boolean read;
    private String dateGroupLabel;
    private String relativeTime;
}
