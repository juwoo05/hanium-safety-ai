package kopo.poly.dto.request;

// 브라우저 → Spring: 사진에서 MSDS 물질 인식 요청.
// imageS3Key(업로드/촬영한 사진)가 있으면 그것을, 없고 inspectionId만 있으면 그 점검의 첫 사진을 쓴다.
public record MsdsDetectApiRequestDTO(
        String imageS3Key,
        Long inspectionId,
        String workInfo
) {
}
