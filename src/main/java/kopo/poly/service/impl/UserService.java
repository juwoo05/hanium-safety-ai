package kopo.poly.service.impl;

import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService implements IUserService {

    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    private final UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public Optional<User> login(String email, String rawPassword) {
        return userRepository.findByEmail(email)
                .filter(user -> passwordEncoder.matches(rawPassword, user.getPassword()));
    }

    @Override
    @Transactional
    public User signup(SignupRequestDTO request) {
        UserRole role = "contractor".equalsIgnoreCase(request.getRole()) ? UserRole.원청 : UserRole.하청;
        LocalDateTime now = LocalDateTime.now();

        User user = User.builder()
                .username(request.getUserId())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(role)
                .companyName(request.getCompany())
                .email(request.getEmail())
                .createAt(now)
                .regAt(now)
                .build();
        return userRepository.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isUsernameTaken(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email);
    }
}
