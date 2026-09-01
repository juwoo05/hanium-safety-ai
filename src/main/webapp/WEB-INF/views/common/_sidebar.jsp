<%@ page pageEncoding="UTF-8" %>
<%-- 공통 사이드바: 각 페이지에서 <%@ include file="../common/_sidebar.jsp" %> 로 포함 --%>

<%-- 공통 보정: 표 머리글, 상태·위험 배지(pill), 버튼·필터·탭 라벨, 셀렉트 옵션이
     좁은 칸에서 "중위\n험"처럼 중간에 줄바꿈되어 잘리는 현상을 전역으로 막는다.
     긴 본문(제목·설명 등 셀 텍스트)은 기존 줄바꿈 동작을 유지한다. --%>
<style>
  table th { white-space: nowrap; }
  span[style*="border-radius"],
  span[style*="border-radius"] *,
  span[class*="rounded-full"],
  span[class*="rounded"][class*="px-2"] { white-space: nowrap; }
  button { white-space: nowrap; }
  select,
  select option { white-space: nowrap; }

  /* 헤더 종 아이콘 표시는 항상 노출되던 빨간 점 대신 JS가 안 읽은(미확인) 알림 개수를
     빨간 배지로 채워 넣는다. 개수가 없거나 JS 실행 전에는 숨긴다. */
  a[href="/notifications"] span.bg-red-500 { display: none; }

  /* 사이드바 접기/펼치기 */
  #sidebar { transition: transform .22s ease; }
  #mainContent { transition: margin-left .22s ease; }
  #sidebarOpen,
  #sidebarRail { display: none; }
  body.sidebar-collapsed #sidebar { transform: translateX(-100%); }
  /* 접었을 때: 왼쪽에 48px 다크 바를 남기고 본문을 그만큼 오른쪽으로 밀어
     햄버거 버튼이 본문 위에 겹치지 않게 한다. */
  body.sidebar-collapsed #sidebarRail {
    display: block; position: fixed; top: 0; left: 0; bottom: 0;
    width: 48px; background: #0F172A; z-index: 41;
  }
  body.sidebar-collapsed #mainContent { margin-left: 48px !important; }
  body.sidebar-collapsed #sidebarOpen {
    display: flex; left: 6px; background: transparent; color: #CBD5E1; box-shadow: none;
  }
  body.sidebar-collapsed #sidebarOpen:hover { background: rgba(255,255,255,.08); color: #fff; }

  /* flex 자식의 기본 min-width:auto 때문에 본문이 뷰포트보다 넓어져 화면 오른쪽이
     잘리는 현상 방지. 넓은 표 등은 각자의 overflow-x 컨테이너 안에서 스크롤된다. */
  #mainContent { min-width: 0; }
  #mainContent > main,
  #mainContent > header { min-width: 0; }
  #mainContent [style*="overflow-x"] { max-width: 100%; }

  /* 좁은 뷰포트에서 대시보드 2단 그리드는 세로로 쌓아 오른쪽 잘림을 막는다 */
  @media (max-width: 1024px) {
    #mainContent .dash-2col { grid-template-columns: 1fr !important; }
  }
</style>

<%-- 저장된 접힘 상태를 페인트 전에 반영해 깜빡임을 막는다 --%>
<script>try { if (localStorage.getItem('sidebar.collapsed') === '1') document.body.classList.add('sidebar-collapsed'); } catch (e) {}</script>

<%-- 사이드바를 접었을 때 왼쪽에 남는 다크 바 + 열기(햄버거) 버튼 --%>
<div id="sidebarRail" aria-hidden="true"></div>
<button id="sidebarOpen" type="button" aria-label="사이드바 열기"
        class="fixed top-3 left-3 z-50 w-9 h-9 items-center justify-center rounded-md text-white transition-colors">
  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
</button>

