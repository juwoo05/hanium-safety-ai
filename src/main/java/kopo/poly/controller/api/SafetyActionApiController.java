package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.ActionCreateRequestDTO;
import kopo.poly.dto.request.ActionStatusUpdateRequestDTO;
import kopo.poly.dto.response.ActionResponseDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.ISafetyActionService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
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

@RestController
public class SafetyActionApiController {

    private final ISafetyActionService safetyActionService;
    private final UserRepository userRepository;

    public SafetyActionApiController(ISafetyActionService safetyActionService, UserRepository userRepository) {
        this.safetyActionService = safetyActionService;
        this.userRepository = userRepository;
    }

    // 조치 관리 목록 화면: 필터/검색 결과에 현장명·담당자 실명까지 채워서 반환한다.
    @GetMapping("/api/actions/search")
    public List<ActionResponseDTO> search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) ActionStatus status,
            @RequestParam(required = false) RiskLevel riskLevel,
            @RequestParam(required = false) String siteName,
            HttpSession session
    ) {
        Long loginUserId = requireLoginUserId(session);
        return safetyActionService.search(keyword, status, riskLevel, siteName, loginUserId).stream()
                .map(action -> ActionResponseDTO.from(action, safetyActionService.resolveUserName(action.getReporterId())))
                .toList();
    }

    @PostMapping("/api/actions")
    @ResponseStatus(HttpStatus.CREATED)
    public ActionResponseDTO create(@RequestBody ActionCreateRequestDTO request) {
        return ActionResponseDTO.from(safetyActionService.createManual(request));
    }

    @GetMapping("/api/actions")
    public List<ActionResponseDTO> getByStatus(@RequestParam ActionStatus status) {
        return safetyActionService.findByStatus(status).stream()
                .map(ActionResponseDTO::from)
                .toList();
    }

    @GetMapping("/api/actions/overdue")
    public List<ActionResponseDTO> getOverdue() {
        return safetyActionService.findOverdue().stream()
                .map(ActionResponseDTO::from)
                .toList();
    }

    // 조치전 카드를 인스펙션 없이(수동 등록) 클릭했을 때의 단건 상세 조회
    @GetMapping("/api/actions/{id}")
    public ActionResponseDTO getById(@PathVariable Long id, HttpSession session) {
        requireLoginUserId(session);
        var action = safetyActionService.findById(id);
        return ActionResponseDTO.from(action, safetyActionService.resolveUserName(action.getReporterId()));
    }

    @PatchMapping("/api/actions/{id}/status")
    public ActionResponseDTO updateStatus(@PathVariable Long id, @RequestBody ActionStatusUpdateRequestDTO request) {
        return ActionResponseDTO.from(safetyActionService.updateStatus(id, request.status()));
    }

    // 하청: 조치 완료를 원청에게 승인 요청한다.
    @PostMapping("/api/actions/{id}/submit-approval")
    public ActionResponseDTO submitForApproval(@PathVariable Long id, HttpSession session) {
        requireLoginUserId(session);
        return ActionResponseDTO.from(safetyActionService.submitForApproval(id));
    }

    // 원청 전용: 승인 요청을 승인해 완료 처리한다.
    @PostMapping("/api/actions/{id}/approve")
    public ActionResponseDTO approve(@PathVariable Long id, HttpSession session) {
        requirePrimeContractor(session);
        return ActionResponseDTO.from(safetyActionService.approveCompletion(id));
    }

    // 원청 전용: 승인 요청을 반려해 다시 진행중으로 되돌린다.
    @PostMapping("/api/actions/{id}/reject")
    public ActionResponseDTO reject(@PathVariable Long id, HttpSession session) {
        requirePrimeContractor(session);
        return ActionResponseDTO.from(safetyActionService.rejectCompletion(id));
    }

    // 원청 전용: 조치 항목을 영구 삭제한다.
    @DeleteMapping("/api/actions/{id}")
    public Map<String, Boolean> delete(@PathVariable Long id, HttpSession session) {
        requirePrimeContractor(session);
        safetyActionService.delete(id);
        return Map.of("ok", true);
    }

    private void requirePrimeContractor(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        boolean isPrimeContractor = userRepository.findById(loginUserId)
                .map(User::getRole)
                .filter(role -> role == UserRole.원청)
                .isPresent();
        if (!isPrimeContractor) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "원청만 승인/반려할 수 있습니다.");
        }
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }
}
