package kopo.poly.service.impl;

import kopo.poly.dto.response.MsdsSearchResultDto;
import kopo.poly.entity.enums.MsdsSourceType;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class MockMsdsProviderTest {

    private static final String KOSHA_DETAIL = "https://msds.kosha.or.kr/MSDSInfo/kcic/msdsdetail.do";
    private final MockMsdsProvider provider = new MockMsdsProvider(KOSHA_DETAIL);

    @Test
    void 물질명으로_검색하면_KOSHA_상세페이지_링크로_결과를_반환한다() {
        List<MsdsSearchResultDto> results = provider.search("톨루엔");

        assertThat(results).isNotEmpty();
        MsdsSearchResultDto first = results.get(0);
        assertThat(first.chemicalName()).isEqualTo("톨루엔");
        assertThat(first.casNo()).isEqualTo("108-88-3");
        assertThat(first.sourceType()).isEqualTo(MsdsSourceType.KOSHA);
        assertThat(first.documentUrl()).isEqualTo(KOSHA_DETAIL);
        assertThat(first.verified()).isFalse();
    }

    @Test
    void CAS번호로도_검색된다() {
        assertThat(provider.search("67-64-1")).anyMatch(r -> r.chemicalName().equals("아세톤"));
    }

    @Test
    void 매칭되는_물질이_없으면_빈_목록을_반환한다() {
        assertThat(provider.search("존재하지않는물질xyz")).isEmpty();
        assertThat(provider.search("")).isEmpty();
    }
}
