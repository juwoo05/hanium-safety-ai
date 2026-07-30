package kopo.poly.controller.api;

import kopo.poly.dto.request.AnalysisRequest;
import kopo.poly.dto.response.ActionResponse;
import kopo.poly.dto.response.InspectionResponse;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.service.AiSafetyInspectionService;
import kopo.poly.service.SafetyActionService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class AiSafetyInspectionApiController {

    private final AiSafetyInspectionService inspectionService;
    private final SafetyActionService safetyActionService;

    public AiSafetyInspectionApiController(
            AiSafetyInspectionService inspectionService,
            SafetyActionService safetyActionService
    ) {
        this.inspectionService = inspectionService;
        this.safetyActionService = safetyActionService;
    }

    @PostMapping("/api/inspections/analyze")
    @ResponseStatus(HttpStatus.CREATED)
    public InspectionResponse analyze(@RequestBody AnalysisRequest request) {
        AiSafetyInspection inspection = inspectionService.requestAnalysis(request);
        return InspectionResponse.from(inspection);
    }

    @GetMapping("/api/inspections/{id}")
    public InspectionResponse getById(@PathVariable Long id) {
        return InspectionResponse.from(inspectionService.getById(id));
    }

    @GetMapping("/api/inspections")
    public List<InspectionResponse> getByRequestedBy(@RequestParam Long requestedBy) {
        return inspectionService.findByRequestedBy(requestedBy).stream()
                .map(InspectionResponse::from)
                .toList();
    }

    @GetMapping("/api/inspections/{id}/actions")
    public List<ActionResponse> getActions(@PathVariable Long id) {
        return safetyActionService.findByInspectionId(id).stream()
                .map(ActionResponse::from)
                .toList();
    }
}
