package kopo.poly.dto.response;

// 대시보드 날씨 위젯에서 보여주는 서울 지역 초단기예보(향후 6시간) 요약
public record WeatherResponse(
        String skyCondition,
        String precipitationType,
        String precipitationAmount,
        Integer temperature,
        String fcstDate,
        String fcstTime
) {
}
