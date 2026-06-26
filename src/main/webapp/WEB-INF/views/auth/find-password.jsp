<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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

  <!-- 단계 표시 -->
  <div class="flex items-center justify-between mb-8">
    <div class="flex items-center gap-2">
      <div class="w-12 h-12 bg-[#FF6B35] rounded-xl flex items-center justify-center">
        <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
      </div>
      <div>
        <span class="font-bold text-2xl text-[#1B3A5F]">비밀번호 찾기</span>
        <p class="text-xs text-gray-500">본인 인증 후 비밀번호를 재설정합니다</p>
      </div>
    </div>
  </div>

  <div class="flex items-center gap-2 mb-8">
    <div id="step-dot-1" class="flex flex-col items-center gap-1"><div class="w-8 h-8 rounded-full bg-[#FF6B35] text-white flex items-center justify-center text-xs font-bold">1</div><span class="text-xs text-[#FF6B35]">이메일</span></div>
    <div class="flex-1 h-0.5 bg-gray-200" id="line1"></div>
    <div id="step-dot-2" class="flex flex-col items-center gap-1"><div class="w-8 h-8 rounded-full bg-gray-200 text-gray-400 flex items-center justify-center text-xs font-bold">2</div><span class="text-xs text-gray-400">코드 인증</span></div>
    <div class="flex-1 h-0.5 bg-gray-200" id="line2"></div>
    <div id="step-dot-3" class="flex flex-col items-center gap-1"><div class="w-8 h-8 rounded-full bg-gray-200 text-gray-400 flex items-center justify-center text-xs font-bold">3</div><span class="text-xs text-gray-400">재설정</span></div>
    <div class="flex-1 h-0.5 bg-gray-200" id="line3"></div>
    <div id="step-dot-4" class="flex flex-col items-center gap-1"><div class="w-8 h-8 rounded-full bg-gray-200 text-gray-400 flex items-center justify-center text-xs font-bold">4</div><span class="text-xs text-gray-400">완료</span></div>
  </div>

  <!-- Step 1: 이메일 입력 -->
  <div id="step1">
    <h3 class="text-lg font-bold text-gray-800 mb-4">이메일을 입력해주세요</h3>
    <div class="relative mb-4">
      <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
      <input id="emailInput" type="email" placeholder="가입 시 등록한 이메일"
             class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
    </div>
    <button onclick="goStep2()" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">인증 코드 발송</button>
  </div>

  <!-- Step 2: 코드 인증 -->
  <div id="step2" class="hidden">
    <h3 class="text-lg font-bold text-gray-800 mb-2">인증 코드를 입력해주세요</h3>
    <p id="emailSentTo" class="text-sm text-gray-500 mb-4"></p>
    <input id="codeInput" type="text" placeholder="인증 코드 6자리 (테스트: 123456)" maxlength="6"
           class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none mb-4"/>
    <button onclick="goStep3()" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">코드 확인</button>
  </div>

  <!-- Step 3: 비밀번호 재설정 -->
  <div id="step3" class="hidden">
    <h3 class="text-lg font-bold text-gray-800 mb-4">새 비밀번호를 설정해주세요</h3>
    <div class="relative mb-4">
      <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
      <input id="newPw" type="password" placeholder="새 비밀번호 (6자 이상)"
             class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
    </div>
    <div class="relative mb-4">
      <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
      <input id="confirmPw" type="password" placeholder="비밀번호 확인"
             class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
    </div>
    <button onclick="goStep4()" class="w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors">비밀번호 변경</button>
  </div>

  <!-- Step 4: 완료 -->
  <div id="step4" class="hidden text-center">
    <svg class="w-16 h-16 text-green-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
    <h3 class="text-xl font-bold text-gray-800 mb-2">비밀번호가 변경되었습니다!</h3>
    <p class="text-gray-500 mb-6">새 비밀번호로 로그인해주세요.</p>
    <a href="/login" class="block w-full bg-[#FF6B35] text-white py-3 rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors text-center">로그인하기</a>
  </div>
</div>

<script>
function activateStep(n) {
  for (var i = 1; i <= 4; i++) {
    var dot = document.getElementById('step-dot-' + i).querySelector('div');
    if (i <= n) { dot.className = 'w-8 h-8 rounded-full bg-[#FF6B35] text-white flex items-center justify-center text-xs font-bold'; }
    else { dot.className = 'w-8 h-8 rounded-full bg-gray-200 text-gray-400 flex items-center justify-center text-xs font-bold'; }
    document.getElementById('step' + i) && document.getElementById('step' + i).classList.add('hidden');
  }
  document.getElementById('step' + n).classList.remove('hidden');
}
function goStep2() {
  var email = document.getElementById('emailInput').value.trim();
  if (!email || !email.includes('@')) { alert('올바른 이메일을 입력해주세요.'); return; }
  document.getElementById('emailSentTo').textContent = email + '로 인증 코드를 발송했습니다.';
  activateStep(2);
}
function goStep3() {
  var code = document.getElementById('codeInput').value.trim();
  if (code === '123456' || code.length === 6) { activateStep(3); }
  else { alert('인증 코드가 올바르지 않습니다. (테스트: 123456)'); }
}
function goStep4() {
  var p1 = document.getElementById('newPw').value;
  var p2 = document.getElementById('confirmPw').value;
  if (p1.length < 6) { alert('비밀번호는 6자 이상이어야 합니다.'); return; }
  if (p1 !== p2) { alert('비밀번호가 일치하지 않습니다.'); return; }
  activateStep(4);
}
</script>
</body>
</html>
