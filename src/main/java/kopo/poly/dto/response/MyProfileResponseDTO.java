package kopo.poly.dto.response;

import kopo.poly.entity.User;

import java.time.LocalDateTime;

public record MyProfileResponseDTO(
        Long id,
        String username,
        String email,
        String companyName,
        String companyBizNo,
        String companyCeoName,
        String companyAddress,
        String role,
        LocalDateTime createAt,
        boolean twoFactorEnabled
) {
    public static MyProfileResponseDTO from(User user) {
        return new MyProfileResponseDTO(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getCompanyName(),
                user.getCompanyBizNo(),
                user.getCompanyCeoName(),
                user.getCompanyAddress(),
                user.getRole().name(),
                user.getCreateAt(),
                user.isTwoFactorEnabled()
        );
    }
}
