package kopo.poly.entity.enums;

public enum DocumentType {
    INSPECTION_LOG("안전점검일지"),
    RISK_ASSESSMENT("위험성평가서"),
    ACTION_REPORT("조치결과보고서"),
    WORK_PERMIT("작업허가서");

    private final String label;

    DocumentType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
