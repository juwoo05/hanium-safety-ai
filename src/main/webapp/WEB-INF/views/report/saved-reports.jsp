<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>완료된 보고서 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* 이 페이지 전용 스타일. 다른 화면과 클래스명이 겹치지 않도록 srp- 접두사를 사용한다. */
    .srp-badge { display:inline-flex; align-items:center; gap:4px; padding:3px 10px; border-radius:9999px; font-size:11px; font-weight:600; white-space:nowrap; }
    .srp-filter-tab { padding:8px 16px; border-radius:8px; font-size:13px; font-weight:600; border:1px solid #E5E7EB; color:#6B7280; background:#fff; cursor:pointer; transition:all .15s; white-space:nowrap; }
    .srp-filter-tab:hover { background:#F9FAFB; }
    .srp-filter-tab.srp-active { border-color:#2563EB; color:#2563EB; background:#EFF6FF; }
    .srp-danger-btn { padding:6px 10px; border:1px solid #FECACA; border-radius:8px; font-size:12px; font-weight:600; color:#DC2626; background:#fff; }
    .srp-danger-btn:hover { background:#FEF2F2; }
    .srp-table-wrap { overflow-x:auto; }
    .srp-row:hover { background:#F5F8FF; }
    @media (max-width: 720px) {
      .srp-table-wrap table { min-width: 720px; }
    }
  </style>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3 flex-1 max-w-md">
      <svg class="w-5 h-5 text-gray-400 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      <input type="text" placeholder="검색..." class="flex-1 outline-none text-sm bg-transparent"/>
    </div>
    <div class="flex items-center gap-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <div class="flex items-center gap-2">
        <div id="headerUserInitial" class="w-8 h-8 rounded-full bg-[#1A2E44] flex items-center justify-center text-white text-xs font-bold">-</div>
        <span id="headerUserName" class="text-sm font-medium text-gray-800">-</span>
      </div>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px">
    <div class="mx-auto" style="max-width:1200px">

      <!-- 상단 정보 -->
      <div class="bg-white rounded-xl p-6 mb-5" style="box-shadow:0 1px 2px rgba(16,24,40,0.04)">
        <div class="flex flex-wrap items-start justify-between gap-4 mb-1">
          <div>
            <h1 class="text-xl font-bold text-gray-900 mb-1">완료된 보고서</h1>
            <p class="text-sm text-gray-500">작성이 완료된 보고서를 확인하고 관리할 수 있습니다. · <span id="srpTotalCount">불러오는 중...</span></p>
          </div>
          <div class="flex items-center gap-2">
            <div class="relative">
              <svg class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
              <input id="srpSearchInput" type="text" placeholder="현장명 검색" class="pl-9 pr-3 py-2 border border-gray-200 rounded-lg text-sm w-52 outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-blue-400"/>
            </div>
            <select id="srpSortSelect" class="px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-blue-500/30 bg-white">
              <option value="latest">최신순</option>
              <option value="oldest">오래된순</option>
            </select>
          </div>
        </div>
      </div>

      <!-- 필터 탭 -->
      <div id="srpFilterTabs" class="flex items-center gap-2 mb-4 flex-wrap"></div>

      <!-- 테이블 -->
      <div class="bg-white rounded-xl" style="box-shadow:0 1px 2px rgba(16,24,40,0.04)">
        <div class="srp-table-wrap">
          <table class="w-full text-sm">
            <thead>
              <tr class="bg-gray-50 text-xs text-gray-500 border-b border-gray-100">
                <th class="text-left py-3 px-5 font-semibold">보고서 종류</th>
                <th class="text-left py-3 px-5 font-semibold">현장명</th>
                <th class="text-left py-3 px-5 font-semibold">생성 방식</th>
                <th class="text-left py-3 px-5 font-semibold">최종 수정</th>
                <th class="text-left py-3 px-5 font-semibold">관리</th>
              </tr>
            </thead>
            <tbody id="srpTableBody"></tbody>
          </table>
        </div>

        <!-- 빈 상태 -->
        <div id="srpEmptyState" class="hidden flex-col items-center justify-center text-center py-16 px-6">
          <svg class="w-10 h-10 text-gray-300 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
          <p class="text-sm font-bold text-gray-700 mb-1">검색 결과가 없습니다</p>
          <p class="text-xs text-gray-400">다른 현장명이나 보고서 종류를 선택해보세요.</p>
        </div>
      </div>

    </div>
  </main>
</div>

<script>
var reports = [];

var SRP_TYPE_LABELS = {
  INSPECTION_LOG: '안전점검일지',
  RISK_ASSESSMENT: '위험성평가서',
  ACTION_REPORT: '조치결과보고서',
  WORK_PERMIT: '작업허가서',
  SAFETY_EDU_LOG: '안전보건교육일지',
  TBM_LOG: 'TBM 일지',
  PPE_ISSUE_LOG: '보호구 지급대장',
  SAFETY_EXPENSE_LOG: '산업안전보건관리비 사용내역서'
};

var SRP_TYPE_ORDER = [
  'INSPECTION_LOG',
  'RISK_ASSESSMENT',
  'ACTION_REPORT',
  'WORK_PERMIT',
  'SAFETY_EDU_LOG',
  'TBM_LOG',
  'PPE_ISSUE_LOG',
  'SAFETY_EXPENSE_LOG'
];

function srpFormatDate(value) {
  if (!value) return '-';
  var date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  var pad = function (n) { return String(n).padStart(2, '0'); };
  return date.getFullYear() + '.' + pad(date.getMonth() + 1) + '.' + pad(date.getDate())
    + ' ' + pad(date.getHours()) + ':' + pad(date.getMinutes());
}

function srpFromDocument(doc) {
  return {
    id: doc.id,
    docType: doc.docType,
    type: SRP_TYPE_LABELS[doc.docType] || doc.docType,
    siteName: doc.location || (doc.formData && doc.formData.siteName) || '',
    generationType: doc.aiGenerated ? 'AI 자동 작성' : '직접 작성',
    updatedAt: srpFormatDate(doc.updatedAt)
  };
}

var srpState = { filter: 'ALL', keyword: '', sort: 'latest' };

function srpEsc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

function srpParseDate(updatedAt) {
  // "2026.08.31 17:43" -> Date
  return new Date(updatedAt.replace(/\./g, '/'));
}

var SRP_TYPE_BADGE = {
  '조치결과보고서': 'background:#EFF6FF;color:#1D4ED8',
  '안전점검일지': 'background:#F0FDF4;color:#15803D'
};

function srpFilterTabsHtml() {
  var total = reports.length;
  var counts = {};
  reports.forEach(function (r) { counts[r.docType] = (counts[r.docType] || 0) + 1; });
  var tabs = [{ key: 'ALL', label: '전체', count: total }].concat(
    SRP_TYPE_ORDER.map(function (t) { return { key: t, label: SRP_TYPE_LABELS[t] || t, count: counts[t] || 0 }; })
  );
  return tabs.map(function (tab) {
    var active = srpState.filter === tab.key ? ' srp-active' : '';
    return '<button type="button" class="srp-filter-tab' + active + '" data-filter="' + srpEsc(tab.key) + '">' +
      srpEsc(tab.label) + ' <span style="opacity:.7">' + tab.count + '</span></button>';
  }).join('');
}

function srpRowHtml(r) {
  var typeStyle = SRP_TYPE_BADGE[r.type] || 'background:#F3F4F6;color:#374151';
  var siteHtml = r.siteName
    ? srpEsc(r.siteName)
    : '<span class="inline-flex items-center gap-1 text-orange-600"><svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>현장 정보 없음</span>';

  return '<tr class="srp-row border-b border-gray-50 transition-colors cursor-pointer" data-id="' + r.id + '">' +
    '<td class="py-3 px-5"><span class="srp-badge" style="' + typeStyle + '">' + srpEsc(r.type) + '</span></td>' +
    '<td class="py-3 px-5 font-medium text-gray-800">' + siteHtml + '</td>' +
    '<td class="py-3 px-5"><span class="srp-badge" style="background:#EFF6FF;color:#2563EB"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>' + srpEsc(r.generationType) + '</span></td>' +
    '<td class="py-3 px-5 text-gray-500">' + srpEsc(r.updatedAt) + '</td>' +
    '<td class="py-3 px-5"><div class="flex items-center gap-2">' +
    '<button type="button" class="srp-view-btn px-3 py-1.5 border border-gray-200 rounded-lg text-xs font-semibold text-gray-700 hover:bg-gray-50" data-id="' + r.id + '">보기</button>' +
    '<button type="button" class="srp-delete-btn srp-danger-btn" data-id="' + r.id + '">삭제</button>' +
    '</div></td></tr>';
}

function srpApplyFilters() {
  var keyword = srpState.keyword.trim().toLowerCase();
  var filtered = reports.filter(function (r) {
    var matchesType = srpState.filter === 'ALL' || r.docType === srpState.filter;
    var matchesKeyword = !keyword || (r.siteName || '').toLowerCase().indexOf(keyword) !== -1;
    return matchesType && matchesKeyword;
  });
  filtered.sort(function (a, b) {
    var diff = srpParseDate(a.updatedAt) - srpParseDate(b.updatedAt);
    return srpState.sort === 'latest' ? -diff : diff;
  });
  return filtered;
}

function srpRender() {
  qs('#srpFilterTabs').innerHTML = srpFilterTabsHtml();
  qsa('.srp-filter-tab').forEach(function (btn) {
    btn.addEventListener('click', function () {
      srpState.filter = btn.dataset.filter;
      srpRender();
    });
  });

  var list = srpApplyFilters();
  qs('#srpTotalCount').textContent = '총 ' + reports.length + '건' + (list.length !== reports.length ? ' · 검색결과 ' + list.length + '건' : '');

  var tbody = qs('#srpTableBody');
  var tableWrap = document.querySelector('.srp-table-wrap');
  var emptyState = qs('#srpEmptyState');

  if (list.length === 0) {
    tbody.innerHTML = '';
    tableWrap.classList.add('hidden');
    emptyState.classList.remove('hidden');
    emptyState.classList.add('flex');
  } else {
    tableWrap.classList.remove('hidden');
    emptyState.classList.add('hidden');
    emptyState.classList.remove('flex');
    tbody.innerHTML = list.map(srpRowHtml).join('');
    qsa('.srp-view-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); srpGoToDetail(Number(btn.dataset.id)); });
    });
    qsa('.srp-delete-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) { e.stopPropagation(); srpDeleteReport(Number(btn.dataset.id)); });
    });
    qsa('.srp-row').forEach(function (row) {
      row.addEventListener('click', function () { srpGoToDetail(Number(row.dataset.id)); });
    });
  }
}

function srpGoToDetail(id) {
  window.location.href = '/reports/detail?id=' + id;
}

function srpDeleteReport(id) {
  var report = reports.find(function (r) { return r.id === id; });
  var title = report ? report.type + ' · ' + (report.siteName || '현장 정보 없음') : '선택한 보고서';
  if (!confirm(title + '을(를) 삭제하시겠습니까?')) return;

  fetch('/api/documents/' + encodeURIComponent(id), {
    method: 'DELETE',
    credentials: 'same-origin'
  })
    .then(function (res) {
      if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
      if (!res.ok) throw new Error('보고서 삭제에 실패했습니다.');
      reports = reports.filter(function (r) { return r.id !== id; });
      srpRender();
    })
    .catch(function (err) {
      if (err.message !== '로그인이 필요합니다.') alert(err.message);
    });
}

function qs(sel) { return document.querySelector(sel); }
function qsa(sel) { return Array.prototype.slice.call(document.querySelectorAll(sel)); }

qs('#srpSearchInput').addEventListener('input', function (e) {
  srpState.keyword = e.target.value;
  srpRender();
});
qs('#srpSortSelect').addEventListener('change', function (e) {
  srpState.sort = e.target.value;
  srpRender();
});
fetch('/api/documents/mine', { credentials: 'same-origin' })
  .then(function (res) {
    if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
    if (!res.ok) throw new Error('저장된 보고서를 불러오지 못했습니다.');
    return res.json();
  })
  .then(function (documents) {
    reports = documents.map(srpFromDocument);
    srpRender();
  })
  .catch(function (err) {
    if (err.message === '로그인이 필요합니다.') return;
    srpRender();
    qs('#srpTotalCount').textContent = '불러오기 실패';
    qs('#srpEmptyState p').textContent = err.message;
  });

/* 헤더 사용자 정보 표시 (공통 헤더와 동일한 방식) */
fetch('/api/users/me')
  .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
  .then(function (user) {
    qs('#headerUserName').textContent = user.username || '-';
    var initialEl = qs('#headerUserInitial');
    initialEl.textContent = user.username ? user.username.charAt(0) : '?';
  })
  .catch(function () {});
</script>
</body>
</html>
