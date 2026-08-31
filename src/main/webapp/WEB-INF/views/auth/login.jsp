<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>로그인 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body style="min-height:100vh;background:#F7F8FA;display:flex;align-items:center;justify-content:center;padding:24px">
<div style="width:100%;max-width:400px">

  <!-- Logo -->
  <div class="flex items-center justify-center" style="gap:8px;margin-bottom:32px">
    <div style="width:28px;height:28px;background:#F8FAFC;border-radius:4px;display:flex;align-items:center;justify-content:center;overflow:hidden"><img src="/images/yeongyeol-gori-logo.png" alt="연결고리 로고" style="width:26px;height:26px;object-fit:contain"/></div>
    <span style="font-size:18px;font-weight:700;color:#0F172A;letter-spacing:0">연결고리</span>
  </div>

  <!-- Card -->
  <div style="background:white;border:1px solid #E5E7EB;border-radius:6px;padding:32px 36px">
    <h2 style="font-size:18px;font-weight:600;color:#0F172A;margin-bottom:6px;text-align:center">로그인</h2>
    <p style="font-size:12px;color:#9CA3AF;text-align:center;margin-bottom:24px">건설현장 안전관리 플랫폼</p>

    <c:if test="${not empty loginError}">
      <div style="background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;font-size:12px;border-radius:4px;padding:10px 12px;margin-bottom:16px">${loginError}</div>
    </c:if>
    <c:if test="${not empty loginMessage}">
      <div style="background:#F0FDF4;border:1px solid #BBF7D0;color:#166534;font-size:12px;border-radius:4px;padding:10px 12px;margin-bottom:16px">${loginMessage}</div>
    </c:if>
    <c:if test="${param.signup != null}">
      <div style="background:#F0FDF4;border:1px solid #BBF7D0;color:#166534;font-size:12px;border-radius:4px;padding:10px 12px;margin-bottom:16px">회원가입이 완료되었습니다. 로그인해주세요.</div>
    </c:if>

    <!-- 계정 유형 선택 -->
    <div style="margin-bottom:20px">
      <p style="font-size:12px;color:#374151;font-weight:500;margin-bottom:6px">계정 유형</p>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px">
        <button type="button" class="role-btn" data-role="원청" data-color="#086CF0" aria-pressed="false"
                style="padding:9px 12px;font-size:12px;font-weight:600;background:white;color:#6B7280;border:1.5px solid #E5E7EB;border-radius:4px;cursor:pointer;transition:background .15s,color .15s,border-color .15s,box-shadow .15s">원청 계정</button>
        <button type="button" class="role-btn" data-role="하청" data-color="#FF7A00" aria-pressed="false"
                style="padding:9px 12px;font-size:12px;font-weight:600;background:white;color:#6B7280;border:1.5px solid #E5E7EB;border-radius:4px;cursor:pointer;transition:background .15s,color .15s,border-color .15s,box-shadow .15s">하청 계정</button>
      </div>
    </div>

    <form action="/login" method="post" style="display:flex;flex-direction:column;gap:14px">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <input type="hidden" name="loginRole" id="loginRoleInput"/>
      <div>
        <label style="font-size:12px;color:#374151;font-weight:500;display:block;margin-bottom:5px">이메일</label>
        <div class="relative flex items-center">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="position:absolute;left:12px"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
          <input id="emailInput" type="email" name="email" placeholder="your@email.com"
                 style="width:100%;padding:9px 12px 9px 36px;font-size:13px;border:1px solid #E5E7EB;border-radius:4px;outline:none;background:white;color:#0F172A;box-sizing:border-box" required/>
        </div>
      </div>

      <div>
        <label style="font-size:12px;color:#374151;font-weight:500;display:block;margin-bottom:5px">비밀번호</label>
        <div class="relative flex items-center">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="position:absolute;left:12px"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input id="passwordInput" type="password" name="password" placeholder="••••••••"
                 style="width:100%;padding:9px 12px 9px 36px;font-size:13px;border:1px solid #E5E7EB;border-radius:4px;outline:none;background:white;color:#0F172A;box-sizing:border-box" required/>
        </div>
      </div>

      <div class="flex items-center justify-between" style="font-size:12px">
        <label class="flex items-center" style="gap:6px;cursor:pointer;color:#6B7280">
          <input type="checkbox" name="remember" style="width:14px;height:14px"/>
          로그인 유지
        </label>
        <div class="flex items-center" style="gap:10px">
          <a href="/find-id" style="font-size:12px;color:#9CA3AF;text-decoration:none">아이디 찾기</a>
          <span style="color:#E5E7EB">|</span>
          <a href="/find-password" style="font-size:12px;color:#1A2E44;font-weight:500;text-decoration:none">비밀번호 찾기</a>
        </div>
      </div>

      <button type="submit" style="width:100%;padding:10px 0;font-size:13px;font-weight:600;background:#1A2E44;color:white;border:none;border-radius:4px;cursor:pointer;margin-top:4px">
        로그인
      </button>
    </form>

    <p style="text-align:center;font-size:12px;color:#9CA3AF;margin-top:20px">
      계정이 없으신가요?
      <a href="/signup" style="font-size:12px;color:#1A2E44;font-weight:600;text-decoration:none">회원가입</a>
    </p>
  </div>

  <p style="text-align:center;font-size:11px;color:#9CA3AF;margin-top:20px">건설현장 안전관리 AI 플랫폼 · 연결고리</p>
</div>

<script>
(function () {
  var btns = document.querySelectorAll('.role-btn');
  var hidden = document.getElementById('loginRoleInput');
  function reset(b) {
    b.setAttribute('aria-pressed', 'false');
    b.style.background = 'white';
    b.style.color = '#6B7280';
    b.style.borderColor = '#E5E7EB';
    b.style.boxShadow = 'none';
  }
  btns.forEach(function (b) {
    b.addEventListener('click', function () {
      var wasSelected = b.getAttribute('aria-pressed') === 'true';
      btns.forEach(reset);
      if (wasSelected) {
        if (hidden) hidden.value = '';
        return;
      }
      var c = b.getAttribute('data-color');
      b.setAttribute('aria-pressed', 'true');
      b.style.background = c;
      b.style.color = 'white';
      b.style.borderColor = c;
      b.style.boxShadow = '0 0 0 3px ' + c + '40';
      if (hidden) hidden.value = b.getAttribute('data-role');
    });
  });
})();
</script>
</body>
</html>
