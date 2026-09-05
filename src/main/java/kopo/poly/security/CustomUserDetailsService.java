package kopo.poly.security;

import kopo.poly.entity.User;
import kopo.poly.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;

// 로그인의 username 파라미터를 이메일로 받아 사용자 조회
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        List<User> users = userRepository.findAllByEmail(email);
        if (users.isEmpty()) {
            throw new UsernameNotFoundException("등록되지 않은 이메일입니다.");
        }
        // 이메일에 중복 데이터가 있어도 로그인 자체는 막히지 않도록 방어한다.
        // 활성 계정을 우선하고, 그마저 여러 건이면 가장 최근 계정을 사용한다.
        if (users.size() > 1) {
            log.warn("이메일 '{}' 에 중복된 계정이 {}건 존재함 - 데이터 정리 필요", email, users.size());
        }
        User user = users.stream()
                .filter(u -> u.getDeletedAt() == null)
                .max(Comparator.comparing(User::getId))
                .orElseGet(() -> users.stream().max(Comparator.comparing(User::getId)).orElseThrow());
        return new CustomUserDetails(user);
    }
}
