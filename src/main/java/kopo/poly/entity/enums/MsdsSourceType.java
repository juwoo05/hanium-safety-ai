package kopo.poly.entity.enums;

// MSDS/SDS 문서의 출처 구분.
// 법적으로 유효한 MSDS 제공 주체는 제조사/수입사/판매자이므로, KOSHA 자료는 "참고자료"로 명시한다.
public enum MsdsSourceType {
    KOSHA("KOSHA 참고자료"),
    MANUFACTURER("제조사 제공자료"),
    INTERNAL("내부 등록자료"),
    UNKNOWN("출처 미상");

    private final String label;

    MsdsSourceType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
