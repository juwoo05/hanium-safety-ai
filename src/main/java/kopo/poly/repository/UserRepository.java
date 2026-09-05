package kopo.poly.repository;

import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByRole(UserRole role);

    List<User> findByRoleAndDeletedAtIsNull(UserRole role);

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    // 탈퇴(소프트 삭제)한 계정의 이메일은 중복 체크에서 제외해 재가입을 허용한다.
    boolean existsByEmailAndDeletedAtIsNull(String email);

    List<User> findByUsernameAndCompanyName(String username, String companyName);

    List<User> findAllByEmail(String email);
}
