package kopo.poly.service.impl;

import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService implements IUserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

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
    public boolean isNameTaken(String name) {
        return userRepository.existsByUsername(name);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<String> findEmailByNameAndCompany(String name, String companyName) {
        return userRepository.findByUsernameAndCompanyName(name, companyName)
                .filter(user -> user.getDeletedAt() == null)
                .map(User::getEmail);
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
}
