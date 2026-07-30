<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>로그인 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] flex items-center justify-center px-6">

<div class="bg-white rounded-3xl shadow-2xl p-10 w-full max-w-md">
  <div class="flex items-center justify-center gap-2 mb-6">
    <div class="w-12 h-12 bg-[#FF6B35] rounded-xl flex items-center justify-center">
      <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <span class="font-bold text-2xl text-[#1B3A5F]">SafeMate</span>
  </div>

  <!-- Mascot -->
  <div class="flex flex-col items-center gap-3 mb-6">
    <img src="/images/mascot.png" alt="SafeMate 마스코트" class="w-24 h-24 object-contain" style="mix-blend-mode:multiply"/>
    <div class="relative bg-white rounded-2xl shadow-lg border border-gray-100 px-4 py-3 max-w-xs">
      <div class="absolute -top-2 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-8 border-l-transparent border-r-transparent border-b-white"></div>
      <p class="text-sm text-gray-700">안녕하세요! SafeMate에 오신 것을 환영합니다 👋</p>
    </div>
  </div>

  <!-- Demo Account Notice -->
  <div class="bg-blue-50 border-2 border-blue-200 rounded-xl p-4 mb-6">
    <p class="text-sm font-semibold text-blue-900 mb-2">테스트 계정 정보</p>
    <div class="grid grid-cols-2 gap-2">
      <button type="button" onclick="fillContractor()" class="text-sm bg-[#1B3A5F] text-white px-3 py-2 rounded-lg hover:bg-[#2C5282] transition-colors font-medium">🏢 원청 계정</button>
      <button type="button" onclick="fillSubcontractor()" class="text-sm bg-green-600 text-white px-3 py-2 rounded-lg hover:bg-green-700 transition-colors font-medium">👷 하청 계정</button>
    </div>
  </div>

  <h2 class="text-2xl font-bold text-[#1B3A5F] text-center mb-2">로그인</h2>
  <p class="text-gray-500 text-center mb-6">현장 안전을 시작해보세요</p>

  <c:if test="${not empty loginError}">
    <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded-xl px-4 py-3 mb-5">${loginError}</div>
  </c:if>

  <form action="/login" method="post" class="space-y-5">
    <div>
      <label class="block text-sm font-medium text-gray-700 mb-2">이메일</label>
      <div class="relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
        <input id="emailInput" type="email" name="email" value="demo@safemate.com" placeholder="your@email.com"
               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none transition-all" required/>
      </div>
    </div>

    <div>
      <label class="block text-sm font-medium text-gray-700 mb-2">비밀번호</label>
      <div class="relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        <input id="passwordInput" type="password" name="password" value="demo1234" placeholder="••••••••"
               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none transition-all" required/>
      </div>
    </div>

    <div class="flex items-center justify-between text-sm">
      <label class="flex items-center gap-2 cursor-pointer">
        <input type="checkbox" name="remember" class="w-4 h-4 text-[#FF6B35] border-gray-300 rounded focus:ring-[#FF6B35]"/>
        <span class="text-gray-600">로그인 유지</span>
      </label>
      <div class="flex items-center gap-3">
        <a href="/find-id" class="text-gray-500 hover:text-[#FF6B35] transition-colors">아이디 찾기</a>
        <span class="text-gray-300">|</span>
        <a href="/find-password" class="text-[#FF6B35] hover:underline">비밀번호 찾기</a>
      </div>
    </div>

    <button type="submit" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-lg hover:shadow-xl transform hover:-translate-y-0.5">
      SafeMate 시작하기
    </button>
  </form>

  <div class="mt-6 text-center text-sm text-gray-600">
    아직 계정이 없으신가요?
    <a href="/signup" class="text-[#FF6B35] font-semibold hover:underline ml-1">무료로 시작하기</a>
  </div>
</div>

<script>
function fillContractor() {
  document.getElementById('emailInput').value = 'demo@safemate.com';
  document.getElementById('passwordInput').value = 'demo1234';
}
function fillSubcontractor() {
  document.getElementById('emailInput').value = 'sub@safemate.com';
  document.getElementById('passwordInput').value = 'demo1234';
}
</script>
</body>
</html>
