package kopo.poly.service.impl;

import kopo.poly.dto.AnalyzeRequestDto;
import kopo.poly.dto.AnalyzeResponseDto;
import kopo.poly.dto.RiskItemDto;
import kopo.poly.dto.request.AnalysisRequest;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.AiPipelineClient;
import kopo.poly.service.IAiSafetyInspectionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class AiSafetyInspectionService implements IAiSafetyInspectionService {

    // 신규 조치의 기본 조치 기한: 발견 시점으로부터 며칠 뒤까지로 잡을지에 대한 임시 기준.
    // FastAPI가 위험도별 권장 기한을 내려주게 되면 그 값으로 대체한다.
    private static final long DEFAULT_ACTION_DUE_DAYS = 7;

    private final AiPipelineClient aiPipelineClient;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final SafetyActionRepository safetyActionRepository;
    private final UserRepository userRepository;

    public AiSafetyInspectionService(
            AiPipelineClient aiPipelineClient,
            AiSafetyInspectionRepository inspectionRepository,
            SafetyActionRepository safetyActionRepository,
            UserRepository userRepository
    ) {
        this.aiPipelineClient = aiPipelineClient;
        this.inspectionRepository = inspectionRepository;
        this.safetyActionRepository = safetyActionRepository;
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public AiSafetyInspection requestAnalysis(AnalysisRequest request) {
        AnalyzeResponseDto response = aiPipelineClient.analyze(
                new AnalyzeRequestDto(request.siteId(), request.imageS3Key(), request.workInfo())
        );

        AiSafetyInspection inspection = inspectionRepository.save(
                AiSafetyInspection.builder()
                        .promptText(request.workInfo())
                        .imageUrls(List.of(request.imageS3Key()))
                        .location(request.location())
                        .workType(request.workType())
                        .riskLevel(resolveOverallRiskLevel(response.riskItems().size()))
                        .aiResponseTitle(buildTitle(response.riskItems()))
                        .aiResponseContent(buildContent(response.riskItems()))
                        .requestedBy(request.requestedBy())
                        .build()
        );

        response.riskItems().forEach(item -> safetyActionRepository.save(
                SafetyAction.builder()
                        .inspection(inspection)
                        .title(item.riskName())
                        .category("AI 자동 감지")
                        .discoveredAt(LocalDateTime.now())
                        .dueDate(LocalDate.now().plusDays(DEFAULT_ACTION_DUE_DAYS))
                        .description(item.actionRequired())
                        .regulationRef(item.legalBasis())
                        .status(ActionStatus.REQUESTED)
                        .createdBy(request.requestedBy())
                        .build()
        ));

        return inspection;
    }

    @Override
    public AiSafetyInspection getById(Long id) {
        return inspectionRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("검사 결과를 찾을 수 없습니다: " + id));
    }

    @Override
    public List<AiSafetyInspection> findByRequestedBy(Long requestedBy) {
        return inspectionRepository.findByRequestedByOrderByCreatedAtDesc(requestedBy);
    }

    // 리포트 헤더에 담당자 실명을 보여주기 위한 조회. users 테이블은 다른 팀원 모듈이라
    // 연관관계 대신 ID로만 들고 있어 화면에 표시할 땐 이렇게 별도 조회가 필요하다.
    @Override
    public String resolveUserName(Long userId) {
        return userId == null ? null : userRepository.findById(userId).map(User::getUsername).orElse(null);
    }

    // FastAPI가 아직 위험 항목별 심각도(risk_level)를 내려주지 않아, 감지된 항목 수를 기준으로 한
    // 임시 휴리스틱이다. 개별 위험도가 응답에 포함되면 이 로직은 대체되어야 한다.
    private RiskLevel resolveOverallRiskLevel(int riskItemCount) {
        if (riskItemCount >= 3) {
            return RiskLevel.HIGH;
        }
        if (riskItemCount >= 1) {
            return RiskLevel.MEDIUM;
        }
        return RiskLevel.SAFE;
    }

    private String buildTitle(List<RiskItemDto> riskItems) {
        if (riskItems.isEmpty()) {
            return "위험요소 미발견";
        }
        return riskItems.size() == 1
                ? riskItems.get(0).riskName()
                : riskItems.get(0).riskName() + " 외 " + (riskItems.size() - 1) + "건";
    }

    private String buildContent(List<RiskItemDto> riskItems) {
        StringBuilder content = new StringBuilder();
        for (int i = 0; i < riskItems.size(); i++) {
            RiskItemDto item = riskItems.get(i);
            content.append(i + 1).append(". ").append(item.riskName())
                    .append(" - ").append(item.actionRequired())
                    .append(" (근거: ").append(item.legalBasis()).append(")\n");
        }
        return content.toString();
    }
}
