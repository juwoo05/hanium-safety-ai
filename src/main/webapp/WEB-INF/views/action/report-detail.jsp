<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AI 서류 작성 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @media print {
      #sidebar, header, #evidenceCard, #formTypeCard, #aiAssistCard, #formFileCard, .no-print { display: none !important; }
      #mainContent { margin-left: 0 !important; }
    }
  </style>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
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

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-6xl mx-auto space-y-6">

      <!-- Report Header -->
      <div class="bg-white rounded-2xl p-6 shadow-md">
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
        <div class="flex items-center gap-6 bg-gradient-to-r from-red-50 to-orange-50 rounded-xl p-4">
          <div>
            <p class="text-xs text-gray-500 mb-1">종합 위험도</p>
            <div class="flex items-baseline gap-2">
              <span id="riskLevelLabel" class="text-3xl font-bold text-red-600">-</span>
              <span id="riskLevelBadge" class="text-xs font-bold px-2 py-0.5 bg-red-500 text-white rounded-full"></span>
            </div>
          </div>
          <div class="flex-1">
            <div class="w-full bg-white/60 rounded-full h-2.5"><div id="riskLevelBar" class="bg-red-500 h-2.5 rounded-full" style="width:0%"></div></div>
          </div>
          <div class="text-right">
            <p class="text-xs text-gray-500 mb-1">감지 항목</p>
            <p id="detectedCount" class="text-2xl font-bold text-gray-900">-</p>
          </div>
        </div>

        <!-- Tabs -->
        <div class="flex gap-6 mt-5 border-b border-gray-200">
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-900 border-b-2 border-gray-900" data-tab="result">분석결과</button>
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-400 border-b-2 border-transparent hover:text-gray-600" data-tab="form">안전양식</button>
          <button class="tab-btn pb-3 text-sm font-semibold text-gray-400 border-b-2 border-transparent hover:text-gray-600" data-tab="evidence">증거자료</button>
        </div>
      </div>

      <!-- 분석결과 탭 -->
      <div id="tab-result" class="tab-panel grid grid-cols-1 lg:grid-cols-3 gap-5">
      <div class="lg:col-span-2 space-y-4">
      <div class="bg-white rounded-2xl p-6 shadow-md">
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
          <div id="formTypeCard" class="bg-white rounded-2xl p-4 shadow-md">
            <h3 class="text-sm font-semibold text-gray-500 px-2 mb-2">양식 종류</h3>
            <div class="space-y-1" id="formTypeList">
              <button class="form-type-btn w-full text-left px-4 py-3 rounded-xl border-2 border-[#1A2E44] bg-orange-50 flex items-start gap-3" data-type="INSPECTION_LOG">
                <svg class="w-5 h-5 text-[#1A2E44] flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                <span><span class="block text-sm font-bold text-gray-900">안전점검일지</span><span class="block text-xs text-gray-500">일상 현장 안전점검 결과 기록</span></span>
              </button>
              <button class="form-type-btn w-full text-left px-4 py-3 rounded-xl border-2 border-transparent hover:bg-gray-50 flex items-start gap-3" data-type="RISK_ASSESSMENT">
                <svg class="w-5 h-5 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <span><span class="block text-sm font-bold text-gray-900">위험성평가서</span><span class="block text-xs text-gray-500">위험요소 분류 및 개선대책 수립</span></span>
              </button>
              <button class="form-type-btn w-full text-left px-4 py-3 rounded-xl border-2 border-transparent hover:bg-gray-50 flex items-start gap-3" data-type="ACTION_REPORT">
                <svg class="w-5 h-5 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <span><span class="block text-sm font-bold text-gray-900">조치결과보고서</span><span class="block text-xs text-gray-500">조치 완료 결과 및 재발방지 계획</span></span>
              </button>
              <button class="form-type-btn w-full text-left px-4 py-3 rounded-xl border-2 border-transparent hover:bg-gray-50 flex items-start gap-3" data-type="WORK_PERMIT">
                <svg class="w-5 h-5 text-gray-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                <span><span class="block text-sm font-bold text-gray-900">작업허가서</span><span class="block text-xs text-gray-500">위험작업 사전 승인 및 조건 기록</span></span>
              </button>
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
            <p id="aiAssistStatus" class="hidden text-xs text-green-300 mt-2 text-center">✓ 자동 작성 완료 — 내용을 검토하세요</p>
          </div>

          <div id="formFileCard" class="bg-white rounded-2xl p-4 shadow-md">
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
          <div class="bg-white rounded-2xl p-6 shadow-md">
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
                <div><label class="block text-xs text-gray-500 mb-1">건설사명</label><input type="text" data-field="companyName" placeholder="예) (주)세이프메이트 건설" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">현장명</label><input type="text" data-field="siteName" placeholder="예) 3동 건물 외벽 공사현장" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">점검일시</label><input type="datetime-local" data-field="inspectedAt" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">점검자</label><input type="text" data-field="inspector" placeholder="예) 김현장" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div><label class="block text-xs text-gray-500 mb-1">관리감독자</label><input type="text" data-field="supervisor" placeholder="예) 박안전" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div class="field-inspection field-workpermit hidden"><label class="block text-xs text-gray-500 mb-1">기상 상태</label><input type="text" data-field="weather" placeholder="맑음" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div class="field-workpermit hidden"><label class="block text-xs text-gray-500 mb-1">작업 종류</label><input type="text" data-field="workType" placeholder="예) 외벽 마감 작업" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
              </div>
              <div class="field-inspection grid grid-cols-2 gap-4 mt-4 hidden">
                <div><label class="block text-xs text-gray-500 mb-1">작업인원 수</label><input type="number" data-field="workerCount" placeholder="명" class="form-input w-full px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/></div>
                <div>
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
      <div id="tab-evidence" class="tab-panel hidden bg-white rounded-2xl p-6 shadow-md">
        <div class="flex gap-2 mb-5">
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-[#1A2E44] text-white" data-evidence="law">법규</button>
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-evidence="case">사고사례</button>
          <button class="evidence-tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-gray-100 text-gray-600 hover:bg-gray-200" data-evidence="guide">지침</button>
        </div>

        <div id="evidence-law" class="evidence-panel grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h4 class="text-sm font-bold text-gray-900">산업안전보건법 제38조 - 추락 위험 방지</h4>
              <svg class="w-4 h-4 text-gray-300 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            </div>
            <p class="text-xs text-gray-500 mb-3">사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간, 울, 수직형 추락방호망...</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">고용노동부</span>
              <span class="text-xs font-bold text-green-600">98% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h4 class="text-sm font-bold text-gray-900">전기사업법 제67조 - 전기설비 기술기준</h4>
              <svg class="w-4 h-4 text-gray-300 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            </div>
            <p class="text-xs text-gray-500 mb-3">전기사용장소의 시설은 감전, 화재 그 밖에 사람에게 위해를 주거나...</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">산업통상자원부</span>
              <span class="text-xs font-bold text-green-600">95% 관련</span>
            </div>
          </div>
        </div>

        <div id="evidence-case" class="evidence-panel hidden grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">건설현장 추락사고 사례 (2025.03)</h4>
            <p class="text-xs text-gray-500 mb-3">안전난간 미설치로 인한 3층 높이 추락사고로 중상자 1명 발생</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">산업재해통계</span>
              <span class="text-xs font-bold text-green-600">92% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">전기감전 사고 사례 (2025.01)</h4>
            <p class="text-xs text-gray-500 mb-3">임시 전선 노출로 인한 감전사고, 작업 중단 및 안전점검 실시</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">안전보건공단</span>
              <span class="text-xs font-bold text-green-600">88% 관련</span>
            </div>
          </div>
        </div>

        <div id="evidence-guide" class="evidence-panel hidden grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">건설현장 안전난간 설치 가이드</h4>
            <p class="text-xs text-gray-500 mb-3">안전난간의 높이, 재질, 설치 방법에 대한 상세 지침</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">안전보건공단</span>
              <span class="text-xs font-bold text-green-600">96% 관련</span>
            </div>
          </div>
          <div class="border border-gray-200 rounded-xl p-4">
            <h4 class="text-sm font-bold text-gray-900 mb-2">전기안전 작업수칙</h4>
            <p class="text-xs text-gray-500 mb-3">전기 작업 시 안전수칙 및 점검사항</p>
            <div class="flex items-center justify-between">
              <span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">한국전기안전공사</span>
              <span class="text-xs font-bold text-green-600">90% 관련</span>
            </div>
          </div>
        </div>
        <p id="evidenceNotice" class="hidden text-xs text-gray-400 mt-4">위 항목은 예시 데이터입니다. 실제 리포트에서 열면 AI가 검색한 관련 법규·사고사례·지침으로 대체됩니다.</p>
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
  var VERIFY_AFTER_S3KEY = null;

  var FORM_META = {
    INSPECTION_LOG: { title: '안전점검일지', fieldClass: 'field-inspection' },
    RISK_ASSESSMENT: { title: '위험성평가서', fieldClass: 'field-risk' },
    ACTION_REPORT: { title: '조치결과보고서', fieldClass: 'field-action' },
    WORK_PERMIT: { title: '작업허가서', fieldClass: 'field-workpermit' }
  };

  var state = { currentType: 'INSPECTION_LOG', documents: {} };

  function qs(sel, root) { return (root || document).querySelector(sel); }
  function qsa(sel, root) { return Array.prototype.slice.call((root || document).querySelectorAll(sel)); }

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

  // AI 검색(OpenSearch/Bedrock) 연결 실패 시 보여줄 예시 자료
  var DUMMY_EVIDENCE = {
    law: [
      { title: '산업안전보건법 제38조 - 추락 위험 방지', snippet: '사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간, 울, 수직형 추락방호망...', category: 'law', relevance: 98 },
      { title: '전기사업법 제67조 - 전기설비 기술기준', snippet: '전기사용장소의 시설은 감전, 화재 그 밖에 사람에게 위해를 주거나...', category: 'law', relevance: 95 }
    ],
    case: [
      { title: '건설현장 추락사고 사례 (2025.03)', snippet: '안전난간 미설치로 인한 3층 높이 추락사고로 중상자 1명 발생', category: 'case', relevance: 92 },
      { title: '전기감전 사고 사례 (2025.01)', snippet: '임시 전선 노출로 인한 감전사고, 작업 중단 및 안전점검 실시', category: 'case', relevance: 88 }
    ],
    guide: [
      { title: '건설현장 안전난간 설치 가이드', snippet: '안전난간의 높이, 재질, 설치 방법에 대한 상세 지침', category: 'guide', relevance: 96 },
      { title: '전기안전 작업수칙', snippet: '전기 작업 시 안전수칙 및 점검사항', category: 'guide', relevance: 90 }
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
        panel.innerHTML = DUMMY_EVIDENCE[category].map(evidenceCardHtml).join('') +
          '<p class="col-span-2 text-xs text-gray-400 mt-1">AI 검색 서버에 연결하지 못해 예시 자료를 표시하고 있습니다.</p>';
      });
  }

  function setFieldVisibility(type) {
    ['field-inspection', 'field-risk', 'field-action', 'field-workpermit'].forEach(function (cls) {
      qsa('.' + cls).forEach(function (el) { el.classList.add('hidden'); });
    });
    qsa('.' + FORM_META[type].fieldClass).forEach(function (el) { el.classList.remove('hidden'); });
  }

  function clearForm() {
    qsa('.form-input').forEach(function (el) { el.value = ''; });
    qsa('.result-btn').forEach(function (el) { el.classList.remove('border-green-500', 'bg-green-50', 'border-red-500', 'bg-red-50', 'border-yellow-500', 'bg-yellow-50'); el.classList.add('border-gray-200'); });
    qs('#inspectionItems').innerHTML = '<div class="text-center py-8 text-gray-400 text-sm" id="inspectionItemsEmpty"><svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>AI 자동 작성으로 점검 항목을 채워보세요</div>';
    qs('#riskItems').innerHTML = '<div class="text-center py-8 text-gray-400 text-sm" id="riskItemsEmpty"><svg class="w-6 h-6 mx-auto mb-2 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>AI 자동 작성으로 평가 항목을 채워보세요</div>';
    qs('#formAiNotice').classList.add('hidden');
  }

  function selectFormType(type) {
    state.currentType = type;
    qsa('.form-type-btn').forEach(function (btn) {
      var active = btn.dataset.type === type;
      btn.classList.toggle('border-[#1A2E44]', active);
      btn.classList.toggle('bg-orange-50', active);
      btn.classList.toggle('border-transparent', !active);
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

    if (type === 'INSPECTION_LOG') {
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
    if (type === 'INSPECTION_LOG') {
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
    btn.classList.add('opacity-60');

    fetch('/api/documents/draft?inspectionId=' + encodeURIComponent(INSPECTION_ID) + '&docType=' + type)
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
        if (!res.ok) throw new Error('자동 작성 실패');
        return res.json();
      })
      .then(function (draft) {
        state.documents[type] = { formData: draft, aiGenerated: true };
        renderForm(type, draft, true);
        qs('#aiAssistStatus').classList.remove('hidden');
      })
      .catch(function (err) {
        alert(err.message);
      })
      .finally(function () {
        btn.disabled = false;
        btn.classList.remove('opacity-60');
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
    return '<div class="rounded-xl border-2 p-5 ' + meta.box + '">' +
      '<div class="flex items-start justify-between mb-3">' +
      '<div class="flex items-start gap-3 flex-1"><div class="w-2.5 h-2.5 rounded-full ' + meta.dot + ' mt-2 flex-shrink-0"></div>' +
      '<div><h4 class="font-bold text-gray-900 mb-1">' + action.title + '</h4>' +
      '<span class="px-2 py-0.5 ' + meta.badge + ' text-white text-[10px] font-bold rounded">' + meta.label + '</span></div></div>' +
      '<span class="px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 ' + (completed ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700') + '">' + (completed ? '완료' : '조치 필요') + '</span>' +
      '</div>' +
      '<p class="text-sm text-gray-700 mb-3">' + (action.description || '') + '</p>' +
      infoBoxes +
      (action.recommendation ? '<div class="bg-white/80 rounded-lg p-3 mb-4 border border-orange-200"><p class="text-xs font-bold text-orange-800 mb-1">권장 조치사항</p><p class="text-xs text-orange-700">' + action.recommendation + '</p></div>' : '') +
      '<div class="flex gap-2">' +
      (completed ? '' : '<a href="' + link + '" class="flex-1 py-2.5 bg-[#1A2E44] text-white text-sm font-semibold rounded-lg hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-2"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>조치 상세 보기</a>') +
      '<button type="button" class="' + (completed ? 'flex-1 ' : '') + 'verify-open-btn flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-sm font-semibold transition-colors border-2 border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44]/5" data-id="' + action.id + '">' +
      '<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>현장 비교</button>' +
      '</div>' +
      '</div>';
  }

  function renderDetectedItems() {
    var filtered = CURRENT_ACTIONS.filter(function (a) {
      if (issueFilter === 'needed') return a.status !== 'COMPLETED';
      if (issueFilter === 'done') return a.status === 'COMPLETED';
      return true;
    });
    qs('#detectedItems').innerHTML = filtered.length
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
    qs('.tab-btn[data-tab="form"]').click();
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
    var btn = e.target.closest('.verify-open-btn');
    if (!btn) return;
    var action = CURRENT_ACTIONS.find(function (a) { return String(a.id) === btn.dataset.id; });
    if (action) openVerification(action);
  });

  function openVerification(action) {
    verifyingAction = action;
    verifyAfterFile = null;
    qs('#verificationPanel').classList.remove('hidden');
    qs('#verifyIssueLabel').textContent = '조치 항목: ' + action.title;

    var beforeImg = CURRENT_INSPECTION && CURRENT_INSPECTION.imageUrls && CURRENT_INSPECTION.imageUrls[0];
    qs('#verifyBeforeImageWrap').innerHTML = beforeImg
      ? '<img src="' + beforeImg + '" alt="조치 전 현장" class="w-full h-full object-cover"/>'
      : '<p class="text-xs text-gray-400">등록된 현장 사진이 없습니다.</p>';

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
        box.innerHTML = '<p class="font-bold mb-1">AI 재평가 결과: ' + meta.label + '</p><p>' + (result.aiResponseContent || result.aiResponseTitle || '분석이 완료되었습니다.') + '</p>';
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
    var ensureInProgress = verifyingAction.status === 'REQUESTED'
      ? fetch('/api/actions/' + verifyingAction.id + '/status', {
          method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ status: 'IN_PROGRESS' })
        })
      : Promise.resolve();

    ensureInProgress
      .then(function () { return fetch('/api/actions/' + verifyingAction.id + '/submit-approval', { method: 'POST' }); })
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function () {
        qs('#verificationPanel').classList.add('hidden');
        refreshReport();
      })
      .catch(function () { alert('승인 요청에 실패했습니다.'); });
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

      qs('#reportTitle').textContent = inspection.aiResponseTitle || (inspection.location + ' 안전 분석 리포트');
      qs('#reportIdBadge').textContent = '#' + inspection.id;
      qs('#reportDate').textContent = inspection.createdAt ? inspection.createdAt.replace('T', ' ').slice(0, 16) : '-';
      qs('#reportLocation').textContent = inspection.location;
      qs('#reportRequester').textContent = inspection.requestedByName || '담당자 정보 없음';

      var riskLabelEl = qs('#riskLevelLabel');
      riskLabelEl.textContent = meta.label;
      riskLabelEl.className = 'text-3xl font-bold text-' + meta.color;
      var badgeEl = qs('#riskLevelBadge');
      badgeEl.textContent = meta.label;
      badgeEl.className = 'text-xs font-bold px-2 py-0.5 text-white rounded-full ' + meta.badgeColor;
      var barEl = qs('#riskLevelBar');
      barEl.className = meta.barColor + ' h-2.5 rounded-full';
      barEl.style.width = meta.barPct + '%';

      qs('#detectedCount').textContent = actions.length + '건';
      CURRENT_ACTIONS = actions;
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

        var riskLabelEl = qs('#riskLevelLabel');
        riskLabelEl.textContent = meta.label;
        riskLabelEl.className = 'text-3xl font-bold text-' + meta.color;
        var badgeEl = qs('#riskLevelBadge');
        badgeEl.textContent = meta.label;
        badgeEl.className = 'text-xs font-bold px-2 py-0.5 text-white rounded-full ' + meta.badgeColor;
        var barEl = qs('#riskLevelBar');
        barEl.className = meta.barColor + ' h-2.5 rounded-full';
        barEl.style.width = meta.barPct + '%';

        qs('#detectedCount').textContent = '1건';
        CURRENT_ACTIONS = [action];
        renderDetectedItems();
      })
      .catch(function (err) {
        qs('#reportTitle').textContent = err.message || '조치를 불러오지 못했습니다.';
      });
  }

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
    qs('#reportTitle').textContent = '리포트가 선택되지 않았습니다. 조치 관리에서 리포트를 선택해주세요.';
    setFieldVisibility(state.currentType);
  }
})();
</script>
</body>
</html>
