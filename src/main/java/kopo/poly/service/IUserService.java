package kopo.poly.service;

import kopo.poly.dto.SignupRequestDTO;
import kopo.poly.entity.User;

import java.util.List;

public interface IUserService {

    User signup(SignupRequestDTO request);

    boolean isEmailTaken(String email);

    // 아이디 찾기. 동명이인이 같은 회사에 있으면 여러 건이 나옴
    List<String> findEmailsByNameAndCompany(String name, String companyName);

    // 비밀번호 재설정
    void resetPassword(String email, String rawPassword);
}
