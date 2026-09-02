package kopo.poly.controller.api;

import kopo.poly.dto.request.AnalysisRequestDTO;
import kopo.poly.dto.response.ActionResponseDTO;
import kopo.poly.dto.response.InspectionResponseDTO;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.service.IAiSafetyInspectionService;
import kopo.poly.service.ISafetyActionService;
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

    private final IAiSafetyInspectionService inspectionService;
    private final ISafetyActionService safetyActionService;

    public AiSafetyInspectionApiController(
            IAiSafetyInspectionService inspectionService,
            ISafetyActionService safetyActionService
    ) {
        this.inspectionService = inspectionService;
        this.safetyActionService = safetyActionService;
    }

    @PostMapping("/api/inspections/analyze")
    @ResponseStatus(HttpStatus.CREATED)
    public InspectionResponseDTO analyze(@RequestBody AnalysisRequestDTO request) {
        AiSafetyInspection inspection = inspectionService.requestAnalysis(request);
        return InspectionResponseDTO.from(inspection);
    }

    @GetMapping("/api/inspections/{id}")
    public InspectionResponseDTO getById(@PathVariable Long id) {
        AiSafetyInspection inspection = inspectionService.getById(id);
        String requestedByName = inspectionService.resolveUserName(inspection.getRequestedBy());
        return InspectionResponseDTO.from(inspection, requestedByName);
    }

    @GetMapping("/api/inspections")
    public List<InspectionResponseDTO> getByRequestedBy(@RequestParam Long requestedBy) {
        return inspectionService.findByRequestedBy(requestedBy).stream()
                .map(InspectionResponseDTO::from)
                .toList();
    }

    @GetMapping("/api/inspections/{id}/actions")
    public List<ActionResponseDTO> getActions(@PathVariable Long id) {
        return safetyActionService.findByInspectionId(id).stream()
                .map(ActionResponseDTO::from)
                .toList();
    }
}
