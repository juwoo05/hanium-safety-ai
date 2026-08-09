package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.CompanyProfileUpdateRequest;
import kopo.poly.dto.request.PasswordChangeRequest;
import kopo.poly.dto.request.ProfileUpdateRequest;
import kopo.poly.dto.request.TwoFactorToggleRequest;
import kopo.poly.dto.request.WithdrawRequest;
import kopo.poly.dto.response.CurrentUserResponse;
import kopo.poly.dto.response.MyActivityStatsResponse;
import kopo.poly.dto.response.MyProfileResponse;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.IUserService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
public class UserApiController {

    private final UserRepository userRepository;
    private final IUserService userService;

    public UserApiController(UserRepository userRepository, IUserService userService) {
        this.userRepository = userRepository;
        this.userService = userService;
    }

    // 마이페이지: 내 프로필 조회
    @GetMapping("/api/users/me/profile")
    public MyProfileResponse myProfile(HttpSession session) {
        return MyProfileResponse.from(userService.getProfile(requireLoginUserId(session)));
    }

    // 마이페이지: 이름/소속 업체 수정
    @PutMapping("/api/users/me/profile")
    public MyProfileResponse updateMyProfile(@RequestBody ProfileUpdateRequest request, HttpSession session) {
        User updated = userService.updateProfile(requireLoginUserId(session), request.username(), request.companyName());
        return MyProfileResponse.from(updated);
    }

    // 마이페이지: 원청 건설사 정보(사업자번호/대표자/주소) 수정
    @PutMapping("/api/users/me/company")
    public MyProfileResponse updateCompanyProfile(@RequestBody CompanyProfileUpdateRequest request, HttpSession session) {
        User updated = userService.updateCompanyProfile(requireLoginUserId(session), request);
        return MyProfileResponse.from(updated);
    }

    // 마이페이지: 비밀번호 변경
    @PostMapping("/api/users/me/password")
    public Map<String, Boolean> changeMyPassword(@RequestBody PasswordChangeRequest request, HttpSession session) {
        if (request.newPassword() == null || !request.newPassword().equals(request.newPasswordConfirm())) {
            throw new IllegalArgumentException("새 비밀번호가 일치하지 않습니다.");
        }
        userService.changePassword(requireLoginUserId(session), request.currentPassword(), request.newPassword());
        return Map.of("ok", true);
    }

    // 마이페이지: 활동 통계
    @GetMapping("/api/users/me/stats")
    public MyActivityStatsResponse myStats(HttpSession session) {
        return userService.getMyStats(requireLoginUserId(session));
    }

    // 마이페이지: 2단계 인증 사용 여부 변경
    @PatchMapping("/api/users/me/two-factor")
    public MyProfileResponse updateTwoFactor(@RequestBody TwoFactorToggleRequest request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        userService.setTwoFactorEnabled(loginUserId, request.enabled());
        return MyProfileResponse.from(userService.getProfile(loginUserId));
    }

    // 마이페이지: 계정 탈퇴(소프트 삭제). 성공 시 현재 세션도 함께 무효화한다.
    @PostMapping("/api/users/me/withdraw")
    public Map<String, Boolean> withdraw(@RequestBody WithdrawRequest request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        userService.withdraw(loginUserId, request.password());
        session.invalidate();
        return Map.of("ok", true);
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
