package kopo.poly.dto.request;

import kopo.poly.entity.enums.ReportStatus;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SafetyReportStatusChangeRequestDTO {
    private ReportStatus status;
}
