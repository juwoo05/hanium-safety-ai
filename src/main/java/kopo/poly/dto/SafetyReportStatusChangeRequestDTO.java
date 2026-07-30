package kopo.poly.dto;

import kopo.poly.entity.enums.ReportStatus;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SafetyReportStatusChangeRequestDTO {
    private ReportStatus status;
}