<aside id="sidebar" class="fixed top-0 left-0 h-screen z-40 w-[220px] bg-[#0F172A] text-white flex flex-col flex-shrink-0">
  <!-- Logo + 접기 버튼 -->
  <div class="flex items-center h-16 pl-[18px] pr-2 border-b border-white/5 flex-shrink-0">
    <a href="/dashboard" class="flex items-center gap-2.5 flex-1 min-w-0 hover:opacity-90 transition-opacity">
      <div class="w-8 h-8 rounded-md bg-[#4A90D9]/[0.18] border border-[#4A90D9]/25 flex items-center justify-center flex-shrink-0 overflow-hidden">
        <img src="/images/yeongyeol-gori-logo.png" alt="연결고리 로고" class="w-7 h-7 object-contain"/>
      </div>
      <span class="text-base font-semibold text-slate-200 truncate">연결고리</span>
    </a>
    <button id="sidebarToggle" type="button" aria-label="사이드바 접기"
            class="flex-shrink-0 w-8 h-8 flex items-center justify-center rounded-md text-slate-400 hover:bg-white/10 hover:text-slate-200 transition-colors">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-[18px] h-[18px]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
    </button>
  </div>

  <!-- Project context -->
  <div class="px-[18px] pt-3 pb-2.5 border-b border-white/5 flex-shrink-0">
    <p class="text-[11px] text-slate-500 font-medium tracking-wider uppercase mb-1">현장</p>
    <p id="sidebarSiteName" class="text-xs text-slate-400 leading-snug">현장 정보를 불러오는 중...</p>
  </div>

  <!-- Nav -->
  <nav class="flex-1 px-2.5 py-2.5 overflow-y-auto">
    <a href="/dashboard" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="dashboard">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/></svg>
      <span>대시보드</span>
    </a>
    <a href="/upload" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="upload">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
      <span>사진 업로드</span>
    </a>
    <a href="/actions" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="actions">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
      <span>조치 관리</span>
    </a>
    <a href="/analytics" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="analytics">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
      <span>분석 리포트</span>
    </a>
    <a href="/actions/detail" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="actions-detail">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
      <span>보고서</span>
    </a>
    <a href="/report-board" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="report-board">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
      <span>신고 게시판</span>
    </a>
  </nav>

  <!-- Bottom -->
  <div class="border-t border-white/5 px-2.5 pt-2.5 pb-3.5 flex-shrink-0">
    <a href="/notifications" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="notifications">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
      <span>알림</span>
    </a>
    <a href="/mypage" class="nav-item flex items-center gap-2.5 px-3 py-2 mb-0.5 rounded text-sm text-slate-500 hover:bg-white/[0.04] hover:text-slate-300 transition-colors" data-path="mypage">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
      <span>설정</span>
    </a>

    <div class="h-px bg-white/5 my-2 mx-0.5"></div>

    <div class="relative">
      <button type="button" onclick="document.getElementById('sidebarUserMenu').classList.toggle('hidden')" class="w-full flex items-center gap-2.5 px-2.5 py-2 rounded hover:bg-white/[0.04] transition-colors">
        <div class="w-[30px] h-[30px] rounded-full bg-[#1E3A5F] border border-[#4A90D9]/20 flex items-center justify-center text-[11px] font-semibold text-[#7BBDE8] flex-shrink-0">
          <span id="sidebarUserInitial">-</span>
        </div>
        <div class="flex-1 text-left min-w-0">
          <p id="sidebarUserName" class="text-sm font-medium text-slate-300 leading-tight truncate">불러오는 중...</p>
          <p id="sidebarUserRole" class="text-[11px] text-slate-500 leading-tight mt-0.5">-</p>
        </div>
        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-slate-500 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
      </button>
      <div id="sidebarUserMenu" class="hidden absolute bottom-[54px] left-2 right-2 bg-[#1E293B] border border-white/[0.07] rounded-md shadow-lg overflow-hidden z-50">
        <a href="/mypage" class="block px-3.5 py-2.5 text-sm text-slate-400 hover:bg-white/5 transition-colors">내 정보</a>
        <div class="border-t border-white/[0.06]"></div>
        <%-- Spring Security의 기본 /logout 은 POST만 받는다. <a href> 로 GET 요청을 보내면
             매칭되는 핸들러가 없어 404가 뜨므로, CSRF 토큰을 담은 폼으로 제출한다. --%>
        <form action="/logout" method="post" style="margin:0">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <button type="submit" class="w-full flex items-center gap-2 px-3.5 py-2.5 text-sm text-red-400 hover:bg-red-400/[0.06] transition-colors" style="background:none;border:none;cursor:pointer;text-align:left">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            로그아웃
          </button>
        </form>
      </div>
    </div>
  </div>
</aside>

<%@ include file="_quicknav.jsp" %>

<script>
// 사이드바 접기/펼치기 (접힘 상태는 localStorage에 저장돼 페이지 이동 후에도 유지)
(function() {
  function setCollapsed(v) {
    document.body.classList.toggle('sidebar-collapsed', v);
    try { localStorage.setItem('sidebar.collapsed', v ? '1' : '0'); } catch (e) {}
  }
  var toggle = document.getElementById('sidebarToggle');
  var open = document.getElementById('sidebarOpen');
  if (toggle) toggle.addEventListener('click', function() { setCollapsed(true); });
  if (open) open.addEventListener('click', function() { setCollapsed(false); });
})();

