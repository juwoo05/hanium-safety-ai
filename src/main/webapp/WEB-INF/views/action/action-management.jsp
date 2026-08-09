<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>조치 관리 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<%@ include file="../common/_topnav.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div><span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">조치 관리</h1>
          <p id="totalCount" class="text-sm text-gray-500 mt-0.5">총 0건</p>
        </div>
        <a href="/actions/new" class="flex items-center gap-1.5 px-4 py-2 bg-[#FF6B35] text-white rounded-lg hover:bg-[#E55A2A] transition-colors shadow-sm font-semibold text-sm">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          새 조치 등록
        </a>
      </div>

      <!-- KPI Strip -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 flex items-center gap-3">
          <div class="bg-blue-50 w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"><svg class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg></div>
          <div><p class="text-xs text-gray-500">전체 항목</p><p id="kpiTotal" class="text-xl font-bold text-blue-600">-</p></div>
        </div>
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 flex items-center gap-3">
          <div class="bg-red-50 w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"><svg class="w-4 h-4 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          <div><p class="text-xs text-gray-500">기한 초과</p><p id="kpiOverdue" class="text-xl font-bold text-red-600">-</p></div>
        </div>
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 flex items-center gap-3">
          <div class="bg-orange-50 w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"><svg class="w-4 h-4 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          <div><p class="text-xs text-gray-500">고위험 미완료</p><p id="kpiHighRisk" class="text-xl font-bold text-orange-600">-</p></div>
        </div>
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 flex items-center gap-3">
          <div class="bg-green-50 w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"><svg class="w-4 h-4 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg></div>
          <div><p class="text-xs text-gray-500">완료율</p><p id="kpiCompletionRate" class="text-xl font-bold text-green-600">-</p></div>
        </div>
      </div>

      <!-- Toolbar -->
      <div class="bg-white rounded-xl p-3 shadow-sm border border-gray-100">
        <div class="flex flex-col lg:flex-row gap-3">
          <div class="relative flex-1">
            <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input id="filterKeyword" type="text" placeholder="제목, 담당자, 현장명 검색..." oninput="debouncedFilter()" class="w-full pl-9 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
          </div>
          <div class="flex flex-wrap gap-2 items-center">
            <select id="filterStatus" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none bg-white">
              <option value="">전체 상태</option><option value="REQUESTED">조치 전</option><option value="IN_PROGRESS">조치 중</option><option value="PENDING_APPROVAL">승인 대기</option><option value="COMPLETED">완료</option>
            </select>
            <select id="filterRisk" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none bg-white">
              <option value="">전체 위험도</option><option value="HIGH">고위험</option><option value="MEDIUM">중위험</option><option value="SAFE">안전</option>
            </select>
            <select id="filterSite" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none bg-white">
              <option value="">전체 현장</option>
            </select>
            <div class="flex items-center gap-0.5 bg-gray-100 rounded-lg p-1">
              <button type="button" data-mode="kanban" onclick="setViewMode('kanban')" class="view-mode-btn p-1.5 rounded-md transition-all" title="칸반 보기">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="18" rx="1"/><rect x="14" y="3" width="7" height="10" rx="1"/></svg>
              </button>
              <button type="button" data-mode="list" onclick="setViewMode('list')" class="view-mode-btn p-1.5 rounded-md transition-all" title="리스트 보기">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
              </button>
              <button type="button" data-mode="gantt" onclick="setViewMode('gantt')" class="view-mode-btn p-1.5 rounded-md transition-all" title="타임라인 보기">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="14" y2="6"/><line x1="3" y1="18" x2="18" y2="18"/></svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- KANBAN -->
      <div id="view-kanban" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4"></div>

      <!-- LIST -->
      <div id="view-list" class="hidden bg-white rounded-2xl shadow-md overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">조치명</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">위험도</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">현장</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">담당자</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">마감일</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">상태</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500"></th>
              </tr>
            </thead>
            <tbody id="actionTableBody" class="divide-y divide-gray-100">
              <tr><td colspan="7" class="px-4 py-8 text-center text-sm text-gray-400">불러오는 중...</td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- GANTT -->
      <div id="view-gantt" class="hidden bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
          <h3 class="font-semibold text-gray-900">마감일 타임라인</h3>
          <span id="ganttRangeLabel" class="text-xs text-gray-400"></span>
        </div>
        <div class="overflow-x-auto">
          <div id="ganttRuler" class="flex border-b border-gray-100 bg-gray-50" style="min-width:700px"></div>
          <div id="ganttBody" style="min-width:700px"></div>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };
  var RISK_CLASS = { HIGH: 'bg-red-100 text-red-700', MEDIUM: 'bg-orange-100 text-orange-700', SAFE: 'bg-green-100 text-green-700' };
  var RISK_DOT = { HIGH: 'bg-red-500', MEDIUM: 'bg-orange-400', SAFE: 'bg-yellow-400' };
  var STATUS_LABEL = { REQUESTED: '조치 전', IN_PROGRESS: '조치 중', PENDING_APPROVAL: '승인 대기', COMPLETED: '완료' };
  var STATUS_CLASS = { REQUESTED: 'bg-red-100 text-red-700', IN_PROGRESS: 'bg-orange-100 text-orange-700', PENDING_APPROVAL: 'bg-blue-100 text-blue-700', COMPLETED: 'bg-green-100 text-green-700' };
  var STATUS_DOT = { REQUESTED: 'bg-red-500', IN_PROGRESS: 'bg-orange-500', PENDING_APPROVAL: 'bg-blue-500', COMPLETED: 'bg-green-500' };
  var STATUS_COLBG = { REQUESTED: 'bg-red-50/50', IN_PROGRESS: 'bg-orange-50/30', PENDING_APPROVAL: 'bg-blue-50/30', COMPLETED: 'bg-green-50/30' };
  var STATUSES = ['REQUESTED', 'IN_PROGRESS', 'PENDING_APPROVAL', 'COMPLETED'];

  var viewMode = 'kanban';
  var currentActions = [];
  var draggedId = null;
  var dragOverStatus = null;
  var CURRENT_USER_ROLE = null;

  function qs(sel) { return document.querySelector(sel); }
  function todayStr() { return new Date().toISOString().slice(0, 10); }
  function detailLinkFor(a) { return a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id; }

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

  function isOverdue(a) { return a.status !== 'COMPLETED' && a.dueDate && a.dueDate < todayStr(); }

  function renderKpis(actions) {
    var overdue = actions.filter(isOverdue).length;
    var highRisk = actions.filter(function (a) { return a.riskLevel === 'HIGH' && a.status !== 'COMPLETED'; }).length;
    var completed = actions.filter(function (a) { return a.status === 'COMPLETED'; }).length;
    var rate = actions.length === 0 ? 0 : Math.round(completed * 100 / actions.length);
    qs('#kpiTotal').textContent = actions.length;
    qs('#kpiOverdue').textContent = overdue;
    qs('#kpiHighRisk').textContent = highRisk;
    qs('#kpiCompletionRate').textContent = rate + '%';
    qs('#totalCount').textContent = '총 ' + actions.length + '건';
  }

  /* ── Kanban ── */
  function renderKanban(actions) {
    var grouped = { REQUESTED: [], IN_PROGRESS: [], PENDING_APPROVAL: [], COMPLETED: [] };
    actions.forEach(function (a) { if (grouped[a.status]) grouped[a.status].push(a); });

    qs('#view-kanban').innerHTML = STATUSES.map(function (status) {
      var cards = grouped[status];
      var over = dragOverStatus === status ? 'border-[#FF6B35] bg-[#FF6B35]/5' : 'border-transparent ' + STATUS_COLBG[status];
      var cardsHtml = cards.length ? cards.map(function (a) {
        var dueLabel = a.dueDate ? (isOverdue(a) ? '기한 초과' : a.dueDate.slice(5)) : '-';
        var dueClass = isOverdue(a) ? 'text-red-600' : 'text-gray-500';
        var actions2 = '';
        if (status === 'PENDING_APPROVAL' && CURRENT_USER_ROLE === '원청') {
          actions2 = '<button type="button" class="approve-btn text-[11px] px-2 py-1 bg-green-600 text-white rounded-md font-semibold hover:bg-green-700" data-id="' + a.id + '">승인</button>' +
            '<button type="button" class="reject-btn text-[11px] px-2 py-1 border border-red-300 text-red-600 rounded-md font-semibold hover:bg-red-50" data-id="' + a.id + '">반려</button>';
        }
        return '<div class="kanban-card bg-white rounded-xl shadow-sm hover:shadow-md transition-all cursor-grab border-2 border-transparent hover:border-[#FF6B35] p-3" draggable="true" data-id="' + a.id + '">' +
          '<div class="flex items-center gap-1.5 mb-1.5">' +
          '<span class="text-[10px] font-bold px-1.5 py-0.5 rounded ' + RISK_DOT[a.riskLevel] + ' text-white">' + RISK_LABEL[a.riskLevel] + '</span></div>' +
          '<h4 class="font-semibold text-gray-900 text-sm mb-1 line-clamp-1">' + a.title + '</h4>' +
          '<p class="text-xs text-gray-500 mb-2">' + (a.location || '현장 미지정') + '</p>' +
          '<div class="flex items-center justify-between text-xs text-gray-500">' +
          '<span class="flex items-center gap-1">' + (a.reporterName || '미배정') + '</span>' +
          '<span class="font-medium ' + dueClass + '">' + dueLabel + '</span></div>' +
          '<div class="mt-2 pt-2 border-t border-gray-100 flex items-center justify-between gap-1">' +
          '<a href="' + detailLinkFor(a) + '" class="text-[11px] text-[#FF6B35] hover:underline font-medium">상세보기</a>' +
          '<div class="flex items-center gap-1">' + actions2 + '</div></div></div>';
      }).join('') : '<div class="flex flex-col items-center justify-center py-10 text-gray-300"><p class="text-sm">항목 없음</p></div>';

      return '<div class="kanban-col rounded-2xl border-2 transition-all ' + over + ' min-h-[420px] flex flex-col" data-status="' + status + '">' +
        '<div class="flex items-center justify-between px-4 py-3 rounded-t-xl border-b-2 border-gray-200 bg-white">' +
        '<div class="flex items-center gap-2"><div class="w-2.5 h-2.5 rounded-full ' + STATUS_DOT[status] + '"></div>' +
        '<span class="font-semibold text-gray-800 text-sm">' + STATUS_LABEL[status] + '</span></div>' +
        '<span class="text-xs font-bold px-2 py-0.5 rounded-full ' + STATUS_CLASS[status] + '">' + cards.length + '</span></div>' +
        '<div class="p-3 space-y-3 flex-1">' + cardsHtml + '</div></div>';
    }).join('');

    attachDragHandlers();
  }

  function attachDragHandlers() {
    document.querySelectorAll('.kanban-card').forEach(function (card) {
      card.addEventListener('dragstart', function () { draggedId = card.dataset.id; card.classList.add('opacity-50'); });
      card.addEventListener('dragend', function () { card.classList.remove('opacity-50'); draggedId = null; dragOverStatus = null; renderKanban(currentActions); });
    });
    document.querySelectorAll('.approve-btn').forEach(function (btn) {
      btn.addEventListener('click', function () { approveAction(btn.dataset.id); });
    });
    document.querySelectorAll('.reject-btn').forEach(function (btn) {
      btn.addEventListener('click', function () { rejectAction(btn.dataset.id); });
    });
    document.querySelectorAll('.kanban-col').forEach(function (col) {
      col.addEventListener('dragover', function (e) { e.preventDefault(); dragOverStatus = col.dataset.status; });
      col.addEventListener('drop', function (e) {
        e.preventDefault();
        var newStatus = col.dataset.status;
        var action = currentActions.find(function (a) { return String(a.id) === String(draggedId); });
        if (!action || action.status === newStatus) return;
        moveActionTo(action, newStatus);
      });
    });
  }

  function moveActionTo(action, newStatus) {
    if (newStatus === 'COMPLETED') {
      if (action.status !== 'PENDING_APPROVAL') { alert('승인 대기 중인 조치만 완료 처리할 수 있습니다.'); return; }
      approveAction(action.id);
      return;
    }
    if (newStatus === 'PENDING_APPROVAL') {
      if (action.status !== 'IN_PROGRESS') { alert('진행중인 조치만 승인 요청할 수 있습니다.'); return; }
      fetch('/api/actions/' + action.id + '/submit-approval', { method: 'POST' })
        .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
        .then(function () { loadActions(); })
        .catch(function () { alert('승인 요청에 실패했습니다.'); });
      return;
    }
    fetch('/api/actions/' + action.id + '/status', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus })
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

  /* ── List ── */
  function formatDueDate(dueDate, status) {
    if (!dueDate) return '-';
    var today = todayStr();
    var overdue = status !== 'COMPLETED' && dueDate < today;
    var label = dueDate === today ? '오늘' : dueDate;
    return '<span class="' + (overdue || dueDate === today ? 'text-red-600 font-medium' : 'text-gray-700') + '">' + label + '</span>';
  }

  function renderList(actions) {
    qs('#actionTableBody').innerHTML = actions.length ? actions.map(function (a) {
      var detailLink = '<a href="' + detailLinkFor(a) + '" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a>';
      return '<tr class="hover:bg-gray-50 transition-colors">' +
        '<td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">' + a.title + '</p><p class="text-xs text-gray-500">' + (a.location || '현장 미지정') + '</p></td>' +
        '<td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full font-medium ' + RISK_CLASS[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span></td>' +
        '<td class="px-4 py-4 text-sm text-gray-700">' + (a.location || '-') + '</td>' +
        '<td class="px-4 py-4 text-sm text-gray-700">' + (a.reporterName || '-') + '</td>' +
        '<td class="px-4 py-4 text-sm">' + formatDueDate(a.dueDate, a.status) + '</td>' +
        '<td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full ' + STATUS_CLASS[a.status] + '">' + STATUS_LABEL[a.status] + '</span></td>' +
        '<td class="px-4 py-4">' + detailLink + '</td></tr>';
    }).join('') : '<tr><td colspan="7" class="px-4 py-8 text-center text-sm text-gray-400">조건에 맞는 조치가 없습니다.</td></tr>';
  }

  /* ── Gantt ── */
  function renderGantt(actions) {
    var today = new Date();
    var rangeStart = new Date(today); rangeStart.setDate(today.getDate() - 3);
    var days = 14;
    qs('#ganttRangeLabel').textContent = (rangeStart.getMonth() + 1) + '월 ' + rangeStart.getDate() + '일 ~ ';

    var ruler = '<div class="w-48 flex-shrink-0 px-4 py-2 text-xs font-semibold text-gray-500 border-r border-gray-100">조치 항목</div><div class="flex flex-1">';
    for (var i = 0; i < days; i++) {
      var d = new Date(rangeStart); d.setDate(rangeStart.getDate() + i);
      var isToday = d.toDateString() === today.toDateString();
      ruler += '<div class="flex-1 text-center py-2 text-xs font-medium border-r border-gray-100 ' + (isToday ? 'bg-[#FF6B35]/10 text-[#FF6B35] font-bold' : 'text-gray-400') + '">' + (d.getMonth() + 1) + '/' + d.getDate() + '</div>';
    }
    ruler += '</div>';
    qs('#ganttRuler').innerHTML = ruler;

    var withDue = actions.filter(function (a) { return a.dueDate; });
    if (!withDue.length) {
      qs('#ganttBody').innerHTML = '<p class="text-center text-sm text-gray-400 py-12">마감일이 설정된 조치가 없습니다.</p>';
      return;
    }

    qs('#ganttBody').innerHTML = withDue.map(function (a) {
      var due = new Date(a.dueDate + 'T00:00:00');
      var diffDays = Math.round((due - rangeStart) / 86400000);
      var clamped = Math.max(0, Math.min(days - 1, diffDays));
      var left = (clamped / days) * 100;
      var width = Math.max(5, 100 / days);
      var overdue = isOverdue(a);
      var barColor = a.status === 'COMPLETED' ? 'bg-green-500' : overdue ? 'bg-red-500' : RISK_DOT[a.riskLevel];
      return '<a href="' + detailLinkFor(a) + '" class="flex items-center border-b border-gray-50 hover:bg-gray-50 transition-colors group">' +
        '<div class="w-48 flex-shrink-0 px-4 py-3 border-r border-gray-100"><p class="text-xs font-medium text-gray-800 truncate">' + a.title + '</p>' +
        '<p class="text-[10px] text-gray-400 mt-0.5">' + (a.reporterName || '미배정') + '</p></div>' +
        '<div class="flex-1 relative h-10 px-1"><div class="absolute inset-y-0 flex items-center w-full px-1"><div class="w-full h-1 bg-gray-100 rounded-full"></div></div>' +
        '<div class="absolute inset-y-0 flex items-center" style="left:' + left + '%;width:' + width + '%">' +
        '<div class="h-6 rounded-full w-full flex items-center justify-center text-[10px] font-semibold text-white shadow-sm ' + barColor + '">' + a.dueDate.slice(5) + '</div></div></div>' +
        '<div class="w-24 flex-shrink-0 px-3 py-3 text-right"><span class="text-xs px-2 py-0.5 rounded-full font-medium ' + STATUS_CLASS[a.status] + '">' + STATUS_LABEL[a.status] + '</span></div></a>';
    }).join('');
  }

  window.setViewMode = function (mode) {
    viewMode = mode;
    ['kanban', 'list', 'gantt'].forEach(function (m) {
      qs('#view-' + m).classList.toggle('hidden', m !== mode);
    });
    document.querySelectorAll('.view-mode-btn').forEach(function (b) {
      b.className = 'view-mode-btn p-1.5 rounded-md transition-all ' + (b.dataset.mode === mode ? 'bg-white shadow-sm text-[#FF6B35]' : 'text-gray-500 hover:text-gray-700');
    });
    renderCurrentView();
  };

  function renderCurrentView() {
    if (viewMode === 'kanban') renderKanban(currentActions);
    else if (viewMode === 'list') renderList(currentActions);
    else renderGantt(currentActions);
  }

  function loadActions() {
    var params = new URLSearchParams();
    var keyword = qs('#filterKeyword').value.trim();
    var status = qs('#filterStatus').value;
    var risk = qs('#filterRisk').value;
    var site = qs('#filterSite').value;
    if (keyword) params.set('keyword', keyword);
    if (status) params.set('status', status);
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
        renderKpis(actions);
        renderCurrentView();
      })
      .catch(function () {
        qs('#actionTableBody').innerHTML = '<tr><td colspan="7" class="px-4 py-8 text-center text-sm text-red-400">조치 목록을 불러오지 못했습니다.</td></tr>';
      });
  }

  window.applyFilters = loadActions;
  var debounceTimer;
  window.debouncedFilter = function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(loadActions, 300);
  };

  loadCurrentUser();
  loadSiteFilter();
  setViewMode('kanban');
  loadActions();
})();
</script>
</body>
</html>
