<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="step" value="${empty step ? 1 : step}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>비밀번호 찾기 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] flex items-center justify-center px-6">
<div class="bg-white rounded-3xl shadow-2xl p-10 w-full max-w-md">
  <a href="/login" class="flex items-center gap-2 text-gray-500 hover:text-gray-700 transition-colors mb-6 text-sm">
    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
    로그인으로 돌아가기
  </a>

  <div class="flex items-center gap-2 mb-6">
    <div class="w-12 h-12 bg-[#FF6B35] rounded-xl flex items-center justify-center">
      <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
    </div>
    <div>
      <span class="font-bold text-2xl text-[#1B3A5F]">비밀번호 찾기</span>
      <p class="text-xs text-gray-500">본인 인증 후 비밀번호를 재설정합니다</p>
    </div>
  </div>

  <!-- 단계 표시 -->
  <div class="flex items-center gap-2 mb-8">
    <c:forEach var="i" begin="1" end="4">
      <c:if test="${i > 1}"><div class="flex-1 h-0.5 bg-gray-200"></div></c:if>
      <div class="flex flex-col items-center gap-1">
        <div class="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold ${i <= step ? 'bg-[#FF6B35] text-white' : 'bg-gray-200 text-gray-400'}">${i}</div>
        <span class="text-xs ${i <= step ? 'text-[#FF6B35]' : 'text-gray-400'}">
          <c:choose>
            <c:when test="${i == 1}">이메일</c:when>
            <c:when test="${i == 2}">코드 인증</c:when>
            <c:when test="${i == 3}">재설정</c:when>
            <c:otherwise>완료</c:otherwise>
          </c:choose>
        </span>
      </div>
    </c:forEach>
  </div>

  <c:if test="${not empty findPwError}">
    <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded-xl px-4 py-3 mb-5">${findPwError}</div>
  </c:if>

  <!-- Step 1: 이메일 입력 -->
  <c:if test="${step == 1}">
    <form action="/find-password/send-code" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <h3 class="text-lg font-bold text-gray-800 mb-4">이메일을 입력해주세요</h3>
      <div class="relative mb-4">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
        <input type="email" name="email" placeholder="가입 시 등록한 이메일" required
               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <button type="submit" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">인증 코드 발송</button>
    </form>
  </c:if>

  <!-- Step 2: 코드 인증 -->
  <c:if test="${step == 2}">
    <form action="/find-password/verify-code" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <h3 class="text-lg font-bold text-gray-800 mb-2">인증 코드를 입력해주세요</h3>
      <p class="text-sm text-gray-500 mb-4">
        <c:if test="${not empty targetEmail}">${targetEmail}로 인증 코드를 발송했습니다. (5분간 유효)</c:if>
      </p>
      <input type="text" name="code" placeholder="인증 코드 6자리" maxlength="6" required inputmode="numeric"
             class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none mb-4"/>
      <button type="submit" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">코드 확인</button>
    </form>
  </c:if>

  <!-- Step 3: 비밀번호 재설정 -->
  <c:if test="${step == 3}">
    <form action="/find-password/reset" method="post" onsubmit="return validateNewPassword()">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <h3 class="text-lg font-bold text-gray-800 mb-4">새 비밀번호를 설정해주세요</h3>
      <div class="relative mb-4">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        <input id="newPw" type="password" name="newPassword" placeholder="새 비밀번호 (6자 이상)" required
               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <div class="relative mb-4">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        <input id="confirmPw" type="password" name="confirmPassword" placeholder="비밀번호 확인" required
               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <button type="submit" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">비밀번호 변경</button>
    </form>
  </c:if>

  <!-- Step 4: 완료 -->
  <c:if test="${step == 4}">
    <div class="text-center">
      <svg class="w-16 h-16 text-green-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      <h3 class="text-xl font-bold text-gray-800 mb-2">비밀번호가 변경되었습니다!</h3>
      <p class="text-gray-500 mb-6">새 비밀번호로 로그인해주세요.</p>
      <a href="/login" class="block w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors text-center">로그인하기</a>
    </div>
  </c:if>
</div>

<script>
function validateNewPassword() {
  var p1 = document.getElementById('newPw').value;
  var p2 = document.getElementById('confirmPw').value;
  if (p1.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
  if (p1 !== p2) { alert('비밀번호가 일치하지 않습니다.'); return false; }
  return true;
}
</script>
</body>
</html>
