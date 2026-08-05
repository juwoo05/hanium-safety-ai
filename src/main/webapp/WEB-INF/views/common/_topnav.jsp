<%@ page pageEncoding="UTF-8" %>
<%-- 보조 하단 플로팅 네비게이션: 각 페이지에서 <%@ include file="../common/_topnav.jsp" %> 로 포함.
     왼쪽 사이드바(_sidebar.jsp)를 대체하지 않고 함께 떠 있는 보조 네비게이션이다. --%>

<div id="topnavWrap" class="fixed bottom-4 inset-x-0 z-50 flex justify-center pointer-events-none">
  <div id="topnav" class="pointer-events-auto bg-white/95 backdrop-blur border border-gray-100 rounded-full shadow-lg flex items-center gap-1 px-2 py-1.5 transition-all duration-300">
    <a href="/landing" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="landing">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 11.5L12 4l9 7.5"/><path d="M5 10v10a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1V10"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">랜딩</span>
    </a>
    <a href="/login" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="login">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">로그인</span>
    </a>
    <a href="/dashboard" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="dashboard">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">대시보드</span>
    </a>
    <a href="/actions" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="actions">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">조치관리</span>
    </a>
    <a href="/upload" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="upload">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">업로드</span>
    </a>
    <a href="/actions/detail" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="actions-detail">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">리포트상세</span>
    </a>
    <a href="/analytics" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="analytics">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">통계</span>
    </a>
    <a href="/notifications" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="notifications">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">알림</span>
    </a>
    <a href="/mypage" class="topnav-item flex flex-col items-center justify-center gap-0.5 px-3 py-1.5 rounded-full text-gray-500 hover:bg-gray-50 transition-colors" data-path="mypage">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
      <span class="topnav-label text-[10px] font-semibold whitespace-nowrap">마이페이지</span>
    </a>

    <button id="topnavToggle" onclick="toggleTopnav()" class="flex items-center justify-center w-7 h-7 rounded-full text-gray-400 hover:bg-gray-100 hover:text-gray-600 transition-colors ml-1 flex-shrink-0" aria-label="네비게이션 접기/펼치기">
      <svg id="topnavCollapseIcon" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
      <svg id="topnavExpandIcon" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 hidden" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
    </button>
  </div>
</div>

<script>
function applyTopnavState(collapsed) {
  const labels = document.querySelectorAll('.topnav-label');
  const collapseIcon = document.getElementById('topnavCollapseIcon');
  const expandIcon = document.getElementById('topnavExpandIcon');
  labels.forEach(function (el) {
    el.classList.toggle('hidden', collapsed);
  });
  document.querySelectorAll('.topnav-item').forEach(function (el) {
    el.classList.toggle('px-3', !collapsed);
    el.classList.toggle('px-2.5', collapsed);
  });
  if (collapseIcon) collapseIcon.classList.toggle('hidden', collapsed);
  if (expandIcon) expandIcon.classList.toggle('hidden', !collapsed);
}

function toggleTopnav() {
  const collapsed = localStorage.getItem('topnavCollapsed') === 'true';
  const next = !collapsed;
  localStorage.setItem('topnavCollapsed', String(next));
  applyTopnavState(next);
}

(function () {
  applyTopnavState(localStorage.getItem('topnavCollapsed') === 'true');

  const path = window.location.pathname;
  document.querySelectorAll('.topnav-item').forEach(function (el) {
    const p = el.getAttribute('data-path');
    if (p !== 'landing' && p !== 'login' && path.includes(p)) {
      el.classList.remove('text-gray-500');
      el.classList.add('bg-[#FF6B35]', 'text-white');
    }
  });
})();
</script>
