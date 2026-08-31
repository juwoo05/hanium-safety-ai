<%@ page pageEncoding="UTF-8" %>
<%-- 공통 사이드바: 각 페이지에서 <%@ include file="../common/_sidebar.jsp" %> 로 포함 --%>

<aside id="sidebar" class="fixed top-0 left-0 h-screen z-40 w-[220px] bg-[#0F172A] text-white flex flex-col flex-shrink-0">
  <!-- Logo -->
  <a href="/dashboard" class="flex items-center gap-2.5 h-14 px-[18px] border-b border-white/5 flex-shrink-0 hover:opacity-90 transition-opacity">
    <div class="w-7 h-7 rounded-md bg-[#4A90D9]/[0.18] border border-[#4A90D9]/25 flex items-center justify-center flex-shrink-0">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 text-[#5CA8E8]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <span class="text-sm font-semibold text-slate-200">안전고리</span>
  </a>

  <!-- Project context -->
  <div class="px-[18px] pt-2.5 pb-2 border-b border-white/5 flex-shrink-0">
    <p class="text-[10px] text-slate-500 font-medium tracking-wider uppercase mb-0.5">현장</p>
    <p id="sidebarSiteName" class="text-[11px] text-slate-400 leading-tight">현장 정보를 불러오는 중...</p>
  </div>

  <!-- Nav -->
  <nav class="flex-1 px-2.5 py-2.5 overflow-y-auto">
    <a href="/dashboard" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="dashboard">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/></svg>
      <span>대시보드</span>
    </a>
    <a href="/upload" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="upload">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
      <span>사진 업로드</span>
    </a>
    <a href="/actions" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="actions">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
      <span>조치 관리</span>
    </a>
    <a href="/analytics" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="analytics">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
      <span>분석 리포트</span>
    </a>
    <a href="/actions/detail" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="actions-detail">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
      <span>보고서</span>
    </a>
    <a href="/report-board" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="report-board">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
      <span>신고 게시판</span>
    </a>
  </nav>

  <!-- Bottom -->
  <div class="border-t border-white/5 px-2.5 pt-2.5 pb-3.5 flex-shrink-0">
    <a href="/notifications" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="notifications">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
      <span>알림</span>
    </a>
    <a href="/mypage" class="nav-item flex items-center gap-2.5 px-3 py-[7px] mb-0.5 rounded text-[13px] text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="mypage">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
      <span>설정</span>
    </a>

    <div class="h-px bg-white/5 my-2 mx-0.5"></div>

    <div class="relative">
      <button type="button" onclick="document.getElementById('sidebarUserMenu').classList.toggle('hidden')" class="w-full flex items-center gap-2 px-2.5 py-[7px] rounded hover:bg-white/[0.04] transition-colors">
        <div class="w-[26px] h-[26px] rounded-full bg-[#1E3A5F] border border-[#4A90D9]/20 flex items-center justify-center text-[10px] font-semibold text-[#7BBDE8] flex-shrink-0">
          <span id="sidebarUserInitial">-</span>
        </div>
        <div class="flex-1 text-left min-w-0">
          <p id="sidebarUserName" class="text-xs font-medium text-slate-300 leading-tight truncate">불러오는 중...</p>
          <p id="sidebarUserRole" class="text-[10px] text-slate-500 leading-tight mt-0.5">-</p>
        </div>
        <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5 text-slate-500 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
      </button>
      <div id="sidebarUserMenu" class="hidden absolute bottom-[46px] left-2 right-2 bg-[#1E293B] border border-white/[0.07] rounded-md shadow-lg overflow-hidden z-50">
        <a href="/mypage" class="block px-3.5 py-2.5 text-xs text-slate-400 hover:bg-white/5 transition-colors">내 정보</a>
        <div class="border-t border-white/[0.06]"></div>
        <%-- Spring Security의 기본 /logout 은 POST만 받는다. <a href> 로 GET 요청을 보내면
             매칭되는 핸들러가 없어 404가 뜨므로, CSRF 토큰을 담은 폼으로 제출한다. --%>
        <form action="/logout" method="post" style="margin:0">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <button type="submit" class="w-full flex items-center gap-2 px-3.5 py-2.5 text-xs text-red-400 hover:bg-red-400/[0.06] transition-colors" style="background:none;border:none;cursor:pointer;text-align:left">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            로그아웃
          </button>
        </form>
      </div>
    </div>
  </div>
</aside>

<%@ include file="_quicknav.jsp" %>

<script>
// 현재 페이지 메뉴 활성화 (디자인 원본의 블루 액센트)
(function() {
  const path = window.location.pathname;
  document.querySelectorAll('.nav-item').forEach(function(el) {
    const p = el.getAttribute('data-path');
    if (path.includes(p)) {
      el.classList.remove('text-slate-500');
      el.classList.add('bg-white/[0.07]', 'text-white');
      el.style.boxShadow = 'inset 2px 0 0 #4A90D9';
      const icon = el.querySelector('svg');
      if (icon) icon.classList.add('text-[#4A90D9]');
    }
  });
})();

// 사이드바 사용자 정보 (모든 인증 페이지 공통 표시)
(function() {
  // 하청 계정은 대시보드 / 사진 업로드 / 신고 게시판만 접근 가능 — 나머지 업무 메뉴는 숨긴다.
  // (알림·설정은 역할과 무관한 공통 기능이라 그대로 둔다)
  var SUB_HIDDEN_PATHS = ['actions', 'analytics', 'actions-detail'];

  fetch('/api/users/me', { credentials: 'same-origin' })
    .then(function(res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function(user) {
      const nameEl = document.getElementById('sidebarUserName');
      const initialEl = document.getElementById('sidebarUserInitial');
      const roleEl = document.getElementById('sidebarUserRole');
      if (nameEl) nameEl.textContent = user.username || '-';
      if (initialEl) initialEl.textContent = user.username ? user.username.charAt(0) : '?';
      if (roleEl) roleEl.textContent = user.companyName || '';

      if (user.role === 'SUBCONTRACTOR') {
        document.querySelectorAll('.nav-item, .quicknav-item').forEach(function(el) {
          if (SUB_HIDDEN_PATHS.indexOf(el.getAttribute('data-path')) !== -1) {
            el.style.display = 'none';
          }
        });
      }
    })
    .catch(function() {});
  fetch('/api/sites', { credentials: 'same-origin' })
    .then(function(res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function(sites) {
      const el = document.getElementById('sidebarSiteName');
      if (!el) return;
      if (Array.isArray(sites) && sites.length > 0) {
        el.textContent = sites.length === 1 ? sites[0].name : (sites[0].name + ' 외 ' + (sites.length - 1) + '곳');
      } else {
        el.textContent = '연동된 현장 없음';
      }
    })
    .catch(function() {
      const el = document.getElementById('sidebarSiteName');
      if (el) el.textContent = '';
    });
})();
</script>
