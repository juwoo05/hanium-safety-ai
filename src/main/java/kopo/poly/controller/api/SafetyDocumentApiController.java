package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.DocumentSaveRequest;
import kopo.poly.dto.response.DocumentResponse;
import kopo.poly.entity.enums.DocumentType;
import kopo.poly.service.ISafetyDocumentService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
public class SafetyDocumentApiController {

    private final ISafetyDocumentService safetyDocumentService;

    public SafetyDocumentApiController(ISafetyDocumentService safetyDocumentService) {
        this.safetyDocumentService = safetyDocumentService;
    }

    @PostMapping("/api/documents")
    @ResponseStatus(HttpStatus.CREATED)
    public DocumentResponse save(@RequestBody DocumentSaveRequest request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        return DocumentResponse.from(safetyDocumentService.save(request, loginUserId));
    }

    @GetMapping("/api/documents")
    public List<DocumentResponse> getByInspection(@RequestParam Long inspectionId, HttpSession session) {
        requireLoginUserId(session);
        return safetyDocumentService.findByInspectionId(inspectionId).stream()
                .map(DocumentResponse::from)
                .toList();
    }

    // "보고서" 메뉴 진입 시 내가 이전에 작성해둔 보고서 목록
    @GetMapping("/api/documents/mine")
    public List<DocumentResponse> mine(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        return safetyDocumentService.findMine(loginUserId).stream()
                .map(DocumentResponse::from)
                .toList();
    }

    @GetMapping("/api/documents/draft")
    public Map<String, Object> draft(
            @RequestParam Long inspectionId,
            @RequestParam DocumentType docType,
            HttpSession session
    ) {
        requireLoginUserId(session);
        return safetyDocumentService.buildDraft(inspectionId, docType);
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }
}
