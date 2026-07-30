package kopo.poly.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SafetyReportListItemDTO {
    private Long id;
    private String title;
    private String categoryLabel;
    private String riskLevelValue;
    private String riskLevelLabel;
    private String statusValue;
    private String statusLabel;
    private String location;
    private String createdDateLabel;
    private boolean anonymous;
    private String reporterName;
    private long views;
    private String description;
}
