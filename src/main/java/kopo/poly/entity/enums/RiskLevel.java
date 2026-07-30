package kopo.poly.entity.enums;

public enum RiskLevel {
    HIGH("고위험"),
    MEDIUM("중위험"),
    SAFE("안전");

    private final String label;

    RiskLevel(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
