package kopo.poly.repository;

import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.enums.RiskLevel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AiSafetyInspectionRepository extends JpaRepository<AiSafetyInspection, Long> {
    List<AiSafetyInspection> findByRequestedByOrderByCreatedAtDesc(Long requestedBy);
    List<AiSafetyInspection> findByRiskLevelOrderByCreatedAtDesc(RiskLevel riskLevel);

    // 현장(Site)별 최근 위험도를 위치 선택 화면에 보여주기 위한 조회. Site와 실제 FK 연관관계는 없고
    // location 문자열이 site.name과 일치하는지로 느슨하게 매칭한다.
    Optional<AiSafetyInspection> findFirstByLocationOrderByCreatedAtDesc(String location);
}
