package kopo.poly.service;

// KISCON(국토교통부 건설업체정보) 서비스 호출 실패 시 던지는 예외.
public class KisconException extends RuntimeException {

    public KisconException(String message) {
        super(message);
    }

    public KisconException(String message, Throwable cause) {
        super(message, cause);
    }
}
