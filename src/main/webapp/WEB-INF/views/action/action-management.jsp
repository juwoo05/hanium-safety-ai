<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>조치 관리 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div><span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span></a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1280px">

    <!-- Page header -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <p style="font-size:11px;color:#9CA3AF;letter-spacing:0.06em;text-transform:uppercase;font-weight:500;margin-bottom:5px">조치 관리</p>
        <h1 style="font-size:22px;font-weight:600;color:#0F172A;letter-spacing:-0.02em;line-height:1;margin-bottom:6px">조치관리</h1>
        <p id="summaryLine" style="font-size:12px;color:#6B7280">전체 0건 · 완료율 0%</p>
      </div>
      <div class="flex items-center gap-2">
        <button type="button" id="exportBtn" onclick="exportSelected()" style="display:flex;align-items:center;gap:6px;padding:7px 12px;font-size:12px;font-weight:500;background:white;color:#374151;border:1px solid #E5E7EB;border-radius:4px;cursor:pointer">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          <span id="exportBtnLabel">내보내기</span>
        </button>
        <a href="/upload" style="display:flex;align-items:center;gap:6px;padding:7px 14px;font-size:13px;font-weight:500;background:#1A2E44;color:white;border:none;border-radius:4px;cursor:pointer;text-decoration:none">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          조치 등록
        </a>
      </div>
    </div>

    <!-- Tabs + filters -->
    <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;border-bottom-left-radius:0;border-bottom-right-radius:0;border-bottom:none">
      <div class="flex items-center justify-between flex-wrap gap-2" style="padding:0 20px;border-bottom:1px solid #E5E7EB">
        <div id="statusTabs" class="flex items-center"></div>
        <div class="flex items-center gap-2 py-2">
          <div class="relative flex items-center">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="position:absolute;left:10px"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input id="filterKeyword" type="text" placeholder="항목, 현장, 담당자 검색" oninput="debouncedFilter()"
                   style="padding:6px 10px 6px 32px;font-size:12px;border:1px solid #E5E7EB;border-radius:4px;outline:none;background:#F9FAFB;color:#374151;width:200px"/>
          </div>
          <select id="filterRisk" onchange="applyFilters()" style="padding:6px 10px;font-size:12px;border:1px solid #E5E7EB;border-radius:4px;background:#F9FAFB;color:#374151;outline:none;cursor:pointer">
            <option value="">위험도 전체</option><option value="HIGH">고위험</option><option value="MEDIUM">중위험</option><option value="SAFE">안전</option>
          </select>
          <select id="filterSite" onchange="applyFilters()" style="padding:6px 10px;font-size:12px;border:1px solid #E5E7EB;border-radius:4px;background:#F9FAFB;color:#374151;outline:none;cursor:pointer">
            <option value="">전체 현장</option>
          </select>
          <button type="button" id="resetFiltersBtn" onclick="resetFilters()" class="hidden" style="padding:6px 10px;font-size:12px;color:#991B1B;background:#FEF2F2;border:1px solid #FECACA;border-radius:4px;cursor:pointer">초기화</button>
        </div>
      </div>
    </div>

    <!-- Table -->
    <div style="background:white;border:1px solid #E5E7EB;border-top-left-radius:0;border-top-right-radius:0;border-radius:4px;overflow:hidden">
      <div style="overflow-x:auto">
        <table style="width:100%;border-collapse:collapse;font-size:13px">
          <thead>
            <tr style="background:#F9FAFB;border-bottom:1px solid #F3F4F6">
              <th style="padding:9px 14px;width:36px;text-align:center;white-space:nowrap"><input type="checkbox" id="selectAllCheckbox" style="width:14px;height:14px;cursor:pointer" aria-label="전체 선택"/></th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap"></th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">항목 ID</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">위험유형</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">현장</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">담당자</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">위험등급</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">마감일</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">상태</th>
              <th style="padding:9px 14px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;white-space:nowrap">조치</th>
            </tr>
          </thead>
          <tbody id="actionTableBody">
            <tr><td colspan="10" style="padding:32px;text-align:center;font-size:13px;color:#9CA3AF">불러오는 중...</td></tr>
          </tbody>
        </table>
      </div>
      <div class="flex items-center justify-between" style="padding:10px 20px;border-top:1px solid #F3F4F6">
        <span id="footerCount" style="font-size:12px;color:#9CA3AF"></span>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  // 조치 항목 썸네일: 실제 업로드 사진은 현재 원본 S3 키만 저장돼 접근 가능한 URL이 아니라
  // (presigned URL 발급 인프라 미구현) 항상 깨진 이미지가 뜬다. 붙을 때까지는 목업(5173 React)과
  // 동일한 스톡 이미지를 항목 ID 기준으로 순환시켜 보여준다.
  var MOCK_THUMBS = [
    'https://images.unsplash.com/photo-1626885930974-4b69aa21bbf9?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1777262095520-9805f225fb63?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1621294465978-6b4198a5f2f7?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1625958936686-a9343dc35b5b?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1561715608-5659baeccfb4?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1567954970774-58d6aa6c50dc?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1713593930871-e21d7f9ef4a1?w=80&h=60&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=80&h=60&fit=crop&auto=format'
  ];
  // 실제 현장사진: 안전모 미착용(id 53), 추락 위험 현장(id 54)
  var REAL_SITE_PHOTOS = { 53: '/images/site-photos/safety-helmet-missing.png', 54: '/images/site-photos/fall-risk-site.png' };
  function mockThumbFor(id) { return REAL_SITE_PHOTOS[id] || MOCK_THUMBS[Math.abs(id) % MOCK_THUMBS.length]; }

  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };
  var RISK_COLOR = { HIGH: '#991B1B', MEDIUM: '#B45309', SAFE: '#166534' };
  var RISK_BG    = { HIGH: '#FEF2F2', MEDIUM: '#FFFBEB', SAFE: '#F0FDF4' };

  var STATUSES = ['REQUESTED', 'IN_PROGRESS', 'PENDING_APPROVAL', 'COMPLETED'];
  var STATUS_LABEL = { REQUESTED: '조치 전', IN_PROGRESS: '조치 중', PENDING_APPROVAL: '승인 대기', COMPLETED: '완료' };
  var STATUS_COLOR = { REQUESTED: '#B45309', IN_PROGRESS: '#1D4ED8', PENDING_APPROVAL: '#6D28D9', COMPLETED: '#166534' };
  var STATUS_BG    = { REQUESTED: '#FFFBEB', IN_PROGRESS: '#EFF6FF', PENDING_APPROVAL: '#F5F3FF', COMPLETED: '#F0FDF4' };
  var NEXT_STATUS  = { REQUESTED: 'IN_PROGRESS', IN_PROGRESS: 'PENDING_APPROVAL' };

  var statusTab = 'ALL';
  var currentActions = [];
  var expandedId = null;
  var CURRENT_USER_ROLE = null;
  var selectedIds = new Set(); // 내보내기 대상으로 체크된 조치 항목 id (문자열)

  function qs(sel) { return document.querySelector(sel); }
  function todayStr() { return new Date().toISOString().slice(0, 10); }
  function detailLinkFor(a) { return a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id; }
  function isOverdue(a) { return a.status !== 'COMPLETED' && a.dueDate && a.dueDate < todayStr(); }
  function esc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  function loadCurrentUser() {
    fetch('/api/users/me')
      .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
      .then(function (user) {
        qs('#headerUserName').textContent = user.username;
        qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
      })
      .catch(function () {});

    fetch('/api/users/me/profile')
      .then(function (res) { return res.ok ? res.json() : null; })
      .then(function (profile) { if (profile) CURRENT_USER_ROLE = profile.role; })
      .catch(function () {});
  }

  function loadSiteFilter() {
    fetch('/api/sites')
      .then(function (res) { return res.ok ? res.json() : []; })
      .then(function (sites) {
        var sel = qs('#filterSite');
        sites.forEach(function (s) {
          var opt = document.createElement('option');
          opt.value = s.name; opt.textContent = s.name;
          sel.appendChild(opt);
        });
      })
      .catch(function () {});
  }

  function renderTabs(actions) {
    var counts = { ALL: actions.length };
    STATUSES.forEach(function (s) { counts[s] = actions.filter(function (a) { return a.status === s; }).length; });
    var tabs = [{ key: 'ALL', label: '전체' }].concat(STATUSES.map(function (s) { return { key: s, label: STATUS_LABEL[s] }; }));
    qs('#statusTabs').innerHTML = tabs.map(function (t) {
      var active = statusTab === t.key;
      return '<button type="button" class="status-tab-btn" data-key="' + t.key + '" style="padding:12px 16px;font-size:13px;font-weight:' + (active ? 600 : 400) +
        ';color:' + (active ? '#0F172A' : '#9CA3AF') + ';background:none;border:none;cursor:pointer;border-bottom:2px solid ' + (active ? '#0F172A' : 'transparent') +
        ';display:flex;align-items:center;gap:6px;margin-bottom:-1px">' + t.label +
        '<span style="font-size:11px;padding:1px 6px;border-radius:10px;font-weight:600;background:' + (active ? '#0F172A' : '#F3F4F6') + ';color:' + (active ? 'white' : '#9CA3AF') + '">' + counts[t.key] + '</span></button>';
    }).join('');
    document.querySelectorAll('.status-tab-btn').forEach(function (btn) {
      btn.addEventListener('click', function () { statusTab = btn.dataset.key; renderTabs(currentActions); renderTable(); });
    });
  }

  function renderSummary(actions) {
    var completed = actions.filter(function (a) { return a.status === 'COMPLETED'; }).length;
    var rate = actions.length === 0 ? 0 : Math.round(completed * 100 / actions.length);
    var overdue = actions.filter(isOverdue).length;
    var html = '전체 ' + actions.length + '건 · 완료율 ' + rate + '%';
    if (overdue > 0) html += '<span style="margin-left:8px;color:#991B1B;font-weight:500">기한 초과 ' + overdue + '건</span>';
    qs('#summaryLine').innerHTML = html;
  }

  function rowHtml(a) {
    var overdue = isOverdue(a);
    var isExpanded = expandedId !== null && String(expandedId) === String(a.id);
    var next = NEXT_STATUS[a.status];
    var actionsHtml = '';
    if (next) {
      actionsHtml += '<button type="button" class="advance-btn" data-id="' + a.id + '" data-status="' + a.status + '" style="padding:3px 10px;font-size:11px;font-weight:500;background:#1A2E44;color:white;border:none;border-radius:3px;cursor:pointer;white-space:nowrap">' + STATUS_LABEL[next] + '</button>';
    }
    if (a.status === 'PENDING_APPROVAL' && CURRENT_USER_ROLE === '원청') {
      actionsHtml += '<button type="button" class="approve-btn" data-id="' + a.id + '" style="padding:3px 10px;font-size:11px;font-weight:500;background:#166534;color:white;border:none;border-radius:3px;cursor:pointer;white-space:nowrap;margin-left:4px">승인</button>';
      actionsHtml += '<button type="button" class="reject-btn" data-id="' + a.id + '" style="padding:3px 10px;font-size:11px;font-weight:500;background:white;color:#991B1B;border:1px solid #FECACA;border-radius:3px;cursor:pointer;white-space:nowrap;margin-left:4px">반려</button>';
    }
    actionsHtml += '<button type="button" class="expand-btn" data-id="' + a.id + '" aria-label="상세 보기" style="width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;background:none;border:1px solid #E5E7EB;border-radius:3px;cursor:pointer;margin-left:4px;transform:' + (isExpanded ? 'rotate(180deg)' : 'none') + ';transition:transform .2s;vertical-align:middle">' +
      '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg></button>';
    // 원청 전용: 조치 항목 삭제 (DELETE /api/actions/{id})
    if (CURRENT_USER_ROLE === '원청') {
      actionsHtml += '<button type="button" class="delete-btn" data-id="' + a.id + '" aria-label="삭제" style="width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;background:none;border:1px solid #E5E7EB;border-radius:3px;cursor:pointer;margin-left:4px;vertical-align:middle">' +
        '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg></button>';
    }

    var thumbSrc = (a.thumbnailUrl && /^https?:\/\//.test(a.thumbnailUrl)) ? a.thumbnailUrl : mockThumbFor(a.id);
    var thumbHtml = '<img src="' + thumbSrc + '" alt="' + esc(a.title) + '" style="width:40px;height:30px;border-radius:3px;object-fit:cover;display:block"/>';

    var row = '<tr class="action-row" data-id="' + a.id + '" style="border-bottom:1px solid #F9FAFB;cursor:pointer;background:' + (isExpanded ? '#FAFAFA' : 'transparent') + '">' +
      '<td class="check-cell" style="padding:10px 14px;width:36px;text-align:center"><input type="checkbox" class="row-check" data-id="' + a.id + '"' + (selectedIds.has(String(a.id)) ? ' checked' : '') + ' style="width:14px;height:14px;cursor:pointer"/></td>' +
      '<td style="padding:10px 14px">' + thumbHtml + '</td>' +
      '<td style="padding:10px 14px;color:#9CA3AF;font-family:monospace;font-size:12px">AC-' + a.id + '</td>' +
      '<td style="padding:10px 14px"><span style="font-weight:500;color:#0F172A">' + esc(a.title) + '</span></td>' +
      '<td style="padding:10px 14px;color:#6B7280">' + esc(a.location || '-') + '</td>' +
      '<td style="padding:10px 14px;color:#6B7280">' + esc(a.reporterName || '미배정') + '</td>' +
      '<td style="padding:10px 14px"><span style="display:inline-block;padding:2px 8px;border-radius:3px;font-size:11px;font-weight:600;background:' + RISK_BG[a.riskLevel] + ';color:' + RISK_COLOR[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span></td>' +
      '<td style="padding:10px 14px"><span style="white-space:nowrap;color:' + (overdue ? '#991B1B' : '#6B7280') + ';font-weight:' + (overdue ? 600 : 400) + ';font-size:12px">' + (a.dueDate || '-') +
        (overdue ? '<span style="margin-left:4px;font-size:10px;padding:1px 5px;background:#FEF2F2;color:#991B1B;border-radius:3px">초과</span>' : '') + '</span></td>' +
      '<td style="padding:10px 14px"><span style="display:inline-block;padding:2px 8px;border-radius:3px;font-size:11px;font-weight:500;background:' + STATUS_BG[a.status] + ';color:' + STATUS_COLOR[a.status] + '">' + STATUS_LABEL[a.status] + '</span></td>' +
      '<td style="padding:10px 14px;white-space:nowrap">' + actionsHtml + '</td></tr>';

    if (isExpanded) {
      row += '<tr style="background:#FAFAFA;border-bottom:1px solid #F3F4F6"><td colspan="10" style="padding:12px 14px 14px 14px">' +
        '<div class="grid gap-4" style="display:grid;grid-template-columns:1fr 1fr 1fr;font-size:12px">' +
        '<div><p style="color:#9CA3AF;margin-bottom:4px">공종/분류</p><p style="color:#374151;font-weight:500">' + esc(a.category || '-') + '</p></div>' +
        '<div><p style="color:#9CA3AF;margin-bottom:4px">발견일시</p><p style="color:#374151;font-weight:500">' + (a.discoveredAt ? a.discoveredAt.replace('T', ' ').slice(0, 16) : '-') + '</p></div>' +
        '<div><p style="color:#9CA3AF;margin-bottom:4px">설명</p><p style="color:#374151;font-weight:500">' + esc(a.description || '-') + '</p></div>' +
        '</div>' +
        '<div class="flex items-center gap-2 mt-3">' +
        '<a href="' + detailLinkFor(a) + '" style="padding:5px 12px;font-size:12px;font-weight:500;background:white;color:#374151;border:1px solid #E5E7EB;border-radius:3px;cursor:pointer;text-decoration:none">상세 보기</a>' +
        '</div></td></tr>';
    }
    return row;
  }

  function visibleActions() {
    return statusTab === 'ALL' ? currentActions : currentActions.filter(function (a) { return a.status === statusTab; });
  }

  function renderTable() {
    var filtered = visibleActions();
    qs('#actionTableBody').innerHTML = filtered.length ? filtered.map(rowHtml).join('') :
      '<tr><td colspan="10" style="padding:64px;text-align:center;color:#9CA3AF;font-size:13px">해당 조건의 조치 항목이 없습니다.</td></tr>';
    qs('#footerCount').textContent = filtered.length + '건 표시 / 전체 ' + currentActions.length + '건';
    attachRowHandlers();
    syncSelectionUI();
  }

  // 필터/탭 변경, 재조회 후 더 이상 목록에 없는 선택 항목은 정리한다.
  function pruneSelection() {
    var ids = new Set(currentActions.map(function (a) { return String(a.id); }));
    selectedIds.forEach(function (id) { if (!ids.has(id)) selectedIds.delete(id); });
  }

  function syncSelectionUI() {
    var checks = document.querySelectorAll('.row-check');
    var selectAll = qs('#selectAllCheckbox');
    if (selectAll) {
      var total = checks.length;
      var checked = 0;
      checks.forEach(function (c) { if (c.checked) checked++; });
      selectAll.checked = total > 0 && checked === total;
      selectAll.indeterminate = checked > 0 && checked < total;
    }
    var label = qs('#exportBtnLabel');
    if (label) label.textContent = selectedIds.size > 0 ? '내보내기 (' + selectedIds.size + ')' : '내보내기';
  }

  function attachRowHandlers() {
    document.querySelectorAll('.check-cell').forEach(function (cell) {
      cell.addEventListener('click', function (e) { e.stopPropagation(); });
    });
    document.querySelectorAll('.row-check').forEach(function (chk) {
      chk.addEventListener('click', function (e) { e.stopPropagation(); });
      chk.addEventListener('change', function () {
        var id = String(chk.dataset.id);
        if (chk.checked) selectedIds.add(id); else selectedIds.delete(id);
        syncSelectionUI();
      });
    });
    document.querySelectorAll('.expand-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.stopPropagation();
        expandedId = expandedId === btn.dataset.id ? null : btn.dataset.id;
        renderTable();
      });
    });
    document.querySelectorAll('.advance-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); advance(btn.dataset.id, btn.dataset.status); });
    });
    document.querySelectorAll('.approve-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); approveAction(btn.dataset.id); });
    });
    document.querySelectorAll('.reject-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); rejectAction(btn.dataset.id); });
    });
    document.querySelectorAll('.delete-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); deleteAction(btn.dataset.id); });
    });
    document.querySelectorAll('.action-row').forEach(function (row) {
      row.addEventListener('click', function () {
        var a = currentActions.find(function (x) { return String(x.id) === String(row.dataset.id); });
        if (a) window.location.href = detailLinkFor(a);
      });
    });
  }

  function advance(id, currentStatus) {
    if (currentStatus === 'IN_PROGRESS') {
      fetch('/api/actions/' + id + '/submit-approval', { method: 'POST' })
        .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
        .then(function () { loadActions(); })
        .catch(function () { alert('승인 요청에 실패했습니다.'); });
      return;
    }
    fetch('/api/actions/' + id + '/status', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: 'IN_PROGRESS' })
    })
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function () { loadActions(); })
      .catch(function () { alert('상태 변경에 실패했습니다.'); });
  }

  function approveAction(id) {
    fetch('/api/actions/' + id + '/approve', { method: 'POST' })
      .then(function (res) {
        if (res.status === 403) { alert('원청만 승인할 수 있습니다.'); throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(function () { loadActions(); })
      .catch(function () {});
  }

  function rejectAction(id) {
    if (!confirm('이 조치를 반려하고 진행중으로 되돌릴까요?')) return;
    fetch('/api/actions/' + id + '/reject', { method: 'POST' })
      .then(function (res) {
        if (res.status === 403) { alert('원청만 반려할 수 있습니다.'); throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(function () { loadActions(); })
      .catch(function () {});
  }

  function deleteAction(id) {
    var a = currentActions.find(function (x) { return String(x.id) === String(id); });
    if (!confirm('"' + (a ? a.title : '이 조치') + '" 항목을 삭제하시겠습니까? 삭제하면 복구할 수 없습니다.')) return;
    fetch('/api/actions/' + id, { method: 'DELETE' })
      .then(function (res) {
        if (res.status === 403) { alert('원청만 삭제할 수 있습니다.'); throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(function () { selectedIds.delete(String(id)); loadActions(); })
      .catch(function () { alert('삭제에 실패했습니다.'); });
  }

  function updateResetBtn() {
    var show = qs('#filterKeyword').value.trim() || qs('#filterRisk').value || qs('#filterSite').value;
    qs('#resetFiltersBtn').classList.toggle('hidden', !show);
  }

  window.resetFilters = function () {
    qs('#filterKeyword').value = '';
    qs('#filterRisk').value = '';
    qs('#filterSite').value = '';
    loadActions();
  };

  function loadActions() {
    var params = new URLSearchParams();
    var keyword = qs('#filterKeyword').value.trim();
    var risk = qs('#filterRisk').value;
    var site = qs('#filterSite').value;
    updateResetBtn();
    if (keyword) params.set('keyword', keyword);
    if (risk) params.set('riskLevel', risk);
    if (site) params.set('siteName', site);

    fetch('/api/actions/search?' + params.toString())
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
        if (!res.ok) throw new Error('조치 목록 조회 실패');
        return res.json();
      })
      .then(function (actions) {
        currentActions = actions;
        pruneSelection();
        renderSummary(actions);
        renderTabs(actions);
        renderTable();
      })
      .catch(function () {
        qs('#actionTableBody').innerHTML = '<tr><td colspan="10" style="padding:32px;text-align:center;font-size:13px;color:#991B1B">조치 목록을 불러오지 못했습니다.</td></tr>';
      });
  }

  // 전체 선택 체크박스: 현재 화면에 보이는(필터/탭 적용된) 항목을 일괄 선택/해제한다.
  function bindSelectAll() {
    var selectAll = qs('#selectAllCheckbox');
    if (!selectAll) return;
    selectAll.addEventListener('change', function () {
      var on = selectAll.checked;
      visibleActions().forEach(function (a) {
        if (on) selectedIds.add(String(a.id)); else selectedIds.delete(String(a.id));
      });
      document.querySelectorAll('.row-check').forEach(function (c) { c.checked = on; });
      syncSelectionUI();
    });
  }

  var CSV_COLUMNS = [
    { key: '항목ID',   get: function (a) { return 'AC-' + a.id; } },
    { key: '위험유형', get: function (a) { return a.title || ''; } },
    { key: '현장',     get: function (a) { return a.location || ''; } },
    { key: '담당자',   get: function (a) { return a.reporterName || '미배정'; } },
    { key: '위험등급', get: function (a) { return RISK_LABEL[a.riskLevel] || a.riskLevel || ''; } },
    { key: '마감일',   get: function (a) { return a.dueDate || ''; } },
    { key: '상태',     get: function (a) { return STATUS_LABEL[a.status] || a.status || ''; } },
    { key: '분류',     get: function (a) { return a.category || ''; } },
    { key: '발견일시', get: function (a) { return a.discoveredAt ? a.discoveredAt.replace('T', ' ').slice(0, 16) : ''; } }
  ];

  function csvCell(v) {
    var s = (v == null ? '' : String(v));
    return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
  }

  window.exportSelected = function () {
    var rows = selectedIds.size > 0
      ? currentActions.filter(function (a) { return selectedIds.has(String(a.id)); })
      : visibleActions();
    if (!rows.length) {
      alert('내보낼 조치 항목이 없습니다.');
      return;
    }
    var lines = [CSV_COLUMNS.map(function (c) { return csvCell(c.key); }).join(',')];
    rows.forEach(function (a) {
      lines.push(CSV_COLUMNS.map(function (c) { return csvCell(c.get(a)); }).join(','));
    });
    // Excel에서 한글이 깨지지 않도록 UTF-8 BOM 추가
    var blob = new Blob(['﻿' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8;' });
    var url = URL.createObjectURL(blob);
    var link = document.createElement('a');
    link.href = url;
    link.download = '조치관리_' + todayStr() + '.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  window.applyFilters = loadActions;
  var debounceTimer;
  window.debouncedFilter = function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(loadActions, 300);
  };

  bindSelectAll();
  loadCurrentUser();
  loadSiteFilter();
  loadActions();
})();
</script>
</body>
</html>
