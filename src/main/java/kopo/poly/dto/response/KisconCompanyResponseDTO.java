package kopo.poly.dto.response;

// 마이페이지 "건설사 및 현장 연동"에서 KISCON 조회 결과로 보여주는 후보 항목
public record KisconCompanyResponseDTO(
        String name,
        String bizNo,
        String ceoName,
        String address
) {
}
