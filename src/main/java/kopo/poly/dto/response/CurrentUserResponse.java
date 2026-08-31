package kopo.poly.dto.response;

import kopo.poly.entity.User;

public record CurrentUserResponse(
        Long id,
        String username,
        String companyName,
        String role
) {
    public static CurrentUserResponse from(User user) {
        return new CurrentUserResponse(user.getId(), user.getUsername(), user.getCompanyName(), user.getRole().name());
    }
}
