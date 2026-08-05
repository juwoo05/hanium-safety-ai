package kopo.poly.service.impl;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import kopo.poly.service.IMailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;

@Slf4j
@Service
@RequiredArgsConstructor
public class MailService implements IMailService {
    private static final String FROM_NAME = "SafeMate";

    private final JavaMailSender mailSender;
    @Value("${spring.mail.username:}")
    private String fromAddress;

    @Override
    public boolean sendSignupVerifyCode(String toEmail, String code, int ttlMinutes) {
        String subject = "[SafeMate] 회원가입 이메일 인증 코드";
        String html = buildCodeHtml(
                "이메일 인증",
                "회원가입 화면에 아래 인증 코드를 입력해주세요.",
                code, ttlMinutes);
        return send(toEmail, subject, html);
    }

    @Override
    public boolean sendPasswordResetCode(String toEmail, String code, int ttlMinutes) {
        String subject = "[SafeMate] 비밀번호 재설정 인증 코드";
        String html = buildCodeHtml(
                "비밀번호 재설정",
                "아래 인증 코드를 화면에 입력해주세요.",
                code, ttlMinutes);
        return send(toEmail, subject, html);
    }

    private boolean send(String toEmail, String subject, String html) {
        if (fromAddress.isBlank()) {
            log.warn("메일 계정(GMAIL_USERNAME)이 설정되지 않아 발송을 건너뜁니다. 수신자={}", toEmail);
            return false;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper =
                    new MimeMessageHelper(message, false, StandardCharsets.UTF_8.name());

            helper.setFrom(new InternetAddress(fromAddress, FROM_NAME, StandardCharsets.UTF_8.name()));
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(html, true);

            mailSender.send(message);
            log.info("메일 발송 완료. 수신자={}, 제목={}", toEmail, subject);
            return true;

        } catch (UnsupportedEncodingException | MessagingException e) {
            log.error("메일 생성에 실패했습니다. 수신자={}", toEmail, e);
            return false;
        } catch (MailException e) {
            log.error("메일 발송에 실패했습니다. 수신자={}", toEmail, e);
            return false;
        }
    }

    private String buildCodeHtml(String title, String description, String code, int ttlMinutes) {
        return """
                <div style="font-family:'Malgun Gothic',sans-serif;max-width:480px;margin:0 auto;padding:32px 24px;">
                  <h2 style="margin:0 0 8px;font-size:20px;color:#1f2937;">%s</h2>
                  <p style="margin:0 0 24px;font-size:14px;color:#4b5563;">
                    %s
                  </p>
                  <div style="padding:20px;background:#f3f4f6;border-radius:8px;text-align:center;
                              font-size:32px;font-weight:700;letter-spacing:8px;color:#111827;">
                    %s
                  </div>
                  <p style="margin:24px 0 0;font-size:13px;color:#6b7280;">
                    이 코드는 <strong>%d분</strong> 동안만 유효합니다.<br>
                    본인이 요청하지 않았다면 이 메일은 무시하셔도 됩니다.
                  </p>
                </div>
                """.formatted(title, description, code, ttlMinutes);
    }
}
