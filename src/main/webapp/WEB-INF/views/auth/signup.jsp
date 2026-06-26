<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>회원가입 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] flex items-center justify-center px-4 py-10">

<div class="bg-white rounded-3xl shadow-2xl w-full max-w-lg overflow-hidden">
  <!-- Header -->
  <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] p-8 text-white">
    <a href="/login" class="flex items-center gap-2 text-white/70 hover:text-white transition-colors mb-4 text-sm">
      <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
      로그인으로 돌아가기
    </a>
    <div class="flex items-center gap-3 mb-4">
      <div class="w-12 h-12 bg-[#FF6B35] rounded-xl flex items-center justify-center shadow-lg">
        <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      </div>
      <div>
        <h1 class="text-2xl font-bold">SafeMate</h1>
        <p class="text-white/70 text-sm">현장 안전 관리 시스템</p>
      </div>
    </div>
    <div class="flex items-center gap-4">
      <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain" style="mix-blend-mode:multiply"/>
      <div class="bg-white/10 rounded-2xl px-4 py-3">
        <p class="text-sm">안전한 현장을 위해 함께해요! 회원가입하고 SafeMate를 시작하세요 🦺</p>
      </div>
    </div>
  </div>

  <!-- Form -->
  <form id="signupForm" action="/signup" method="post" class="p-8 space-y-5" onsubmit="return validateForm()">

    <!-- 아이디 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">아이디 <span class="text-red-500">*</span></label>
      <div class="flex gap-2">
        <div class="relative flex-1">
          <input id="userId" type="text" name="userId" placeholder="영문, 숫자 4~16자"
                 class="w-full pl-4 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
        </div>
        <button type="button" onclick="checkId()" class="px-4 py-3 rounded-xl text-sm font-semibold bg-[#1B3A5F] text-white hover:bg-[#2C5282] transition-colors whitespace-nowrap">중복확인</button>
      </div>
      <p id="userIdError" class="text-red-500 text-xs mt-1 hidden"></p>
    </div>

    <!-- 이름 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">이름 <span class="text-red-500">*</span></label>
      <input type="text" name="name" placeholder="실명을 입력해주세요"
             class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
    </div>

    <!-- 이메일 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">이메일 <span class="text-red-500">*</span></label>
      <div class="flex gap-2">
        <input id="emailInput" type="email" name="email" placeholder="your@email.com"
               class="flex-1 px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
        <button type="button" onclick="sendVerifyCode()" class="px-4 py-3 rounded-xl text-sm font-semibold bg-[#FF6B35] text-white hover:bg-[#E55A2A] transition-colors whitespace-nowrap">이메일 인증</button>
      </div>
      <div id="verifySection" class="hidden flex gap-2 mt-2">
        <input id="verifyCode" type="text" placeholder="인증 코드 6자리 (테스트: 123456)" maxlength="6"
               class="flex-1 px-3 py-2 border border-gray-300 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
        <button type="button" onclick="verifyEmail()" class="px-4 py-2 bg-[#1B3A5F] text-white rounded-xl text-sm font-semibold hover:bg-[#2C5282] transition-colors">확인</button>
      </div>
      <p id="emailStatus" class="text-xs mt-1 hidden"></p>
    </div>

    <!-- 비밀번호 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">비밀번호 <span class="text-red-500">*</span></label>
      <input id="pw1" type="password" name="password" placeholder="6자 이상"
             class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
    </div>

    <!-- 비밀번호 확인 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">비밀번호 확인 <span class="text-red-500">*</span></label>
      <input id="pw2" type="password" name="passwordConfirm" placeholder="비밀번호를 다시 입력해주세요" oninput="checkPw()"
             class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
      <p id="pwStatus" class="text-xs mt-1 hidden"></p>
    </div>

    <!-- 회사명 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-2">회사명 <span class="text-red-500">*</span></label>
      <input type="text" name="company" placeholder="소속 회사명을 입력해주세요"
             class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none text-sm" required/>
    </div>

    <!-- 계정 유형 -->
    <div>
      <label class="block text-sm font-semibold text-gray-700 mb-3">계정 유형 <span class="text-red-500">*</span></label>
      <div class="grid grid-cols-2 gap-3">
        <label class="role-card flex flex-col items-center gap-2 p-4 border-2 border-gray-200 bg-gray-50 rounded-2xl cursor-pointer hover:border-gray-400 transition-all">
          <input type="radio" name="role" value="contractor" class="sr-only" onclick="selectRole(this)"/>
          <span class="text-2xl">🏢</span>
          <span class="font-bold text-base">원청</span>
          <span class="text-xs text-gray-500">발주처 / 원도급사</span>
        </label>
        <label class="role-card flex flex-col items-center gap-2 p-4 border-2 border-gray-200 bg-gray-50 rounded-2xl cursor-pointer hover:border-gray-400 transition-all">
          <input type="radio" name="role" value="subcontractor" class="sr-only" onclick="selectRole(this)"/>
          <span class="text-2xl">👷</span>
          <span class="font-bold text-base">하청</span>
          <span class="text-xs text-gray-500">하도급사 / 협력업체</span>
        </label>
      </div>
    </div>

    <button type="submit" class="w-full bg-[#FF6B35] text-white py-4 rounded-xl font-bold text-base hover:bg-[#E55A2A] transition-colors shadow-lg mt-2">
      회원가입
    </button>

    <p class="text-center text-sm text-gray-600">
      이미 계정이 있으신가요?
      <a href="/login" class="text-[#FF6B35] font-semibold hover:underline ml-1">로그인하기</a>
    </p>
  </form>
