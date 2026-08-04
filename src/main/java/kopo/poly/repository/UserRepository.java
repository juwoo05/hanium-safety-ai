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

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    Optional<User> findByUsernameAndCompanyName(String username, String companyName);
}
