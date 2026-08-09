package kopo.poly.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SafetyReportCommentResponseDTO {
    private Long id;
    private String writerName;
    private String writerRole;
    private String content;
    private boolean official;
    private String createdAtLabel;
}
