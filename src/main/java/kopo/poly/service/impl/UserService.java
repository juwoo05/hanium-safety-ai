package kopo.poly.service.impl;

import kopo.poly.dto.request.CompanyProfileUpdateRequest;
import kopo.poly.dto.request.SignupRequestDTO;
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
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class UserService implements IUserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AiSafetyInspectionRepository inspectionRepository;
    private final SafetyActionRepository safetyActionRepository;

    @Override
    @Transactional
    public User signup(SignupRequestDTO request) {
        UserRole role = "contractor".equalsIgnoreCase(request.getRole()) ? UserRole.원청 : UserRole.하청;
        LocalDateTime now = LocalDateTime.now();

        User user = User.builder()
                // users.username 컬럼은 실명을 담는다. 로그인 아이디는 email 이다.
                .username(request.getName())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(role)
                .companyName(request.getCompany())
                .email(request.getEmail())
                .createAt(now)
                .regAt(now)
                // users.updated_at 은 NOT NULL 이라 INSERT 시점에 채워야 한다.
                .updatedAt(now)
                .build();
        return userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> findEmailsByNameAndCompany(String name, String companyName) {
        return userRepository.findByUsernameAndCompanyName(name, companyName).stream()
                .filter(user -> user.getDeletedAt() == null)
                .map(User::getEmail)
                .toList();
    }

    @Override
    @Transactional
    public void resetPassword(String email, String rawPassword) {
        User user = userRepository.findByEmail(email)
                .filter(u -> u.getDeletedAt() == null)
                .orElseThrow(() -> new UsernameNotFoundException("등록되지 않은 이메일입니다."));

        user.changePassword(passwordEncoder.encode(rawPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public User getProfile(Long userId) {
        return userRepository.findById(userId)
                .filter(u -> u.getDeletedAt() == null)
                .orElseThrow(() -> new NoSuchElementException("사용자를 찾을 수 없습니다."));
    }

    @Override
    @Transactional
    public User updateProfile(Long userId, String username, String companyName) {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("이름을 입력해주세요.");
        }
        User user = getProfile(userId);
        user.updateProfile(username.trim(), companyName == null ? null : companyName.trim());
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = getProfile(userId);
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("비밀번호는 6자 이상이어야 합니다.");
        }
        user.changePassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public MyActivityStatsResponse getMyStats(Long userId) {
        List<AiSafetyInspection> myInspections = inspectionRepository.findByRequestedByOrderByCreatedAtDesc(userId);
        List<SafetyAction> myActions = safetyActionRepository.findByReporterId(userId);

        long totalUploads = myInspections.size();
        long riskDetected = myInspections.stream().filter(i -> i.getRiskLevel() != RiskLevel.SAFE).count();

        long totalActions = myActions.size();
        long actionsCompleted = myActions.stream().filter(a -> a.getStatus() == ActionStatus.COMPLETED).count();
        double actionCompletionRate = totalActions == 0 ? 0.0 : actionsCompleted * 100.0 / totalActions;
        int safetyScore = totalActions == 0 ? 100 : (int) Math.round(actionCompletionRate);

        int currentYear = LocalDate.now().getYear();
        List<Integer> monthlyUploads = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            int m = month;
            long count = myInspections.stream()
                    .filter(i -> i.getCreatedAt().getYear() == currentYear && i.getCreatedAt().getMonthValue() == m)
                    .count();
            monthlyUploads.add((int) count);
        }
        long thisMonthUploads = monthlyUploads.get(LocalDate.now().getMonthValue() - 1);

        return new MyActivityStatsResponse(
                totalUploads, riskDetected, actionsCompleted, safetyScore,
                thisMonthUploads, actionCompletionRate, monthlyUploads
        );
    }

    @Override
    @Transactional
    public void setTwoFactorEnabled(Long userId, boolean enabled) {
        User user = getProfile(userId);
        user.setTwoFactorEnabled(enabled);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void withdraw(Long userId, String currentPassword) {
        User user = getProfile(userId);
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 올바르지 않습니다.");
        }
        user.withdraw();
        userRepository.save(user);
    }

    @Override
    @Transactional
    public User updateCompanyProfile(Long userId, CompanyProfileUpdateRequest request) {
        if (request.companyName() == null || request.companyName().isBlank()) {
            throw new IllegalArgumentException("건설사명을 입력해주세요.");
        }
        User user = getProfile(userId);
        user.updateCompanyProfile(
                request.companyName().trim(),
                request.companyBizNo() == null ? null : request.companyBizNo().trim(),
                request.companyCeoName() == null ? null : request.companyCeoName().trim(),
                request.companyAddress() == null ? null : request.companyAddress().trim()
        );
        return userRepository.save(user);
    }
}
