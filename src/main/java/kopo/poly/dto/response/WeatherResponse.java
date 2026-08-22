package kopo.poly.dto.response;

// 대시보드 날씨 위젯에서 보여주는 서울 지역 단기예보 요약
public record WeatherResponse(
        String skyCondition,
        String precipitationType,
        Integer precipitationProbability,
        Integer temperature,
        Integer todayMin,
        Integer todayMax,
        String fcstDate,
        String fcstTime
) {
}
