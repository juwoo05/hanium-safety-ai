package kopo.poly.entity.enums;

public enum ActionStatus {
    REQUESTED,         // 요청중
    IN_PROGRESS,       // 진행중
    PENDING_APPROVAL,  // 승인대기 (하청이 조치를 마치고 원청 승인을 요청한 상태)
    COMPLETED          // 완료 (원청이 승인한 뒤에만 도달)
}
