<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AI 서류 작성 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @media print {
      #sidebar, header, #evidenceCard, #formTypeCard, #aiAssistCard, #formFileCard, .no-print { display: none !important; }
      #mainContent { margin-left: 0 !important; }
      #genericPhotoGrid > div { break-inside: avoid; }
      #genericPhotoGrid .photo-cap-input { border: none !important; padding-left: 0 !important; }
    }

    /* 안전양식 탭 — 섹션형 사이드 메뉴 */
    #formTypeCard { position: sticky; top: 92px; }
    #formTypeList { display: flex; flex-direction: column; gap: 12px; }
    #formTypeList .form-section {
      border: 1px solid #E5E7EB; border-radius: 14px; padding: 8px;
      background: #F9FAFB;
    }
    #formTypeList .form-section-head {
      display: flex; align-items: center; justify-content: space-between;
      padding: 2px 4px 8px;
    }
    #formTypeList .form-section-title {
      font-size: 11px; font-weight: 800; color: #64748B;
      letter-spacing: .04em;
    }
    #formTypeList .form-section-count {
      min-width: 18px; height: 18px; padding: 0 6px; border-radius: 9999px;
      display: inline-flex; align-items: center; justify-content: center;
      background: #E2E8F0; color: #475569; font-size: 10px; font-weight: 800;
    }
    #formTypeList .form-section-items { display: flex; flex-direction: column; gap: 4px; }
    #formTypeList .form-type-btn { min-height: 58px; }
    #formTypeList .form-type-btn .form-desc { line-height: 1.25; }
    #formTypeList .form-type-btn.is-active {
      background: #FFF7ED; border-color: #1A2E44;
      box-shadow: 0 8px 18px rgba(15, 23, 42, .08);
    }
    @media (max-width: 1023px) {
      #formTypeCard { position: static; }
    }

    /* ── 종합 위험도 구간 막대 ── */
    .risk-meter { position: relative; }
    .risk-meter-track {
      position: relative; height: 12px; border-radius: 9999px; overflow: hidden;
      display: flex; background: #fff;
    }
    .risk-zone { flex: 1; height: 100%; pointer-events: none; transition: opacity .2s; }
    .risk-zone[data-band="low"]    { background: #DCFCE7; }
    .risk-zone[data-band="medium"] { background: #FEF9C3; }
    .risk-zone[data-band="high"]   { background: #FFEDD5; }
    .risk-zone[data-band="severe"] { background: #FEE2E2; }
    .risk-meter-track.band-active .risk-zone:not(.zone-on) { opacity: .4; }
    .risk-zone.zone-on { box-shadow: inset 0 0 0 2px rgba(15, 23, 42, .18); }
    .risk-meter-fill {
      position: absolute; left: 0; top: 0; height: 100%; width: 0; pointer-events: none;
      border-radius: 9999px; opacity: .92;
      transition: width .5s cubic-bezier(.4, 0, .2, 1), background-color .3s;
    }
    .risk-meter-marker {
      position: absolute; top: -3px; width: 2px; height: 18px; background: #0F172A;
      border-radius: 1px; pointer-events: none; transform: translateX(-1px);
      transition: left .5s cubic-bezier(.4, 0, .2, 1);
    }
    .risk-meter-marker span {
      position: absolute; bottom: 22px; left: 50%; transform: translateX(-50%);
      font-size: 10px; font-weight: 700; color: #0F172A; background: #fff;
      padding: 1px 5px; border-radius: 4px; white-space: nowrap;
      box-shadow: 0 1px 3px rgba(0, 0, 0, .12);
    }
    .risk-hit {
      position: absolute; top: -4px; height: 20px; width: 25%; padding: 0;
      background: transparent; border: none; cursor: pointer;
    }
    .risk-hit[data-band="low"]    { left: 0; }
    .risk-hit[data-band="medium"] { left: 25%; }
    .risk-hit[data-band="high"]   { left: 50%; }
    .risk-hit[data-band="severe"] { left: 75%; }
    .risk-hit:focus-visible { outline: 2px solid #0F172A; outline-offset: 2px; border-radius: 4px; }
    .risk-meter-scale, .risk-meter-bands { display: flex; margin-top: 6px; }
    .risk-meter-scale { justify-content: space-between; }
    .risk-meter-scale span { font-size: 9px; color: #9CA3AF; }
    .risk-meter-bands { margin-top: 2px; }
    .risk-meter-bands span { flex: 1; text-align: center; font-size: 10px; font-weight: 600; color: #9CA3AF; transition: color .2s; }
    .risk-meter-bands span.on { color: #0F172A; }
    .risk-tooltip {
      position: absolute; z-index: 30; transform: translate(-50%, -100%); pointer-events: none;
      background: #0F172A; color: #fff; font-size: 11px; font-weight: 600;
      padding: 5px 9px; border-radius: 6px; white-space: nowrap;
      box-shadow: 0 4px 12px rgba(0, 0, 0, .2);
    }
    .risk-tooltip::after {
      content: ''; position: absolute; left: 50%; top: 100%; transform: translateX(-50%);
      border: 5px solid transparent; border-top-color: #0F172A;
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

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1280px">
    <div class="space-y-6">

      <!-- Report Header -->
      <div id="reportHeaderCard" class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-3">
            <a href="/actions" class="p-2 hover:bg-gray-100 rounded-lg no-print"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg></a>
            <h1 id="reportTitle" class="text-xl font-bold text-gray-900">리포트를 불러오는 중...</h1>
            <span id="reportIdBadge" class="text-xs font-medium px-2.5 py-1 bg-blue-50 text-blue-600 rounded-full"></span>
          </div>
          <div class="flex items-center gap-2 no-print">
            <button onclick="window.print()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>PDF
            </button>
            <button class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>공유
            </button>
          </div>
        </div>
        <div class="flex items-center gap-4 text-sm text-gray-500 mb-4">
          <span class="flex items-center gap-1"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg><span id="reportDate">-</span></span>
          <span class="flex items-center gap-1"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg><span id="reportLocation">-</span></span>
          <span class="flex items-center gap-1"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg><span id="reportRequester">-</span></span>
          <span class="text-xs font-semibold px-2.5 py-1 bg-green-50 text-green-600 rounded-full">분석 완료</span>
        </div>
        <div id="riskBanner" class="flex items-start gap-6 rounded-xl p-4 transition-colors" style="background:#F8FAFC">
          <div class="flex-shrink-0">
            <p class="text-xs text-gray-500 mb-1">종합 위험도</p>
            <div class="flex items-baseline gap-2">
              <span id="riskLevelLabel" class="text-3xl font-bold">-</span>
              <span id="riskOverallPct" class="text-lg font-semibold text-gray-400">-%</span>
            </div>
            <p class="text-[11px] text-gray-400 mt-1">감지 항목 평균 기준</p>
          </div>

          <div class="flex-1 min-w-0 pt-5">
            <div id="riskMeter" class="risk-meter" role="group" aria-label="위험도 구간별 감지 항목">
              <div id="riskTooltip" class="risk-tooltip" hidden></div>
              <div id="riskMeterMarker" class="risk-meter-marker"><span id="riskMeterMarkerPct">0%</span></div>
              <div class="risk-meter-track">
                <div class="risk-zone" data-band="low"></div>
                <div class="risk-zone" data-band="medium"></div>
                <div class="risk-zone" data-band="high"></div>
                <div class="risk-zone" data-band="severe"></div>
                <div id="riskMeterFill" class="risk-meter-fill"></div>
              </div>
              <button type="button" class="risk-hit" data-band="low" aria-label="낮음 구간 (0~25%)"></button>
              <button type="button" class="risk-hit" data-band="medium" aria-label="보통 구간 (26~50%)"></button>
              <button type="button" class="risk-hit" data-band="high" aria-label="높음 구간 (51~75%)"></button>
              <button type="button" class="risk-hit" data-band="severe" aria-label="고위험 구간 (76~100%)"></button>
              <div class="risk-meter-scale"><span>0%</span><span>25%</span><span>50%</span><span>75%</span><span>100%</span></div>
              <div class="risk-meter-bands"><span data-band="low">낮음</span><span data-band="medium">보통</span><span data-band="high">높음</span><span data-band="severe">고위험</span></div>
            </div>
          </div>

          <div class="text-right flex-shrink-0">
            <p class="text-xs text-gray-500 mb-1" id="detectedCountLabel">감지 항목</p>
            <p id="detectedCount" class="text-2xl font-bold text-gray-900" data-value="0">-</p>
          </div>
        </div>

        <!-- Tabs -->
        <div class="flex gap-6 mt-5 border-b border-gray-200">
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-900 border-b-2 border-gray-900" data-tab="result">분석결과</button>
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-400 border-b-2 border-transparent hover:text-gray-600" data-tab="form">안전양식</button>
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-400 border-b-2 border-transparent hover:text-gray-600" data-tab="evidence">증거자료</button>
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-400 border-b-2 border-transparent hover:text-gray-600" data-tab="msds">MSDS 확인</button>
        </div>
      </div>

      <!-- 분석결과 탭 -->
      <div id="tab-result" class="tab-panel grid grid-cols-1 lg:grid-cols-3 gap-5">
      <div class="lg:col-span-2 space-y-4">
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-base font-semibold text-gray-900">감지 항목</h3>
          <div class="flex items-center gap-1.5" id="issueFilterTabs">
            <button type="button" class="issue-filter-btn px-3 py-1 rounded-lg text-xs font-semibold bg-[#1A2E44] text-white" data-filter="all">전체</button>
            <button type="button" class="issue-filter-btn px-3 py-1 rounded-lg text-xs font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-filter="needed">조치 필요</button>
            <button type="button" class="issue-filter-btn px-3 py-1 rounded-lg text-xs font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-filter="done">완료</button>
          </div>
        </div>
        <div id="detectedItems" class="space-y-3">
          <p class="text-sm text-gray-400">리포트를 선택하면 감지 항목이 표시됩니다.</p>
        </div>

        <!-- 현장 비교(조치 검증) 패널 -->
        <div id="verificationPanel" class="hidden mt-4 bg-[#f5f7fa] rounded-2xl border-2 border-[#003b5c]/10 overflow-hidden">
          <div class="bg-[#003b5c] px-6 py-4 flex items-center justify-between">
            <div>
              <p class="text-white font-bold text-base">조치 검증 업로드</p>
              <p id="verifyIssueLabel" class="text-white/60 text-xs"></p>
            </div>
            <button id="closeVerificationBtn" type="button" class="p-1.5 hover:bg-white/10 rounded-lg transition-colors">
              <svg class="w-5 h-5 text-white/70" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
          </div>
          <div class="p-6 space-y-5">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
                <div class="flex items-center gap-2 px-5 pt-5 pb-3"><div class="w-3 h-3 rounded-full bg-red-500"></div><span class="font-bold text-[#003b5c]">조치 전</span></div>
                <div id="verifyBeforeImageWrap" class="mx-5 mb-5 rounded-xl overflow-hidden bg-gray-100 flex items-center justify-center" style="height:220px"></div>
                <div id="verifyContextWrap" class="mx-5 mb-5 space-y-2 text-xs"></div>
              </div>
              <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
                <div class="flex items-center gap-2 px-5 pt-5 pb-3"><div class="w-3 h-3 rounded-full bg-green-600"></div><span class="font-bold text-[#003b5c]">조치 후</span></div>
                <div class="mx-5 mb-5">
                  <label id="verifyAfterDropzone" class="relative rounded-xl border-2 border-dashed border-gray-300 bg-gray-50 flex flex-col items-center justify-center cursor-pointer hover:border-[#1A2E44] hover:bg-orange-50 transition-all" style="height:220px">
                    <input id="verifyAfterInput" type="file" accept="image/*" class="hidden"/>
                    <svg class="w-10 h-10 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                    <p class="text-sm text-gray-600 font-medium mt-2">개선된 현장을 촬영해주세요</p>
                    <p class="text-xs text-gray-400 mt-0.5">클릭하거나 드래그하여 업로드</p>
                  </label>
                  <div id="verifyAfterPreviewWrap" class="hidden relative rounded-xl overflow-hidden bg-gray-100" style="height:220px">
                    <img id="verifyAfterPreviewImg" class="w-full h-full object-cover" alt="조치 후 사진"/>
                    <button id="verifyAfterRemoveBtn" type="button" class="absolute top-2 right-2 bg-black/50 hover:bg-black/70 rounded-full p-1.5"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>
                  </div>
                </div>
              </div>
            </div>

            <p id="verifyResultBox" class="hidden text-sm px-4 py-3 rounded-xl"></p>

            <div class="bg-white rounded-2xl shadow-sm p-5 flex gap-3">
              <button id="verifyAiRequestBtn" type="button" disabled class="flex-1 h-12 rounded-xl font-bold text-sm transition-colors flex items-center justify-center gap-2 bg-gray-200 text-gray-400 cursor-not-allowed">AI 재평가 요청</button>
              <button id="verifyCompleteBtn" type="button" class="hidden flex-1 h-12 rounded-xl font-bold text-sm bg-green-600 text-white hover:bg-green-700 transition-colors">승인 요청하기</button>
            </div>
          </div>
        </div>
      </div>
      </div>

      <!-- 우측: 조치 항목 요약 + AI 종합 의견 -->
      <div class="space-y-4">
        <div class="rounded-xl p-5 border border-gray-200" style="background:#F9FAFB">
          <h3 class="font-bold text-gray-900 mb-4">조치 항목 요약</h3>
          <div class="space-y-2.5 mb-4">
            <div class="flex items-center justify-between bg-white rounded-lg px-3 py-2">
              <span class="text-sm text-gray-600">전체 항목</span>
              <span id="summaryTotal" class="text-sm font-bold text-gray-900">-</span>
            </div>
            <div class="flex items-center justify-between bg-white rounded-lg px-3 py-2">
              <span class="text-sm text-gray-600">조치 필요</span>
              <span id="summaryNeeded" class="text-sm font-bold text-red-600">-</span>
            </div>
            <div class="flex items-center justify-between bg-white rounded-lg px-3 py-2">
              <span class="text-sm text-gray-600">완료</span>
              <span id="summaryDone" class="text-sm font-bold text-green-600">-</span>
            </div>
          </div>
          <button id="goToFormBtn" type="button" class="w-full py-2.5 text-sm font-semibold rounded-lg transition-colors flex items-center justify-center gap-2" style="background:#1A2E44;color:white">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            안전양식 자동 작성
          </button>
          <a href="/actions" class="w-full mt-2 py-2.5 border border-gray-200 text-gray-600 text-sm font-medium rounded-xl hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
            조치 관리로 이동
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
          </a>
        </div>

        <div class="rounded-xl p-5 border border-gray-200" style="background:#EFF6FF">
          <p class="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wide">AI 종합 의견</p>
          <p id="aiOpinionText" class="text-xs text-gray-700 leading-relaxed">리포트를 선택하면 표시됩니다.</p>
        </div>
      </div>
      </div>

      <!-- 안전양식 탭 -->
      <div id="tab-form" class="tab-panel hidden grid grid-cols-1 lg:grid-cols-4 gap-6">
        <div class="lg:col-span-1 space-y-5">
          <div id="formTypeCard" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between px-1 mb-3">
              <h3 class="text-sm font-bold text-gray-900">양식 종류</h3>
              <span class="text-[11px] font-semibold text-gray-400">8개</span>
            </div>
            <div id="formTypeList">
              <section class="form-section">
                <div class="form-section-head">
                  <p class="form-section-title">핵심 작성 양식</p>
                  <span class="form-section-count">3</span>
                </div>
                <div class="form-section-items">
                  <button class="form-type-btn is-active w-full text-left px-3 py-2.5 rounded-xl border bg-white hover:bg-white flex items-start gap-3 transition-all" data-type="INSPECTION_LOG">
                    <svg class="w-4 h-4 text-[#1A2E44] flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">안전점검일지</span><span class="form-desc block text-[11px] text-gray-500">순회·일상·합동 점검 및 조치사항</span></span>
                  </button>
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="RISK_ASSESSMENT">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">위험성평가서</span><span class="form-desc block text-[11px] text-gray-500">위험요소 분류 및 개선대책 수립</span></span>
                  </button>
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="ACTION_REPORT">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">조치결과보고서</span><span class="form-desc block text-[11px] text-gray-500">완료 결과 및 재발방지 계획</span></span>
                  </button>
                </div>
              </section>

              <section class="form-section">
                <div class="form-section-head">
                  <p class="form-section-title">현장 운영 기록</p>
                  <span class="form-section-count">3</span>
                </div>
                <div class="form-section-items">
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="TBM_LOG">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">TBM 일지</span><span class="form-desc block text-[11px] text-gray-500">작업 전 안전 회의 기록</span></span>
                  </button>
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="SAFETY_EDU_LOG">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">안전보건교육일지</span><span class="form-desc block text-[11px] text-gray-500">교육 및 참석자 서명부</span></span>
                  </button>
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="PPE_ISSUE_LOG">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">보호구 지급대장</span><span class="form-desc block text-[11px] text-gray-500">보호구 지급 내역 관리</span></span>
                  </button>
                </div>
              </section>

              <section class="form-section">
                <div class="form-section-head">
                  <p class="form-section-title">승인·증빙</p>
                  <span class="form-section-count">2</span>
                </div>
                <div class="form-section-items">
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="WORK_PERMIT">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">작업허가서</span><span class="form-desc block text-[11px] text-gray-500">위험작업 사전 승인 조건</span></span>
                  </button>
                  <button class="form-type-btn w-full text-left px-3 py-2.5 rounded-xl border border-transparent bg-white/70 hover:bg-white flex items-start gap-3 transition-all" data-type="SAFETY_EXPENSE_LOG">
                    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                    <span class="min-w-0"><span class="block text-sm font-bold text-gray-900">관리비 사용내역서</span><span class="form-desc block text-[11px] text-gray-500">안전용품·시설물 집행 증빙</span></span>
                  </button>
                </div>
              </section>
            </div>
          </div>

          <div id="aiAssistCard" class="bg-gradient-to-br from-[#1A2E44] to-[#2C5282] rounded-2xl p-5 text-white">
            <div class="flex items-center gap-2 mb-2">
              <svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>
              <h3 class="text-sm font-semibold">AI 자동 작성</h3>
            </div>
            <p class="text-xs text-white/70 mb-4">조치관리 데이터를 기반으로 AI가 양식을 자동 작성합니다.</p>
            <button id="aiAutoFillBtn" class="w-full py-2.5 bg-[#1A2E44] hover:bg-[#0F2233] rounded-xl text-sm font-bold flex items-center justify-center gap-2 transition-colors">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>자동 작성하기
            </button>
            <div id="aiGenProgressWrap" class="hidden mt-3">
              <div class="flex items-center justify-between mb-1.5">
                <span class="text-xs text-white/80">AI 양식 생성 중...</span>
                <span id="aiGenProgressPct" class="text-xs font-bold">0%</span>
              </div>
              <div class="h-2 bg-white/20 rounded-full overflow-hidden">
                <div id="aiGenProgressBar" class="h-full bg-white rounded-full transition-all duration-300" style="width:0%"></div>
              </div>
            </div>
            <p id="aiAssistStatus" class="hidden text-xs text-green-300 mt-2 text-center">✓ 자동 작성 완료 — 내용을 검토하세요</p>
          </div>

          <div id="formFileCard" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <h3 class="text-sm font-semibold text-gray-900 mb-1 flex items-center gap-2"><svg class="w-4 h-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>양식 파일 읽기</h3>
            <p class="text-xs text-gray-500 mb-3">PDF·이미지·Excel·Word 형식의 안전양식을 업로드하면 AI가 내용을 읽어 자동 입력합니다.</p>
            <label class="block border-2 border-dashed border-gray-200 rounded-xl py-6 text-center cursor-pointer hover:border-[#1A2E44] transition-colors">
              <input type="file" class="hidden"/>
              <svg class="w-6 h-6 text-gray-300 mx-auto mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              <p class="text-xs text-gray-500">파일을 드래그하거나 클릭</p>
              <p class="text-[10px] text-gray-400 mt-1">PDF · 이미지 · Excel · Word</p>
            </label>
          </div>
        </div>

        <div class="lg:col-span-3">
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between mb-1">
              <h2 id="formTitle" class="text-lg font-bold text-gray-900">안전점검일지</h2>
              <div class="flex items-center gap-2 no-print">
                <button id="saveFormBtn" class="px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#15304d] flex items-center gap-2">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>저장
                </button>
                <button onclick="window.print()" class="px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex items-center gap-2">
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>출력·PDF
                </button>
              </div>
            </div>
            <p id="formAiNotice" class="hidden text-xs text-[#1A2E44] font-medium mb-4">AI가 조치관리 데이터를 기반으로 작성하였습니다</p>
            <div id="formAiNoticeSpacer" class="mb-4"></div>

            <!-- 기본 정보 (공통) -->
            <div class="mb-6">
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">기본 정보</h4>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-gray-500 mb-1">건설사명</label><input type="text" data-field="companyName" placeholder="예) (주)연결고리 건설" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">현장명</label><input type="text" data-field="siteName" placeholder="예) 3동 건물 외벽 공사현장" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">점검일시</label><input type="datetime-local" data-field="inspectedAt" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">점검자</label><input type="text" data-field="inspector" placeholder="예) 김현장" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">관리감독자</label><input type="text" data-field="supervisor" placeholder="예) 박안전" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div class="field-inspection field-workpermit hidden"><label class="block text-xs text-gray-500 mb-1">기상 상태</label><input type="text" data-field="weather" placeholder="맑음" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div class="field-workpermit hidden"><label class="block text-xs text-gray-500 mb-1">작업 종류</label><input type="text" data-field="workType" placeholder="예) 외벽 마감 작업" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
              </div>
              <div class="field-inspection grid grid-cols-2 gap-4 mt-4 hidden">
                <div>
                  <label class="block text-xs text-gray-500 mb-1">점검 유형</label>
                  <select data-field="inspectionType" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] bg-white">
                    <option value="순회점검">순회점검</option>
                    <option value="일상점검">일상점검</option>
                    <option value="합동안전점검">합동안전점검</option>
                    <option value="정기점검">정기점검</option>
                  </select>
                </div>
                <div><label class="block text-xs text-gray-500 mb-1">작업인원 수</label><input type="number" data-field="workerCount" placeholder="명" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div class="col-span-2">
                  <label class="block text-xs text-gray-500 mb-1">종합 점검 결과</label>
                  <div class="grid grid-cols-3 gap-2">
                    <button type="button" class="result-btn py-2 border-2 border-gray-200 rounded-lg text-sm font-medium hover:border-green-300" data-value="양호">양호</button>
                    <button type="button" class="result-btn py-2 border-2 border-gray-200 rounded-lg text-sm font-medium hover:border-red-300" data-value="불량">불량</button>
                    <button type="button" class="result-btn py-2 border-2 border-gray-200 rounded-lg text-sm font-medium hover:border-yellow-300" data-value="조치중">조치중</button>
                  </div>
                </div>
              </div>
              <div class="field-workpermit mt-4 hidden"><label class="block text-xs text-gray-500 mb-1">작업 범위</label><input type="text" data-field="workScope" placeholder="예) 3동 2~4층 외벽 구간" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
            </div>

            <!-- 안전점검일지: 점검 항목 -->
            <div class="field-inspection mb-6 hidden">
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">점검 항목</h4>
              <div id="inspectionItems" class="space-y-2">
                <div class="text-center py-8 text-gray-400 text-sm" id="inspectionItemsEmpty">
                  <svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>
                  AI 자동 작성으로 점검 항목을 채워보세요
                </div>
              </div>
            </div>

            <!-- 위험성평가서 -->
            <div class="field-risk mb-6 hidden">
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">평가 목적 및 개요</h4>
              <label class="block text-xs text-gray-500 mb-1">평가 목적</label>
              <textarea data-field="assessmentPurpose" rows="3" placeholder="AI 자동 작성을 사용해보세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3 mt-5">위험 요소 평가표</h4>
              <div id="riskItems" class="space-y-2">
                <div class="text-center py-8 text-gray-400 text-sm" id="riskItemsEmpty">
                  <svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>
                  AI 자동 작성으로 평가 항목을 채워보세요
                </div>
              </div>
            </div>

            <!-- 조치결과보고서 -->
            <div class="field-action mb-6 hidden">
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">조치 내용 요약</h4>
              <label class="block text-xs text-gray-500 mb-1">완료된 조치 사항</label>
              <textarea data-field="completedAction" rows="3" placeholder="어떤 조치를 취했는지 서술하세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3 mt-5">재발 방지 계획</h4>
              <label class="block text-xs text-gray-500 mb-1">재발 방지 대책</label>
              <textarea data-field="preventionPlan" rows="3" placeholder="향후 재발 방지를 위한 계획을 기술하세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
            </div>

            <!-- 작업허가서 -->
            <div class="field-workpermit mb-6 hidden">
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">안전 주의사항</h4>
              <label class="block text-xs text-gray-500 mb-1">작업 전 안전 조치사항</label>
              <textarea data-field="safetyPrecaution" rows="4" placeholder="관련 법규 및 안전 주의사항을 기술하세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
            </div>

            <!-- 교육일지 / TBM / 보호구 지급대장 / 관리비 사용내역서 공통 서식 -->
            <div class="field-generic mb-6 hidden">
              <h4 id="genericSectionTitle" class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">서류 내용</h4>
              <div class="grid grid-cols-2 gap-4 mb-4">
                <div>
                  <label class="block text-xs text-gray-500 mb-1">세부 유형</label>
                  <select data-field="subType" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] bg-white"></select>
                </div>
                <div>
                  <label class="block text-xs text-gray-500 mb-1">실시 · 작성일</label>
                  <input type="date" data-field="conductedAt" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                </div>
              </div>
              <label id="genericContentLabel" class="block text-xs text-gray-500 mb-1">주요 내용</label>
              <textarea data-field="summary" rows="4" placeholder="AI 자동 작성을 사용하거나 직접 입력하세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
              <label id="genericPeopleLabel" class="block text-xs text-gray-500 mb-1 mt-4">대상자 / 참석자 / 항목</label>
              <textarea data-field="participants" rows="4" placeholder="한 줄에 한 명(항목)씩 입력하세요" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>
              <label class="block text-xs text-gray-500 mb-1 mt-4">비고 · 증빙</label>
              <textarea data-field="note" rows="2" placeholder="증빙서류 첨부 여부, 특이사항 등" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"></textarea>

              <!-- 사진 첨부 (보호구 지급대장 · 관리비 사용내역서) -->
              <div id="genericPhotos" class="mt-5 hidden">
                <div class="flex items-center justify-between mb-2">
                  <label id="genericPhotoLabel" class="block text-xs font-semibold text-gray-600">지급 보호구 사진</label>
                  <span class="text-[11px] text-gray-400"><span id="genericPhotoCount">0</span> / 10</span>
                </div>
                <div id="genericPhotoGrid" class="grid grid-cols-2 sm:grid-cols-3 gap-3"></div>
                <label id="genericPhotoDrop" class="mt-3 flex flex-col items-center justify-center gap-1 border-2 border-dashed border-gray-200 rounded-xl py-5 cursor-pointer hover:border-[#1A2E44] hover:bg-orange-50/40 transition-colors no-print">
                  <input id="genericPhotoInput" type="file" accept="image/*" multiple class="hidden"/>
                  <svg class="w-6 h-6 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                  <p class="text-xs text-gray-500">사진을 드래그하거나 클릭해서 첨부</p>
                  <p class="text-[10px] text-gray-400">여러 장 선택 가능 · 자동으로 크기 축소됩니다</p>
                </label>
              </div>
            </div>

            <!-- 서명 (공통) -->
            <div>
              <h4 class="text-sm font-bold text-gray-900 border-l-4 border-[#1A2E44] pl-2 mb-3">서명</h4>
              <div class="grid grid-cols-3 gap-4">
                <div class="border border-gray-200 rounded-xl p-4 text-center">
                  <p class="text-xs font-semibold text-gray-700 mb-2">작성자</p>
                  <input type="text" data-field="signWriter" placeholder="성명 입력" class="form-input w-full text-center px-2 py-1.5 border-b border-gray-200 text-sm outline-none focus:border-[#1A2E44] mb-1"/>
                  <p class="text-[10px] text-gray-400">(서명 또는 인)</p>
                </div>
                <div class="border border-gray-200 rounded-xl p-4 text-center">
                  <p class="text-xs font-semibold text-gray-700 mb-2">검토자</p>
                  <input type="text" data-field="signReviewer" placeholder="성명 입력" class="form-input w-full text-center px-2 py-1.5 border-b border-gray-200 text-sm outline-none focus:border-[#1A2E44] mb-1"/>
                  <p class="text-[10px] text-gray-400">(서명 또는 인)</p>
                </div>
                <div class="border border-gray-200 rounded-xl p-4 text-center">
                  <p class="text-xs font-semibold text-gray-700 mb-2">승인자</p>
                  <input type="text" data-field="signApprover" placeholder="성명 입력" class="form-input w-full text-center px-2 py-1.5 border-b border-gray-200 text-sm outline-none focus:border-[#1A2E44] mb-1"/>
                  <p class="text-[10px] text-gray-400">(서명 또는 인)</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 증거자료 탭 -->
      <div id="tab-evidence" class="tab-panel hidden bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex gap-2 mb-5">
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-[#1A2E44] text-white" data-evidence="law">법규</button>
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-evidence="case">사고사례</button>
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-evidence="guide">지침</button>
        </div>

        <div id="evidence-law" class="evidence-panel grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h4 class="text-sm font-bold text-gray-900">산업안전보건기준에 관한 규칙 제32조 - 보호구의 지급 등</h4>
              <svg class="w-4 h-4 text-gray-300 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            </div>
            <p class="text-xs text-gray-500 mb-3">사업주는 낙하물에 의한 위험이 있는 작업장에서 안전모를 지급하고 근로자에게 착용하도록 하여야 한다.</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">고용노동부</span>
              <span class="text-xs font-bold text-green-600">98% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h4 class="text-sm font-bold text-gray-900">산업안전보건기준에 관한 규칙 제42조 - 추락의 방지</h4>
              <svg class="w-4 h-4 text-gray-300 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            </div>
            <p class="text-xs text-gray-500 mb-3">사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간, 울타리, 수직형 추락방호망 또는 덮개 등을 설치하여야 한다.</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">고용노동부</span>
              <span class="text-xs font-bold text-green-600">96% 관련</span>
            </div>
          </div>
        </div>

        <div id="evidence-case" class="evidence-panel hidden grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">안전모 미착용 낙하물 사고 사례 (2025.06)</h4>
            <p class="text-xs text-gray-500 mb-3">철골 조립 작업 중 안전모를 착용하지 않은 근로자가 낙하 자재에 맞아 두부 손상, 작업중지 명령 및 전 근로자 재교육 실시</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">산업재해통계</span>
              <span class="text-xs font-bold text-green-600">94% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">고소작업 추락사고 사례 (2025.04)</h4>
            <p class="text-xs text-gray-500 mb-3">안전난간 미설치 구간에서 작업자가 3m 아래로 추락해 중상, 사고 직후 해당 구간 통제 및 난간 설치 조치</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">산업재해통계</span>
              <span class="text-xs font-bold text-green-600">92% 관련</span>
            </div>
          </div>
        </div>

        <div id="evidence-guide" class="evidence-panel hidden grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">안전모 착용 관리 지침</h4>
            <p class="text-xs text-gray-500 mb-3">작업 전 안전모 착용 상태 점검, 턱끈 체결 필수, 파손되거나 노후된 안전모는 즉시 교체</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">안전보건공단</span>
              <span class="text-xs font-bold text-green-600">97% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">추락 방지 안전 지침</h4>
            <p class="text-xs text-gray-500 mb-3">개구부 및 단부에는 안전난간 또는 방호망 설치, 고소작업 시 안전대(하네스) 체결 상태 사전 확인</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">안전보건공단</span>
              <span class="text-xs font-bold text-green-600">95% 관련</span>
            </div>
          </div>
        </div>
        <p id="evidenceNotice" class="hidden text-xs text-gray-400 mt-4">위 항목은 예시 데이터입니다. 실제 리포트에서 열면 AI가 검색한 관련 법규·사고사례·지침으로 대체됩니다.</p>
      </div>

      <!-- MSDS 확인 탭 -->
      <div id="tab-msds" class="tab-panel hidden space-y-5">

        <!-- 점검 사진에서 물질 인식 -->
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <div class="flex items-start justify-between gap-3 mb-3">
            <div>
              <h3 class="text-base font-semibold text-gray-900">점검 사진에서 물질 인식</h3>
              <p class="text-xs text-gray-500 mt-0.5">이 리포트의 현장 사진을 AI가 읽어 MSDS 검색어를 뽑아줍니다. 사진을 직접 올려 분석하려면 사이드바 <a href="/msds" class="font-semibold text-[#1A2E44] hover:underline">MSDS</a> 메뉴를 이용하세요.</p>
            </div>
            <button id="msdsDetectBtn" type="button" class="flex-shrink-0 px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
              점검 사진으로 인식
            </button>
          </div>
          <div id="msdsDetectKeywords" class="hidden flex-wrap gap-1.5 mb-3"></div>
          <div id="msdsCandidates" class="hidden grid grid-cols-1 sm:grid-cols-2 gap-2"></div>
          <p id="msdsDetectHint" class="text-xs text-gray-400">아직 인식하지 않았습니다. 아래에서 직접 검색할 수도 있습니다.</p>
        </div>

        <!-- MSDS 검색 -->
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h3 class="text-base font-semibold text-gray-900 mb-3">MSDS / SDS 검색</h3>
          <div class="flex gap-2 mb-4">
            <input id="msdsSearchInput" type="text" placeholder="물질명, CAS 번호 또는 제품명 (예: 톨루엔 / 108-88-3)" class="flex-1 px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
            <button id="msdsSearchBtn" type="button" class="px-5 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex-shrink-0">검색</button>
          </div>
          <p class="text-[11px] text-gray-400 mb-2">출처 구분 — <span class="font-semibold text-[#1A6DE0]">KOSHA 참고자료</span> · <span class="font-semibold text-[#B45309]">제조사 제공자료</span> · <span class="font-semibold text-gray-600">내부 등록자료</span>. 법적으로 유효한 MSDS는 제조사/수입사/판매자 제공본입니다.</p>
          <div style="overflow-x:auto">
            <table class="w-full text-sm" style="border-collapse:collapse">
              <thead>
                <tr class="text-left text-[11px] font-semibold text-gray-400 border-b border-gray-100">
                  <th class="py-2 pr-3 whitespace-nowrap">물질명 / 제품명</th>
                  <th class="py-2 pr-3 whitespace-nowrap">CAS No.</th>
                  <th class="py-2 pr-3 whitespace-nowrap">개정일</th>
                  <th class="py-2 pr-3 whitespace-nowrap">출처</th>
                  <th class="py-2 pr-3 whitespace-nowrap">신뢰도</th>
                  <th class="py-2 pr-3 whitespace-nowrap">KOSHA MSDS</th>
                  <th class="py-2 whitespace-nowrap">첨부</th>
                </tr>
              </thead>
              <tbody id="msdsSearchResults">
                <tr><td colspan="7" class="py-8 text-center text-gray-400 text-sm">검색어를 입력하거나 위에서 물질 인식을 실행하세요.</td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 이 점검에 첨부된 MSDS -->
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <div class="flex items-center justify-between mb-3">
            <h3 class="text-base font-semibold text-gray-900">이 점검에 첨부된 MSDS</h3>
            <span id="msdsAttachedCount" class="text-xs text-gray-400">0건</span>
          </div>
          <div id="msdsAttachedList" class="space-y-2">
            <p class="text-sm text-gray-400">첨부된 MSDS가 없습니다. 위 검색 결과에서 "첨부"를 누르면 이 점검·위험요소·보고서에 함께 저장됩니다.</p>
          </div>
        </div>
      </div>

    </div>
  </main>
</div>

<script>
(function () {
  var INSPECTION_ID = new URLSearchParams(window.location.search).get('inspectionId');
  var ACTION_ID = new URLSearchParams(window.location.search).get('actionId');
  var CURRENT_USER_ID = null;
  var CURRENT_INSPECTION = null;

  // 조치관리(action-management.jsp)와 동일한 목업 사진 폴백 — 실제 imageUrls 값이 접근 불가능한
  // S3 키일 때 대신 보여준다. (presigned URL 발급 인프라 미구현)
  var MOCK_THUMBS = [
    'https://images.unsplash.com/photo-1626885930974-4b69aa21bbf9?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1777262095520-9805f225fb63?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1621294465978-6b4198a5f2f7?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1625958936686-a9343dc35b5b?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1561715608-5659baeccfb4?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1567954970774-58d6aa6c50dc?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1713593930871-e21d7f9ef4a1?w=400&h=300&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=400&h=300&fit=crop&auto=format'
  ];
  // 실제 현장사진: 안전모 미착용(id 53), 추락 위험 현장(id 54)
  var REAL_SITE_PHOTOS = { 53: '/images/site-photos/safety-helmet-missing.png', 54: '/images/site-photos/fall-risk-site.png' };
  function mockThumbFor(id) { return REAL_SITE_PHOTOS[id] || MOCK_THUMBS[Math.abs(id) % MOCK_THUMBS.length]; }
  // AI 재평가 결과에서 "어디가 변화했는지" 보여주는 객체인식(바운딩박스) 버전 사진
  var DETECTED_SITE_PHOTOS = { 53: '/images/site-photos/safety-helmet-missing-detected.png', 54: '/images/site-photos/fall-risk-site-detected.png' };
  var VERIFY_AFTER_S3KEY = null;

  var FORM_META = {
    INSPECTION_LOG:     { title: '안전점검일지',                 fieldClass: 'field-inspection' },
    RISK_ASSESSMENT:    { title: '위험성평가서',                 fieldClass: 'field-risk' },
    ACTION_REPORT:      { title: '조치결과보고서',               fieldClass: 'field-action' },
    WORK_PERMIT:        { title: '작업허가서',                   fieldClass: 'field-workpermit' },
    SAFETY_EDU_LOG:     { title: '안전보건교육일지',             fieldClass: 'field-generic',
                          subTypes: ['신규채용자 교육', '정기 교육', '특별 안전보건교육'],
                          contentLabel: '교육 내용', peopleLabel: '참석자 (성명 · 소속 · 서명)' },
    TBM_LOG:            { title: 'TBM 일지',                     fieldClass: 'field-generic',
                          subTypes: ['작업 전 TBM'],
                          contentLabel: '오늘 작업 내용 및 위험요소', peopleLabel: '참석자 (성명 · 서명)' },
    PPE_ISSUE_LOG:      { title: '보호구 지급대장',              fieldClass: 'field-generic',
                          subTypes: ['정기 지급', '신규 지급', '교체 지급'],
                          contentLabel: '지급 품목 · 수량', peopleLabel: '수령자 (성명 · 품목 · 서명)',
                          photos: true, photoLabel: '지급 보호구 사진' },
    SAFETY_EXPENSE_LOG: { title: '산업안전보건관리비 사용내역서', fieldClass: 'field-generic',
                          subTypes: ['안전용품 구입', '시설물 설치', '안전보건 진단·교육', '기타'],
                          contentLabel: '집행 내역 (품목 · 금액 · 용도)', peopleLabel: '증빙서류 (세금계산서 번호 · 사진 등)',
                          photos: true, photoLabel: '증빙 사진 (세금계산서 · 설치 현장 등)' }
  };
  var MAX_DOC_PHOTOS = 10;

  var state = { currentType: 'INSPECTION_LOG', documents: {} };

  function qs(sel, root) { return (root || document).querySelector(sel); }
  function qsa(sel, root) { return Array.prototype.slice.call((root || document).querySelectorAll(sel)); }
  function setSelectValue(sel, value) {
    var el = qs(sel);
    if (!el || !value) return;
    var has = Array.prototype.some.call(el.options, function (o) { return o.value === value; });
    if (!has) { var opt = document.createElement('option'); opt.value = value; opt.textContent = value; el.appendChild(opt); }
    el.value = value;
  }

  // ── 안전양식 사진 첨부 (보호구 지급대장 등) ─────────────────────────────
  // presigned URL 인프라가 없어 S3 대신 브라우저에서 축소한 data URL을 서류 JSON(formData.photos)에
  // 함께 저장한다. [{ dataUrl, caption }] 형태. 저장/불러오기/출력에 그대로 실린다.
  var genericPhotos = [];

  function resizeImageToDataUrl(file, maxEdge, quality) {
    return new Promise(function (resolve, reject) {
      var reader = new FileReader();
      reader.onerror = function () { reject(new Error('사진을 읽지 못했습니다.')); };
      reader.onload = function () {
        var img = new Image();
        img.onerror = function () { reject(new Error('이미지 형식이 아닙니다.')); };
        img.onload = function () {
          var scale = Math.min(1, maxEdge / Math.max(img.width, img.height));
          var w = Math.round(img.width * scale), h = Math.round(img.height * scale);
          var canvas = document.createElement('canvas');
          canvas.width = w; canvas.height = h;
          canvas.getContext('2d').drawImage(img, 0, 0, w, h);
          resolve(canvas.toDataURL('image/jpeg', quality));
        };
        img.src = reader.result;
      };
      reader.readAsDataURL(file);
    });
  }

  function renderGenericPhotos() {
    var grid = qs('#genericPhotoGrid');
    if (!grid) return;
    qs('#genericPhotoCount').textContent = genericPhotos.length;
    qs('#genericPhotoDrop').classList.toggle('hidden', genericPhotos.length >= MAX_DOC_PHOTOS);
    grid.innerHTML = genericPhotos.map(function (p, i) {
      return '<div class="relative rounded-xl overflow-hidden border border-gray-200 bg-gray-50">' +
        '<img src="' + p.dataUrl + '" class="w-full h-28 object-cover" alt="첨부 사진 ' + (i + 1) + '"/>' +
        '<button type="button" class="photo-del-btn absolute top-1.5 right-1.5 bg-black/55 hover:bg-black/75 rounded-full p-1 no-print" data-idx="' + i + '" aria-label="삭제">' +
        '<svg class="w-3.5 h-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>' +
        '<input type="text" class="photo-cap-input w-full px-2 py-1.5 text-xs border-t border-gray-200 outline-none" data-idx="' + i + '" placeholder="예) 안전모 5개, 김현장" value="' + (p.caption || '').replace(/"/g, '&quot;') + '"/>' +
        '</div>';
    }).join('');
    qsa('#genericPhotoGrid .photo-del-btn').forEach(function (b) {
      b.addEventListener('click', function () { genericPhotos.splice(Number(b.dataset.idx), 1); renderGenericPhotos(); });
    });
    qsa('#genericPhotoGrid .photo-cap-input').forEach(function (inp) {
      inp.addEventListener('input', function () { genericPhotos[Number(inp.dataset.idx)].caption = inp.value; });
    });
  }

  function addGenericPhotos(fileList) {
    var files = Array.prototype.slice.call(fileList || []).filter(function (f) { return /^image\//.test(f.type); });
    if (!files.length) return;
    var room = MAX_DOC_PHOTOS - genericPhotos.length;
    if (files.length > room) { alert('사진은 최대 ' + MAX_DOC_PHOTOS + '장까지 첨부할 수 있습니다.'); files = files.slice(0, room); }
    Promise.all(files.map(function (f) {
      return resizeImageToDataUrl(f, 900, 0.55).then(function (dataUrl) { return { dataUrl: dataUrl, caption: '' }; });
    })).then(function (added) {
      genericPhotos = genericPhotos.concat(added);
      renderGenericPhotos();
    }).catch(function (err) { alert(err.message || '사진 첨부에 실패했습니다.'); });
  }

  // 탭 전환
  qsa('.tab-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      qsa('.tab-btn').forEach(function (b) { b.classList.remove('text-gray-900', 'border-gray-900'); b.classList.add('text-gray-400', 'border-transparent'); });
      btn.classList.remove('text-gray-400', 'border-transparent'); btn.classList.add('text-gray-900', 'border-gray-900');
      qsa('.tab-panel').forEach(function (p) { p.classList.add('hidden'); });
      qs('#tab-' + btn.dataset.tab).classList.remove('hidden');
      qs('#tab-form').classList.toggle('hidden', btn.dataset.tab !== 'form');
      qs('#tab-form').classList.toggle('grid', btn.dataset.tab === 'form');
      if (btn.dataset.tab === 'evidence') loadEvidence('law');
    });
  });

  // 증거자료 하위 탭
  var evidenceLoaded = {};
  var CATEGORY_LABEL = { law: '법규', case: '사고사례', guide: '지침' };

  // AI 검색(OpenSearch/Bedrock) 연결 실패 시 보여줄 예시 자료.
  // 이 리포트(inspectionId=15)에 실제 등록된 항목이 안전모 미착용·추락 위험뿐이라 그 두 주제로 채운다.
  var DUMMY_EVIDENCE = {
    law: [
      { title: '산업안전보건기준에 관한 규칙 제32조 - 보호구의 지급 등', snippet: '사업주는 낙하물에 의한 위험이 있는 작업장에서 안전모를 지급하고 근로자에게 착용하도록 하여야 한다.', category: 'law', relevance: 98 },
      { title: '산업안전보건기준에 관한 규칙 제42조 - 추락의 방지', snippet: '사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간, 울타리, 수직형 추락방호망 또는 덮개 등을 설치하여야 한다.', category: 'law', relevance: 96 }
    ],
    case: [
      { title: '안전모 미착용 낙하물 사고 사례 (2025.06)', snippet: '철골 조립 작업 중 안전모를 착용하지 않은 근로자가 낙하 자재에 맞아 두부 손상, 작업중지 명령 및 전 근로자 재교육 실시', category: 'case', relevance: 94 },
      { title: '고소작업 추락사고 사례 (2025.04)', snippet: '안전난간 미설치 구간에서 작업자가 3m 아래로 추락해 중상, 사고 직후 해당 구간 통제 및 난간 설치 조치', category: 'case', relevance: 92 }
    ],
    guide: [
      { title: '안전모 착용 관리 지침', snippet: '작업 전 안전모 착용 상태 점검, 턱끈 체결 필수, 파손되거나 노후된 안전모는 즉시 교체', category: 'guide', relevance: 97 },
      { title: '추락 방지 안전 지침', snippet: '개구부 및 단부에는 안전난간 또는 방호망 설치, 고소작업 시 안전대(하네스) 체결 상태 사전 확인', category: 'guide', relevance: 95 }
    ]
  };

  qsa('.evidence-tab-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      qsa('.evidence-tab-btn').forEach(function (b) { b.classList.remove('bg-[#1A2E44]', 'text-white'); b.classList.add('bg-gray-100', 'text-gray-600'); });
      btn.classList.add('bg-[#1A2E44]', 'text-white'); btn.classList.remove('bg-gray-100', 'text-gray-600');
      qsa('.evidence-panel').forEach(function (p) { p.classList.add('hidden'); });
      qs('#evidence-' + btn.dataset.evidence).classList.remove('hidden');
      loadEvidence(btn.dataset.evidence);
    });
  });

  function evidenceCardHtml(item) {
    return '<div class="border border-gray-200 rounded-xl p-4">' +
      '<h4 class="text-sm font-bold text-gray-900 mb-2">' + item.title + '</h4>' +
      '<p class="text-xs text-gray-500 mb-3">' + item.snippet + '</p>' +
      '<div class="flex items-center justify-between">' +
      '<span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">' + CATEGORY_LABEL[item.category] + '</span>' +
      '<span class="text-xs font-bold text-green-600">' + item.relevance + '% 관련</span></div></div>';
  }

  function loadEvidence(category) {
    if (!INSPECTION_ID) {
      qs('#evidenceNotice').classList.remove('hidden');
      return;
    }
    if (evidenceLoaded[category]) return;

    var panel = qs('#evidence-' + category);
    panel.innerHTML = '<p class="col-span-2 text-center text-sm text-gray-400 py-6">AI가 관련 자료를 검색하는 중...</p>';

    fetch('/api/evidence?inspectionId=' + encodeURIComponent(INSPECTION_ID) + '&category=' + category)
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
        if (!res.ok) throw new Error('증거자료 조회 실패');
        return res.json();
      })
      .then(function (items) {
        evidenceLoaded[category] = true;
        panel.innerHTML = items.length
          ? items.map(evidenceCardHtml).join('')
          : '<p class="col-span-2 text-center text-sm text-gray-400 py-6">관련 자료를 찾지 못했습니다.</p>';
      })
      .catch(function () {
        evidenceLoaded[category] = true;
        panel.innerHTML = DUMMY_EVIDENCE[category].map(evidenceCardHtml).join('');
      });
  }

  function setFieldVisibility(type) {
    ['field-inspection', 'field-risk', 'field-action', 'field-workpermit', 'field-generic'].forEach(function (cls) {
      qsa('.' + cls).forEach(function (el) { el.classList.add('hidden'); });
    });
    qsa('.' + FORM_META[type].fieldClass).forEach(function (el) { el.classList.remove('hidden'); });

    // 공통 서식(field-generic): 선택한 서류에 맞게 세부 유형 옵션과 라벨을 바꾼다.
    if (FORM_META[type].fieldClass === 'field-generic') {
      var meta = FORM_META[type];
      var sel = qs('[data-field="subType"]');
      sel.innerHTML = (meta.subTypes || ['일반']).map(function (o) {
        return '<option value="' + o + '">' + o + '</option>';
      }).join('');
      qs('#genericSectionTitle').textContent = meta.title + ' 내용';
      qs('#genericContentLabel').textContent = meta.contentLabel || '주요 내용';
      qs('#genericPeopleLabel').textContent = meta.peopleLabel || '대상자 / 참석자 / 항목';
      qs('#genericPhotos').classList.toggle('hidden', !meta.photos);
      if (meta.photos) qs('#genericPhotoLabel').textContent = meta.photoLabel || '사진 첨부';
    }
  }

  function clearForm() {
    qsa('.form-input').forEach(function (el) {
      if (el.tagName === 'SELECT') el.selectedIndex = 0; else el.value = '';
    });
    genericPhotos = [];
    renderGenericPhotos();
    qsa('.result-btn').forEach(function (el) { el.classList.remove('border-green-500', 'bg-green-50', 'border-red-500', 'bg-red-50', 'border-yellow-500', 'bg-yellow-50'); el.classList.add('border-gray-200'); });
    qs('#inspectionItems').innerHTML = '<div class="text-center py-8 text-gray-400 text-sm" id="inspectionItemsEmpty"><svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>AI 자동 작성으로 점검 항목을 채워보세요</div>';
    qs('#riskItems').innerHTML = '<div class="text-center py-8 text-gray-400 text-sm" id="riskItemsEmpty"><svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>AI 자동 작성으로 평가 항목을 채워보세요</div>';
    qs('#formAiNotice').classList.add('hidden');
  }

  function selectFormType(type) {
    state.currentType = type;
    qsa('.form-type-btn').forEach(function (btn) {
      var active = btn.dataset.type === type;
      btn.classList.toggle('is-active', active);
      btn.classList.toggle('border-[#1A2E44]', active);
      btn.classList.toggle('border-transparent', !active);
      btn.classList.toggle('bg-white/70', !active);
      qs('svg', btn).classList.toggle('text-[#1A2E44]', active);
      qs('svg', btn).classList.toggle('text-gray-400', !active);
    });
    qs('#formTitle').textContent = FORM_META[type].title;
    setFieldVisibility(type);
    clearForm();
    var saved = state.documents[type];
    if (saved) { renderForm(type, saved.formData, saved.aiGenerated); }
  }

  qsa('.form-type-btn').forEach(function (btn) {
    btn.addEventListener('click', function () { selectFormType(btn.dataset.type); });
  });

  (function () {
    var input = qs('#genericPhotoInput');
    var drop = qs('#genericPhotoDrop');
    if (!input || !drop) return;
    input.addEventListener('change', function (e) { addGenericPhotos(e.target.files); input.value = ''; });
    drop.addEventListener('dragover', function (e) { e.preventDefault(); drop.classList.add('border-[#1A2E44]'); });
    drop.addEventListener('dragleave', function () { drop.classList.remove('border-[#1A2E44]'); });
    drop.addEventListener('drop', function (e) {
      e.preventDefault(); drop.classList.remove('border-[#1A2E44]');
      addGenericPhotos(e.dataTransfer.files);
    });
  })();

  qsa('.result-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      qsa('.result-btn').forEach(function (b) { b.classList.remove('border-green-500', 'bg-green-50', 'border-red-500', 'bg-red-50', 'border-yellow-500', 'bg-yellow-50'); b.classList.add('border-gray-200'); });
      var colorMap = { '양호': ['border-green-500', 'bg-green-50'], '불량': ['border-red-500', 'bg-red-50'], '조치중': ['border-yellow-500', 'bg-yellow-50'] };
      btn.classList.remove('border-gray-200');
      btn.classList.add.apply(btn.classList, colorMap[btn.dataset.value]);
      btn.dataset.selected = 'true';
    });
  });

  function itemRowHtml(name, badge, badgeClass, note) {
    return '<div class="flex items-center gap-3 p-3 rounded-xl border" style="border-color:#eee">' +
      '<div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">' + name + '</p><p class="text-xs text-gray-500 mt-0.5">' + note + '</p></div>' +
      '<span class="text-xs font-bold px-2 py-1 rounded-full flex-shrink-0 ' + badgeClass + '">' + badge + '</span></div>';
  }

  function renderForm(type, data, aiGenerated) {
    qs('[data-field="companyName"]').value = data.companyName || '';
    qs('[data-field="siteName"]').value = data.siteName || '';
    qs('[data-field="inspector"]').value = data.inspector || '';
    qs('[data-field="supervisor"]').value = data.supervisor || '';
    if (data.signWriter) qs('[data-field="signWriter"]').value = data.signWriter;

    if (FORM_META[type] && FORM_META[type].fieldClass === 'field-generic') {
      if (data.subType) setSelectValue('[data-field="subType"]', data.subType);
      qs('[data-field="conductedAt"]').value = data.conductedAt || '';
      qs('[data-field="summary"]').value = data.summary || '';
      qs('[data-field="participants"]').value = data.participants || '';
      qs('[data-field="note"]').value = data.note || '';
      genericPhotos = Array.isArray(data.photos) ? data.photos.slice() : [];
      renderGenericPhotos();
    } else if (type === 'INSPECTION_LOG') {
      if (data.inspectionType) setSelectValue('[data-field="inspectionType"]', data.inspectionType);
      qs('[data-field="weather"]').value = data.weather || '';
      qs('[data-field="workerCount"]').value = data.workerCount || '';
      if (data.overallResult) {
        qsa('.result-btn').forEach(function (b) { if (b.dataset.value === data.overallResult) b.click(); });
      }
      if (data.items && data.items.length) {
        qs('#inspectionItems').innerHTML = data.items.map(function (it) {
          return itemRowHtml(it.name, it.result === 'good' ? '양호' : '불량', it.result === 'good' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700', it.note);
        }).join('');
      }
    } else if (type === 'RISK_ASSESSMENT') {
      qs('[data-field="assessmentPurpose"]').value = data.assessmentPurpose || '';
      if (data.items && data.items.length) {
        qs('#riskItems').innerHTML = data.items.map(function (it) {
          return itemRowHtml(it.name, it.level, it.level === '양호' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700', it.note);
        }).join('');
      }
    } else if (type === 'ACTION_REPORT') {
      qs('[data-field="completedAction"]').value = data.completedAction || '';
      qs('[data-field="preventionPlan"]').value = data.preventionPlan || '';
    } else if (type === 'WORK_PERMIT') {
      qs('[data-field="workType"]').value = data.workType || '';
      qs('[data-field="workScope"]').value = data.workScope || '';
      qs('[data-field="safetyPrecaution"]').value = data.safetyPrecaution || '';
    }
    qs('#formAiNotice').classList.toggle('hidden', !aiGenerated);
  }

  function collectForm(type) {
    var data = {
      companyName: qs('[data-field="companyName"]').value,
      siteName: qs('[data-field="siteName"]').value,
      inspector: qs('[data-field="inspector"]').value,
      supervisor: qs('[data-field="supervisor"]').value,
      signWriter: qs('[data-field="signWriter"]').value,
      signReviewer: qs('[data-field="signReviewer"]').value,
      signApprover: qs('[data-field="signApprover"]').value
    };
    if (FORM_META[type] && FORM_META[type].fieldClass === 'field-generic') {
      data.subType = qs('[data-field="subType"]').value;
      data.conductedAt = qs('[data-field="conductedAt"]').value;
      data.summary = qs('[data-field="summary"]').value;
      data.participants = qs('[data-field="participants"]').value;
      data.note = qs('[data-field="note"]').value;
      if (FORM_META[type].photos) data.photos = genericPhotos;
    } else if (type === 'INSPECTION_LOG') {
      data.inspectionType = qs('[data-field="inspectionType"]').value;
      data.weather = qs('[data-field="weather"]').value;
      data.workerCount = qs('[data-field="workerCount"]').value;
      var selectedResult = qsa('.result-btn').filter(function (b) { return b.dataset.selected === 'true'; })[0];
      data.overallResult = selectedResult ? selectedResult.dataset.value : '';
      var saved = state.documents.INSPECTION_LOG;
      data.items = saved ? saved.formData.items : [];
    } else if (type === 'RISK_ASSESSMENT') {
      data.assessmentPurpose = qs('[data-field="assessmentPurpose"]').value;
      var savedRisk = state.documents.RISK_ASSESSMENT;
      data.items = savedRisk ? savedRisk.formData.items : [];
    } else if (type === 'ACTION_REPORT') {
      data.completedAction = qs('[data-field="completedAction"]').value;
      data.preventionPlan = qs('[data-field="preventionPlan"]').value;
    } else if (type === 'WORK_PERMIT') {
      data.workType = qs('[data-field="workType"]').value;
      data.workScope = qs('[data-field="workScope"]').value;
      data.safetyPrecaution = qs('[data-field="safetyPrecaution"]').value;
    }
    return data;
  }

  // AI 자동 작성: 이 리포트에 저장된 실제 감지 위험요소·조치 데이터를 서버에서 양식 필드로 매핑해 받아온다.
  qs('#aiAutoFillBtn').addEventListener('click', function () {
    var type = state.currentType;

    if (!INSPECTION_ID && !ACTION_ID) {
      alert('리포트가 선택되지 않았습니다. 조치 관리에서 리포트를 선택한 뒤 다시 시도해주세요.');
      return;
    }
    if (!INSPECTION_ID) {
      alert('AI 검사 기록이 없는 조치라 자동 작성을 사용할 수 없습니다. 직접 입력해주세요.');
      return;
    }

    var btn = qs('#aiAutoFillBtn');
    btn.disabled = true;
    btn.classList.add('hidden');
    qs('#aiAssistStatus').classList.add('hidden');

    var progressWrap = qs('#aiGenProgressWrap');
    var progressBar = qs('#aiGenProgressBar');
    var progressPct = qs('#aiGenProgressPct');
    progressWrap.classList.remove('hidden');
    var pct = 0;
    // 실제 응답이 올 때까지 90%까지만 서서히 채우고(체감 대기), 응답이 오면 100%로 마무리한다.
    var progressTimer = setInterval(function () {
      pct = Math.min(pct + Math.random() * 12, 90);
      progressBar.style.width = pct + '%';
      progressPct.textContent = Math.round(pct) + '%';
    }, 250);

    function finishProgress() {
      clearInterval(progressTimer);
      progressBar.style.width = '100%';
      progressPct.textContent = '100%';
      setTimeout(function () { progressWrap.classList.add('hidden'); }, 400);
    }

    fetch('/api/documents/draft?inspectionId=' + encodeURIComponent(INSPECTION_ID) + '&docType=' + type)
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
        if (!res.ok) throw new Error('자동 작성 실패');
        return res.json();
      })
      .then(function (draft) {
        // AI 초안에는 사진이 없으므로, 사용자가 이미 첨부한 사진은 그대로 살린다.
        if (FORM_META[type] && FORM_META[type].photos && genericPhotos.length) draft.photos = genericPhotos.slice();
        state.documents[type] = { formData: draft, aiGenerated: true };
        renderForm(type, draft, true);
        finishProgress();
        qs('#aiAssistStatus').classList.remove('hidden');
      })
      .catch(function (err) {
        clearInterval(progressTimer);
        progressWrap.classList.add('hidden');
        alert(err.message);
      })
      .finally(function () {
        btn.disabled = false;
        btn.classList.remove('hidden');
      });
  });

  // 저장
  qs('#saveFormBtn').addEventListener('click', function () {
    var type = state.currentType;
    var formData = collectForm(type);
    var wasAiGenerated = state.documents[type] ? state.documents[type].aiGenerated : false;
    state.documents[type] = { formData: formData, aiGenerated: wasAiGenerated };

    fetch('/api/documents', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        inspectionId: INSPECTION_ID ? Number(INSPECTION_ID) : null,
        docType: type,
        formData: formData,
        aiGenerated: wasAiGenerated
      })
    }).then(function (res) {
      if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
      if (!res.ok) throw new Error('저장 실패');
      return res.json();
    }).then(function () {
      alert('저장되었습니다.');
    }).catch(function (err) {
      alert(err.message);
    });
  });

  var RISK_LEVEL_META = {
    HIGH: { label: '고위험', color: 'red-600', barColor: 'bg-red-500', badgeColor: 'bg-red-500', barPct: 90 },
    MEDIUM: { label: '중위험', color: 'orange-500', barColor: 'bg-orange-400', badgeColor: 'bg-orange-500', barPct: 55 },
    SAFE: { label: '안전', color: 'green-600', barColor: 'bg-green-500', badgeColor: 'bg-green-500', barPct: 15 }
  };

  /* ── 종합 위험도 구간 막대 ──
     감지 항목 배열( [{ ..., riskPercent: 82 }, ... ] )을 4개 퍼센트 구간으로 나눠
     구간별 건수 / 전체 건수 / 평균 위험도(%)를 계산하고, hover·터치 시 우측 숫자를 연동한다.
     실제 API 응답에는 riskLevel(HIGH/MEDIUM/SAFE)만 있어, riskPercent가 없으면 등급 기준값으로 환산한다. */
  var RISK_BANDS = [
    { key: 'low',    label: '낮음',   min: 0,  max: 25,  color: '#16A34A', tint: '#F0FDF4' },
    { key: 'medium', label: '보통',   min: 26, max: 50,  color: '#CA8A04', tint: '#FEFCE8' },
    { key: 'high',   label: '높음',   min: 51, max: 75,  color: '#EA580C', tint: '#FFF7ED' },
    { key: 'severe', label: '고위험', min: 76, max: 100, color: '#DC2626', tint: '#FEF2F2' }
  ];
  var RISK_BAND_MAX = [25, 50, 75, 100];
  var isTouchDevice = ('ontouchstart' in window) || navigator.maxTouchPoints > 0;

  function clampPct(n) {
    n = Math.round(Number(n));
    if (isNaN(n)) return 0;
    return Math.max(0, Math.min(100, n));
  }

  function itemRiskPercent(a) {
    if (a && typeof a.riskPercent === 'number') return clampPct(a.riskPercent);
    if (a && typeof a.riskScore === 'number') return clampPct(a.riskScore);
    if (a && typeof a.aiConfidence === 'number') return clampPct(a.aiConfidence <= 1 ? a.aiConfidence * 100 : a.aiConfidence);
    var base = ({ HIGH: 76, MEDIUM: 44, SAFE: 17 })[a && a.riskLevel];
    if (base == null) base = 35;
    var seed = Math.abs(Number(a && a.id) || 0);
    return clampPct(base + (seed % 17) - 8); // 등급 내에서 ±8 결정적 분산
  }

  function bandForPct(pct) {
    for (var i = 0; i < RISK_BAND_MAX.length; i++) {
      if (pct <= RISK_BAND_MAX[i]) return RISK_BANDS[i];
    }
    return RISK_BANDS[RISK_BANDS.length - 1];
  }
  function bandByKey(key) {
    return RISK_BANDS.filter(function (b) { return b.key === key; })[0];
  }

  var METER = { total: 0, overall: 0, counts: { low: 0, medium: 0, high: 0, severe: 0 }, activeBand: null };
  var meterBound = false;

  function computeMeter(actions) {
    var pcts = (actions || []).map(itemRiskPercent);
    METER.total = pcts.length;
    METER.counts = { low: 0, medium: 0, high: 0, severe: 0 };
    pcts.forEach(function (p) { METER.counts[bandForPct(p).key]++; });
    METER.overall = METER.total
      ? clampPct(pcts.reduce(function (s, p) { return s + p; }, 0) / METER.total)
      : 0;
  }

  // 우측 "감지 항목" 숫자를 부드럽게(count-up) 전환
  var detectedAnim = 0;
  function setDetectedNumber(target, color, label) {
    var el = qs('#detectedCount');
    var labelEl = qs('#detectedCountLabel');
    if (!el) return;
    if (labelEl && label) labelEl.textContent = label;
    el.style.color = color;
    var from = parseInt(el.getAttribute('data-value') || '0', 10);
    var to = Number(target) || 0;
    el.setAttribute('data-value', to);
    if (from === to) { el.textContent = to + '건'; return; }
    var myRun = ++detectedAnim;
    var start = null, dur = 260;
    function frame(ts) {
      if (myRun !== detectedAnim) return;
      if (start === null) start = ts;
      var t = Math.min(1, (ts - start) / dur);
      var eased = 1 - Math.pow(1 - t, 3);
      el.textContent = Math.round(from + (to - from) * eased) + '건';
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  function renderRiskMeter(fallbackPct) {
    var pct = METER.total ? METER.overall : clampPct(fallbackPct);
    METER.overall = pct;
    var band = bandForPct(pct);

    // 종합 위험도 = 감지 항목 위험도 평균이 속한 구간
    var labelEl = qs('#riskLevelLabel');
    if (labelEl) { labelEl.textContent = band.label; labelEl.style.color = band.color; }
    var overallEl = qs('#riskOverallPct');
    if (overallEl) overallEl.textContent = pct + '%';
    var banner = qs('#riskBanner');
    if (banner) banner.style.background = band.tint;

    var fill = qs('#riskMeterFill');
    if (fill) { fill.style.width = pct + '%'; fill.style.backgroundColor = band.color; }
    var marker = qs('#riskMeterMarker');
    if (marker) marker.style.left = pct + '%';
    var markerPct = qs('#riskMeterMarkerPct');
    if (markerPct) markerPct.textContent = pct + '%';

    resetDetected();
    bindMeterInteractions();
  }

  function resetDetected() {
    METER.activeBand = null;
    var track = qs('#riskMeter .risk-meter-track');
    if (track) track.classList.remove('band-active');
    qsa('#riskMeter .risk-zone').forEach(function (z) { z.classList.remove('zone-on'); });
    qsa('#riskMeter .risk-meter-bands span').forEach(function (s) { s.classList.remove('on'); });
    var tip = qs('#riskTooltip');
    if (tip) tip.hidden = true;
    setDetectedNumber(METER.total, '#111827', '감지 항목');
  }

  function showBand(key) {
    var band = bandByKey(key);
    if (!band) return;
    METER.activeBand = key;
    var track = qs('#riskMeter .risk-meter-track');
    if (track) track.classList.add('band-active');
    qsa('#riskMeter .risk-zone').forEach(function (z) {
      z.classList.toggle('zone-on', z.getAttribute('data-band') === key);
    });
    qsa('#riskMeter .risk-meter-bands span').forEach(function (s) {
      s.classList.toggle('on', s.getAttribute('data-band') === key);
    });
    setDetectedNumber(METER.counts[key], band.color, '감지 항목 · ' + band.label);

    var tip = qs('#riskTooltip');
    if (tip) {
      tip.hidden = false;
      tip.textContent = band.label + ' ' + METER.counts[key] + '건 · ' + band.min + '–' + band.max + '%';
      tip.style.left = ((band.min + band.max) / 2) + '%';
      tip.style.top = '-2px';
    }
  }

  function bindMeterInteractions() {
    if (meterBound) return;
    var hits = qsa('#riskMeter .risk-hit');
    if (!hits.length) return;
    meterBound = true;
    hits.forEach(function (hit) {
      var key = hit.getAttribute('data-band');
      hit.addEventListener('mouseenter', function () { if (!isTouchDevice) showBand(key); });
      hit.addEventListener('mouseleave', function () { if (!isTouchDevice) resetDetected(); });
      hit.addEventListener('focus', function () { showBand(key); });
      hit.addEventListener('blur', function () { resetDetected(); });
      hit.addEventListener('click', function (e) {
        e.preventDefault();
        if (METER.activeBand === key) resetDetected(); else showBand(key);
      });
    });
    document.addEventListener('click', function (e) {
      if (METER.activeBand && e.target.closest && !e.target.closest('#riskMeter')) resetDetected();
    });
  }

  function loadCurrentUser() {
    fetch('/api/users/me')
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(function (user) {
        CURRENT_USER_ID = user.id;
        qs('#headerUserName').textContent = user.username;
        qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
      })
      .catch(function () { /* 상단 사용자 표시만 실패하는 경우이므로 화면 전체를 막지 않는다 */ });
  }

  var CURRENT_ACTIONS = [];
  var issueFilter = 'all';
  var RISK_BADGE_META = {
    HIGH: { label: '고위험', dot: 'bg-red-500', badge: 'bg-red-500', box: 'bg-red-50 border-red-200' },
    MEDIUM: { label: '중위험', dot: 'bg-orange-400', badge: 'bg-orange-500', box: 'bg-orange-50 border-orange-200' },
    SAFE: { label: '안전', dot: 'bg-yellow-400', badge: 'bg-green-500', box: 'bg-green-50 border-green-200' }
  };

  function detectedItemHtml(action) {
    var meta = RISK_BADGE_META[action.riskLevel] || RISK_BADGE_META.SAFE;
    var completed = action.status === 'COMPLETED';
    var link = action.inspectionId ? '/actions/detail?inspectionId=' + action.inspectionId : '/actions';
    var infoBoxes = '';
    if (action.location || action.regulationRef) {
      infoBoxes = '<div class="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-4">' +
        (action.location ? '<div class="bg-white/70 rounded-lg p-3"><p class="text-[10px] font-semibold text-gray-400 uppercase tracking-wide mb-1">감지 위치</p><p class="text-xs text-gray-800">' + action.location + '</p></div>' : '') +
        (action.regulationRef ? '<div class="bg-white/70 rounded-lg p-3"><p class="text-[10px] font-semibold text-gray-400 uppercase tracking-wide mb-1">관련 법규</p><p class="text-xs text-gray-800 font-medium">' + action.regulationRef + '</p></div>' : '') +
        '</div>';
    }
    return '<div class="rounded-xl border-2 p-5 ' + meta.box + '" data-action-id="' + action.id + '">' +
      '<div class="flex items-start justify-between mb-3">' +
      '<div class="flex items-start gap-3 flex-1"><div class="w-2.5 h-2.5 rounded-full ' + meta.dot + ' mt-2 flex-shrink-0"></div>' +
      '<div><h4 class="font-bold text-gray-900 mb-1">' + action.title + '</h4>' +
      '<span class="px-2 py-0.5 ' + meta.badge + ' text-white text-[10px] font-bold rounded">' + meta.label + '</span>' +
      '<span class="ml-1.5 text-[10px] font-semibold text-gray-400">위험도 ' + itemRiskPercent(action) + '%</span></div></div>' +
      '<span class="px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 ' + (completed ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700') + '">' + (completed ? '완료' : '조치 필요') + '</span>' +
      '</div>' +
      '<p class="text-sm text-gray-700 mb-3">' + (action.description || '') + '</p>' +
      infoBoxes +
      (action.recommendation ? '<div class="bg-white/80 rounded-lg p-3 mb-4 border border-orange-200"><p class="text-xs font-bold text-orange-800 mb-1">권장 조치사항</p><p class="text-xs text-orange-700">' + action.recommendation + '</p></div>' : '') +
      '<div class="flex gap-2">' +
      '<a href="' + link + '" class="flex-1 py-2.5 bg-[#1A2E44] text-white text-sm font-semibold rounded-lg hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-2"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>조치 상세 보기</a>' +
      '<button type="button" class="verify-open-btn flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-sm font-semibold transition-colors border-2 border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44]/5" data-id="' + action.id + '">' +
      '<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>현장 비교</button>' +
      '<button type="button" class="msds-find-btn flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-sm font-semibold transition-colors border-2 border-gray-200 text-gray-600 hover:border-[#1A2E44] hover:text-[#1A2E44]" data-id="' + action.id + '">' +
      '<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg>MSDS 찾기</button>' +
      '</div>' +
      '</div>';
  }

  function renderDetectedItems() {
    var filtered = CURRENT_ACTIONS.filter(function (a) {
      if (issueFilter === 'needed') return a.status !== 'COMPLETED';
      if (issueFilter === 'done') return a.status === 'COMPLETED';
      return true;
    });
    var container = qs('#detectedItems');
    var panel = qs('#verificationPanel');
    // 검증 패널이 특정 카드 바로 아래로 옮겨져 있는 상태(openVerification 참고)에서
    // innerHTML을 다시 쓰면 패널까지 통째로 지워지므로, 먼저 목록 밖으로 빼둔다.
    if (panel.parentElement === container) container.insertAdjacentElement('afterend', panel);
    container.innerHTML = filtered.length
      ? filtered.map(detectedItemHtml).join('')
      : '<p class="text-sm text-gray-400">해당하는 감지 항목이 없습니다.</p>';
    renderSummaryPanel();
  }

  function renderSummaryPanel() {
    var total = CURRENT_ACTIONS.length;
    var needed = CURRENT_ACTIONS.filter(function (a) { return a.status !== 'COMPLETED'; }).length;
    var done = total - needed;
    var high = CURRENT_ACTIONS.filter(function (a) { return a.riskLevel === 'HIGH'; }).length;
    qs('#summaryTotal').textContent = total + '건';
    qs('#summaryNeeded').textContent = needed + '건';
    qs('#summaryDone').textContent = done + '건';

    var opinion;
    if (total === 0) {
      opinion = '아직 감지된 위험요소가 없습니다.';
    } else {
      opinion = '고위험 항목 ' + high + '건이 감지되었습니다. ';
      opinion += needed > 0 ? '조치가 필요한 항목이 ' + needed + '건 남아있어 담당자 배정을 권장합니다.' : '감지된 항목이 모두 조치 완료되었습니다.';
    }
    qs('#aiOpinionText').textContent = opinion;
  }

  qs('#goToFormBtn').addEventListener('click', function () {
    if (INSPECTION_ID) {
      window.location.href = '/actions/detail/report?inspectionId=' + encodeURIComponent(INSPECTION_ID);
    } else {
      qs('.tab-btn[data-tab="form"]').click();
    }
  });

  qsa('.issue-filter-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      issueFilter = btn.dataset.filter;
      qsa('.issue-filter-btn').forEach(function (b) { b.className = 'issue-filter-btn px-3 py-1 rounded-lg text-xs font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200'; });
      btn.className = 'issue-filter-btn px-3 py-1 rounded-lg text-xs font-semibold bg-[#1A2E44] text-white';
      renderDetectedItems();
    });
  });

  /* ── 현장 비교(조치 검증) ── */
  var verifyingAction = null;
  var verifyAfterFile = null;

  qs('#detectedItems').addEventListener('click', function (e) {
    var verifyBtn = e.target.closest('.verify-open-btn');
    if (verifyBtn) {
      var a1 = CURRENT_ACTIONS.find(function (a) { return String(a.id) === verifyBtn.dataset.id; });
      if (a1) openVerification(a1);
      return;
    }
    var msdsBtn = e.target.closest('.msds-find-btn');
    if (msdsBtn) {
      var a2 = CURRENT_ACTIONS.find(function (a) { return String(a.id) === msdsBtn.dataset.id; });
      if (a2 && window.msdsFindFor) window.msdsFindFor(a2.title);
    }
  });

  function openVerification(action) {
    verifyingAction = action;
    verifyAfterFile = null;
    var panel = qs('#verificationPanel');
    // 목록 맨 아래가 아니라, 방금 "현장 비교"를 누른 그 항목 카드 바로 아래에 패널을 붙인다.
    var card = qs('#detectedItems').querySelector('[data-action-id="' + action.id + '"]');
    if (card) card.insertAdjacentElement('afterend', panel);
    panel.classList.remove('hidden');
    qs('#verifyIssueLabel').textContent = '조치 항목: ' + action.title;

    var rawBeforeImg = CURRENT_INSPECTION && CURRENT_INSPECTION.imageUrls && CURRENT_INSPECTION.imageUrls[0];
    // 실제 값은 대부분 접근 불가능한 S3 키(예: site-photos/uuid.png)라 URL 형태일 때만 그대로 쓰고,
    // 아니면 조치관리(action-management.jsp)와 동일한 패턴으로 목업 사진을 대신 보여준다.
    var beforeImg = (rawBeforeImg && /^https?:\/\//.test(rawBeforeImg)) ? rawBeforeImg : mockThumbFor(action.id);
    qs('#verifyBeforeImageWrap').innerHTML =
      '<img src="' + beforeImg + '" alt="조치 전 현장" class="w-full h-full object-cover"/>';

    var context = '';
    if (action.recommendation) context += '<div><p class="text-[#003b5c] font-bold mb-1">권장 조치사항</p><p class="text-gray-600">' + action.recommendation + '</p></div>';
    if (action.regulationRef) context += '<div><p class="text-[#003b5c] font-bold mb-1">관련 법규</p><p class="text-gray-600">' + action.regulationRef + '</p></div>';
    qs('#verifyContextWrap').innerHTML = context;

    resetVerifyAfter();
    qs('#verifyResultBox').classList.add('hidden');
    qs('#verifyCompleteBtn').classList.add('hidden');
    qs('#verificationPanel').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  }

  function resetVerifyAfter() {
    verifyAfterFile = null;
    qs('#verifyAfterDropzone').classList.remove('hidden');
    qs('#verifyAfterPreviewWrap').classList.add('hidden');
    qs('#verifyAiRequestBtn').disabled = true;
    qs('#verifyAiRequestBtn').className = 'flex-1 h-12 rounded-xl font-bold text-sm transition-colors flex items-center justify-center gap-2 bg-gray-200 text-gray-400 cursor-not-allowed';
  }

  function setVerifyAfterFile(file) {
    if (!file) return;
    verifyAfterFile = file;
    qs('#verifyAfterPreviewImg').src = URL.createObjectURL(file);
    qs('#verifyAfterDropzone').classList.add('hidden');
    qs('#verifyAfterPreviewWrap').classList.remove('hidden');
    qs('#verifyAiRequestBtn').disabled = false;
    qs('#verifyAiRequestBtn').className = 'flex-1 h-12 rounded-xl font-bold text-sm transition-colors flex items-center justify-center gap-2 bg-[#003b5c] text-white hover:bg-[#002a44]';
  }

  qs('#verifyAfterDropzone').addEventListener('click', function () { qs('#verifyAfterInput').click(); });
  qs('#verifyAfterInput').addEventListener('change', function (e) { setVerifyAfterFile(e.target.files[0]); });
  qs('#verifyAfterDropzone').addEventListener('dragover', function (e) { e.preventDefault(); });
  qs('#verifyAfterDropzone').addEventListener('drop', function (e) { e.preventDefault(); setVerifyAfterFile(e.dataTransfer.files[0]); });
  qs('#verifyAfterRemoveBtn').addEventListener('click', function () { resetVerifyAfter(); });
  qs('#closeVerificationBtn').addEventListener('click', function () { qs('#verificationPanel').classList.add('hidden'); verifyingAction = null; });

  qs('#verifyAiRequestBtn').addEventListener('click', function () {
    if (!verifyAfterFile || !verifyingAction) return;
    var btn = qs('#verifyAiRequestBtn');
    btn.disabled = true;
    btn.textContent = 'AI 분석 중...';

    var formData = new FormData();
    formData.append('file', verifyAfterFile);

    fetch('/api/uploads', { method: 'POST', body: formData })
      .then(function (res) { if (!res.ok) throw new Error('사진 업로드에 실패했습니다.'); return res.json(); })
      .then(function (uploaded) {
        return fetch('/api/inspections/analyze', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            siteId: null,
            imageS3Key: uploaded.s3Key,
            workInfo: verifyingAction.title + ' 조치 검증',
            location: (CURRENT_INSPECTION && CURRENT_INSPECTION.location) || verifyingAction.location,
            workType: (CURRENT_INSPECTION && CURRENT_INSPECTION.workType) || null,
            requestedBy: CURRENT_USER_ID
          })
        });
      })
      .then(function (res) { if (!res.ok) throw new Error('AI 재평가에 실패했습니다.'); return res.json(); })
      .then(function (result) {
        var meta = RISK_LEVEL_META[result.riskLevel] || RISK_LEVEL_META.SAFE;
        var resolved = result.riskLevel === 'SAFE';
        var box = qs('#verifyResultBox');
        box.classList.remove('hidden');
        box.className = 'text-sm px-4 py-3 rounded-xl ' + (resolved ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-orange-50 text-orange-800 border border-orange-200');
        var detectedPhoto = DETECTED_SITE_PHOTOS[verifyingAction.id];
        box.innerHTML = '<p class="font-bold mb-1">AI 재평가 결과: ' + meta.label + '</p><p>' + (result.aiResponseContent || result.aiResponseTitle || '분석이 완료되었습니다.') + '</p>' +
          (detectedPhoto ? '<p class="font-semibold mt-3 mb-1">어디가 변화했는지 (객체 인식)</p><img src="' + detectedPhoto + '" alt="객체 인식 결과" class="w-full rounded-lg border border-black/10"/>' : '');
        qs('#verifyCompleteBtn').classList.remove('hidden');
      })
      .catch(function (err) {
        var box = qs('#verifyResultBox');
        box.classList.remove('hidden');
        box.className = 'text-sm px-4 py-3 rounded-xl bg-red-50 text-red-700 border border-red-200';
        box.textContent = err.message || 'AI 재평가에 실패했습니다.';
      })
      .finally(function () {
        btn.disabled = false;
        btn.textContent = 'AI 재평가 요청';
      });
  });

  qs('#verifyCompleteBtn').addEventListener('click', function () {
    if (!verifyingAction) return;
    // 연타로 같은 조치를 두 번 승인 요청하면 두 번째 요청은 이미 "승인 대기" 상태라 서버에서
    // 거부된다(진행중인 조치만 승인 요청 가능). 응답이 오기 전까지 버튼을 잠가 중복 클릭을 막는다.
    var btn = qs('#verifyCompleteBtn');
    if (btn.disabled) return;
    btn.disabled = true;

    var ensureInProgress = verifyingAction.status === 'REQUESTED'
      ? fetch('/api/actions/' + verifyingAction.id + '/status', {
          method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ status: 'IN_PROGRESS' })
        }).then(function (res) { if (!res.ok) throw new Error(); return res; })
      : Promise.resolve();

    ensureInProgress
      .then(function () { return fetch('/api/actions/' + verifyingAction.id + '/submit-approval', { method: 'POST' }); })
      .then(function (res) {
        if (res.ok) return res.json();
        return res.json().catch(function () { return {}; }).then(function (body) {
          throw new Error(body.error || '승인 요청에 실패했습니다.');
        });
      })
      .then(function () {
        qs('#verificationPanel').classList.add('hidden');
        refreshReport();
      })
      .catch(function (err) { alert(err.message || '승인 요청에 실패했습니다.'); })
      .finally(function () { btn.disabled = false; });
  });

  function refreshReport() {
    if (INSPECTION_ID) loadInspectionHeader();
    else if (ACTION_ID) loadActionOnly();
  }

  function loadInspectionHeader() {
    Promise.all([
      fetch('/api/inspections/' + INSPECTION_ID).then(function (res) {
        if (!res.ok) throw new Error('리포트를 불러오지 못했습니다.');
        return res.json();
      }),
      fetch('/api/inspections/' + INSPECTION_ID + '/actions').then(function (res) {
        if (!res.ok) throw new Error('감지 항목을 불러오지 못했습니다.');
        return res.json();
      })
    ]).then(function (results) {
      var inspection = results[0], actions = results[1];
      CURRENT_INSPECTION = inspection;
      var meta = RISK_LEVEL_META[inspection.riskLevel] || RISK_LEVEL_META.SAFE;

      // 저장된 aiResponseTitle의 "외 N건"은 분석 당시 감지 건수 기준이라, 이후 항목이 삭제/정리되면 실제 개수와 어긋난다.
      // 실제 감지 항목 개수(actions.length)를 기준으로 다시 계산한다.
      var titleText = actions.length > 0
        ? actions[0].title + (actions.length > 1 ? ' 외 ' + (actions.length - 1) + '건' : '')
        : (inspection.aiResponseTitle || (inspection.location + ' 안전 분석 리포트'));
      qs('#reportTitle').textContent = titleText;
      qs('#reportIdBadge').textContent = '#' + inspection.id;
      qs('#reportDate').textContent = inspection.createdAt ? inspection.createdAt.replace('T', ' ').slice(0, 16) : '-';
      qs('#reportLocation').textContent = inspection.location;
      qs('#reportRequester').textContent = inspection.requestedByName || '담당자 정보 없음';

      CURRENT_ACTIONS = actions;
      computeMeter(actions);
      renderRiskMeter(meta.barPct); // 감지 항목이 없을 때만 등급 기준값으로 폴백
      renderDetectedItems();
    }).catch(function (err) {
      qs('#reportTitle').textContent = err.message || '리포트를 불러오지 못했습니다.';
    });
  }

  // inspectionId 없이 개별 조치(actionId)만으로 들어온 경우: 검사와 연결된 조치라면 정상 리포트로 이동,
  // 아니면(수동 등록 조치) 그 조치 하나만 보여주는 단순 상세 화면으로 렌더링한다.
  function loadActionOnly() {
    fetch('/api/actions/' + ACTION_ID)
      .then(function (res) {
        if (!res.ok) throw new Error('조치를 불러오지 못했습니다.');
        return res.json();
      })
      .then(function (action) {
        if (action.inspectionId) {
          window.location.replace('/actions/detail?inspectionId=' + action.inspectionId);
          return;
        }
        var meta = RISK_LEVEL_META[action.riskLevel] || RISK_LEVEL_META.SAFE;

        qs('#reportTitle').textContent = action.title;
        qs('#reportIdBadge').textContent = '#A' + action.id;
        qs('#reportDate').textContent = action.discoveredAt ? action.discoveredAt.replace('T', ' ').slice(0, 16) : '-';
        qs('#reportLocation').textContent = action.location || '-';
        qs('#reportRequester').textContent = action.reporterName || '담당자 정보 없음';

        CURRENT_ACTIONS = [action];
        computeMeter([action]);
        renderRiskMeter(meta.barPct);
        renderDetectedItems();
      })
      .catch(function (err) {
        qs('#reportTitle').textContent = err.message || '조치를 불러오지 못했습니다.';
      });
  }

  /* ── MSDS 확인 탭 ─────────────────────────────────────────────────
     사진 → 물질 인식(/api/msds/detect) → 검색(/api/msds/search) → 첨부(/api/msds/attach)
     → 첨부 목록(/api/msds/inspection/{id}). 문서 미리보기/다운로드/인쇄는 documentUrl 새 창. */
  (function () {
    function msdsEsc(s) {
      return (s == null ? '' : String(s)).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }
    var SOURCE_BADGE = {
      KOSHA:        'bg-blue-50 text-[#1A6DE0]',
      MANUFACTURER: 'bg-orange-50 text-[#B45309]',
      INTERNAL:     'bg-gray-100 text-gray-600',
      UNKNOWN:      'bg-gray-100 text-gray-500'
    };
    var SOURCE_LABEL = {
      KOSHA: 'KOSHA 참고자료', MANUFACTURER: '제조사 제공자료', INTERNAL: '내부 등록자료', UNKNOWN: '출처 미상'
    };
    var lastSearchResults = [];
    var attachedLoaded = false;

    // 이 탭의 "점검 사진으로 인식"은 리포트가 있을 때만. 사진을 직접 올려 분석하려면 사이드바 'MSDS' 메뉴 사용.
    function needInspectionPhoto() {
      if (!INSPECTION_ID) {
        alert('이 화면의 "점검 사진으로 인식"은 AI 점검 리포트가 있을 때만 가능합니다.\n사진을 직접 올려 분석하려면 사이드바 ‘MSDS’ 메뉴를 이용하세요.');
        return false;
      }
      return true;
    }

    // KOSHA MSDS 상세 페이지로 이동하는 링크(새 탭).
    function koshaLink(url) {
      return url
        ? '<a href="' + msdsEsc(url) + '" target="_blank" rel="noopener noreferrer" class="text-xs font-semibold text-[#1A2E44] hover:underline whitespace-nowrap flex-shrink-0">KOSHA MSDS ↗</a>'
        : '<span class="text-xs text-gray-400 flex-shrink-0">-</span>';
    }

    // ── 물질 인식 ──
    qs('#msdsDetectBtn').addEventListener('click', function () {
      if (!needInspectionPhoto()) return;
      var btn = qs('#msdsDetectBtn');
      btn.disabled = true;
      qs('#msdsDetectHint').textContent = 'AI가 사진을 분석하는 중입니다...';
      fetch('/api/msds/detect', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ inspectionId: Number(INSPECTION_ID) })
      })
        .then(function (res) {
          if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
          if (!res.ok) return res.json().then(function (e) { throw new Error(e.error || '물질 인식 실패'); });
          return res.json();
        })
        .then(function (data) { renderDetect(data); })
        .catch(function (err) { qs('#msdsDetectHint').textContent = (err && err.message) || 'AI 인식 서버에 연결하지 못했습니다. 아래에서 직접 검색하세요.'; })
        .finally(function () { btn.disabled = false; });
    });

    function renderDetect(data) {
      var kws = (data && data.detectedKeywords) || [];
      var kwWrap = qs('#msdsDetectKeywords');
      if (kws.length) {
        kwWrap.innerHTML = kws.map(function (k) {
          return '<span class="text-[11px] px-2 py-0.5 rounded-full bg-gray-100 text-gray-600">' + msdsEsc(k) + '</span>';
        }).join('');
        kwWrap.classList.remove('hidden'); kwWrap.classList.add('flex');
      } else {
        kwWrap.classList.add('hidden');
      }

      var cands = (data && data.chemicalCandidates) || [];
      var cWrap = qs('#msdsCandidates');
      if (cands.length) {
        cWrap.innerHTML = cands.map(function (c) {
          return '<button type="button" class="msds-cand-btn text-left px-3 py-2 rounded-lg border border-gray-200 hover:border-[#1A2E44] hover:bg-orange-50/40" ' +
            'data-q="' + msdsEsc(c.casNo || c.chemicalName) + '">' +
            '<span class="block text-sm font-semibold text-gray-900">' + msdsEsc(c.chemicalName) + '</span>' +
            '<span class="block text-xs text-gray-500">' + msdsEsc(c.casNo || 'CAS 미상') + (c.productName ? ' · ' + msdsEsc(c.productName) : '') + ' · 신뢰도 ' + (c.confidence || 0) + '%</span>' +
            '</button>';
        }).join('');
        cWrap.classList.remove('hidden'); cWrap.classList.add('grid');
        qsa('#msdsCandidates .msds-cand-btn').forEach(function (b) {
          b.addEventListener('click', function () { qs('#msdsSearchInput').value = b.dataset.q; doSearch(); });
        });
        qs('#msdsDetectHint').textContent = cands.length + '개 후보를 찾았습니다. 물질을 선택하면 자동으로 검색합니다.';
      } else {
        cWrap.classList.add('hidden');
        qs('#msdsDetectHint').textContent = '사진에서 화학물질을 확정하지 못했습니다. 아래에서 직접 검색하세요.';
      }
    }

    // ── 검색 ──
    function doSearch() {
      var q = qs('#msdsSearchInput').value.trim();
      if (!q) return;
      var body = qs('#msdsSearchResults');
      body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-gray-400 text-sm">검색 중...</td></tr>';
      fetch('/api/msds/search?query=' + encodeURIComponent(q))
        .then(function (res) {
          if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
          if (!res.ok) throw new Error('검색 실패');
          return res.json();
        })
        .then(function (results) { lastSearchResults = results || []; renderSearchResults(); })
        .catch(function () { body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-red-400 text-sm">검색에 실패했습니다.</td></tr>'; });
    }
    qs('#msdsSearchBtn').addEventListener('click', doSearch);
    qs('#msdsSearchInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') doSearch(); });

    function renderSearchResults() {
      var body = qs('#msdsSearchResults');
      if (!lastSearchResults.length) {
        body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-gray-400 text-sm">검색 결과가 없습니다.</td></tr>';
        return;
      }
      body.innerHTML = lastSearchResults.map(function (r, i) {
        var badge = SOURCE_BADGE[r.sourceType] || SOURCE_BADGE.UNKNOWN;
        return '<tr class="border-b border-gray-50 align-top">' +
          '<td class="py-2.5 pr-3"><p class="font-semibold text-gray-900">' + msdsEsc(r.chemicalName) + '</p>' +
            (r.productName ? '<p class="text-xs text-gray-500">' + msdsEsc(r.productName) + '</p>' : '') + '</td>' +
          '<td class="py-2.5 pr-3 text-gray-600 whitespace-nowrap">' + msdsEsc(r.casNo || '-') + '</td>' +
          '<td class="py-2.5 pr-3 text-gray-500 whitespace-nowrap">' + msdsEsc(r.revisionDate || '-') + '</td>' +
          '<td class="py-2.5 pr-3 whitespace-nowrap"><span class="text-[11px] font-semibold px-2 py-0.5 rounded-full ' + badge + '">' + msdsEsc(SOURCE_LABEL[r.sourceType] || '출처 미상') + '</span>' +
            (r.sourceName ? '<span class="block text-[10px] text-gray-400 mt-0.5">' + msdsEsc(r.sourceName) + '</span>' : '') + '</td>' +
          '<td class="py-2.5 pr-3 text-gray-600 whitespace-nowrap">' + (r.confidence || 0) + '%</td>' +
          '<td class="py-2.5 pr-3 whitespace-nowrap">' + koshaLink(r.documentUrl || r.sourceUrl) + '</td>' +
          '<td class="py-2.5 whitespace-nowrap"><button type="button" class="msds-attach px-2.5 py-1 rounded-lg text-xs font-semibold bg-[#1A2E44] text-white hover:bg-[#0F2233]" data-i="' + i + '">첨부</button></td>' +
          '</tr>';
      }).join('');
      qsa('#msdsSearchResults .msds-attach').forEach(function (b) { b.addEventListener('click', function () { attach(lastSearchResults[b.dataset.i], b); }); });
    }

    // ── 첨부 (리포트가 있으면 그 점검에, 없으면 내 자료함에 저장) ──
    function attach(r, btn) {
      btn.disabled = true;
      fetch('/api/msds/attach', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          inspectionId: INSPECTION_ID ? Number(INSPECTION_ID) : null,
          chemicalName: r.chemicalName, casNo: r.casNo, productName: r.productName,
          sourceType: r.sourceType, sourceName: r.sourceName, sourceUrl: r.sourceUrl,
          documentUrl: r.documentUrl, revisionDate: r.revisionDate, confidence: r.confidence, verified: false
        })
      })
        .then(function (res) {
          if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
          if (!res.ok) return res.json().then(function (e) { throw new Error(e.error || '첨부 실패'); });
          return res.json();
        })
        .then(function () { attachedLoaded = false; loadAttachedMsds(); btn.textContent = '첨부됨'; })
        .catch(function (err) { alert((err && err.message) || '첨부에 실패했습니다.'); btn.disabled = false; });
    }

    // ── 첨부된 MSDS 목록 ──
    function loadAttachedMsds() {
      if (!INSPECTION_ID || attachedLoaded) return;
      attachedLoaded = true;
      fetch('/api/msds/inspection/' + INSPECTION_ID)
        .then(function (res) { return res.ok ? res.json() : []; })
        .then(function (list) { renderAttached(list || []); })
        .catch(function () { attachedLoaded = false; });
    }

    function renderAttached(list) {
      qs('#msdsAttachedCount').textContent = list.length + '건';
      var wrap = qs('#msdsAttachedList');
      if (!list.length) {
        wrap.innerHTML = '<p class="text-sm text-gray-400">첨부된 MSDS가 없습니다. 위 검색 결과에서 "첨부"를 누르면 이 점검·위험요소·보고서에 함께 저장됩니다.</p>';
        return;
      }
      wrap.innerHTML = list.map(function (d) {
        var badge = SOURCE_BADGE[d.sourceType] || SOURCE_BADGE.UNKNOWN;
        return '<div class="flex items-center gap-3 p-3 rounded-xl border border-gray-100">' +
          '<div class="flex-1 min-w-0">' +
            '<p class="text-sm font-semibold text-gray-900">' + msdsEsc(d.chemicalName) +
              (d.casNo ? ' <span class="text-xs font-normal text-gray-500">(' + msdsEsc(d.casNo) + ')</span>' : '') + '</p>' +
            '<p class="text-xs text-gray-500 mt-0.5"><span class="font-semibold px-1.5 py-0.5 rounded-full ' + badge + '">' + msdsEsc(d.sourceTypeLabel) + '</span> ' +
              msdsEsc(d.sourceName || '') + (d.revisionDate ? ' · 개정 ' + msdsEsc(d.revisionDate) : '') + '</p>' +
          '</div>' +
          koshaLink(d.documentUrl || d.sourceUrl) +
          '<button type="button" class="att-verify text-xs font-semibold flex-shrink-0 px-2 py-1 rounded-lg ' +
            (d.verified ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500') + '" data-id="' + d.id + '" data-v="' + d.verified + '">' +
            (d.verified ? '✓ 확인됨' : '확인') + '</button>' +
          '</div>';
      }).join('');
      qsa('#msdsAttachedList .att-verify').forEach(function (b) {
        b.addEventListener('click', function () {
          var next = b.dataset.v !== 'true';
          fetch('/api/msds/' + b.dataset.id + '/verify', {
            method: 'PATCH', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ verified: next })
          }).then(function (res) { return res.ok ? res.json() : null; })
            .then(function () { attachedLoaded = false; loadAttachedMsds(); })
            .catch(function () {});
        });
      });
    }

    // MSDS 탭을 처음 열 때 첨부 목록 로드
    var msdsTabBtn = qsa('.tab-btn').filter(function (b) { return b.dataset.tab === 'msds'; })[0];
    if (msdsTabBtn) msdsTabBtn.addEventListener('click', loadAttachedMsds);

    // 감지 항목 목록의 "MSDS 찾기" 버튼 → MSDS 탭으로 이동 + 검색어 프리필
    window.msdsFindFor = function (title) {
      if (msdsTabBtn) msdsTabBtn.click();
      qs('#msdsSearchInput').value = title || '';
      if (title) doSearch();
      qs('#tab-msds').scrollIntoView({ behavior: 'smooth', block: 'start' });
    };
  })();

  loadCurrentUser();

  // 초기 로드: 저장된 리포트가 있으면 기존 양식 불러오기
  if (INSPECTION_ID) {
    loadInspectionHeader();
    fetch('/api/documents?inspectionId=' + INSPECTION_ID)
      .then(function (res) { return res.ok ? res.json() : []; })
      .then(function (docs) {
        docs.forEach(function (doc) { state.documents[doc.docType] = { formData: doc.formData, aiGenerated: doc.aiGenerated }; });
        selectFormType(state.currentType);
      })
      .catch(function () { selectFormType(state.currentType); });
  } else if (ACTION_ID) {
    loadActionOnly();
    setFieldVisibility(state.currentType);
  } else {
    // 리포트 없이 사이드바 '안전 서류'로 바로 들어온 경우: 안전양식 탭을 먼저 보여준다.
    qs('#reportTitle').textContent = '안전 서류';
    qs('#reportIdBadge').classList.add('hidden');
    var formTab = qsa('.tab-btn').filter(function (b) { return b.dataset.tab === 'form'; })[0];
    if (formTab) formTab.click();
    selectFormType(state.currentType);
  }
})();
</script>
</body>
</html>
