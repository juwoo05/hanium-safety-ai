package kopo.poly.service;

import kopo.poly.dto.response.AnalyticsSummaryResponseDTO;

public interface IAnalyticsService {

    AnalyticsSummaryResponseDTO summarize(int year);
}
