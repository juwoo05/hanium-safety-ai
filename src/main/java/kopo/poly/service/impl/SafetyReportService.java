package kopo.poly.service.impl;

import kopo.poly.dto.request.SafetyReportCommentRequestDTO;
import kopo.poly.dto.response.SafetyReportCommentResponseDTO;
import kopo.poly.dto.request.SafetyReportCreateRequestDTO;
import kopo.poly.dto.response.SafetyReportDetailResponseDTO;
import kopo.poly.dto.response.SafetyReportListItemDTO;
import kopo.poly.dto.response.SafetyReportStatsResponseDTO;
import kopo.poly.dto.response.SafetyReportTimelineItemResponseDTO;
import kopo.poly.entity.SafetyReport;
import kopo.poly.entity.SafetyReportComment;
import kopo.poly.entity.SafetyReportTimeline;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.NotificationSeverity;
import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.SafetyReportCommentRepository;
import kopo.poly.repository.SafetyReportRepository;
import kopo.poly.repository.SafetyReportTimelineRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.INotificationService;
import kopo.poly.service.ISafetyReportService;
import kopo.poly.specification.SafetyReportSpecifications;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SafetyReportService implements ISafetyReportService {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private final SafetyReportRepository safetyReportRepository;
    private final SafetyReportCommentRepository safetyReportCommentRepository;
    private final SafetyReportTimelineRepository safetyReportTimelineRepository;
    private final UserRepository userRepository;
    private final INotificationService notificationService;

    @Override
    @Transactional(readOnly = true)
    public List<SafetyReportListItemDTO> getReports(String keyword, ReportStatus status,
                                                      ReportCategory category, ReportRiskLevel riskLevel) {
        Specification<SafetyReport> spec = SafetyReportSpecifications.search(keyword, status, category, riskLevel);
        return safetyReportRepository.findAll(spec, Sort.by(Sort.Direction.DESC, "createdAt"))
                .stream()
                .map(this::toListItem)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public SafetyReportStatsResponseDTO getStats() {
        return SafetyReportStatsResponseDTO.builder()
                .total(safetyReportRepository.count())
                .inProgress(safetyReportRepository.countByStatus(ReportStatus.IN_PROGRESS))
                .completed(safetyReportRepository.countByStatus(ReportStatus.COMPLETED))
                .highRisk(safetyReportRepository.countByRiskLevel(ReportRiskLevel.HIGH))
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public SafetyReportDetailResponseDTO getReportDetail(Long reportId) {
        return toDetailResponse(getReportOrThrow(reportId));
    }

    @Override
    @Transactional
    public void increaseView(Long reportId) {
        getReportOrThrow(reportId).increaseView();
    }

    @Override
    @Transactional(readOnly = true)
    public List<SafetyReportCommentResponseDTO> getComments(Long reportId) {
        return safetyReportCommentRepository.findByReportIdOrderByCreatedAtAsc(reportId).stream()
                .map(this::toCommentResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<SafetyReportTimelineItemResponseDTO> getTimeline(Long reportId) {
        SafetyReport report = getReportOrThrow(reportId);
        List<SafetyReportTimelineItemResponseDTO> items = safetyReportTimelineRepository
                .findByReportIdOrderByCreatedAtAsc(reportId).stream()
                .map(t -> SafetyReportTimelineItemResponseDTO.builder()
                        .label(t.getLabel())
                        .description(t.getDescription())
                        .dateLabel(t.getCreatedAt().format(DATE_TIME_FORMAT))
                        .done(true)
                        .build())
                .collect(Collectors.toCollection(ArrayList::new));

        if (report.getStatus() == ReportStatus.RECEIVED || report.getStatus() == ReportStatus.IN_PROGRESS) {
            items.add(SafetyReportTimelineItemResponseDTO.builder()
                    .label("조치 완료")
                    .description("처리 완료 시 안내됩니다.")
                    .dateLabel("처리 예정")
                    .done(false)
                    .build());
        }
        return items;
    }

    @Override
    @Transactional
    public Long createReport(SafetyReportCreateRequestDTO request, Long reporterUserId) {
        LocalDateTime now = LocalDateTime.now();
        User reporter = !request.isAnonymous() && reporterUserId != null
                ? userRepository.findById(reporterUserId).orElse(null)
                : null;
        String reporterNameSnapshot = request.isAnonymous()
                ? "익명"
                : (reporter != null ? reporter.getUsername() : "게스트");

        SafetyReport report = SafetyReport.builder()
                .title(request.getTitle())
                .category(request.getCategory())
                .riskLevel(request.getRiskLevel())
                .location(request.getLocation())
                .description(request.getDescription())
                .status(ReportStatus.RECEIVED)
                .anonymous(request.isAnonymous())
                .reporter(reporter)
                .reporterNameSnapshot(reporterNameSnapshot)
                .views(0L)
                .createdAt(now)
                .updatedAt(now)
                .build();
        safetyReportRepository.save(report);

        safetyReportTimelineRepository.save(SafetyReportTimeline.builder()
                .report(report)
                .status(ReportStatus.RECEIVED)
                .label("신고 접수")
                .description("신고가 안전 관리팀에 접수되었습니다.")
                .createdBy(reporter)
                .createdAt(now)
                .build());

        notificationService.notifyReportRegisteredToPrimeContractors(report.getId(), report.getTitle());

        return report.getId();
    }

    @Override
    @Transactional
    public void addComment(Long reportId, SafetyReportCommentRequestDTO request, Long writerUserId) {
        SafetyReport report = getReportOrThrow(reportId);
        User writer = writerUserId != null ? userRepository.findById(writerUserId).orElse(null) : null;

        safetyReportCommentRepository.save(SafetyReportComment.builder()
                .report(report)
                .writer(writer)
                .writerNameSnapshot(writer != null ? writer.getUsername() : "나")
                .writerRoleSnapshot(writer != null ? writer.getRole().name() : "작업자")
                .content(request.getContent())
                .official(false)
                .createdAt(LocalDateTime.now())
                .build());
    }

    @Override
    @Transactional
    public void deleteComment(Long reportId, Long commentId, Long actorUserId) {
        SafetyReportComment comment = safetyReportCommentRepository.findById(commentId)
                .orElseThrow(() -> new NoSuchElementException("댓글을 찾을 수 없습니다. id=" + commentId));
        if (!comment.getReport().getId().equals(reportId)) {
            throw new NoSuchElementException("댓글을 찾을 수 없습니다. id=" + commentId);
        }

        User actor = actorUserId != null ? userRepository.findById(actorUserId).orElse(null) : null;
        boolean isWriter = actor != null && comment.getWriter() != null && comment.getWriter().getId().equals(actor.getId());
        boolean isPrimeContractor = actor != null && actor.getRole() == UserRole.원청;
        if (!isWriter && !isPrimeContractor) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "댓글을 삭제할 권한이 없습니다.");
        }

        safetyReportCommentRepository.delete(comment);
    }

    @Override
    @Transactional
    public void changeStatus(Long reportId, ReportStatus newStatus, Long actorUserId) {
        User actor = actorUserId != null ? userRepository.findById(actorUserId).orElse(null) : null;
        if (actor == null || actor.getRole() != UserRole.원청) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "신고 상태 변경 권한이 없습니다.");
        }

        SafetyReport report = getReportOrThrow(reportId);
        LocalDateTime now = LocalDateTime.now();

        report.changeStatus(newStatus, now);

        String label = switch (newStatus) {
            case IN_PROGRESS -> "처리중";
            case COMPLETED -> "조치 완료";
            case REJECTED -> "반려";
            case RECEIVED -> "신고 접수";
        };
        String description = switch (newStatus) {
            case IN_PROGRESS -> "담당자가 신고 내용을 확인하고 처리를 시작했습니다.";
            case COMPLETED -> "신고에 대한 조치가 완료되었습니다.";
            case REJECTED -> "신고 내용을 검토한 결과 반려되었습니다.";
            case RECEIVED -> "신고가 접수되었습니다.";
        };

        safetyReportTimelineRepository.save(SafetyReportTimeline.builder()
                .report(report)
                .status(newStatus)
                .label(label)
                .description(description)
                .createdBy(actor)
                .createdAt(now)
                .build());

        if (newStatus == ReportStatus.COMPLETED || newStatus == ReportStatus.REJECTED) {
            Long reporterId = report.getReporter() != null ? report.getReporter().getId() : null;
            NotificationSeverity severity = newStatus == ReportStatus.REJECTED
                    ? NotificationSeverity.LOW
                    : NotificationSeverity.INFO;
            notificationService.notifyReportStatusChanged(reporterId, report.getId(), report.getTitle(), label, severity);
        }
    }

    private SafetyReport getReportOrThrow(Long reportId) {
        return safetyReportRepository.findById(reportId)
                .orElseThrow(() -> new NoSuchElementException("신고를 찾을 수 없습니다. id=" + reportId));
    }

    private SafetyReportListItemDTO toListItem(SafetyReport report) {
        return SafetyReportListItemDTO.builder()
                .id(report.getId())
                .title(report.getTitle())
                .categoryLabel(categoryLabel(report.getCategory()))
                .riskLevelValue(riskLevelValue(report.getRiskLevel()))
                .riskLevelLabel(riskLevelLabel(report.getRiskLevel()))
                .statusValue(statusValue(report.getStatus()))
                .statusLabel(statusLabel(report.getStatus()))
                .location(report.getLocation())
                .createdDateLabel(report.getCreatedAt().format(DATE_FORMAT))
                .anonymous(report.isAnonymous())
                .reporterName(reporterName(report))
                .views(report.getViews())
                .description(report.getDescription())
                .build();
    }

    private SafetyReportDetailResponseDTO toDetailResponse(SafetyReport report) {
        return SafetyReportDetailResponseDTO.builder()
                .id(report.getId())
                .title(report.getTitle())
                .categoryLabel(categoryLabel(report.getCategory()))
                .riskLevelValue(riskLevelValue(report.getRiskLevel()))
                .riskLevelLabel(riskLevelLabel(report.getRiskLevel()))
                .statusValue(statusValue(report.getStatus()))
                .statusLabel(statusLabel(report.getStatus()))
                .location(report.getLocation())
                .createdDateLabel(report.getCreatedAt().format(DATE_FORMAT))
                .anonymous(report.isAnonymous())
                .reporterName(reporterName(report))
                .views(report.getViews())
                .description(report.getDescription())
                .build();
    }

    private SafetyReportCommentResponseDTO toCommentResponse(SafetyReportComment comment) {
        return SafetyReportCommentResponseDTO.builder()
                .id(comment.getId())
                .writerName(comment.getWriterNameSnapshot())
                .writerRole(comment.getWriterRoleSnapshot())
                .content(comment.getContent())
                .official(comment.isOfficial())
                .createdAtLabel(comment.getCreatedAt().format(DATE_TIME_FORMAT))
                .build();
    }

    private String reporterName(SafetyReport report) {
        return report.isAnonymous() || !StringUtils.hasText(report.getReporterNameSnapshot())
                ? "익명"
                : report.getReporterNameSnapshot();
    }

    private String categoryLabel(ReportCategory category) {
        return switch (category) {
            case SAFETY_VIOLATION -> "안전 위반";
            case DEFECTIVE_MATERIAL -> "불량 자재";
            case WORK_ENVIRONMENT -> "작업 환경";
            case ILLEGAL_SUBCONTRACT -> "불법 하도급";
            case ETC -> "기타";
        };
    }

    private String riskLevelValue(ReportRiskLevel riskLevel) {
        return riskLevel.name().toLowerCase();
    }

    private String riskLevelLabel(ReportRiskLevel riskLevel) {
        return switch (riskLevel) {
            case HIGH -> "고위험";
            case MEDIUM -> "중위험";
            case LOW -> "저위험";
        };
    }

    private String statusValue(ReportStatus status) {
        return status.name();
    }

    private String statusLabel(ReportStatus status) {
        return switch (status) {
            case RECEIVED -> "접수";
            case IN_PROGRESS -> "처리중";
            case COMPLETED -> "완료";
            case REJECTED -> "반려";
        };
    }
}
