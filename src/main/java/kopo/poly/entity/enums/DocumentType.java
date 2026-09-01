package kopo.poly.entity.enums;

public enum DocumentType {
    // 점검 서류
    INSPECTION_LOG("안전점검일지"),
    // 조치/보고 서류
    RISK_ASSESSMENT("위험성평가서"),
    ACTION_REPORT("조치결과보고서"),
    WORK_PERMIT("작업허가서"),
    // 교육 서류
    SAFETY_EDU_LOG("안전보건교육일지"),
    // TBM
    TBM_LOG("TBM 일지"),
    // 보호구
    PPE_ISSUE_LOG("보호구 지급대장"),
    // 예산/증빙
    SAFETY_EXPENSE_LOG("산업안전보건관리비 사용내역서");

    private final String label;

    DocumentType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
