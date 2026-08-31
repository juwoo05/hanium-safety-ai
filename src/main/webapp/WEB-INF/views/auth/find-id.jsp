<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>아이디 찾기 - 연결고리</title>
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
      <img src="/images/yeongyeol-gori-logo.png" alt="연결고리 로고" class="w-11 h-11 object-contain"/>
    </div>
    <div>
      <span class="font-bold text-2xl text-[#1A2E44]">아이디 찾기</span>
      <p class="text-xs text-gray-500">연결고리 계정 아이디를 찾아드립니다</p>
    </div>
  </div>

  <div id="formSection" class="${not empty foundEmails ? 'hidden' : ''}">
    <c:if test="${not empty findIdError}">
      <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded px-4 py-3 mb-5">${findIdError}</div>
    </c:if>
    <form action="/find-id" method="post" class="space-y-5">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-2">이름</label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          <input id="nameInput" type="text" name="name" value="${param.name}" placeholder="가입 시 등록한 이름"
                 class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none" required/>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-2">회사명</label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
          <input id="companyInput" type="text" name="company" value="${param.company}" placeholder="가입 시 등록한 회사명"
                 class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none" required/>
        </div>
      </div>
      <button type="submit" class="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#2C5282] transition-colors shadow-lg">아이디 찾기</button>
    </form>
  </div>

  <div id="resultSection" class="${empty foundEmails ? 'hidden' : ''} space-y-6">
    <div class="bg-green-50 border-2 border-green-200 rounded p-6 text-center">
      <svg class="w-12 h-12 text-green-500 mx-auto mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      <p class="text-sm text-gray-600 mb-2">가입하신 아이디(이메일)는</p>
      <div class="space-y-1">
        <c:forEach var="email" items="${foundEmails}">
          <p class="text-xl font-bold text-[#1A2E44]">${email}</p>
        </c:forEach>
      </div>
      <p class="text-sm text-gray-500 mt-2">입니다.</p>
      <%-- 동명이인이 같은 회사에 있으면 여러 건이 나온다. --%>
      <c:if test="${foundEmails.size() > 1}">
        <p class="text-xs text-gray-500 mt-3">동명이인이 있어 여러 계정이 조회되었습니다.</p>
      </c:if>
    </div>
    <div class="flex gap-3">
      <a href="/login" class="flex-1 text-center bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors">로그인하기</a>
      <a href="/find-password" class="flex-1 text-center border-2 border-[#1A2E44] text-[#1A2E44] py-3 rounded font-semibold hover:bg-[#1A2E44]/5 transition-colors">비밀번호 찾기</a>
    </div>
  </div>

  <div class="mt-6 pt-6 border-t border-gray-100 flex justify-center gap-6 text-sm">
    <a href="/find-password" class="text-gray-500 hover:text-[#1A2E44] transition-colors">비밀번호 찾기</a>
    <span class="text-gray-300">|</span>
    <a href="/signup" class="text-gray-500 hover:text-[#1A2E44] transition-colors">회원가입</a>
  </div>
</div>
</body>
</html>
