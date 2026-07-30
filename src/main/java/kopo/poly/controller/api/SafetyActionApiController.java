package kopo.poly.controller.api;

import kopo.poly.dto.request.ActionCreateRequest;
import kopo.poly.dto.request.ActionStatusUpdateRequest;
import kopo.poly.dto.response.ActionResponse;
import kopo.poly.entity.enums.ActionStatus;
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

import java.util.List;

@RestController
public class SafetyActionApiController {

    private final SafetyActionService safetyActionService;

    public SafetyActionApiController(SafetyActionService safetyActionService) {
        this.safetyActionService = safetyActionService;
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
