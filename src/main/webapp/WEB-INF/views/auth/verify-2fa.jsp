<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>2단계 인증 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-[#1A2E44] to-[#2C5282] flex items-center justify-center px-6">

<div class="bg-white rounded shadow-2xl p-10 w-full max-w-md">
  <a href="/login" class="flex items-center gap-2 text-gray-500 hover:text-gray-700 transition-colors mb-6 text-sm">
    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
    로그인으로 돌아가기
  </a>
  <div class="flex items-center gap-2 mb-8">
    <div class="w-12 h-12 bg-[#1A2E44] rounded flex items-center justify-center">
      <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <div>
      <span class="font-bold text-2xl text-[#1A2E44]">2단계 인증</span>
      <p class="text-xs text-gray-500">가입하신 이메일로 전송된 인증 코드를 입력해주세요</p>
    </div>
  </div>

  <c:if test="${not empty verifyError}">
    <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded px-4 py-3 mb-5">${verifyError}</div>
  </c:if>

  <form action="/login/verify-2fa" method="post" class="space-y-5">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-2">인증 코드</label>
      <input type="text" name="code" placeholder="6자리 코드" maxlength="6" inputmode="numeric" autofocus
             class="w-full px-4 py-3 border border-gray-300 rounded text-center text-2xl tracking-[0.5em] font-mono focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all" required/>
    </div>
    <button type="submit" class="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors shadow-lg hover:shadow-xl transform hover:-translate-y-0.5">
      확인
    </button>
  </form>
</div>
</body>
</html>
