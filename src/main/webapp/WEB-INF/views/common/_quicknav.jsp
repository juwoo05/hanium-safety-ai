<%@ page pageEncoding="UTF-8" %>
<%-- 하단 빠른 이동 툴바 (5173 React 목업의 QuickNav와 동일한 역할). 로그인 필요 페이지에서만 표시. --%>

<div id="quickNav" class="fixed bottom-5 left-1/2 z-50 flex flex-col items-center gap-2" style="transform:translateX(-50%)">
  <div id="quickNavPanel" style="background:rgba(15,23,42,0.92);backdrop-filter:blur(12px);border-radius:8px;border:1px solid rgba(255,255,255,0.08);box-shadow:0 8px 32px rgba(0,0,0,0.3);padding:6px 8px">
    <div class="flex items-center" style="gap:2px">
      <a href="/dashboard" class="quicknav-item" data-path="dashboard" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/></svg>
        <span style="font-size:9px;white-space:nowrap">대시보드</span>
      </a>
      <a href="/upload" class="quicknav-item" data-path="upload" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
        <span style="font-size:9px;white-space:nowrap">사진분석</span>
      </a>
      <a href="/actions" class="quicknav-item" data-path="actions" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
        <span style="font-size:9px;white-space:nowrap">조치관리</span>
      </a>
      <a href="/documents" class="quicknav-item" data-path="documents" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        <span style="font-size:9px;white-space:nowrap">안전 서류</span>
      </a>
      <a href="/reports" class="quicknav-item" data-path="reports" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
        <span style="font-size:9px;white-space:nowrap">완료된 보고서</span>
      </a>
      <a href="/msds" class="quicknav-item" data-path="msds" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 3h6M10 3v6l-5 9a2 2 0 0 0 1.8 3h10.4a2 2 0 0 0 1.8-3l-5-9V3"/><line x1="7" y1="16" x2="17" y2="16"/></svg>
        <span style="font-size:9px;white-space:nowrap">MSDS</span>
      </a>
      <a href="/analytics" class="quicknav-item" data-path="analytics" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
        <span style="font-size:9px;white-space:nowrap">리포트</span>
      </a>
      <a href="/notifications" class="quicknav-item" data-path="notifications" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span style="font-size:9px;white-space:nowrap">알림</span>
      </a>
      <a href="/report-board" class="quicknav-item" data-path="report-board" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
        <span style="font-size:9px;white-space:nowrap">신고</span>
      </a>
      <a href="/mypage" class="quicknav-item" data-path="mypage" style="display:flex;align-items:center;gap:5px;padding:5px 8px;border-radius:4px;text-decoration:none">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>
        <span style="font-size:9px;white-space:nowrap">마이페이지</span>
      </a>
    </div>
  </div>

  <button type="button" id="quickNavToggle" style="background:rgba(15,23,42,0.85);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,0.08);border-radius:20px;padding:4px 12px;display:flex;align-items:center;gap:4px;font-size:10px;font-weight:500;cursor:pointer">
    <svg id="quickNavToggleIcon" width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
    <span id="quickNavToggleLabel">숨기기</span>
  </button>
</div>

<style>
/* 사이드바 nav 처럼: 기본은 옅게, 마우스 올리면 글씨/아이콘이 밝고 진하게 */
.quicknav-item { color: #94A3B8; transition: color .12s, background-color .12s; }
.quicknav-item span { order: 1; transition: font-weight .12s; }
.quicknav-item svg { order: 2; transition: stroke-width .12s; }
.quicknav-item.active { background: rgba(74,144,217,0.2); color: #7BBDE8; }
.quicknav-item.active span { font-weight: 600; }
.quicknav-item:hover { background: rgba(255,255,255,0.1); color: #F1F5F9; }
.quicknav-item:hover span { font-weight: 700; }
.quicknav-item:hover svg { stroke-width: 2.2; }

#quickNavToggle { color: #94A3B8; transition: color .12s; }
#quickNavToggle:hover { color: #F1F5F9; }
</style>

<script>
(function () {
  // href가 가장 길게(가장 구체적으로) 일치하는 항목 하나만 활성화한다.
  var path = window.location.pathname;
  var items = Array.prototype.slice.call(document.querySelectorAll('.quicknav-item'));
  var best = null;
  items.forEach(function (el) {
    var href = el.getAttribute('href');
    if (!href) return;
    var matches = path === href || path.indexOf(href + '/') === 0 || path.indexOf(href + '?') === 0;
    if (matches && (!best || href.length > best.getAttribute('href').length)) best = el;
  });
  if (best) best.classList.add('active');

  var panel = document.getElementById('quickNavPanel');
  var toggle = document.getElementById('quickNavToggle');
  var icon = document.getElementById('quickNavToggleIcon');
  var label = document.getElementById('quickNavToggleLabel');
  toggle.addEventListener('click', function () {
    var hidden = panel.style.display === 'none';
    panel.style.display = hidden ? '' : 'none';
    label.textContent = hidden ? '숨기기' : '메뉴';
    icon.innerHTML = hidden
      ? '<polyline points="6 9 12 15 18 9"/>'
      : '<polyline points="18 15 12 9 6 15"/>';
  });
})();
</script>
