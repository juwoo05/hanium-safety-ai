<%@ page pageEncoding="UTF-8" %>
<%-- 공통 사이드바: 각 페이지에서 <%@ include file="_sidebar.jsp" %> 로 포함 --%>


<aside id="sidebar" class="fixed top-0 left-0 h-screen z-40 bg-[#1B3A5F] text-white flex flex-col transition-all duration-300 ease-in-out w-16">
  <div class="flex items-center gap-3 px-3 py-5 border-b border-white/10 min-h-[72px]">
    <button onclick="toggleSidebar()" class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-white/10 transition-colors flex-shrink-0" aria-label="메뉴">
      <svg id="menuIcon" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
      <svg id="closeIcon" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 hidden" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
    </button>
    <a href="/landing" id="sidebarLogo" class="hidden items-center gap-2 overflow-hidden hover:opacity-80 transition-opacity">
      <div class="w-8 h-8 bg-[#FF6B35] rounded-lg flex items-center justify-center flex-shrink-0">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      </div>
      <span class="font-bold text-lg whitespace-nowrap">SafeMate</span>
    </a>
  </div>

  <nav id="sidebarNav" class="hidden flex-1 p-3 space-y-1 overflow-y-auto">
    <div class="px-4 py-2 mb-3">
      <span id="userTypeLabel" class="text-xs font-semibold px-3 py-1 rounded-full bg-[#FF6B35]/20 text-[#FF6B35]">원청</span>
    </div>
    <a href="/dashboard" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="dashboard">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/></svg>
      <span class="font-medium">대시보드</span>
    </a>
    <a href="/actions" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="actions">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
      <span class="font-medium">조치 관리</span>
    </a>
    <a href="/upload" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="upload">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
      <span class="font-medium">사진 업로드</span>
    </a>
    <a href="/actions/detail" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="actions-detail">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
      <span class="font-medium">리포트 상세</span>
    </a>
    <a href="/analytics" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="analytics">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
      <span class="font-medium">분석 리포트</span>
    </a>
    <a href="/notifications" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="notifications">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
      <span class="font-medium">알림</span>
    </a>
    <a href="/report-board" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="report-board">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
      <span class="font-medium">신고 게시판</span>
    </a>
    <a href="/mypage" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-white/70 hover:bg-white/10 hover:text-white" data-path="mypage">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
      <span class="font-medium">설정</span>
    </a>
  </nav>

  <div id="sidebarBottom" class="hidden p-3 border-t border-white/10">
    <a href="/mypage" class="flex items-center gap-3 px-4 py-3 text-white/70 hover:bg-white/10 hover:text-white rounded-xl transition-colors">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
      <span class="font-medium">마이페이지</span>
    </a>
  </div>
</aside>
<div id="sidebarOverlay" class="fixed inset-0 z-30 bg-black/30 hidden lg:hidden" onclick="toggleSidebar()"></div>

<script>
function toggleSidebar() {
  const sidebar = document.getElementById('sidebar');
  const logo = document.getElementById('sidebarLogo');
  const nav = document.getElementById('sidebarNav');
  const bottom = document.getElementById('sidebarBottom');
  const overlay = document.getElementById('sidebarOverlay');
  const main = document.getElementById('mainContent');
  const menuIcon = document.getElementById('menuIcon');
  const closeIcon = document.getElementById('closeIcon');
  const isOpen = sidebar.classList.contains('w-64');
  if (isOpen) {
    sidebar.classList.remove('w-64'); sidebar.classList.add('w-16');
    logo.classList.remove('flex'); logo.classList.add('hidden');
    nav.classList.remove('flex'); nav.classList.add('hidden');
    bottom.classList.add('hidden');
    overlay.classList.add('hidden');
    if (main) { main.classList.remove('ml-64'); main.classList.add('ml-16'); }
    menuIcon.classList.remove('hidden'); closeIcon.classList.add('hidden');
  } else {
    sidebar.classList.remove('w-16'); sidebar.classList.add('w-64');
    logo.classList.remove('hidden'); logo.classList.add('flex');
    nav.classList.remove('hidden'); nav.classList.add('flex'); nav.style.display = 'block';
    bottom.classList.remove('hidden');
    overlay.classList.remove('hidden');
    if (main) { main.classList.remove('ml-16'); main.classList.add('ml-64'); }
    menuIcon.classList.add('hidden'); closeIcon.classList.remove('hidden');
  }
}
// 현재 페이지 메뉴 활성화
(function() {
  const path = window.location.pathname;
  document.querySelectorAll('.nav-item').forEach(function(el) {
    const p = el.getAttribute('data-path');
    if (path.includes(p)) {
      el.classList.remove('text-white/70');
      el.classList.add('bg-[#FF6B35]', 'text-white');
    }
  });
})();
</script>
