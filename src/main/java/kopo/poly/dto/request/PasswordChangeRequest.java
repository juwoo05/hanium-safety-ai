package kopo.poly.dto.request;

public record PasswordChangeRequest(
        String currentPassword,
        String newPassword,
        String newPasswordConfirm
) {
}
