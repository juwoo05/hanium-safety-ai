package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.response.CurrentUserResponse;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
public class UserApiController {

    private final UserRepository userRepository;

    public UserApiController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 화면 상단의 로그인 사용자 이름 표시 등에 쓰는 최소 정보 조회.
    @GetMapping("/api/users/me")
    public CurrentUserResponse me(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        return userRepository.findById(loginUserId)
                .map(CurrentUserResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "사용자를 찾을 수 없습니다."));
    }

    // 조치 등록 화면의 "담당자" 선택 목록. 위험요소는 원청이 등록하고 하청이 조치를 수행하는
    // 구조라 담당자는 하청(SUBCONTRACTOR) 역할 사용자로 한정하고, 호출자도 원청으로만 제한한다.
    // (하청 계정이 다른 하청 업체 인력 명단을 조회할 이유가 없음 — 정보 노출 방지)
    @GetMapping("/api/users/subcontractors")
    public List<CurrentUserResponse> subcontractors(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        if (!isPrimeContractor(loginUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "원청만 조회할 수 있습니다.");
        }
        return userRepository.findByRoleAndDeletedAtIsNull(UserRole.하청).stream()
                .map(CurrentUserResponse::from)
                .toList();
    }

    private boolean isPrimeContractor(Long userId) {
        return userRepository.findById(userId)
                .map(User::getRole)
                .filter(role -> role == UserRole.원청)
                .isPresent();
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }
}
