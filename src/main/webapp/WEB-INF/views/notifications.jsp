<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>알림 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <h1 class="text-lg font-semibold text-gray-900">알림</h1>
      <span class="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">5</span>
    </div>
    <div class="flex items-center gap-3">
      <button onclick="markAllRead()" class="text-sm text-[#FF6B35] hover:text-[#E55A2A] font-medium transition-colors">모두 읽음 처리</button>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto space-y-3">

      <!-- Filter Tabs -->
      <div class="flex gap-2 bg-white rounded-xl p-1.5 shadow-sm border border-gray-100">
        <button onclick="filterNoti('all',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg bg-[#FF6B35] text-white transition-all">전체</button>
        <button onclick="filterNoti('unread',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">읽지 않음</button>
        <button onclick="filterNoti('danger',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">위험 알림</button>
        <button onclick="filterNoti('action',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">조치 알림</button>
      </div>

      <!-- Today -->
      <p class="text-xs font-semibold text-gray-400 px-1 pt-2">오늘</p>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-red-500 border border-red-100 hover:shadow-md transition-all" data-type="danger unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-red-100 text-red-700 rounded-full font-medium">고위험</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">3동 옥상 안전난간 미설치 감지</p>
            <p class="text-xs text-gray-500 mt-0.5">AI가 고위험 요소를 감지했습니다. 즉시 확인이 필요합니다.</p>
            <p class="text-xs text-gray-400 mt-1.5">방금 전</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-orange-500 border border-orange-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-orange-100 text-orange-700 rounded-full font-medium">조치 마감</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">임시 배선 노출 조치 마감 임박</p>
            <p class="text-xs text-gray-500 mt-0.5">오늘 18:00까지 완료해야 합니다.</p>
            <p class="text-xs text-gray-400 mt-1.5">1시간 전</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-blue-500 border border-blue-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-blue-100 text-blue-700 rounded-full font-medium">조치 완료</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">소화기 위치 재배치 조치 완료</p>
            <p class="text-xs text-gray-500 mt-0.5">대성철골(주)이 조치를 완료했습니다. 검증 부탁드립니다.</p>
            <p class="text-xs text-gray-400 mt-1.5">3시간 전</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/dashboard" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-green-500 border border-green-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0"><img src="/images/mascot.png" alt="마스코트" class="w-7 h-7 object-contain" style="mix-blend-mode:multiply"/></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-green-100 text-green-700 rounded-full font-medium">AI 팁</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">오늘의 안전 점수: 87점</p>
            <p class="text-xs text-gray-500 mt-0.5">지난주 대비 3점 상승했습니다! 조치 완료율을 높이면 90점 달성 가능합니다.</p>
            <p class="text-xs text-gray-400 mt-1.5">5시간 전</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <!-- Yesterday -->
      <p class="text-xs font-semibold text-gray-400 px-1 pt-3">어제</p>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all opacity-70" data-type="danger">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full font-medium">고위험</span></div>
            <p class="text-sm font-semibold text-gray-700">지하 1층 임시 배선 노출 감지</p>
            <p class="text-xs text-gray-500 mt-0.5">AI 자동 감지 — 전기 위험</p>
            <p class="text-xs text-gray-400 mt-1.5">어제 09:15</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all opacity-70" data-type="action">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full font-medium">조치 배정</span></div>
            <p class="text-sm font-semibold text-gray-700">새 조치가 배정되었습니다</p>
            <p class="text-xs text-gray-500 mt-0.5">5층 외벽 안전망 점검 · 마감 2026-06-19</p>
            <p class="text-xs text-gray-400 mt-1.5">어제 08:30</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>
    </div>
  </main>
</div>
<script>
function markAllRead() {
  document.querySelectorAll('[data-type]').forEach(function(el) {
    el.classList.add('opacity-70');
    var dot = el.querySelector('.w-2.h-2.bg-red-500');
    if (dot) dot.classList.replace('bg-red-500', 'bg-transparent');
  });
  var badge = document.querySelector('header span.bg-red-500');
  if (badge) badge.remove();
}

function filterNoti(type, btn) {
  document.querySelectorAll('[data-type]').forEach(function(el) {
    if (type === 'all') { el.style.display = ''; }
    else if (type === 'unread') { el.style.display = el.dataset.type.includes('unread') ? '' : 'none'; }
    else { el.style.display = el.dataset.type.includes(type) ? '' : 'none'; }
  });
  document.querySelectorAll('button[onclick^="filterNoti"]').forEach(function(b) {
    b.className = 'flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all';
  });
  btn.className = 'flex-1 py-2 text-sm font-semibold rounded-lg bg-[#FF6B35] text-white transition-all';
}
</script>
</body>
</html>
