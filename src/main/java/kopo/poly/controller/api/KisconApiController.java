package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.response.KisconCompanyResponseDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.KisconClient;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

// 마이페이지 "건설사 및 현장 연동"에서 KISCON 건설업체정보 조회
@RestController
public class KisconApiController {

    private final KisconClient kisconClient;
    private final UserRepository userRepository;

    public KisconApiController(KisconClient kisconClient, UserRepository userRepository) {
        this.kisconClient = kisconClient;
        this.userRepository = userRepository;
    }

    @GetMapping("/api/kiscon/companies")
    public List<KisconCompanyResponseDTO> search(@RequestParam String keyword, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        if (!isPrimeContractor(loginUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "원청만 조회할 수 있습니다.");
        }
        return kisconClient.searchByCompanyName(keyword);
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
