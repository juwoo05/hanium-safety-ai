<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>회원가입 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] flex flex-col items-center justify-center px-4 py-10">

<!-- ── STEP 1: 역할 선택 ── -->
<div id="step1" class="w-full max-w-2xl flex flex-col items-center">

  <!-- 로고 -->
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-[#FF6B35] rounded-xl flex items-center justify-center shadow-lg">
      <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <span class="font-bold text-2xl text-white">SafeMate</span>
  </div>

  <h1 class="text-3xl font-bold text-white mb-2">회원가입</h1>
  <p class="text-white/60 mb-10 text-base">계정 유형을 선택해주세요</p>

  <c:if test="${not empty signupError}">
    <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded-xl px-4 py-3 mb-6 w-full max-w-md text-center">${signupError}</div>
  </c:if>

  <!-- 카드 2개 -->
  <div class="grid grid-cols-2 gap-5 w-full">

    <!-- 원청 -->
    <button onclick="selectRole('contractor')" class="group relative bg-white rounded-3xl p-8 flex flex-col items-center gap-3 shadow-xl hover:scale-[1.03] hover:shadow-2xl transition-all duration-200 text-left">
      <div class="w-20 h-20 bg-[#FF6B35]/10 rounded-full flex items-center justify-center mb-2 group-hover:bg-[#FF6B35]/20 transition-colors">
        <svg class="w-10 h-10 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
          <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
          <path d="M9 22V12h6v10"/>
          <rect x="7" y="5" width="2" height="4"/><rect x="11" y="5" width="2" height="4"/><rect x="15" y="5" width="2" height="4"/>
        </svg>
      </div>
      <span class="text-xl font-bold text-gray-900">원청</span>
      <span class="text-sm text-gray-400 font-medium">발주처 / 원도급사</span>
      <span class="text-sm text-gray-500 text-center leading-relaxed mt-1">현장 전체 안전 관리 및 하청 업체 감독</span>
    </button>

    <!-- 하청 -->
    <button onclick="selectRole('subcontractor')" class="group relative bg-white rounded-3xl p-8 flex flex-col items-center gap-3 shadow-xl hover:scale-[1.03] hover:shadow-2xl transition-all duration-200">
      <div class="w-20 h-20 bg-green-50 rounded-full flex items-center justify-center mb-2 group-hover:bg-green-100 transition-colors">
        <svg class="w-10 h-10 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
          <path d="M2 18h20"/><path d="M4 18V9a1 1 0 0 1 .553-.894l7-3.5a1 1 0 0 1 .894 0l7 3.5A1 1 0 0 1 20 9v9"/>
          <path d="M9 18v-6h6v6"/>
          <circle cx="12" cy="6" r="1"/>
        </svg>
      </div>
      <span class="text-xl font-bold text-gray-900">하청</span>
      <span class="text-sm text-gray-400 font-medium">하도급사 / 협력업체</span>
      <span class="text-sm text-gray-500 text-center leading-relaxed mt-1">현장 작업 및 안전 조치 이행 보고</span>
    </button>

  </div>

  <p class="mt-10 text-white/50 text-sm">
    이미 계정이 있으신가요?
    <a href="/login" class="text-[#FF6B35] font-semibold hover:underline ml-1">로그인하기</a>
  </p>
</div>

<!-- ── STEP 2: 가입 폼 ── -->
<div id="step2" class="hidden w-full max-w-lg">
  <div class="bg-white rounded-3xl shadow-2xl overflow-hidden">

    <!-- 헤더 -->
    <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] px-8 py-6">
      <button onclick="goBack()" class="flex items-center gap-1.5 text-white/60 hover:text-white text-sm mb-4 transition-colors">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        계정 유형 다시 선택
      </button>
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 bg-[#FF6B35] rounded-xl flex items-center justify-center">
          <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div>
          <p class="font-bold text-white text-lg">SafeMate 회원가입</p>
          <p id="roleLabel" class="text-white/60 text-sm"></p>
        </div>
      </div>
    </div>

    <!-- 폼 -->
    <form id="signupForm" action="/signup" method="post" onsubmit="return validateForm()" class="px-8 py-7 space-y-5">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <input type="hidden" name="role" id="roleInput"/>

      <c:if test="${not empty signupError}">
        <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded-xl px-4 py-3">${signupError}</div>
      </c:if>

      <!-- 이름 (로그인 아이디는 이메일을 사용한다) -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">이름 <span class="text-red-500">*</span></label>
        <input type="text" name="name" placeholder="실명을 입력해주세요"
               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
      </div>

      <!-- 이메일 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">이메일 <span class="text-red-500">*</span></label>
        <div class="flex gap-2">
          <input id="emailInput" type="email" name="email" placeholder="your@email.com" oninput="resetEmailCheck()"
                 class="flex-1 px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
          <button type="button" onclick="checkEmail()" class="px-4 py-3 rounded-xl text-sm font-semibold bg-[#1B3A5F] text-white hover:bg-[#2C5282] transition-colors whitespace-nowrap">중복확인</button>
        </div>
        <p id="emailStatus" class="text-xs mt-1 hidden"></p>
      </div>

      <!-- 비밀번호 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 <span class="text-red-500">*</span></label>
        <input id="pw1" type="password" name="password" placeholder="6자 이상"
               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
      </div>

      <!-- 비밀번호 확인 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 확인 <span class="text-red-500">*</span></label>
        <input id="pw2" type="password" name="passwordConfirm" placeholder="비밀번호를 다시 입력해주세요" oninput="checkPw()"
               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
        <p id="pwStatus" class="text-xs mt-1 hidden"></p>
      </div>

      <!-- 회사명 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">회사명 <span class="text-red-500">*</span></label>
        <input type="text" name="company" placeholder="소속 회사명을 입력해주세요"
               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
      </div>

      <button type="submit" class="w-full bg-[#FF6B35] text-white py-4 rounded-xl font-bold text-base hover:bg-[#E55A2A] transition-colors shadow-lg mt-2">
        회원가입
      </button>

      <p class="text-center text-sm text-gray-500">
        이미 계정이 있으신가요?
        <a href="/login" class="text-[#FF6B35] font-semibold hover:underline ml-1">로그인하기</a>
      </p>
    </form>
  </div>
</div>

<script>
var emailChecked = false;

function selectRole(role) {
  document.getElementById('roleInput').value = role;
  document.getElementById('roleLabel').textContent = role === 'contractor' ? '원청 (발주처 / 원도급사)' : '하청 (하도급사 / 협력업체)';
  document.getElementById('step1').classList.add('hidden');
  document.getElementById('step2').classList.remove('hidden');
}

function goBack() {
  document.getElementById('step2').classList.add('hidden');
  document.getElementById('step1').classList.remove('hidden');
}

function resetEmailCheck() {
  emailChecked = false;
  document.getElementById('emailStatus').classList.add('hidden');
  document.getElementById('emailInput').classList.remove('border-green-400', 'bg-green-50');
}

function checkEmail() {
  var input = document.getElementById('emailInput');
  var email = input.value.trim();
  var status = document.getElementById('emailStatus');
  if (!email || !email.includes('@')) { alert('올바른 이메일을 입력해주세요.'); return; }

  fetch('/api/auth/check-email?email=' + encodeURIComponent(email))
    .then(function(res) { return res.json(); })
    .then(function(data) {
      emailChecked = data.available;
      status.textContent = data.available ? '사용 가능한 이메일입니다.' : '이미 사용 중인 이메일입니다.';
      status.className = 'text-xs mt-1 ' + (data.available ? 'text-green-600' : 'text-red-500');
      status.classList.remove('hidden');
      input.classList.toggle('border-green-400', data.available);
      input.classList.toggle('bg-green-50', data.available);
    })
    .catch(function() { alert('중복확인 중 오류가 발생했습니다.'); });
}

function checkPw() {
  var p1 = document.getElementById('pw1').value;
  var p2 = document.getElementById('pw2').value;
  var status = document.getElementById('pwStatus');
  if (!p2) { status.classList.add('hidden'); return; }
  if (p1 === p2) {
    status.textContent = '비밀번호가 일치합니다.';
    status.className = 'text-xs mt-1 text-green-600';
  } else {
    status.textContent = '비밀번호가 일치하지 않습니다.';
    status.className = 'text-xs mt-1 text-red-500';
  }
  status.classList.remove('hidden');
}

function validateForm() {
  var p1 = document.getElementById('pw1').value;
  var p2 = document.getElementById('pw2').value;
  if (p1 !== p2) { alert('비밀번호가 일치하지 않습니다.'); return false; }
  if (p1.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
  if (!emailChecked) { alert('이메일 중복확인을 해주세요.'); return false; }
  return true;
}
</script>
</body>
</html>
