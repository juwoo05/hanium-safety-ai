package kopo.poly.service.impl;

import kopo.poly.dto.response.MsdsSearchResultDTO;
import kopo.poly.entity.enums.MsdsSourceType;
import kopo.poly.service.MsdsProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

// 데모/개발용 MSDS 공급자.
// 건설현장에서 자주 쓰는 물질을 내장 목록으로 두고, documentUrl/sourceUrl 은
// 안전보건공단(KOSHA) MSDS 상세 페이지로 그대로 연결한다("KOSHA 참고자료").
// 실제 KOSHA OpenAPI 가 붙으면 KoshaMsdsProvider 로 교체(msds.provider=kosha)하고
// 그때 물질별 상세 URL(chem_id 등)을 채운다.
@Component
@ConditionalOnProperty(name = "msds.provider", havingValue = "mock", matchIfMissing = true)
public class MockMsdsProvider implements MsdsProvider {

    private record Entry(String name, String cas, String product, String revision) {
    }

    // 자주 노출되는 건설현장 화학물질/제품. CAS 는 실제 값.
    private static final List<Entry> CATALOG = List.of(
            new Entry("포틀랜드 시멘트", "65997-15-1", "레미탈 / 포틀랜드 시멘트 1종", "2023-11-01"),
            new Entry("톨루엔", "108-88-3", "락카 신너 주성분", "2024-02-15"),
            new Entry("크실렌", "1330-20-7", "유성 페인트 / 신너", "2023-09-20"),
            new Entry("아세톤", "67-64-1", "우레탄 방수 희석제", "2024-01-10"),
            new Entry("메틸에틸케톤(MEK)", "78-93-3", "에폭시 프라이머 희석제", "2023-12-05"),
            new Entry("디페닐메탄디이소시아네이트(MDI)", "101-68-8", "경질 우레탄폼 원액 B제", "2024-03-01"),
            new Entry("에폭시 수지", "25068-38-6", "바닥용 에폭시 도료 주제", "2023-08-12"),
            new Entry("규산나트륨", "1344-09-8", "콘크리트 표면 강화제(하드너)", "2023-10-30"),
            new Entry("아세틸렌", "74-86-2", "용접·절단용 아세틸렌 가스", "2024-02-01"),
            new Entry("액화석유가스(LPG)", "68476-85-7", "가스 토치 / 난방용 LPG", "2023-07-18")
    );

    private final String koshaDetailUrl;

    public MockMsdsProvider(
            @Value("${msds.kosha.detail-url:https://msds.kosha.or.kr/MSDSInfo/kcic/msdsdetail.do}") String koshaDetailUrl
    ) {
        this.koshaDetailUrl = koshaDetailUrl;
    }

    @Override
    public String name() {
        return "MOCK";
    }

    @Override
    public List<MsdsSearchResultDTO> search(String query) {
        if (query == null || query.isBlank()) {
            return List.of();
        }
        String q = query.toLowerCase(Locale.KOREA).trim();

        List<MsdsSearchResultDTO> results = new ArrayList<>();
        for (Entry e : CATALOG) {
            boolean hit = e.name().toLowerCase(Locale.KOREA).contains(q)
                    || q.contains(e.name().toLowerCase(Locale.KOREA))
                    || (e.cas() != null && e.cas().replace("-", "").contains(q.replace("-", "")))
                    || e.product().toLowerCase(Locale.KOREA).contains(q);
            if (!hit) {
                continue;
            }
            results.add(new MsdsSearchResultDTO(
                    e.name(),
                    e.cas(),
                    e.product(),
                    MsdsSourceType.KOSHA,
                    "안전보건공단 MSDS",
                    koshaDetailUrl,   // sourceUrl
                    koshaDetailUrl,   // documentUrl — KOSHA MSDS 상세 페이지로 연결
                    LocalDate.parse(e.revision()),
                    // 이름이 정확히 들어맞으면 신뢰도를 높게, 부분일치는 낮게
                    e.name().toLowerCase(Locale.KOREA).equals(q) ? 95 : 70,
                    false
            ));
        }
        return results;
    }
}
