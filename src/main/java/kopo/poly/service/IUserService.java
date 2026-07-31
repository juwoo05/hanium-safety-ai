package kopo.poly.service;

import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;
import org.springframework.security.crypto.bcrypt.BCrypt;

import java.util.Optional;

public interface IUserService {

    User signup(SignupRequestDTO request);

    // 이름 중복 여부
    boolean isNameTaken(String name);

    boolean isEmailTaken(String email);

    // 아이디 찾기
    Optional<String> findEmailByNameAndCompany(String name, String companyName);

    // 비밀번호 재설정
    void resetPassword(String email, String rawPassword);
}
