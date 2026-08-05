package kopo.poly.service;

import kopo.poly.dto.response.AnalyticsSummaryResponse;

public interface IAnalyticsService {

    AnalyticsSummaryResponse summarize(int year);
}
