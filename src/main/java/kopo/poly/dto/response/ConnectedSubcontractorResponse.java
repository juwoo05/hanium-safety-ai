package kopo.poly.dto.response;

import java.time.LocalDateTime;

// 원청이 "연결된 하청 업체" 표에서 보는 정보
public record ConnectedSubcontractorResponse(
        String companyName,
        String managerName,
        String siteName,
        LocalDateTime joinedAt
) {
}
