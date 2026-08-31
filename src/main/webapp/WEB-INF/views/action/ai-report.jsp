<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AI 결과보고서 생성 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @media print { .no-print { display: none !important; } }
    @keyframes spin { to { transform: rotate(360deg); } }
    .animate-spin { animation: spin 1s linear infinite; }
  </style>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between no-print">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div><span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span></a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1280px">

    <div id="noInspectionNotice" class="hidden bg-white rounded-2xl shadow-sm border border-gray-100 p-10 text-center">
      <p class="text-sm text-gray-500">잘못된 접근입니다. 보고서 상세 화면에서 다시 시도해주세요.</p>
      <a href="/actions" class="inline-block mt-4 px-5 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold">조치 관리로 이동</a>
    </div>

    <div id="wizardRoot" class="hidden">
      <p class="text-xs text-gray-400 uppercase tracking-wide font-semibold mb-1">결과보고서</p>
      <h1 class="text-xl font-bold text-gray-900 mb-1">AI 결과보고서 생성</h1>
      <p class="text-sm text-gray-500 mb-6">완료된 조치 항목을 선택하여 안전양식을 자동으로 작성합니다.</p>

      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
        <div id="stepIndicatorWrap"></div>

        <!-- STEP 1: 완료 조치 선택 -->
        <div id="step1">
          <h2 class="text-base font-bold text-gray-900 mb-1">완료된 조치 선택</h2>
          <p class="text-sm text-gray-500 mb-4">보고서에 포함할 완료 조치를 선택하세요. 선택된 항목만 양식에 작성됩니다.</p>
          <div class="flex items-center justify-between mb-3">
            <span id="step1Count" class="text-sm text-gray-500">0/0개 선택됨</span>
            <button type="button" id="step1ClearBtn" class="text-sm text-[#1A2E44] font-medium hover:underline">전체 해제</button>
          </div>
          <div id="step1List" class="space-y-3 mb-6">
            <p class="text-sm text-gray-400 text-center py-10">불러오는 중...</p>
          </div>
          <div class="flex justify-end">
            <button type="button" id="step1NextBtn" class="px-5 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex items-center gap-2 disabled:opacity-40 disabled:cursor-not-allowed" disabled>
              다음 단계 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
            </button>
          </div>
        </div>

        <!-- STEP 2: 양식 선택 -->
        <div id="step2" class="hidden">
          <h2 class="text-base font-bold text-gray-900 mb-1">양식 선택</h2>
          <p class="text-sm text-gray-500 mb-4">생성할 보고서 양식을 선택하세요.</p>
          <p class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">기본 제공 양식</p>
          <div id="templateGrid" class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6"></div>
          <div class="flex justify-between">
            <button type="button" id="step2PrevBtn" class="px-4 py-2 border border-gray-200 text-gray-600 rounded-lg text-sm font-medium hover:bg-gray-50">← 이전</button>
            <button type="button" id="step2NextBtn" class="px-5 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex items-center gap-2">
              AI 보고서 생성 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
            </button>
          </div>
        </div>

        <!-- STEP 3: AI 양식 생성 -->
        <div id="step3" class="hidden">
          <h2 class="text-base font-bold text-gray-900 mb-1">AI 양식 파일 생성</h2>
          <p id="step3Desc" class="text-sm text-gray-500 mb-4"></p>
          <div class="rounded-xl p-4 mb-5" style="background:#EFF6FF">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-semibold text-[#1A2E44] flex items-center gap-2">
                <svg class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
                AI 보고서 생성 중...
              </span>
              <span id="step3Pct" class="text-sm font-bold text-[#1A2E44]">0%</span>
            </div>
            <div class="h-2 bg-white rounded-full overflow-hidden"><div id="step3Bar" class="h-full bg-[#1A2E44] rounded-full transition-all duration-300" style="width:0%"></div></div>
          </div>
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
            <div id="step3Checklist" class="space-y-1.5"></div>
            <div class="border border-gray-200 rounded-xl overflow-hidden self-start">
              <div class="px-4 py-2.5 text-white text-sm font-semibold" style="background:#1A2E44">실시간 문서 미리보기</div>
              <div id="step3Preview" class="p-4 text-xs space-y-3"></div>
            </div>
          </div>
        </div>

        <!-- STEP 4: 저장 및 PDF -->
        <div id="step4" class="hidden">
          <h2 class="text-base font-bold text-gray-900 mb-1">저장하기 및 PDF 생성</h2>
          <p class="text-sm text-gray-500 mb-4">보고서를 저장하고 PDF로 출력하세요.</p>

          <div id="step4Banner" class="hidden rounded-xl p-4 mb-5 bg-green-50 border border-green-200 flex items-start gap-3">
            <svg class="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <div><p class="text-sm font-bold text-green-800">AI 보고서 생성 완료</p><p id="step4BannerText" class="text-xs text-green-700 mt-0.5"></p></div>
          </div>

          <div class="border border-gray-200 rounded-xl overflow-hidden mb-5">
            <div class="px-4 py-2.5 bg-gray-50 border-b border-gray-200 flex items-center justify-between no-print">
              <span class="text-sm font-semibold text-gray-700">보고서 미리보기</span>
              <span id="step4FileName" class="text-xs text-gray-400 font-mono"></span>
            </div>
            <div id="step4Preview" class="p-8"></div>
          </div>

          <div class="flex items-center justify-between no-print">
            <a href="/actions" class="px-4 py-2 border border-gray-200 text-gray-600 rounded-lg text-sm font-medium hover:bg-gray-50">조치 관리로 이동</a>
            <div class="flex items-center gap-2">
              <button type="button" id="step4SaveBtn" class="px-4 py-2 border border-gray-200 text-gray-700 rounded-lg text-sm font-semibold hover:bg-gray-50 flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/></svg>저장
              </button>
              <button type="button" id="step4PrintBtn" class="px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>인쇄·PDF
              </button>
            </div>
          </div>
        </div>

      </div>
    </div>
  </main>
</div>

<script>
(function () {
  var INSPECTION_ID = new URLSearchParams(window.location.search).get('inspectionId');

  function qs(sel) { return document.querySelector(sel); }
  function esc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  if (!INSPECTION_ID) {
    qs('#noInspectionNotice').classList.remove('hidden');
    return;
  }
  qs('#wizardRoot').classList.remove('hidden');

  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };
  var RISK_COLOR = { HIGH: '#991B1B', MEDIUM: '#B45309', SAFE: '#166534' };
  var RISK_BG    = { HIGH: '#FEF2F2', MEDIUM: '#FFFBEB', SAFE: '#F0FDF4' };

  // React AIReportPage.tsx의 TEMPLATES 그대로. 실제 백엔드 DocumentType은 4종류뿐이라
  // TBM/하청 조치확인서는 가장 가까운 기존 타입에 매핑해서 실제 AI 자동작성을 그대로 활용한다.
  var TEMPLATES = [
    { id: 'ACTION_REPORT',   name: '조치결과보고서',       desc: '완료된 조치 결과 및 재발방지 계획 기록',      docType: 'ACTION_REPORT',   icon: '<polyline points="20 6 9 17 4 12"/>' },
    { id: 'INSPECTION_LOG',  name: '안전점검 결과보고서',   desc: '현장 안전점검 결과를 정리한 표준 보고서',      docType: 'INSPECTION_LOG',  icon: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>' },
    { id: 'TBM',             name: 'TBM 보고서',            desc: '작업 전 안전 회의 (Tool Box Meeting) 기록',    docType: 'INSPECTION_LOG',  icon: '<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>' },
    { id: 'CONFIRM',         name: '하청 조치확인서',       desc: '하청 업체의 조치 완료 확인 및 서명 문서',      docType: 'ACTION_REPORT',   icon: '<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/>' }
  ];

  var DRAFT_FIELD_LABELS = {
    completedAction: '완료된 조치 사항', preventionPlan: '재발 방지 대책',
    assessmentPurpose: '평가 목적', overallResult: '종합 점검 결과',
    workType: '작업 종류', workScope: '작업 범위', safetyPrecaution: '작업 전 안전 조치사항'
  };

  var STEP_META = [
    { label: '완료 조치 선택', icon: '<path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>' },
    { label: '양식 선택',      icon: '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>' },
    { label: 'AI 양식 생성',   icon: '<path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/>' },
    { label: '저장 및 PDF',    icon: '<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>' }
  ];
  var CHECK_ICON = '<polyline points="20 6 9 17 4 12"/>';

  var GEN_STEPS = ['현장 기본정보 삽입', '완료 조치 항목 파싱', 'AI 2차 판독 결과 통합', '조치 상세 내용 작성', '조치 완료율 및 개선사항 삽입', '종합 의견 자동 생성', '서명란 및 서식 최종 적용'];

  var currentStep = 1;
  var inspection = null;
  var allActions = [];
  var completedActions = [];
  var selectedIds = new Set();
  var selectedTemplateId = 'ACTION_REPORT';
  var draftData = null;
  var genStepIndex = 0;
  var genTimer = null;

  function renderStepIndicator() {
    var html = '<div class="flex items-center mb-10">';
    STEP_META.forEach(function (s, i) {
      var n = i + 1;
      var state = n < currentStep ? 'done' : (n === currentStep ? 'active' : 'pending');
      var circleClass = state === 'pending' ? 'bg-gray-200 text-gray-400' : 'bg-[#1A2E44] text-white';
      var iconPath = state === 'done' ? CHECK_ICON : s.icon;
      html += '<div class="flex flex-col items-center flex-shrink-0" style="width:110px">' +
        '<div class="w-10 h-10 rounded-full flex items-center justify-center ' + circleClass + '">' +
        '<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">' + iconPath + '</svg></div>' +
        '<span class="text-xs font-semibold mt-2 text-center ' + (state === 'pending' ? 'text-gray-400' : 'text-gray-900') + '">' + s.label + '</span></div>';
      if (n < STEP_META.length) {
        html += '<div class="flex-1 h-0.5 mx-1 ' + (n < currentStep ? 'bg-[#1A2E44]' : 'bg-gray-200') + '"></div>';
      }
    });
    html += '</div>';
    qs('#stepIndicatorWrap').innerHTML = html;
  }

  function goToStep(n) {
    currentStep = n;
    renderStepIndicator();
    [1, 2, 3, 4].forEach(function (i) {
      qs('#step' + i).classList.toggle('hidden', i !== n);
    });
    if (n === 3) startGeneration();
    if (n === 4) renderStep4();
  }

  /* ── STEP 1 ── */
  function renderStep1() {
    var listEl = qs('#step1List');
    if (!completedActions.length) {
      listEl.innerHTML = '<p class="text-sm text-gray-400 text-center py-10">완료된 조치 항목이 없습니다. 조치를 먼저 완료해주세요.</p>';
      qs('#step1Count').textContent = '0/0개 선택됨';
      qs('#step1NextBtn').disabled = true;
      return;
    }
    listEl.innerHTML = completedActions.map(function (a) {
      var checked = selectedIds.has(a.id);
      var meta = '';
      if (a.location) meta += '<p><span class="font-semibold text-gray-600">위치:</span> ' + esc(a.location) + '</p>';
      if (a.regulationRef) meta += '<p><span class="font-semibold text-gray-600">관련법규:</span> ' + esc(a.regulationRef) + '</p>';
      if (a.recommendation) meta += '<p><span class="font-semibold text-gray-600">권장조치:</span> ' + esc(a.recommendation) + '</p>';
      return '<label class="block border-2 rounded-xl p-4 cursor-pointer transition-colors ' + (checked ? 'border-[#1A2E44]' : 'border-gray-200 hover:border-gray-300') + '" style="background:' + (checked ? '#EFF6FF' : 'white') + '">' +
        '<div class="flex items-start gap-3">' +
        '<input type="checkbox" class="action-check mt-1 w-4 h-4 flex-shrink-0" data-id="' + a.id + '" ' + (checked ? 'checked' : '') + '/>' +
        '<div class="flex-1 min-w-0">' +
        '<div class="flex items-center gap-2 mb-1 flex-wrap">' +
        '<span class="text-sm font-bold text-gray-900">' + esc(a.title) + '</span>' +
        '<span class="text-xs font-semibold px-2 py-0.5 rounded-full" style="background:' + RISK_BG[a.riskLevel] + ';color:' + RISK_COLOR[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span>' +
        '<span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-green-100 text-green-700">조치 완료</span>' +
        '</div>' +
        (a.description ? '<p class="text-xs text-gray-500 mb-2">' + esc(a.description) + '</p>' : '') +
        (meta ? '<div class="text-xs text-gray-500 space-y-0.5">' + meta + '</div>' : '') +
        '</div></div></label>';
    }).join('');

    qsAllStep1Checks().forEach(function (el) {
      el.addEventListener('change', function () {
        var id = Number(el.dataset.id);
        if (el.checked) selectedIds.add(id); else selectedIds.delete(id);
        updateStep1Counter();
        renderStep1();
      });
    });
    updateStep1Counter();
  }

  function qsAllStep1Checks() { return Array.prototype.slice.call(document.querySelectorAll('.action-check')); }

  function updateStep1Counter() {
    qs('#step1Count').textContent = selectedIds.size + '/' + completedActions.length + '개 선택됨';
    qs('#step1NextBtn').disabled = selectedIds.size === 0;
  }

  qs('#step1ClearBtn').addEventListener('click', function () {
    selectedIds.clear();
    renderStep1();
  });
  qs('#step1NextBtn').addEventListener('click', function () { goToStep(2); });

  /* ── STEP 2 ── */
  function renderStep2() {
    qs('#templateGrid').innerHTML = TEMPLATES.map(function (t) {
      var active = t.id === selectedTemplateId;
      return '<button type="button" class="template-card text-left border-2 rounded-xl p-4 flex items-start gap-3 transition-colors ' +
        (active ? 'border-[#1A2E44]' : 'border-gray-200 hover:border-gray-300') + '" style="background:' + (active ? '#EFF6FF' : 'white') + '" data-id="' + t.id + '">' +
        '<div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0" style="background:' + (active ? '#1A2E44' : '#F3F4F6') + '">' +
        '<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="' + (active ? 'white' : '#6B7280') + '" stroke-width="2">' + t.icon + '</svg></div>' +
        '<div class="flex-1 min-w-0"><p class="text-sm font-bold text-gray-900">' + t.name + '</p><p class="text-xs text-gray-500 mt-0.5">' + t.desc + '</p></div>' +
        (active ? '<svg class="w-4 h-4 text-[#1A2E44] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>' : '') +
        '</button>';
    }).join('');
    document.querySelectorAll('.template-card').forEach(function (btn) {
      btn.addEventListener('click', function () { selectedTemplateId = btn.dataset.id; renderStep2(); });
    });
  }

  qs('#step2PrevBtn').addEventListener('click', function () { goToStep(1); });
  qs('#step2NextBtn').addEventListener('click', function () { goToStep(3); });

  /* ── STEP 3 (실제 /api/documents/draft 호출을 감싼 연출) ── */
  function renderGenChecklist() {
    qs('#step3Checklist').innerHTML = GEN_STEPS.map(function (label, i) {
      var state = i < genStepIndex ? 'done' : (i === genStepIndex ? 'active' : 'pending');
      var icon = state === 'done'
        ? '<svg class="w-3.5 h-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>'
        : state === 'active'
        ? '<svg class="w-3.5 h-3.5 text-white animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>'
        : '<svg class="w-3.5 h-3.5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 16"/></svg>';
      var circleBg = state === 'pending' ? 'bg-gray-200' : 'bg-[#1A2E44]';
      return '<div class="flex items-center gap-3 px-3 py-2.5 rounded-lg ' + (state === 'active' ? 'bg-blue-50' : '') + '">' +
        '<span class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ' + circleBg + '">' + icon + '</span>' +
        '<span class="text-sm ' + (state === 'pending' ? 'text-gray-400' : 'text-gray-800 font-medium') + '">' + label + '</span>' +
        (state === 'done' ? '<span class="ml-auto text-xs text-green-600 font-semibold flex-shrink-0">완료</span>' : '') +
        '</div>';
    }).join('');
    var pct = Math.round(genStepIndex / GEN_STEPS.length * 100);
    qs('#step3Pct').textContent = pct + '%';
    qs('#step3Bar').style.width = pct + '%';
  }

  function renderStep3Preview() {
    var siteName = inspection ? inspection.location : '';
    var inspectedAt = inspection && inspection.createdAt ? inspection.createdAt.slice(0, 10) : '';
    var manager = inspection ? inspection.requestedByName : '';
    var filledRows = genStepIndex >= 1
      ? '<table class="w-full text-xs"><tbody>' +
        '<tr><td class="py-1 pr-3 text-gray-400 w-16">현장명</td><td class="py-1 font-medium text-gray-800">' + esc(siteName || '-') + '</td></tr>' +
        '<tr><td class="py-1 pr-3 text-gray-400">점검일</td><td class="py-1 font-medium text-gray-800">' + esc(inspectedAt || '-') + '</td></tr>' +
        '<tr><td class="py-1 pr-3 text-gray-400">담당자</td><td class="py-1 font-medium text-gray-800">' + esc(manager || '-') + '</td></tr>' +
        '</tbody></table>'
      : '<div class="h-4 bg-gray-100 rounded w-2/3 mb-2"></div><div class="h-4 bg-gray-100 rounded w-1/2"></div>';

    var itemsBlock = genStepIndex >= 2
      ? '<div><p class="text-gray-400 font-semibold mb-1">완료 조치 항목</p>' +
        selectedActionsList().map(function (a) { return '<p class="text-gray-700">· ' + esc(a.title) + '</p>'; }).join('') + '</div>'
      : '<div class="h-3 bg-gray-100 rounded w-1/3 mb-1.5"></div><div class="h-3 bg-gray-100 rounded w-full"></div>';

    var opinionBlock = genStepIndex >= 6
      ? '<div><p class="text-gray-400 font-semibold mb-1">종합 의견</p><p class="text-gray-700">AI가 완료 조치 내용을 반영해 종합 의견을 작성했습니다.</p></div>'
      : '<div class="h-3 bg-gray-100 rounded w-full mb-1.5"></div><div class="h-3 bg-gray-100 rounded w-4/5"></div>';

    qs('#step3Preview').innerHTML = filledRows + '<hr class="border-gray-100"/>' + itemsBlock + '<hr class="border-gray-100"/>' + opinionBlock;
  }

  function selectedActionsList() {
    return completedActions.filter(function (a) { return selectedIds.has(a.id); });
  }

  function startGeneration() {
    genStepIndex = 0;
    draftData = null;
    var template = TEMPLATES.find(function (t) { return t.id === selectedTemplateId; });
    qs('#step3Desc').textContent = '「' + template.name + '」에 맞춰 AI가 선택된 ' + selectedIds.size + '건의 완료 조치를 기반으로 자동 작성 중입니다.';
    renderGenChecklist();
    renderStep3Preview();

    var fetchDone = false;
    var fetchError = null;

    fetch('/api/documents/draft?inspectionId=' + encodeURIComponent(INSPECTION_ID) + '&docType=' + template.docType)
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
        if (!res.ok) throw new Error('AI 자동 작성에 실패했습니다.');
        return res.json();
      })
      .then(function (draft) { draftData = draft; })
      .catch(function (err) { fetchError = err; })
      .finally(function () { fetchDone = true; });

    clearInterval(genTimer);
    genTimer = setInterval(function () {
      // 실제 응답이 아직 안 왔으면 마지막 항목 하나를 남겨두고 순서대로 진행,
      // 응답이 도착하면 남은 항목을 한 번에 완료 처리한다.
      if (!fetchDone && genStepIndex < GEN_STEPS.length - 1) {
        genStepIndex++;
      } else if (fetchDone) {
        genStepIndex = GEN_STEPS.length;
      }
      renderGenChecklist();
      renderStep3Preview();
      if (genStepIndex >= GEN_STEPS.length) {
        clearInterval(genTimer);
        if (fetchError) {
          alert(fetchError.message);
          goToStep(2);
          return;
        }
        setTimeout(function () { goToStep(4); }, 500);
      }
    }, 260);
  }

  /* ── STEP 4 ── */
  function renderStep4() {
    var template = TEMPLATES.find(function (t) { return t.id === selectedTemplateId; });
    var today = new Date();
    var dateStr = today.getFullYear() + '.' + String(today.getMonth() + 1).padStart(2, '0') + '.' + String(today.getDate()).padStart(2, '0');
    var fileDate = today.getFullYear() + String(today.getMonth() + 1).padStart(2, '0') + String(today.getDate()).padStart(2, '0');
    var siteName = inspection ? (inspection.location || '현장') : '현장';

    qs('#step4Banner').classList.remove('hidden');
    qs('#step4BannerText').textContent = '「' + template.name + '」 기반 — ' + selectedIds.size + '건 완료 조치 반영 결과보고서가 자동 작성되었습니다.';
    qs('#step4FileName').textContent = siteName.replace(/\s+/g, '') + '_' + template.name + '_' + fileDate + '.pdf';

    var itemsRows = selectedActionsList().map(function (a, i) {
      return '<tr class="border-b border-gray-100">' +
        '<td class="py-2 px-3 text-gray-500">' + (i + 1) + '</td>' +
        '<td class="py-2 px-3 font-medium text-gray-800">' + esc(a.title) + '</td>' +
        '<td class="py-2 px-3"><span class="text-xs font-semibold px-2 py-0.5 rounded-full" style="background:' + RISK_BG[a.riskLevel] + ';color:' + RISK_COLOR[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span></td>' +
        '<td class="py-2 px-3"><span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-green-100 text-green-700">조치 완료</span></td>' +
        '</tr>';
    }).join('');

    var detailCards = selectedActionsList().map(function (a) {
      var lines = [];
      if (a.location) lines.push('<span class="font-semibold text-gray-600">위치:</span> ' + esc(a.location));
      if (a.regulationRef) lines.push('<span class="font-semibold text-gray-600">관련법규:</span> ' + esc(a.regulationRef));
      if (a.description) lines.push('<span class="font-semibold text-gray-600">조치 내용:</span> ' + esc(a.description));
      return '<div class="border border-gray-100 rounded-lg p-3 mb-2">' +
        '<p class="text-sm font-bold text-gray-900 mb-1">' + esc(a.title) + '</p>' +
        '<div class="text-xs text-gray-600 space-y-0.5">' + lines.map(function (l) { return '<p>' + l + '</p>'; }).join('') + '</div></div>';
    }).join('');

    var draftFieldsHtml = '';
    if (draftData) {
      Object.keys(draftData).forEach(function (key) {
        if (key === 'siteName' || key === 'items') return;
        var label = DRAFT_FIELD_LABELS[key];
        var value = draftData[key];
        if (!label || !value) return;
        draftFieldsHtml += '<div class="mb-3"><p class="text-xs font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-1">' + label + '</p>' +
          '<p class="text-sm text-gray-700 pl-2 whitespace-pre-line">' + esc(value) + '</p></div>';
      });
    }

    qs('#step4Preview').innerHTML =
      '<div class="flex items-center justify-between text-xs text-gray-400 mb-4">' +
      '<span>문서번호: SM-' + fileDate + '-' + INSPECTION_ID + '</span>' +
      '<span class="text-[#1A2E44] font-semibold flex items-center gap-1"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>AI 자동생성</span>' +
      '</div>' +
      '<h2 class="text-xl font-bold text-gray-900 text-center mb-1">' + template.name + '</h2>' +
      '<p class="text-xs text-gray-400 text-center mb-6">건설현장 안전관리 플랫폼 SafeMate · ' + dateStr + '</p>' +
      '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2">현장 기본정보</h3>' +
      '<table class="w-full text-sm mb-6 border border-gray-200 rounded-lg overflow-hidden"><tbody>' +
      '<tr class="border-b border-gray-100"><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600 w-28">현장명</td><td class="py-2 px-3 text-gray-800">' + esc(siteName) + '</td></tr>' +
      '<tr class="border-b border-gray-100"><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600">점검일</td><td class="py-2 px-3 text-gray-800">' + esc(inspection && inspection.createdAt ? inspection.createdAt.slice(0, 10) : '-') + '</td></tr>' +
      '<tr class="border-b border-gray-100"><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600">담당자</td><td class="py-2 px-3 text-gray-800">' + esc(inspection ? inspection.requestedByName : '-') + '</td></tr>' +
      '<tr><td class="py-2 px-3 bg-gray-50 font-semibold text-gray-600">완료 조치 수</td><td class="py-2 px-3 text-gray-800">' + selectedIds.size + '건</td></tr>' +
      '</tbody></table>' +
      '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2">1. 완료된 조치 항목 목록</h3>' +
      '<table class="w-full text-sm mb-6"><thead><tr class="bg-gray-50 text-xs text-gray-500"><th class="text-left py-2 px-3">No.</th><th class="text-left py-2 px-3">항목명</th><th class="text-left py-2 px-3">위험등급</th><th class="text-left py-2 px-3">조치상태</th></tr></thead>' +
      '<tbody>' + itemsRows + '</tbody></table>' +
      '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2">2. 조치 상세 내용</h3>' +
      detailCards +
      (draftFieldsHtml ? '<h3 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-2 mt-4">3. AI 종합 작성 내용</h3>' + draftFieldsHtml : '') +
      '<div class="grid grid-cols-3 gap-4 mt-8 pt-4 border-t border-gray-100">' +
      ['작성자', '검토자', '승인자'].map(function (r) {
        return '<div class="border border-gray-200 rounded-xl p-4 text-center"><p class="text-xs font-semibold text-gray-700 mb-6">' + r + '</p><p class="text-[10px] text-gray-400 border-t border-gray-200 pt-1">(서명 또는 인)</p></div>';
      }).join('') +
      '</div>';
  }

  qs('#step4SaveBtn').addEventListener('click', function () {
    var template = TEMPLATES.find(function (t) { return t.id === selectedTemplateId; });
    var btn = qs('#step4SaveBtn');
    btn.disabled = true;
    fetch('/api/documents', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ inspectionId: Number(INSPECTION_ID), docType: template.docType, formData: draftData || {}, aiGenerated: true })
    })
      .then(function (res) { if (!res.ok) throw new Error('저장에 실패했습니다.'); return res.json(); })
      .then(function () { alert('보고서가 저장되었습니다.'); })
      .catch(function (err) { alert(err.message); })
      .finally(function () { btn.disabled = false; });
  });

  qs('#step4PrintBtn').addEventListener('click', function () { window.print(); });

  /* ── 초기 데이터 로드 ── */
  fetch('/api/users/me')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (user) {
      qs('#headerUserName').textContent = user.username;
      qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(function () {});

  Promise.all([
    fetch('/api/inspections/' + INSPECTION_ID).then(function (res) { if (!res.ok) throw new Error(); return res.json(); }),
    fetch('/api/inspections/' + INSPECTION_ID + '/actions').then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
  ]).then(function (results) {
    inspection = results[0];
    allActions = results[1];
    completedActions = allActions.filter(function (a) { return a.status === 'COMPLETED'; });
    selectedIds = new Set(completedActions.map(function (a) { return a.id; }));
    renderStepIndicator();
    renderStep1();
    renderStep2();
  }).catch(function () {
    qs('#step1List').innerHTML = '<p class="text-sm text-red-600 text-center py-10">점검 정보를 불러오지 못했습니다.</p>';
  });

  renderStepIndicator();
})();
</script>
</body>
</html>
