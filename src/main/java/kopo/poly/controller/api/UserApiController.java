package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.response.CurrentUserResponse;
import kopo.poly.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
public class UserApiController {

    private final UserRepository userRepository;

    public UserApiController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 화면 상단의 로그인 사용자 이름 표시 등에 쓰는 최소 정보 조회.
    @GetMapping("/api/users/me")
    public CurrentUserResponse me(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return userRepository.findById(loginUserId)
                .map(CurrentUserResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "사용자를 찾을 수 없습니다."));
    }
}
