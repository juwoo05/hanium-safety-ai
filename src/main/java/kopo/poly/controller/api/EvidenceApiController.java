package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.EvidenceItemDto;
import kopo.poly.service.EvidenceService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
public class EvidenceApiController {

    private final EvidenceService evidenceService;

    public EvidenceApiController(EvidenceService evidenceService) {
        this.evidenceService = evidenceService;
    }

    @GetMapping("/api/evidence")
    public List<EvidenceItemDto> search(
            @RequestParam Long inspectionId,
            @RequestParam(required = false) String category,
            HttpSession session
    ) {
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return evidenceService.searchForInspection(inspectionId, category);
    }
}
