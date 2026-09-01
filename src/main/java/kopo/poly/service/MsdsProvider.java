package kopo.poly.service;

import kopo.poly.dto.response.MsdsSearchResultDto;

import java.util.List;

// MSDS/SDS 자료 검색 공급자 인터페이스.
// 현재는 MockMsdsProvider(데모용 내장 목록)만 구현돼 있고,
// 나중에 KOSHA OpenAPI / 제조사 연동 provider로 교체하기 쉽도록 분리한다.
// (msds.provider 설정값으로 활성 구현을 선택한다)
public interface MsdsProvider {

    List<MsdsSearchResultDto> search(String query);

    // 로그/화면 표시용 공급자 이름
    String name();
}
