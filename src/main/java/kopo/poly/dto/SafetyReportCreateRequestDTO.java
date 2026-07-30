package kopo.poly.dto;

import kopo.poly.entity.enums.ReportCategory;
import kopo.poly.entity.enums.ReportRiskLevel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SafetyReportCreateRequestDTO {
    private String title;
    private ReportCategory category;
    private ReportRiskLevel riskLevel;
    private String location;
    private String description;
    private boolean anonymous = true;
}
