package kopo.poly.service;

import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;

import java.util.Optional;

public interface IUserService {

    Optional<User> login(String email, String rawPassword);

    User signup(SignupRequestDTO request);

    boolean isUsernameTaken(String username);

    boolean isEmailTaken(String email);
}
