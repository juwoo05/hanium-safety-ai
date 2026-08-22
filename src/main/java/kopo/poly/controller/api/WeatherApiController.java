package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.response.WeatherResponse;
import kopo.poly.service.WeatherClient;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

// 메인 대시보드 날씨(단기예보) 위젯
@RestController
public class WeatherApiController {

    private final WeatherClient weatherClient;

    public WeatherApiController(WeatherClient weatherClient) {
        this.weatherClient = weatherClient;
    }

    @GetMapping("/api/weather/today")
    public WeatherResponse today(HttpSession session) {
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return weatherClient.getTodayForecast();
    }
}
