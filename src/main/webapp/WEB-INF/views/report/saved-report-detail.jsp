<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>완료된 보고서 상세 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @media print {
      #sidebar, header, .no-print { display: none !important; }
      #mainContent { margin-left: 0 !important; }
    }
  </style>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between no-print">
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
    <div class="mx-auto" style="max-width:900px">

      <div class="flex items-center justify-between mb-4 no-print">
        <a href="/reports" class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>목록으로</a>
        <div class="flex items-center gap-2">
          <button id="srdDeleteBtn" type="button" class="px-4 py-2 border border-red-200 text-red-600 rounded-lg text-sm hover:bg-red-50 bg-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v5"/><path d="M14 11v5"/></svg>삭제
          </button>
          <button onclick="window.print()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 bg-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>PDF
          </button>
        </div>
      </div>

      <div id="srdNotFound" class="hidden bg-white rounded-2xl p-10 text-center border border-gray-100">
        <p class="text-sm font-bold text-gray-700 mb-1">보고서를 찾을 수 없습니다</p>
        <p class="text-xs text-gray-400 mb-4">삭제되었거나 잘못된 경로로 접근했을 수 있습니다.</p>
        <a href="/reports" class="text-sm text-blue-600 font-semibold hover:underline">목록으로 돌아가기</a>
      </div>

      <div id="srdContent" class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8"></div>

    </div>
  </main>
</div>

<script>
function srdEsc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
function qs(sel) { return document.querySelector(sel); }

var SRD_TYPE_BADGE = {
  '조치결과보고서': 'background:#EFF6FF;color:#1D4ED8',
  '안전점검일지': 'background:#F0FDF4;color:#15803D'
};

var DRAFT_FIELD_LABELS = {
  subType: '기록 구분',
  summary: '주요 내용',
  note: '비고',
  assessmentPurpose: '평가 목적',
  completedAction: '완료된 조치 사항',
  preventionPlan: '재발 방지 대책',
  overallResult: '종합 점검 결과',
  inspectionType: '점검 구분',
  weather: '날씨',
  workerCount: '작업 인원',
  workType: '작업 종류',
  workScope: '작업 범위',
  safetyPrecaution: '안전 주의사항'
};

var SRD_TYPE_LABELS = {
  INSPECTION_LOG: '안전점검일지',
  RISK_ASSESSMENT: '위험성평가서',
  ACTION_REPORT: '조치결과보고서',
  WORK_PERMIT: '작업허가서',
  SAFETY_EDU_LOG: '안전보건교육일지',
  TBM_LOG: 'TBM 일지',
  PPE_ISSUE_LOG: '보호구 지급대장',
  SAFETY_EXPENSE_LOG: '산업안전보건관리비 사용내역서'
};

function srdFormatDate(value) {
  if (!value) return '-';
  var date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  var pad = function (n) { return String(n).padStart(2, '0'); };
  return date.getFullYear() + '.' + pad(date.getMonth() + 1) + '.' + pad(date.getDate())
    + ' ' + pad(date.getHours()) + ':' + pad(date.getMinutes());
}

function srdFromDocument(doc) {
  return {
    id: doc.id,
    type: SRD_TYPE_LABELS[doc.docType] || doc.docType,
    siteName: doc.location || (doc.formData && doc.formData.siteName) || '',
    generationType: doc.aiGenerated ? 'AI 자동 작성' : '직접 작성',
    updatedAt: srdFormatDate(doc.updatedAt),
    detail: doc.formData || {}
  };
}

function srdShowNotFound(message) {
  qs('#srdNotFound').classList.remove('hidden');
  qs('#srdNotFound p').textContent = message || '보고서를 찾을 수 없습니다';
  qs('#srdContent').classList.add('hidden');
}

var params = new URLSearchParams(window.location.search);
var reportId = Number(params.get('id'));
var currentReport = null;

