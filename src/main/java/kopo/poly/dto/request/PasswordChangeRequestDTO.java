package kopo.poly.dto.request;

public record PasswordChangeRequestDTO(
        String currentPassword,
        String newPassword,
        String newPasswordConfirm
) {
}
