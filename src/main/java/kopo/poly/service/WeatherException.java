package kopo.poly.service;

// 기상청 단기예보 서비스 호출 실패 시 던지는 예외.
public class WeatherException extends RuntimeException {

    public WeatherException(String message) {
        super(message);
    }

    public WeatherException(String message, Throwable cause) {
        super(message, cause);
    }
}