function srdRender(report) {
  currentReport = report;
  var detail = report.detail || {};
  var typeStyle = SRD_TYPE_BADGE[report.type] || 'background:#F3F4F6;color:#374151';

  var itemsRows = '';
  if (Array.isArray(detail.items) && detail.items.length) {
    itemsRows = '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2 mt-6">항목별 점검 내용</h3>' +
      '<table class="w-full text-sm mb-2"><thead><tr class="bg-gray-50 text-xs text-gray-500"><th class="text-left py-2 px-3">No.</th><th class="text-left py-2 px-3">항목명</th><th class="text-left py-2 px-3">결과</th><th class="text-left py-2 px-3">비고</th></tr></thead><tbody>' +
      detail.items.map(function (item, i) {
        return '<tr class="border-b border-gray-100">' +
          '<td class="py-2 px-3 text-gray-500">' + (i + 1) + '</td>' +
          '<td class="py-2 px-3 font-medium text-gray-800">' + srdEsc(item.name) + '</td>' +
          '<td class="py-2 px-3 text-gray-700">' + srdEsc(item.result) + '</td>' +
          '<td class="py-2 px-3 text-gray-500">' + srdEsc(item.note) + '</td></tr>';
      }).join('') + '</tbody></table>';
  }

  var fieldsHtml = '';
  Object.keys(DRAFT_FIELD_LABELS).forEach(function (key) {
    var value = detail[key];
    if (!value) return;
    fieldsHtml += '<div class="mb-3"><p class="text-xs font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-1">' + DRAFT_FIELD_LABELS[key] + '</p>' +
      '<p class="text-sm text-gray-700 pl-2 whitespace-pre-line">' + srdEsc(value) + '</p></div>';
  });

  qs('#srdContent').innerHTML =
    '<div class="flex items-center justify-between text-xs text-gray-400 mb-4">' +
    '<span>문서번호: SM-' + report.id + '</span>' +
    '<span class="text-[#1A2E44] font-semibold flex items-center gap-1"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>' + srdEsc(report.generationType) + '</span>' +
    '</div>' +
    '<div class="flex items-center gap-2 justify-center mb-1">' +
    '<span class="text-xs font-semibold px-2.5 py-1 rounded-full" style="' + typeStyle + '">' + srdEsc(report.type) + '</span>' +
    '</div>' +
    '<h2 class="text-xl font-bold text-gray-900 text-center mb-1">' + srdEsc(report.siteName || '현장 정보 없음') + ' - ' + srdEsc(report.type) + '</h2>' +
    '<p class="text-xs text-gray-400 text-center mb-6">건설현장 안전관리 플랫폼 연결고리 · ' + srdEsc(report.updatedAt) + '</p>' +
    '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2">현장 기본정보</h3>' +
    '<table class="w-full text-sm mb-2 border border-gray-200 rounded-lg overflow-hidden"><tbody>' +
    '<tr class="border-b border-gray-100"><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600 w-28">현장명</td><td class="py-2 px-3 text-gray-800">' + srdEsc(report.siteName || '현장 정보 없음') + '</td></tr>' +
    '<tr class="border-b border-gray-100"><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600">보고서 종류</td><td class="py-2 px-3 text-gray-800">' + srdEsc(report.type) + '</td></tr>' +
    '<tr><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600">최종 수정</td><td class="py-2 px-3 text-gray-800">' + srdEsc(report.updatedAt) + '</td></tr>' +
    '</tbody></table>' +
    (fieldsHtml ? '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2 mt-6">작성 내용</h3>' + fieldsHtml : '') +
    itemsRows +
    '<div class="grid grid-cols-3 gap-4 mt-8 pt-4 border-t border-gray-100">' +
    ['작성자', '검토자', '승인자'].map(function (r) {
      return '<div class="border border-gray-200 rounded-xl p-4 text-center"><p class="text-xs font-semibold text-gray-700 mb-6">' + r + '</p><p class="text-[10px] text-gray-400 border-t border-gray-200 pt-1">(서명 또는 인)</p></div>';
    }).join('') +
    '</div>';
}

function srdDeleteCurrentReport() {
  if (!currentReport) return;
  var title = currentReport.type + ' · ' + (currentReport.siteName || '현장 정보 없음');
  if (!confirm(title + '을(를) 삭제하시겠습니까?')) return;

  fetch('/api/documents/' + encodeURIComponent(currentReport.id), {
    method: 'DELETE',
    credentials: 'same-origin'
  })
    .then(function (res) {
      if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
      if (!res.ok) throw new Error('보고서 삭제에 실패했습니다.');
      alert('보고서가 삭제되었습니다.');
      window.location.href = '/reports';
    })
    .catch(function (err) {
      if (err.message !== '로그인이 필요합니다.') alert(err.message);
    });
}

qs('#srdDeleteBtn').addEventListener('click', srdDeleteCurrentReport);

if (!reportId) {
  srdShowNotFound('보고서 번호가 없습니다.');
} else {
fetch('/api/documents/' + encodeURIComponent(reportId), { credentials: 'same-origin' })
  .then(function (res) {
    if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
    if (res.status === 404) throw new Error('보고서를 찾을 수 없습니다.');
    if (!res.ok) throw new Error('보고서를 불러오지 못했습니다.');
    return res.json();
  })
  .then(function (document) {
    srdRender(srdFromDocument(document));
  })
  .catch(function (err) {
    if (err.message !== '로그인이 필요합니다.') srdShowNotFound(err.message);
  });
}

fetch('/api/users/me')
  .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
  .then(function (user) {
    qs('#headerUserName').textContent = user.username || '-';
    qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
  })
  .catch(function () {});
</script>
</body>
</html>