</div>

<script>
var idChecked = false;
var emailVerified = false;

function checkId() {
  var id = document.getElementById('userId').value.trim();
  var err = document.getElementById('userIdError');
  if (!id || id.length < 4) { err.textContent = '아이디는 4자 이상이어야 합니다.'; err.classList.remove('hidden'); return; }
  idChecked = true;
  err.classList.add('hidden');
  document.getElementById('userId').classList.add('border-green-400', 'bg-green-50');
  alert('사용 가능한 아이디입니다.');
}

function sendVerifyCode() {
  var email = document.getElementById('emailInput').value.trim();
  if (!email || !email.includes('@')) { alert('올바른 이메일을 입력해주세요.'); return; }
  document.getElementById('verifySection').classList.remove('hidden');
  document.getElementById('verifySection').style.display = 'flex';
  alert(email + '로 인증 코드를 발송했습니다.');
}

function verifyEmail() {
  var code = document.getElementById('verifyCode').value.trim();
  var status = document.getElementById('emailStatus');
  if (code === '123456' || code.length === 6) {
    emailVerified = true;
    status.textContent = '이메일 인증이 완료되었습니다!';
    status.className = 'text-xs mt-1 text-green-600';
    status.classList.remove('hidden');
    document.getElementById('emailInput').classList.add('border-green-400', 'bg-green-50');
  } else {
    alert('인증 코드가 올바르지 않습니다. (테스트: 123456)');
  }
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

function selectRole(radio) {
  document.querySelectorAll('.role-card').forEach(function(card) {
    card.classList.remove('border-[#1B3A5F]', 'bg-[#1B3A5F]', 'text-white', 'border-green-600', 'bg-green-600');
    card.classList.add('border-gray-200', 'bg-gray-50');
    card.querySelectorAll('span').forEach(function(s) { s.style.color = ''; });
  });
  var card = radio.closest('.role-card');
  card.classList.remove('border-gray-200', 'bg-gray-50');
  if (radio.value === 'contractor') {
    card.classList.add('border-[#1B3A5F]', 'bg-[#1B3A5F]');
  } else {
    card.classList.add('border-green-600', 'bg-green-600');
  }
  card.querySelectorAll('span:not(.sr-only)').forEach(function(s) { s.style.color = 'white'; });
}

function validateForm() {
  var p1 = document.getElementById('pw1').value;
  var p2 = document.getElementById('pw2').value;
  if (p1 !== p2) { alert('비밀번호가 일치하지 않습니다.'); return false; }
  if (p1.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return false; }
  if (!idChecked) { alert('아이디 중복확인을 해주세요.'); return false; }
  if (!emailVerified) { alert('이메일 인증을 완료해주세요.'); return false; }
  return true;
}
</script>
</body>
</html>
