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
    <div class="space-y-6">
      <div class="flex items-center justify-between">
        <div><h1 class="text-2xl font-bold text-gray-900">조치 관리</h1><p class="text-gray-600 text-sm mt-1">현장 위험 조치 현황을 관리합니다</p></div>
        <a href="/actions/new" class="flex items-center gap-2 px-4 py-2 bg-[#FF6B35] text-white rounded-lg hover:bg-[#E55A2A] transition-colors font-medium">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          새 조치 등록
        </a>
      </div>

      <!-- Filter Bar -->
      <div class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 flex flex-wrap gap-3 items-center">
        <select id="filterStatus" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option value="">전체 상태</option><option value="REQUESTED">조치 전</option><option value="IN_PROGRESS">조치 중</option><option value="COMPLETED">완료</option>
        </select>
        <select id="filterRisk" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option value="">전체 위험도</option><option value="HIGH">고위험</option><option value="MEDIUM">중위험</option><option value="SAFE">안전</option>
        </select>
        <select id="filterSite" onchange="applyFilters()" class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option value="">전체 현장</option>
        </select>
        <div class="flex-1 relative min-w-48">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
          <input id="filterKeyword" type="text" placeholder="조치명 검색..." oninput="debouncedFilter()" class="w-full pl-9 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
        </div>
      </div>

      <!-- Stats -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 text-center"><p id="statTotal" class="text-2xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">전체 조치</p></div>
        <div class="bg-red-50 rounded-xl p-4 shadow-sm border border-red-100 text-center"><p id="statRequested" class="text-2xl font-bold text-red-600">-</p><p class="text-xs text-red-500 mt-1">조치 전</p></div>
        <div class="bg-orange-50 rounded-xl p-4 shadow-sm border border-orange-100 text-center"><p id="statInProgress" class="text-2xl font-bold text-orange-600">-</p><p class="text-xs text-orange-500 mt-1">진행 중</p></div>
        <div class="bg-green-50 rounded-xl p-4 shadow-sm border border-green-100 text-center"><p id="statCompleted" class="text-2xl font-bold text-green-600">-</p><p class="text-xs text-green-500 mt-1">완료</p></div>
      </div>

      <!-- Action List -->
      <div class="bg-white rounded-2xl shadow-md overflow-hidden">
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
        <div class="px-4 py-3 border-t border-gray-100 text-sm text-gray-500">
          <span id="totalCount">총 0건</span>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };
  var RISK_CLASS = { HIGH: 'bg-red-100 text-red-700', MEDIUM: 'bg-orange-100 text-orange-700', SAFE: 'bg-green-100 text-green-700' };
  var STATUS_LABEL = { REQUESTED: '조치 전', IN_PROGRESS: '조치 중', COMPLETED: '완료' };
  var STATUS_CLASS = { REQUESTED: 'bg-red-100 text-red-700', IN_PROGRESS: 'bg-orange-100 text-orange-700', COMPLETED: 'bg-green-100 text-green-700' };

  function qs(sel) { return document.querySelector(sel); }

  function loadCurrentUser() {
    fetch('/api/users/me')
      .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
      .then(function (user) {
        qs('#headerUserName').textContent = user.username;
        qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
      })
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

  function formatDueDate(dueDate, status) {
    if (!dueDate) return '-';
    var today = new Date().toISOString().slice(0, 10);
    var isOverdue = status !== 'COMPLETED' && dueDate < today;
    var label = dueDate === today ? '오늘' : dueDate;
    return '<span class="' + (isOverdue || dueDate === today ? 'text-red-600 font-medium' : 'text-gray-700') + '">' + label + '</span>';
  }

  function rowHtml(a) {
    var detailLink = a.inspectionId
      ? '<a href="/actions/detail?inspectionId=' + a.inspectionId + '" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a>'
      : '<span class="text-xs text-gray-300">-</span>';
    return '<tr class="hover:bg-gray-50 transition-colors">' +
      '<td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">' + a.title + '</p><p class="text-xs text-gray-500">' + (a.location || '현장 미지정') + '</p></td>' +
      '<td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full font-medium ' + RISK_CLASS[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span></td>' +
      '<td class="px-4 py-4 text-sm text-gray-700">' + (a.location || '-') + '</td>' +
      '<td class="px-4 py-4 text-sm text-gray-700">' + (a.reporterName || '-') + '</td>' +
      '<td class="px-4 py-4 text-sm">' + formatDueDate(a.dueDate, a.status) + '</td>' +
      '<td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full ' + STATUS_CLASS[a.status] + '">' + STATUS_LABEL[a.status] + '</span></td>' +
      '<td class="px-4 py-4">' + detailLink + '</td></tr>';
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
        qs('#actionTableBody').innerHTML = actions.length
          ? actions.map(rowHtml).join('')
          : '<tr><td colspan="7" class="px-4 py-8 text-center text-sm text-gray-400">조건에 맞는 조치가 없습니다.</td></tr>';
        qs('#totalCount').textContent = '총 ' + actions.length + '건';
        qs('#statTotal').textContent = actions.length;
        qs('#statRequested').textContent = actions.filter(function (a) { return a.status === 'REQUESTED'; }).length;
        qs('#statInProgress').textContent = actions.filter(function (a) { return a.status === 'IN_PROGRESS'; }).length;
        qs('#statCompleted').textContent = actions.filter(function (a) { return a.status === 'COMPLETED'; }).length;
      })
      .catch(function (err) {
        qs('#actionTableBody').innerHTML = '<tr><td colspan="7" class="px-4 py-8 text-center text-sm text-red-400">' + err.message + '</td></tr>';
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
  loadActions();
})();
</script>
</body>
</html>