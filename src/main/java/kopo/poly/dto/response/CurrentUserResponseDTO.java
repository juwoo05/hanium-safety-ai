package kopo.poly.dto.response;

import kopo.poly.entity.User;

public record CurrentUserResponseDTO(
        Long id,
        String username,
        String companyName,
        String role
) {
    public static CurrentUserResponseDTO from(User user) {
        // .name()은 한글 enum 상수명("원청"/"하청")을 반환해 프론트의 영문 role 비교와 어긋난다.
        // API 응답용으로 설계된 dbValue("CONTRACTOR"/"SUBCONTRACTOR")를 내려준다.
        return new CurrentUserResponseDTO(user.getId(), user.getUsername(), user.getCompanyName(), user.getRole().getDbValue());
    }
}
