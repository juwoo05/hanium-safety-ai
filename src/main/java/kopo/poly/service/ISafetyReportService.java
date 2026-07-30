package kopo.poly.service;

import kopo.poly.dto.SafetyReportCommentRequestDTO;
import kopo.poly.dto.SafetyReportCommentResponseDTO;
import kopo.poly.dto.SafetyReportCreateRequestDTO;
import kopo.poly.dto.SafetyReportDetailResponseDTO;
import kopo.poly.dto.SafetyReportListItemDTO;
import kopo.poly.dto.SafetyReportStatsResponseDTO;
import kopo.poly.dto.SafetyReportTimelineItemResponseDTO;
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

    void changeStatus(Long reportId, ReportStatus newStatus, Long actorUserId);
}