// 현재 페이지 메뉴 활성화 (디자인 원본의 블루 액센트)
// href가 가장 길게(가장 구체적으로) 일치하는 항목 하나만 활성화한다.
// (예전엔 data-path를 path.includes()로만 비교해 "/actions/detail"이 "actions"(조치관리)에도
//  걸려 "보고서" 대신 "조치관리"가 활성화되는 오동작이 있었다.)
(function() {
  const path = window.location.pathname;
  var items = Array.prototype.slice.call(document.querySelectorAll('.nav-item'));
  var best = null;
  items.forEach(function(el) {
    var href = el.getAttribute('href');
    if (!href) return;
    var matches = path === href || path.indexOf(href + '/') === 0 || path.indexOf(href + '?') === 0;
    if (matches && (!best || href.length > best.getAttribute('href').length)) best = el;
  });
  if (best) {
    best.classList.remove('text-slate-500');
    best.classList.add('bg-white/[0.07]', 'text-white');
    best.style.boxShadow = 'inset 2px 0 0 #4A90D9';
    const icon = best.querySelector('svg');
    if (icon) icon.classList.add('text-[#4A90D9]');
  }
})();

// 사이드바 사용자 정보 (모든 인증 페이지 공통 표시)
(function() {
  // 하청 계정은 대시보드 / 신고 게시판만 접근 가능 — 나머지 업무 메뉴는 숨긴다.
  // 사진 업로드(AI 판독용 조치전 사진)는 원청 전용으로 바뀌어 하청에게는 숨긴다.
  // (알림·설정은 역할과 무관한 공통 기능이라 그대로 둔다)
  var SUB_HIDDEN_PATHS = ['upload', 'actions', 'analytics', 'actions-detail'];

  fetch('/api/users/me', { credentials: 'same-origin' })
    .then(function(res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function(user) {
      const nameEl = document.getElementById('sidebarUserName');
      const initialEl = document.getElementById('sidebarUserInitial');
      const roleEl = document.getElementById('sidebarUserRole');
      if (nameEl) nameEl.textContent = user.username || '-';
      if (initialEl) initialEl.textContent = user.username ? user.username.charAt(0) : '?';
      if (roleEl) roleEl.textContent = user.companyName || '';

      // 역할별 아바타 색상: 하청=주황, 원청=파랑 (사이드바 하단 + 상단 헤더 공통)
      var roleColor = user.role === 'SUBCONTRACTOR' ? '#FF7A00' : '#086CF0';
      if (initialEl && initialEl.parentElement) {
        initialEl.parentElement.style.backgroundColor = roleColor;
        initialEl.parentElement.style.borderColor = 'transparent';
        initialEl.style.color = '#fff';
      }
      var headerInitial = document.getElementById('headerUserInitial');
      if (headerInitial) {
        // 페이지에 따라 id가 아바타 원 자체(div)에 있기도, 안쪽 span에 있기도 하다.
        var headerAvatar = /rounded-full/.test(headerInitial.className) ? headerInitial : headerInitial.parentElement;
        if (headerAvatar) headerAvatar.style.backgroundColor = roleColor;
      }

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

// 헤더 종 아이콘 배지: 알림 페이지를 마지막으로 방문한 이후 새로 도착한 알림 개수를
// 빨간 배지로 표시한다. 0이면 숨긴다. 알림 페이지를 열면 서버가 방문 시각을 갱신하므로
// (개별 알림의 읽음 상태는 그대로) 다음 로드부터 배지가 사라진다.
(function() {
  var bells = document.querySelectorAll('a[href="/notifications"] span.bg-red-500');
  if (!bells.length) return;
  fetch('/notifications/unseen-count', { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
    .then(function(res) { return res.ok ? res.json() : null; })
    .then(function(data) {
      if (!data) return;
      var n = Number(data.count) || 0;
      bells.forEach(function(el) {
        if (n > 0) {
          el.textContent = n > 99 ? '99+' : String(n);
          // 동적으로 주입되는 배지라 Tailwind 클래스 대신 인라인 스타일로 고정한다.
          el.style.cssText = 'position:absolute;top:-4px;right:-4px;min-width:16px;height:16px;'
            + 'padding:0 4px;display:flex;align-items:center;justify-content:center;'
            + 'background:#ef4444;color:#fff;font-size:10px;font-weight:700;line-height:1;border-radius:9999px;';
        } else {
          el.style.display = 'none';
        }
      });
    })
    .catch(function() {});
})();
</script>
