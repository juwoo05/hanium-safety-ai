package kopo.poly.service;

public interface IMailService {

    // 회원가입 이메일 인증 코드 메일 발송
    boolean sendSignupVerifyCode(String toEmail, String code, int ttlMinutes);

    // 비밀번호 재설정 인증 코드 메일 발송
    boolean sendPasswordResetCode(String toEmail, String code, int ttlMinutes);

    // 로그인 2단계 인증 코드 메일 발송
    boolean sendTwoFactorCode(String toEmail, String code, int ttlMinutes);
}
