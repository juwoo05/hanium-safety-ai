package kopo.poly.service;

import kopo.poly.dto.request.MsdsAttachRequest;
import kopo.poly.dto.response.MsdsDetectResponseDto;
import kopo.poly.dto.response.MsdsDocumentResponse;
import kopo.poly.dto.response.MsdsSearchResultDto;

import java.util.List;

public interface IMsdsService {

    // 업로드/촬영한 사진(S3 키)에서 물질명/CAS/제품명/경고표지 키워드를 인식한다(FastAPI /msds/detect 프록시).
    // AI가 확정하지 못하면 chemicalCandidates 후보 목록으로 돌려준다. 점검 리포트가 없어도 사용 가능.
    MsdsDetectResponseDto detectFromImage(String imageS3Key, String workInfo);

    // 점검에 등록된 현장 사진에서 물질을 인식한다(보고서 상세의 MSDS 탭 전용).
    MsdsDetectResponseDto detectFromInspection(Long inspectionId);

    // 물질명/CAS/제품명으로 공식 MSDS 자료(KOSHA 참고자료 등)를 검색한다.
    List<MsdsSearchResultDto> search(String query);

    // 검색/선택한 MSDS를 저장한다. 점검/조치에 연결하거나(첨부), 대상 없이 내 자료함에 담을 수 있다.
    MsdsDocumentResponse attach(MsdsAttachRequest request, Long createdBy);

    // 특정 점검에 첨부된 MSDS 목록.
    List<MsdsDocumentResponse> findByInspectionId(Long inspectionId);

    // 내가 저장한 MSDS 전체 목록(독립 MSDS 조회 화면).
    List<MsdsDocumentResponse> findMine(Long createdBy);

    // 저장된 MSDS 확인 상태 토글(현장관리자가 "이 물질/문서가 맞다"고 확인).
    MsdsDocumentResponse setVerified(Long msdsId, boolean verified);
}
