package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.response.AnalyticsSummaryResponse;
import kopo.poly.service.IAnalyticsService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;

@RestController
public class AnalyticsApiController {

    private final IAnalyticsService analyticsService;

    public AnalyticsApiController(IAnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @GetMapping("/api/analytics/summary")
    public AnalyticsSummaryResponse summary(
            @RequestParam(required = false) Integer year,
            HttpSession session
    ) {
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return analyticsService.summarize(year != null ? year : LocalDate.now().getYear());
    }
}
