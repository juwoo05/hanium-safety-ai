package kopo.poly.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SafetyReportTimelineItemResponseDTO {
    private String label;
    private String description;
    private String dateLabel;
    private boolean done;
}
