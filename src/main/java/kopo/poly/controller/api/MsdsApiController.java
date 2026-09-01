package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.MsdsAttachRequest;
import kopo.poly.dto.request.MsdsDetectApiRequest;
import kopo.poly.dto.response.MsdsDetectResponseDto;
import kopo.poly.dto.response.MsdsDocumentResponse;
import kopo.poly.dto.response.MsdsSearchResultDto;
import kopo.poly.service.IMsdsService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

// 인가 정책: 이 컨트롤러는 로그인 여부만 확인하고, inspectionId/msdsId에 대한
// 소유자(객체 수준) 검사는 하지 않는다. 이는 SafetyDocumentApiController·EvidenceApiController·
// AiSafetyInspectionApiController 등 점검 기반 API 전체의 기존 관행을 그대로 따른 것이다
// (원청이 AI 분석을 요청하고 하청이 조치·서류 작업을 하는 협업 모델이라 requestedBy 단독 소유가 아님).
// 사이트 멤버십(SiteMembership) 기반 스코프 검사는 점검 기반 API 전체에 일괄 적용해야 하는
// 별도 과제로 남긴다. (TODO: cross-cutting authorization)
@RestController
public class MsdsApiController {

    private final IMsdsService msdsService;

    public MsdsApiController(IMsdsService msdsService) {
        this.msdsService = msdsService;
    }

    // 업로드/촬영한 사진(또는 점검 사진)에서 물질/제품/경고표지 키워드와 화학물질 후보를 인식한다.
    @PostMapping("/api/msds/detect")
    public MsdsDetectResponseDto detect(@RequestBody MsdsDetectApiRequest request, HttpSession session) {
        requireLoginUserId(session);
        if (request.imageS3Key() != null && !request.imageS3Key().isBlank()) {
            return msdsService.detectFromImage(request.imageS3Key(), request.workInfo());
        }
        if (request.inspectionId() != null) {
            return msdsService.detectFromInspection(request.inspectionId());
        }
        throw new IllegalArgumentException("imageS3Key 또는 inspectionId가 필요합니다.");
    }

    // 물질명/CAS/제품명으로 MSDS 후보를 검색한다.
    @GetMapping("/api/msds/search")
    public List<MsdsSearchResultDto> search(@RequestParam String query, HttpSession session) {
        requireLoginUserId(session);
        return msdsService.search(query);
    }

    // 선택한 MSDS를 점검 또는 조치에 첨부한다.
    @PostMapping("/api/msds/attach")
    @ResponseStatus(HttpStatus.CREATED)
    public MsdsDocumentResponse attach(@RequestBody MsdsAttachRequest request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        return msdsService.attach(request, loginUserId);
    }

    // 해당 점검에 첨부된 MSDS 목록.
    @GetMapping("/api/msds/inspection/{inspectionId}")
    public List<MsdsDocumentResponse> byInspection(@PathVariable Long inspectionId, HttpSession session) {
        requireLoginUserId(session);
        return msdsService.findByInspectionId(inspectionId);
    }

    // 내가 저장한 MSDS 전체(독립 MSDS 조회 화면의 "내 자료함").
    @GetMapping("/api/msds/mine")
    public List<MsdsDocumentResponse> mine(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        return msdsService.findMine(loginUserId);
    }

    // 첨부된 MSDS 확인 상태 토글.
    @PatchMapping("/api/msds/{msdsId}/verify")
    public MsdsDocumentResponse verify(
            @PathVariable Long msdsId,
            @RequestBody Map<String, Boolean> body,
            HttpSession session
    ) {
        requireLoginUserId(session);
        return msdsService.setVerified(msdsId, Boolean.TRUE.equals(body.get("verified")));
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }
}
