package kopo.poly.repository;

import kopo.poly.entity.Notification;
import kopo.poly.entity.enums.NotificationType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    Optional<Notification> findByIdAndReceiverId(Long id, Long receiverId);

    List<Notification> findByReceiverIdOrderByCreatedAtDesc(Long receiverId);

    List<Notification> findByReceiverIdAndReadFalseOrderByCreatedAtDesc(Long receiverId);

    List<Notification> findByReceiverIdAndTypeOrderByCreatedAtDesc(Long receiverId, NotificationType type);

    long countByReceiverIdAndReadFalse(Long receiverId);

    long countByReceiverIdAndCreatedAtAfter(Long receiverId, LocalDateTime after);

    @Modifying
    @Query("UPDATE Notification n SET n.read = true, n.readAt = :now WHERE n.receiver.id = :receiverId AND n.read = false")
    int markAllReadByReceiverId(@Param("receiverId") Long receiverId, @Param("now") LocalDateTime now);
}
