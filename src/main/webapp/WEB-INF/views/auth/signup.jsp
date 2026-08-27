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
<body class="min-h-screen bg-gradient-to-br from-[#1A2E44] to-[#2C5282] flex flex-col items-center justify-center px-4 py-10">

<!-- ── STEP 1: 역할 선택 ── -->
<div id="step1" class="w-full max-w-2xl flex flex-col items-center">

  <!-- 로고 -->
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-[#1A2E44] rounded flex items-center justify-center shadow-lg">
      <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <span class="font-bold text-2xl text-white">SafeMate</span>
  </div>

  <h1 class="text-3xl font-bold text-white mb-2">회원가입</h1>
  <p class="text-white/60 mb-10 text-base">계정 유형을 선택해주세요</p>

  <c:if test="${not empty signupError}">
    <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded px-4 py-3 mb-6 w-full max-w-md text-center">${signupError}</div>
  </c:if>

  <!-- 카드 2개 -->
  <div class="grid grid-cols-2 gap-8 w-full">

    <!-- 원청 -->
    <button onclick="selectRole('contractor')" class="group relative bg-white rounded p-10 flex flex-col items-center gap-4 shadow-2xl hover:scale-[1.04] hover:shadow-[0_24px_64px_rgba(0,0,0,0.35)] transition-all duration-200 text-left overflow-hidden">
      <div class="absolute top-5 left-5 w-9 h-9 rounded-full border-2 border-[#1A2E44] text-[#1A2E44] flex items-center justify-center text-base font-bold">1</div>
      <div class="w-24 h-24 bg-[#1A2E44]/10 rounded-full flex items-center justify-center mt-4 group-hover:bg-[#1A2E44]/20 transition-colors">
        <svg class="w-12 h-12 text-[#1A2E44] group-hover:scale-110 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
          <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
          <path d="M9 22V12h6v10"/>
          <rect x="7" y="5" width="2" height="4"/><rect x="11" y="5" width="2" height="4"/><rect x="15" y="5" width="2" height="4"/>
        </svg>
      </div>
      <div class="text-center">
        <span class="text-2xl font-bold text-gray-900 block">원청</span>
        <span class="text-sm text-gray-400 font-medium">발주처 / 원도급사</span>
      </div>
      <span class="text-sm text-gray-400 text-center leading-relaxed">현장 전체 안전 관리 및 하청 업체 감독</span>
      <div class="absolute bottom-0 left-0 right-0 h-1 rounded-b-2xl opacity-0 group-hover:opacity-100 transition-opacity bg-[#1A2E44]"></div>
    </button>

    <!-- 하청 -->
    <button onclick="selectRole('subcontractor')" class="group relative bg-white rounded p-10 flex flex-col items-center gap-4 shadow-2xl hover:scale-[1.04] hover:shadow-[0_24px_64px_rgba(0,0,0,0.35)] transition-all duration-200 overflow-hidden">
      <div class="absolute top-5 left-5 w-9 h-9 rounded-full border-2 border-green-500 text-green-500 flex items-center justify-center text-base font-bold">2</div>
      <div class="w-24 h-24 bg-green-50 rounded-full flex items-center justify-center mt-4 group-hover:bg-green-100 transition-colors">
        <svg class="w-12 h-12 text-green-600 group-hover:scale-110 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
          <path d="M2 18h20"/><path d="M4 18V9a1 1 0 0 1 .553-.894l7-3.5a1 1 0 0 1 .894 0l7 3.5A1 1 0 0 1 20 9v9"/>
          <path d="M9 18v-6h6v6"/>
          <circle cx="12" cy="6" r="1"/>
        </svg>
      </div>
      <div class="text-center">
        <span class="text-2xl font-bold text-gray-900 block">하청</span>
        <span class="text-sm text-gray-400 font-medium">하도급사 / 협력업체</span>
      </div>
      <span class="text-sm text-gray-400 text-center leading-relaxed">현장 작업 및 안전 조치 이행 보고</span>
      <div class="absolute bottom-0 left-0 right-0 h-1 rounded-b-2xl opacity-0 group-hover:opacity-100 transition-opacity bg-green-500"></div>
    </button>

  </div>

  <p class="mt-10 text-white/50 text-sm">
    이미 계정이 있으신가요?
    <a href="/login" class="text-[#1A2E44] font-semibold hover:underline ml-1">로그인하기</a>
  </p>
</div>

<!-- ── STEP 2: 가입 폼 ── -->
<div id="step2" class="hidden w-full max-w-lg">
  <div class="bg-white rounded shadow-2xl overflow-hidden">

    <!-- 헤더 -->
    <div id="step2Header" class="px-8 py-6" style="background:linear-gradient(135deg,#1A2E44,#2C5282)">
      <button onclick="goBack()" class="flex items-center gap-1.5 text-white/60 hover:text-white text-sm mb-4 transition-colors">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        유형 선택으로
      </button>
      <div class="flex items-center gap-3">
        <div id="step2IconBox" class="w-10 h-10 rounded flex items-center justify-center shadow-lg" style="background:#1A2E44">
          <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div>
          <div class="flex items-center gap-2">
            <p class="font-bold text-white text-lg">회원가입</p>
            <span id="step2RoleBadge" class="text-xs font-bold px-2.5 py-1 rounded-full"></span>
          </div>
          <p id="roleLabel" class="text-white/60 text-sm"></p>
        </div>
      </div>
    </div>

    <!-- 폼 -->
    <form id="signupForm" action="/signup" method="post" onsubmit="return validateForm()" class="px-8 py-7 space-y-5">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <input type="hidden" name="role" id="roleInput"/>

      <c:if test="${not empty signupError}">
        <div class="bg-red-50 border border-red-200 text-red-600 text-sm rounded px-4 py-3">${signupError}</div>
      </c:if>

      <!-- 이름 (로그인 아이디는 이메일을 사용한다) -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">이름 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          <input type="text" name="name" placeholder="실명 입력"
                 class="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none text-sm" required/>
        </div>
      </div>

      <!-- 이메일 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">이메일 <span class="text-red-500">*</span></label>
        <div class="flex gap-2">
          <div class="relative flex-1">
            <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
            <input id="emailInput" type="email" name="email" placeholder="your@email.com" oninput="resetEmailCheck()"
                   class="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none text-sm" required/>
          </div>
          <button type="button" id="sendCodeBtn" onclick="sendVerifyCode()" class="px-4 py-2.5 rounded text-sm font-semibold text-white transition-colors whitespace-nowrap" style="background:#1A2E44">이메일 인증</button>
        </div>
        <div id="verifySection" class="hidden gap-2 mt-2">
          <input id="verifyCode" type="text" inputmode="numeric" placeholder="인증 코드 6자리" maxlength="6"
                 class="flex-1 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
          <button type="button" onclick="verifyEmail()" class="px-4 py-2 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#2C5282] transition-colors">확인</button>
        </div>
        <p id="emailStatus" class="text-xs mt-1 hidden"></p>
      </div>

      <!-- 비밀번호 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input id="pw1" type="password" name="password" placeholder="6자 이상"
                 class="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none text-sm" required/>
        </div>
      </div>

      <!-- 비밀번호 확인 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 확인 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input id="pw2" type="password" name="passwordConfirm" placeholder="비밀번호 재입력" oninput="checkPw()"
                 class="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none text-sm" required/>
        </div>
        <p id="pwStatus" class="text-xs mt-1 hidden"></p>
      </div>

      <!-- 회사명 -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">회사명 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
          <input type="text" name="company" placeholder="소속 회사명"
                 class="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none text-sm" required/>
        </div>
      </div>

      <button type="submit" id="submitBtn" class="w-full text-white py-4 rounded font-bold text-base transition-all shadow-lg mt-2" style="background:#1A2E44">
        <span id="submitBtnLabel">회원가입</span>
      </button>

      <p class="text-center text-sm text-gray-500">
        이미 계정이 있으신가요?
        <a href="/login" id="step2LoginLink" class="font-semibold hover:underline ml-1" style="color:#1A2E44">로그인하기</a>
      </p>
    </form>
  </div>
</div>

<script>
// 인증에 성공한 이메일 주소. 이메일을 고치면 다시 비워서 재인증을 강제한다.
var verifiedEmail = '';

function selectRole(role) {
  var isContractor = role === 'contractor';
  var accent = isContractor ? '#1A2E44' : '#22c55e';
  var roleKr = isContractor ? '원청' : '하청';

  document.getElementById('roleInput').value = role;
  document.getElementById('roleLabel').textContent = isContractor ? '발주처 / 원도급사' : '하도급사 / 협력업체';
  document.getElementById('step2RoleBadge').textContent = roleKr;
  document.getElementById('step2RoleBadge').style.background = accent + '30';
  document.getElementById('step2RoleBadge').style.color = accent;
  document.getElementById('step2IconBox').style.background = accent;
  document.getElementById('submitBtn').style.background = accent;
  document.getElementById('submitBtnLabel').textContent = roleKr + ' 계정 회원가입';
  document.getElementById('step2LoginLink').style.color = accent;
  document.getElementById('sendCodeBtn').style.background = accent;

  document.getElementById('step1').classList.add('hidden');
  document.getElementById('step2').classList.remove('hidden');
}

function goBack() {
  document.getElementById('step2').classList.add('hidden');
  document.getElementById('step1').classList.remove('hidden');
}

function showEmailStatus(message, ok) {
  var status = document.getElementById('emailStatus');
  status.textContent = message;
  status.className = 'text-xs mt-1 ' + (ok ? 'text-green-600' : 'text-red-500');
  status.classList.remove('hidden');
}

// 이메일을 수정하면 이전 인증은 무효고 코드 입력칸도 접음
function resetEmailCheck() {
  verifiedEmail = '';
  document.getElementById('emailStatus').classList.add('hidden');
  document.getElementById('verifySection').classList.add('hidden');
  document.getElementById('verifySection').classList.remove('flex');
  document.getElementById('verifyCode').value = '';
  document.getElementById('emailInput').classList.remove('border-green-400', 'bg-green-50');
}

function sendVerifyCode() {
  var email = document.getElementById('emailInput').value.trim();
  if (!email || !email.includes('@')) { alert('올바른 이메일을 입력해주세요.'); return; }

  var btn = document.getElementById('sendCodeBtn');
  btn.disabled = true;
  btn.textContent = '발송 중...';

  fetch('/api/auth/send-verify-code', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'email=' + encodeURIComponent(email)
  })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      showEmailStatus(data.message, data.ok);
      if (data.ok) {
        var section = document.getElementById('verifySection');
        section.classList.remove('hidden');
        section.classList.add('flex');
        document.getElementById('verifyCode').focus();
      }
    })
    .catch(function() { showEmailStatus('인증 코드 발송 중 오류가 발생했습니다.', false); })
    .finally(function() {
      btn.disabled = false;
      btn.textContent = '인증 코드 재발송';
    });
}

function verifyEmail() {
  var input = document.getElementById('emailInput');
  var email = input.value.trim();
  var code = document.getElementById('verifyCode').value.trim();
  if (!code) { alert('인증 코드를 입력해주세요.'); return; }

  fetch('/api/auth/verify-email', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code)
  })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      showEmailStatus(data.message, data.ok);
      if (!data.ok) { return; }

      verifiedEmail = email;
      var section = document.getElementById('verifySection');
      section.classList.add('hidden');
      section.classList.remove('flex');
      input.readOnly = true;
      input.classList.add('border-green-400', 'bg-green-50');
      document.getElementById('sendCodeBtn').textContent = '인증 완료';
      document.getElementById('sendCodeBtn').disabled = true;
    })
    .catch(function() { showEmailStatus('인증 확인 중 오류가 발생했습니다.', false); });
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
  var email = document.getElementById('emailInput').value.trim();
  if (!verifiedEmail || verifiedEmail !== email) { alert('이메일 인증을 완료해주세요.'); return false; }
  return true;
}
</script>
</body>
</html>
