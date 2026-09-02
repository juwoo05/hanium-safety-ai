<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>안전 서류 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3 flex-1 max-w-md">
      <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      <input id="documentSearch" type="text" placeholder="서류 검색..." class="flex-1 outline-none text-sm bg-transparent"/>
    </div>
    <a href="/reports" class="text-sm font-semibold text-[#1A2E44] hover:underline">완료된 보고서 보기</a>
  </header>

  <main class="flex-1" style="padding:28px 32px 64px;max-width:1280px">
    <div class="flex items-start justify-between gap-6 mb-7">
      <div>
        <p class="text-xs font-semibold text-gray-400 mb-2">현장 문서 관리</p>
        <h1 class="text-[22px] font-semibold text-slate-900 leading-none mb-2">안전 서류</h1>
        <p class="text-sm text-slate-500">조치와 무관한 현장 운영·승인·증빙 서류를 작성합니다.</p>
      </div>
      <label class="block min-w-[280px]">
        <span class="block text-xs font-semibold text-slate-500 mb-1.5">작성 현장</span>
        <select id="siteSelect" class="w-full h-10 px-3 bg-white border border-slate-200 rounded text-sm text-slate-700 outline-none focus:border-[#4A90D9]">
          <option value="">현장을 불러오는 중...</option>
        </select>
      </label>
    </div>

    <section class="mb-8" data-document-section>
      <div class="flex items-center justify-between mb-3">
        <div><h2 class="text-sm font-bold text-slate-800">현장 운영 기록</h2><p class="text-xs text-slate-400 mt-1">작업 전 회의, 교육 및 지급 내역</p></div>
        <span class="text-xs text-slate-400">3개 서류</span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
        <button data-doc-type="TBM_LOG" data-doc-name="TBM 일지" class="document-item text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
          <div class="w-9 h-9 rounded bg-blue-50 text-blue-700 flex items-center justify-center mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/></svg></div>
          <p class="font-semibold text-slate-900">TBM 일지</p><p class="text-xs text-slate-500 mt-1">작업 전 안전 회의와 참석자 기록</p>
        </button>
        <button data-doc-type="SAFETY_EDU_LOG" data-doc-name="안전보건교육일지" class="document-item text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
          <div class="w-9 h-9 rounded bg-emerald-50 text-emerald-700 flex items-center justify-center mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg></div>
          <p class="font-semibold text-slate-900">안전보건교육일지</p><p class="text-xs text-slate-500 mt-1">교육 내용과 참석자 서명부</p>
        </button>
        <button data-doc-type="PPE_ISSUE_LOG" data-doc-name="보호구 지급대장" class="document-item text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
          <div class="w-9 h-9 rounded bg-amber-50 text-amber-700 flex items-center justify-center mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
          <p class="font-semibold text-slate-900">보호구 지급대장</p><p class="text-xs text-slate-500 mt-1">보호구 품목·수량·수령자 기록</p>
        </button>
      </div>
    </section>

    <section class="mb-8" data-document-section>
      <div class="flex items-center justify-between mb-3">
        <div><h2 class="text-sm font-bold text-slate-800">승인·증빙 서류</h2><p class="text-xs text-slate-400 mt-1">위험작업 승인과 안전관리비 집행 증빙</p></div>
        <span class="text-xs text-slate-400">2개 서류</span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
        <button data-doc-type="WORK_PERMIT" data-doc-name="작업허가서" class="document-item text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
          <div class="w-9 h-9 rounded bg-violet-50 text-violet-700 flex items-center justify-center mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <p class="font-semibold text-slate-900">작업허가서</p><p class="text-xs text-slate-500 mt-1">위험작업의 사전 승인 조건 확인</p>
        </button>
        <button data-doc-type="SAFETY_EXPENSE_LOG" data-doc-name="관리비 사용내역서" class="document-item text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
          <div class="w-9 h-9 rounded bg-rose-50 text-rose-700 flex items-center justify-center mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg></div>
          <p class="font-semibold text-slate-900">관리비 사용내역서</p><p class="text-xs text-slate-500 mt-1">안전용품·시설물 집행과 증빙 관리</p>
        </button>
      </div>
    </section>

    <section class="border-t border-slate-200 pt-6">
      <div class="flex items-center justify-between mb-3"><h2 class="text-sm font-bold text-slate-800">조치 연계 보고서</h2><span class="text-xs text-slate-400">조치관리에서 작성</span></div>
      <div class="flex items-center justify-between gap-4 bg-slate-50 border border-slate-200 rounded px-5 py-4">
        <div><p class="text-sm font-semibold text-slate-800">조치결과보고서 · 위험성평가서 · 안전점검일지</p><p class="text-xs text-slate-500 mt-1">완료 조치와 위험요소 데이터를 사용하므로 조치관리에서 해당 항목을 선택해 작성합니다.</p></div>
        <a href="/actions" class="flex-shrink-0 px-4 py-2 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#254d7a]">조치관리로 이동</a>
      </div>
    </section>
  </main>
</div>

<script>
(function () {
  var siteSelect = document.getElementById('siteSelect');

  function showSiteMessage(message) {
    siteSelect.replaceChildren();
    var option = document.createElement('option');
    option.value = '';
    option.textContent = message;
    siteSelect.appendChild(option);
  }

  fetch('/api/sites', { credentials: 'same-origin' })
    .then(function (res) {
      if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
      if (!res.ok) throw new Error('현장 목록을 불러오지 못했습니다.');
      return res.json();
    })
    .then(function (sites) {
      if (!sites.length) { showSiteMessage('등록되거나 연결된 현장이 없습니다'); return; }
      siteSelect.replaceChildren();
      sites.forEach(function (site) {
        var option = document.createElement('option');
        option.value = String(site.id);
        option.textContent = site.name;
        siteSelect.appendChild(option);
      });
    })
    .catch(function (err) {
      if (err.message !== '로그인이 필요합니다.') showSiteMessage(err.message);
    });

  document.querySelectorAll('.document-item').forEach(function (button) {
    button.addEventListener('click', function () {
      if (!siteSelect.value) { alert('작성할 현장을 먼저 선택해주세요.'); return; }
      window.location.href = '/documents/new?siteId=' + encodeURIComponent(siteSelect.value)
        + '&docType=' + encodeURIComponent(button.dataset.docType);
    });
  });

  document.getElementById('documentSearch').addEventListener('input', function (event) {
    var query = event.target.value.trim().toLowerCase();
    document.querySelectorAll('.document-item').forEach(function (item) {
      item.style.display = !query || item.dataset.docName.toLowerCase().indexOf(query) !== -1 ? '' : 'none';
    });
  });
})();
</script>
</body>
</html>
