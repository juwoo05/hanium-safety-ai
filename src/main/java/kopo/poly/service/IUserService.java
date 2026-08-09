package kopo.poly.service;

import kopo.poly.dto.request.CompanyProfileUpdateRequest;
import kopo.poly.dto.request.SignupRequestDTO;
import kopo.poly.dto.response.MyActivityStatsResponse;
import kopo.poly.entity.User;

import java.util.List;

public interface IUserService {

    User signup(SignupRequestDTO request);

    boolean isEmailTaken(String email);

    // 아이디 찾기. 동명이인이 같은 회사에 있으면 여러 건이 나옴
    List<String> findEmailsByNameAndCompany(String name, String companyName);

    // 비밀번호 재설정
    void resetPassword(String email, String rawPassword);

    // 마이페이지: 내 프로필 조회
    User getProfile(Long userId);

    // 마이페이지: 이름/소속 업체 수정
    User updateProfile(Long userId, String username, String companyName);

    // 마이페이지: 현재 비밀번호 확인 후 비밀번호 변경
    void changePassword(Long userId, String currentPassword, String newPassword);

    // 마이페이지: 업로드/위험감지/조치완료 등 활동 통계
    MyActivityStatsResponse getMyStats(Long userId);

    // 마이페이지: 2단계 인증 사용 여부 변경
    void setTwoFactorEnabled(Long userId, boolean enabled);

    // 마이페이지: 현재 비밀번호 확인 후 계정 탈퇴(소프트 삭제)
    void withdraw(Long userId, String currentPassword);

    // 마이페이지: 원청 건설사 정보(사업자번호/대표자/주소) 수정
    User updateCompanyProfile(Long userId, CompanyProfileUpdateRequest request);
}
