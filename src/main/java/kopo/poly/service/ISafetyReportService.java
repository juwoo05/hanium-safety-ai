package kopo.poly.service;

import kopo.poly.dto.request.SafetyReportCommentRequestDTO;
import kopo.poly.dto.response.SafetyReportCommentResponseDTO;
import kopo.poly.dto.request.SafetyReportCreateRequestDTO;
import kopo.poly.dto.response.SafetyReportDetailResponseDTO;
import kopo.poly.dto.response.SafetyReportListItemDTO;
import kopo.poly.dto.response.SafetyReportStatsResponseDTO;
import kopo.poly.dto.response.SafetyReportTimelineItemResponseDTO;
import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import kopo.poly.entity.enums.ReportStatus;

import java.util.List;

public interface ISafetyReportService {

    List<SafetyReportListItemDTO> getReports(String keyword, ReportStatus status, ReportCategory category, ReportRiskLevel riskLevel);

    SafetyReportStatsResponseDTO getStats();

    SafetyReportDetailResponseDTO getReportDetail(Long reportId);

    void increaseView(Long reportId);

    List<SafetyReportCommentResponseDTO> getComments(Long reportId);

    List<SafetyReportTimelineItemResponseDTO> getTimeline(Long reportId);

    Long createReport(SafetyReportCreateRequestDTO request, Long reporterUserId);

    void addComment(Long reportId, SafetyReportCommentRequestDTO request, Long writerUserId);

    // 댓글 작성자 본인 또는 원청(운영 관리 목적)만 삭제할 수 있다.
    void deleteComment(Long reportId, Long commentId, Long actorUserId);

    void changeStatus(Long reportId, ReportStatus newStatus, Long actorUserId);
}
