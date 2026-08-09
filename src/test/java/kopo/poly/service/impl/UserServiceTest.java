package kopo.poly.service.impl;

import kopo.poly.dto.request.CompanyProfileUpdateRequest;
import kopo.poly.dto.response.MyActivityStatsResponse;
import kopo.poly.entity.AiSafetyInspection;
import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.entity.enums.RiskLevel;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private SafetyActionRepository safetyActionRepository;

    @InjectMocks
    private UserService userService;

    private User user() {
        return User.builder()
                .id(1L)
                .username("김현장")
                .password("encoded")
                .role(UserRole.원청)
                .companyName("(주)한국건설")
                .email("kim@hankuk.co.kr")
                .build();
    }

    @Test
    void 이름을_비우고_프로필을_수정하면_실패한다() {
        assertThrows(IllegalArgumentException.class, () -> userService.updateProfile(1L, "  ", "회사"));
    }

    @Test
    void 프로필을_정상적으로_수정한다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userRepository.save(any())).thenReturn(user);

        User result = userService.updateProfile(1L, "새이름", "새회사");

        assertThat(result.getUsername()).isEqualTo("새이름");
        assertThat(result.getCompanyName()).isEqualTo("새회사");
    }

    @Test
    void 존재하지_않는_사용자의_프로필을_조회하면_예외가_발생한다() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(NoSuchElementException.class, () -> userService.getProfile(99L));
    }

    @Test
    void 현재_비밀번호가_틀리면_비밀번호_변경에_실패한다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong", "encoded")).thenReturn(false);

        assertThrows(IllegalArgumentException.class, () -> userService.changePassword(1L, "wrong", "newpass1"));
    }

    @Test
    void 새_비밀번호가_6자_미만이면_변경에_실패한다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("correct", "encoded")).thenReturn(true);

        assertThrows(IllegalArgumentException.class, () -> userService.changePassword(1L, "correct", "123"));
    }

    @Test
    void 현재_비밀번호가_맞으면_비밀번호가_변경된다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("correct", "encoded")).thenReturn(true);
        when(passwordEncoder.encode("newpass1")).thenReturn("encoded-new");

        userService.changePassword(1L, "correct", "newpass1");

        assertThat(user.getPassword()).isEqualTo("encoded-new");
    }

    @Test
    void 업로드와_조치_이력을_바탕으로_활동_통계를_계산한다() {
        LocalDateTime now = LocalDateTime.now();
        List<AiSafetyInspection> inspections = List.of(
                AiSafetyInspection.builder().riskLevel(RiskLevel.HIGH).createdAt(now).build(),
                AiSafetyInspection.builder().riskLevel(RiskLevel.SAFE).createdAt(now).build()
        );
        List<SafetyAction> actions = List.of(
                SafetyAction.builder().status(ActionStatus.COMPLETED).discoveredAt(now).dueDate(LocalDate.now()).build(),
                SafetyAction.builder().status(ActionStatus.REQUESTED).discoveredAt(now).dueDate(LocalDate.now()).build()
        );
        when(inspectionRepository.findByRequestedByOrderByCreatedAtDesc(1L)).thenReturn(inspections);
        when(safetyActionRepository.findByReporterId(1L)).thenReturn(actions);

        MyActivityStatsResponse stats = userService.getMyStats(1L);

        assertThat(stats.totalUploads()).isEqualTo(2);
        assertThat(stats.riskDetected()).isEqualTo(1);
        assertThat(stats.actionsCompleted()).isEqualTo(1);
        assertThat(stats.actionCompletionRate()).isEqualTo(50.0);
        assertThat(stats.safetyScore()).isEqualTo(50);
        assertThat(stats.monthlyUploads()).hasSize(12);
    }

    @Test
    void 조치_이력이_없으면_안전_점수는_기본값_100이다() {
        when(inspectionRepository.findByRequestedByOrderByCreatedAtDesc(1L)).thenReturn(List.of());
        when(safetyActionRepository.findByReporterId(1L)).thenReturn(List.of());

        MyActivityStatsResponse stats = userService.getMyStats(1L);

        assertThat(stats.safetyScore()).isEqualTo(100);
    }

    @Test
    void 이단계_인증을_켤_수_있다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userRepository.save(any())).thenReturn(user);

        userService.setTwoFactorEnabled(1L, true);

        assertThat(user.isTwoFactorEnabled()).isTrue();
    }

    @Test
    void 비밀번호가_맞으면_탈퇴_처리된다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("correct", "encoded")).thenReturn(true);
        when(userRepository.save(any())).thenReturn(user);

        userService.withdraw(1L, "correct");

        assertThat(user.getDeletedAt()).isNotNull();
    }

    @Test
    void 비밀번호가_틀리면_탈퇴에_실패한다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong", "encoded")).thenReturn(false);

        assertThrows(IllegalArgumentException.class, () -> userService.withdraw(1L, "wrong"));
        assertThat(user.getDeletedAt()).isNull();
    }

    @Test
    void 건설사_정보를_수정한다() {
        User user = user();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userRepository.save(any())).thenReturn(user);

        User result = userService.updateCompanyProfile(1L,
                new CompanyProfileUpdateRequest("대한안전건설", "123-45-67890", "김현장", "서울시 강남구"));

        assertThat(result.getCompanyName()).isEqualTo("대한안전건설");
        assertThat(result.getCompanyBizNo()).isEqualTo("123-45-67890");
        assertThat(result.getCompanyCeoName()).isEqualTo("김현장");
        assertThat(result.getCompanyAddress()).isEqualTo("서울시 강남구");
    }

    @Test
    void 건설사명이_비어있으면_수정에_실패한다() {
        assertThrows(IllegalArgumentException.class, () -> userService.updateCompanyProfile(1L,
                new CompanyProfileUpdateRequest("  ", null, null, null)));
    }
}
