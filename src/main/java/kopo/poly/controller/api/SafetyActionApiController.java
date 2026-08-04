package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.ActionCreateRequest;
import kopo.poly.dto.request.ActionStatusUpdateRequest;
import kopo.poly.dto.response.ActionResponse;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.service.SafetyActionService;
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

@RestController
public class SafetyActionApiController {

    private final SafetyActionService safetyActionService;

    public SafetyActionApiController(SafetyActionService safetyActionService) {
        this.safetyActionService = safetyActionService;
    }

    // 조치 관리 목록 화면: 필터/검색 결과에 현장명·담당자 실명까지 채워서 반환한다.
    @GetMapping("/api/actions/search")
    public List<ActionResponse> search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) ActionStatus status,
            @RequestParam(required = false) RiskLevel riskLevel,
            @RequestParam(required = false) String siteName,
            HttpSession session
    ) {
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return safetyActionService.search(keyword, status, riskLevel, siteName).stream()
                .map(action -> ActionResponse.from(action, safetyActionService.resolveUserName(action.getReporterId())))
                .toList();
    }

    @PostMapping("/api/actions")
    @ResponseStatus(HttpStatus.CREATED)
    public ActionResponse create(@RequestBody ActionCreateRequest request) {
        return ActionResponse.from(safetyActionService.createManual(request));
    }

    @GetMapping("/api/actions")
    public List<ActionResponse> getByStatus(@RequestParam ActionStatus status) {
        return safetyActionService.findByStatus(status).stream()
                .map(ActionResponse::from)
                .toList();
    }

    @GetMapping("/api/actions/overdue")
    public List<ActionResponse> getOverdue() {
        return safetyActionService.findOverdue().stream()
                .map(ActionResponse::from)
                .toList();
    }

    @PatchMapping("/api/actions/{id}/status")
    public ActionResponse updateStatus(@PathVariable Long id, @RequestBody ActionStatusUpdateRequest request) {
        return ActionResponse.from(safetyActionService.updateStatus(id, request.status()));
    }
}
