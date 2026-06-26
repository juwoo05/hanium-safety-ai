<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>마이페이지 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <h1 class="text-lg font-semibold text-gray-900">마이페이지</h1>
    <div class="flex items-center gap-3">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-4xl mx-auto space-y-6">

      <!-- Profile Card -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-8 text-white">
        <div class="flex items-center gap-6">
          <div class="relative">
            <div class="w-24 h-24 bg-[#FF6B35] rounded-2xl flex items-center justify-center text-4xl font-bold shadow-lg">김</div>
            <button class="absolute -bottom-1 -right-1 w-7 h-7 bg-white rounded-full flex items-center justify-center shadow-md hover:bg-gray-50 transition-colors">
              <svg class="w-3.5 h-3.5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
            </button>
          </div>
          <div class="flex-1">
            <div class="flex items-center gap-3 mb-1">
              <h2 class="text-2xl font-bold">김현장</h2>
              <span class="bg-[#FF6B35] text-white text-xs font-bold px-3 py-1 rounded-full">원청</span>
            </div>
            <p class="text-white/70 text-sm mb-3">(주)한국건설 · 안전관리자</p>
            <div class="flex flex-wrap gap-4 text-sm text-white/80">
              <span class="flex items-center gap-1.5"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>kim@hankuk.co.kr</span>
              <span class="flex items-center gap-1.5"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.77 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 8.91a16 16 0 0 0 6 6l.91-.91a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>010-1234-5678</span>
            </div>
          </div>
          <div class="hidden lg:block text-right">
            <div class="bg-white/10 rounded-xl px-5 py-3">
              <p class="text-white/60 text-xs mb-1">안전 점수</p>
              <p class="text-4xl font-bold text-[#FF6B35]">92</p>
              <p class="text-white/60 text-xs mt-1">/ 100점</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Tab Navigation -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="flex border-b border-gray-100" id="tabNav">
          <button onclick="switchTab('info', this)" class="flex-1 py-3.5 text-sm font-semibold text-[#FF6B35] border-b-2 border-[#FF6B35] transition-all">기본 정보</button>
          <button onclick="switchTab('stats', this)" class="flex-1 py-3.5 text-sm font-semibold text-gray-500 hover:text-gray-700 transition-all">활동 통계</button>
          <button onclick="switchTab('settings', this)" class="flex-1 py-3.5 text-sm font-semibold text-gray-500 hover:text-gray-700 transition-all">알림 설정</button>
          <button onclick="switchTab('security', this)" class="flex-1 py-3.5 text-sm font-semibold text-gray-500 hover:text-gray-700 transition-all">보안</button>
        </div>

        <!-- Tab: 기본 정보 -->
        <div id="tab-info" class="p-6">
          <form class="space-y-5">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">이름</label>
                <input type="text" value="김현장" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">역할</label>
                <select class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                  <option selected>안전관리자 (원청)</option>
                  <option>현장소장</option>
                  <option>작업자 (하청)</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">이메일</label>
                <input type="email" value="kim@hankuk.co.kr" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">연락처</label>
                <input type="tel" value="010-1234-5678" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">소속 업체</label>
                <input type="text" value="(주)한국건설" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">현장 코드</label>
                <input type="text" value="HK-2026-001" readonly class="w-full px-4 py-3 border border-gray-200 rounded-xl bg-gray-50 text-gray-500 outline-none"/>
              </div>
            </div>
            <div class="flex justify-end gap-3 pt-2">
              <button type="button" class="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors">취소</button>
              <button type="submit" class="px-6 py-2.5 bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-md">저장</button>
            </div>
          </form>
        </div>

        <!-- Tab: 활동 통계 -->
        <div id="tab-stats" class="p-6 hidden">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <div class="text-center p-4 bg-gray-50 rounded-xl"><p class="text-2xl font-bold text-gray-900">312</p><p class="text-xs text-gray-500 mt-1">총 업로드</p></div>
            <div class="text-center p-4 bg-gray-50 rounded-xl"><p class="text-2xl font-bold text-[#FF6B35]">127</p><p class="text-xs text-gray-500 mt-1">위험 감지</p></div>
            <div class="text-center p-4 bg-gray-50 rounded-xl"><p class="text-2xl font-bold text-green-600">94</p><p class="text-xs text-gray-500 mt-1">조치 완료</p></div>
            <div class="text-center p-4 bg-gray-50 rounded-xl"><p class="text-2xl font-bold text-purple-600">92점</p><p class="text-xs text-gray-500 mt-1">안전 점수</p></div>
          </div>
          <h3 class="text-sm font-semibold text-gray-700 mb-3">월별 업로드 현황</h3>
          <div class="flex items-end gap-1.5 h-32 bg-gray-50 rounded-xl p-4">
            <% int[] myUploads={18,22,20,28,25,24,30,32,28,27,23,26}; String[] myMonths={"1","2","3","4","5","6","7","8","9","10","11","12"}; int myMax=32; %>
            <% for(int i=0;i<12;i++){ int pct=myUploads[i]*100/myMax; %>
            <div class="flex-1 flex flex-col items-center gap-1">
              <div class="w-full bg-[#FF6B35] rounded-t" style="height:<%=pct%>%;min-height:3px;max-height:80px"></div>
              <span class="text-[10px] text-gray-400"><%=myMonths[i]%></span>
            </div>
            <% } %>
          </div>
          <div class="mt-4 grid grid-cols-1 md:grid-cols-3 gap-3 text-sm">
            <div class="bg-green-50 rounded-xl p-3 border border-green-100"><p class="text-xs text-gray-500 mb-1">이번 달 업로드</p><p class="text-xl font-bold text-gray-900">26건</p><p class="text-xs text-green-600 mt-0.5">↑ 지난 달 대비 +3</p></div>
            <div class="bg-blue-50 rounded-xl p-3 border border-blue-100"><p class="text-xs text-gray-500 mb-1">조치 완료율</p><p class="text-xl font-bold text-gray-900">92%</p><p class="text-xs text-blue-600 mt-0.5">↑ 지난 달 대비 +5%</p></div>
            <div class="bg-purple-50 rounded-xl p-3 border border-purple-100"><p class="text-xs text-gray-500 mb-1">평균 처리 시간</p><p class="text-xl font-bold text-gray-900">1.8일</p><p class="text-xs text-purple-600 mt-0.5">↓ 0.3일 단축</p></div>
          </div>
        </div>

        <!-- Tab: 알림 설정 -->
        <div id="tab-settings" class="p-6 hidden">
          <div class="space-y-4">
            <% String[] notiLabels={"고위험 감지 즉시 알림","조치 마감 D-1 알림","조치 완료 알림","일일 안전 요약 리포트","AI 인사이트 알림"}; boolean[] notiDefaults={true,true,true,false,true}; %>
            <% for(int i=0;i<notiLabels.length;i++){ String checked=notiDefaults[i]?"checked":""; String bg=notiDefaults[i]?"bg-[#FF6B35]":"bg-gray-300"; %>
            <div class="flex items-center justify-between p-4 border border-gray-100 rounded-xl hover:border-gray-200 transition-colors">
              <div><p class="text-sm font-semibold text-gray-900"><%=notiLabels[i]%></p></div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" <%=checked%> class="sr-only peer" onchange="this.parentElement.querySelector('div').className='w-11 h-6 rounded-full peer peer-checked:bg-[#FF6B35] bg-gray-300 after:content-[\'\'] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full'"/>
                <div class="w-11 h-6 <%=bg%> rounded-full transition-colors after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all <%=notiDefaults[i]?"after:translate-x-full":""%>"></div>
              </label>
            </div>
            <% } %>
            <div class="mt-2">
              <label class="block text-sm font-semibold text-gray-700 mb-2">알림 수신 방법</label>
              <div class="flex gap-3">
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked class="accent-[#FF6B35]"/><span class="text-sm text-gray-700">앱 푸시</span></label>
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked class="accent-[#FF6B35]"/><span class="text-sm text-gray-700">이메일</span></label>
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" class="accent-[#FF6B35]"/><span class="text-sm text-gray-700">문자 SMS</span></label>
              </div>
            </div>
            <div class="flex justify-end pt-2"><button class="px-6 py-2.5 bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-md">저장</button></div>
          </div>
        </div>

        <!-- Tab: 보안 -->
        <div id="tab-security" class="p-6 hidden">
          <div class="space-y-5">
            <div class="p-4 bg-green-50 rounded-xl border border-green-200 flex items-center gap-3">
              <svg class="w-5 h-5 text-green-600 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
              <div><p class="text-sm font-semibold text-green-900">계정이 안전합니다</p><p class="text-xs text-green-700">마지막 로그인: 2026-06-19 09:12 (서울)</p></div>
            </div>
            <div class="border border-gray-100 rounded-xl p-5">
              <h3 class="text-sm font-semibold text-gray-900 mb-4">비밀번호 변경</h3>
              <div class="space-y-3">
                <div><label class="block text-xs font-semibold text-gray-600 mb-1.5">현재 비밀번호</label><input type="password" placeholder="현재 비밀번호" class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div>
                <div><label class="block text-xs font-semibold text-gray-600 mb-1.5">새 비밀번호</label><input type="password" placeholder="8자 이상, 영문+숫자+특수문자" class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div>
                <div><label class="block text-xs font-semibold text-gray-600 mb-1.5">새 비밀번호 확인</label><input type="password" placeholder="새 비밀번호 재입력" class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div>
                <div class="flex justify-end"><button class="px-5 py-2 bg-[#FF6B35] text-white rounded-xl text-sm font-semibold hover:bg-[#E55A2A] transition-colors">변경</button></div>
              </div>
            </div>
            <div class="border border-gray-100 rounded-xl p-5">
              <div class="flex items-center justify-between mb-3"><h3 class="text-sm font-semibold text-gray-900">2단계 인증</h3><span class="text-xs px-2 py-0.5 bg-red-100 text-red-600 rounded-full font-medium">미설정</span></div>
              <p class="text-xs text-gray-500 mb-3">로그인 시 추가 인증으로 계정을 더 안전하게 보호하세요.</p>
              <button class="px-4 py-2 border border-[#FF6B35] text-[#FF6B35] rounded-xl text-sm font-semibold hover:bg-[#FF6B35] hover:text-white transition-colors">2단계 인증 설정</button>
            </div>
            <div class="border border-red-100 rounded-xl p-5 bg-red-50">
              <h3 class="text-sm font-semibold text-red-800 mb-2">위험 구역</h3>
              <p class="text-xs text-red-600 mb-3">아래 작업은 되돌릴 수 없습니다.</p>
              <button class="px-4 py-2 border border-red-400 text-red-600 rounded-xl text-sm font-semibold hover:bg-red-500 hover:text-white transition-colors">계정 탈퇴</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Logout -->
      <div class="flex justify-center">
        <a href="/login" class="flex items-center gap-2 px-6 py-2.5 border border-gray-300 text-gray-600 rounded-xl text-sm font-medium hover:bg-gray-50 hover:border-gray-400 transition-colors">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          로그아웃
        </a>
      </div>
    </div>
  </main>
</div>
<script>
function switchTab(name, btn) {
  ['info','stats','settings','security'].forEach(function(t) {
    document.getElementById('tab-'+t).classList.add('hidden');
  });
  document.getElementById('tab-'+name).classList.remove('hidden');
  document.querySelectorAll('#tabNav button').forEach(function(b) {
    b.className = 'flex-1 py-3.5 text-sm font-semibold text-gray-500 hover:text-gray-700 transition-all';
  });
  btn.className = 'flex-1 py-3.5 text-sm font-semibold text-[#FF6B35] border-b-2 border-[#FF6B35] transition-all';
}
</script>
</body>
</html>