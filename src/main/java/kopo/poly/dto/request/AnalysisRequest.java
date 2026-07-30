package kopo.poly.dto.request;

// 현장관리자가 Wizard Steps(사진등록→분석확인)에서 분석을 요청할 때 보내는 값.
// imageS3Key는 사진이 이미 S3에 업로드된 이후의 키를 의미한다.
public record AnalysisRequest(
        String siteId,
        String imageS3Key,
        String workInfo,
        String location,
        String workType,
        Long requestedBy
) {
}
