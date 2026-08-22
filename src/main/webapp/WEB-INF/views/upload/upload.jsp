<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AI 안전관리 검사 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<%@ include file="../common/_topnav.jsp" %>

<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <!-- Top Bar -->
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl">
      <div class="relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
    </div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
      </a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div>
        <span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto space-y-6">

      <!-- Page title -->
      <div>
        <h1 class="text-2xl font-bold text-gray-900">AI 안전관리 검사</h1>
        <p class="text-sm text-gray-500 mt-1">단계별로 진행하여 현장 위험 요소를 분석하고 조치를 등록합니다</p>
      </div>

      <!-- Step indicator -->
      <div class="bg-white rounded-2xl px-6 py-5 shadow-sm border border-gray-100">
        <div class="flex items-center" id="stepIndicator">
          <!-- Steps rendered by JS -->
        </div>
      </div>

      <!-- Step content -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 min-h-[420px] flex flex-col" id="stepContent">
      </div>

    </div>
  </main>
</div>

<script>
const STEPS = [
  { number: 1, label: '위치 선택',     icon: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z' },
  { number: 2, label: '이미지 업로드', icon: 'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12' },
  { number: 3, label: '질문 입력',     icon: 'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z' },
  { number: 4, label: 'AI 분석',       icon: 'M5 3l14 9-14 9V3z' },
  { number: 5, label: '조치 등록',     icon: 'M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 0 2-2h2a2 2 0 0 0 2 2' },
];

// 서버(/api/sites)에서 실제 등록된 현장 목록을 불러와 채운다. 로드 전까지는 빈 배열.
let SITES = [];
let sitesLoading = true;
let sitesError = false;

const QUESTION_PRESETS = [
  '이 사진에서 안전난간이 제대로 설치되어 있나요?',
  '작업자들이 안전모를 착용하고 있나요?',
  '전기 배선이 안전하게 처리되어 있나요?',
  '소화기가 지정된 위치에 배치되어 있나요?',
  '비상구 및 대피로가 확보되어 있나요?',
  '추락 방지 장치가 적절히 설치되어 있나요?',
];

const CATEGORIES = ['추락 위험', '전기 위험', '화재 위험', '협착 위험', '붕괴 위험', '화학물질', '기타'];
// 서버(/api/users/subcontractors)에서 실제 하청 담당자 목록을 불러와 채운다.
let ASSIGNEES = [];
const REGULATION_REFS = [
  '산업안전보건법 제38조 (추락 위험 방지)',
  '산업안전보건법 제24조 (보호구 착용)',
  '전기사업법 제67조 (전기설비 기술기준)',
  '소방시설법 제10조 (소화기 배치)',
  '건설기술진흥법 제62조',
];

const riskBadge = { high: 'bg-red-100 text-red-700 border-red-200', medium: 'bg-orange-100 text-orange-700 border-orange-200', low: 'bg-green-100 text-green-700 border-green-200' };
const riskLabel = { high: '고위험', medium: '중위험', low: '저위험' };

// State
// 로그인 세션의 실제 사용자 ID. 페이지 로드시 /api/users/me로 채워진다.
let CURRENT_USER_ID = null;
let CURRENT_USER_NAME = null;

let currentStep = 1;
let selectedSite = null;
let uploadedFiles = []; // { name, size, preview, s3Key, uploading }
let question = '';
let analyzing = false;
let analysisError = '';
let progress = 0;
let progressTimer = null;
let results = [];
let currentInspectionId = null;
let regForm = { title:'', category:'', risk:'', assigneeId:'', discoveredDate: new Date().toISOString().slice(0,10), deadline:'', description:'', regulation:'', recommendation:'', note:'' };

// ─── Render step indicator ───
function renderStepIndicator() {
  const el = document.getElementById('stepIndicator');
  el.innerHTML = STEPS.map((s, i) => {
    const done = currentStep > s.number;
    const active = currentStep === s.number;
    const circleClass = done ? 'bg-green-500 text-white' : active ? 'bg-[#FF6B35] text-white shadow-md scale-110' : 'bg-gray-100 text-gray-400';
    const labelClass = active ? 'text-[#FF6B35]' : done ? 'text-green-600' : 'text-gray-400';
    const iconHtml = done
      ? '<svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>'
      : `<svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path d="${s.icon}"/></svg>`;
    const line = i < STEPS.length - 1 ? `<div class="flex-1 h-0.5 mx-2 mb-5 ${done ? 'bg-green-400' : 'bg-gray-200'}"></div>` : '';
    return `
      <div class="flex items-center flex-1 last:flex-none">
        <div class="flex flex-col items-center gap-1.5">
          <div class="w-9 h-9 rounded-full flex items-center justify-center transition-all ${circleClass}">${iconHtml}</div>
          <span class="text-[10px] font-medium whitespace-nowrap ${labelClass}">${s.label}</span>
        </div>
        ${line}
      </div>`;
  }).join('');
}

// ─── Step 1: 위치 선택 ───
function renderStep1() {
  const siteCards = SITES.map(site => {
    const sel = selectedSite && selectedSite.id === site.id;
    const badge = site.riskBadgeKey
      ? `<span class="inline-flex items-center mt-1.5 text-[10px] font-semibold px-2 py-0.5 rounded-full border ${riskBadge[site.riskBadgeKey]}">${riskLabel[site.riskBadgeKey]}</span>`
      : `<span class="inline-flex items-center mt-1.5 text-[10px] font-semibold px-2 py-0.5 rounded-full border bg-gray-50 text-gray-400 border-gray-200">점검 이력 없음</span>`;
    return `
      <button onclick="selectSite(${site.id})" class="flex items-start gap-3 p-4 rounded-xl border-2 text-left transition-all ${sel ? 'border-[#FF6B35] bg-[#FF6B35]/5 shadow-md' : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'}">
        <div class="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0 ${sel ? 'bg-[#FF6B35] text-white' : 'bg-gray-100 text-gray-500'}">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
        </div>
        <div class="flex-1 min-w-0">
          <p class="font-semibold text-gray-900 text-sm">${site.name}</p>
          <p class="text-xs text-gray-500 mt-0.5">${site.zone || '구역 미지정'}</p>
          ${badge}
        </div>
        ${sel ? '<svg class="w-5 h-5 text-[#FF6B35] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>' : ''}
      </button>`;
  }).join('');

  const selectedInfo = selectedSite ? `
    <div class="mt-4 p-3 bg-[#FF6B35]/5 rounded-xl border border-[#FF6B35]/20 flex items-center gap-3">
      <svg class="w-4 h-4 text-[#FF6B35] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
      <p class="text-sm text-gray-700">선택됨: <span class="font-semibold text-[#FF6B35]">${selectedSite.name}</span> <span class="text-gray-500">(${selectedSite.zone || '구역 미지정'})</span></p>
    </div>` : '';

  const listArea = sitesLoading
    ? `<div class="flex-1 flex items-center justify-center text-sm text-gray-400">현장 목록을 불러오는 중...</div>`
    : sitesError
      ? `<div class="flex-1 flex items-center justify-center text-sm text-red-400">현장 목록을 불러오지 못했습니다.</div>`
      : `<div class="grid grid-cols-1 sm:grid-cols-2 gap-3 flex-1">${siteCards || '<p class="text-sm text-gray-400 col-span-2">등록된 현장이 없습니다. 아래에서 새 현장을 추가하세요.</p>'}</div>`;

  return `
    <div class="flex-1 flex flex-col">
      <div class="flex items-center gap-3 mb-5">
        <div class="w-9 h-9 bg-[#FF6B35]/10 rounded-xl flex items-center justify-center">
          <svg class="w-5 h-5 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
        </div>
        <div>
          <h2 class="text-lg font-bold text-gray-900">위치 선택</h2>
          <p class="text-sm text-gray-500">검사할 현장 위치를 선택하세요</p>
        </div>
      </div>
      ${listArea}
      ${selectedInfo}
      <div class="mt-4 pt-4 border-t border-gray-100">
        <p class="text-xs font-semibold text-gray-500 mb-2">목록에 없는 현장인가요?</p>
        <div class="flex gap-2">
          <input id="newSiteName" type="text" placeholder="현장명 (예: 3동 건물 외벽)" class="flex-1 px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none"/>
          <input id="newSiteZone" type="text" placeholder="구역 (선택)" class="w-28 px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none"/>
          <button onclick="addSite()" class="px-4 py-2 bg-gray-800 text-white rounded-lg text-sm font-semibold hover:bg-gray-900">추가</button>
        </div>
      </div>
    </div>`;
}

// ─── Step 2: 이미지 업로드 ───
function renderStep2() {
  const fileGridHtml = uploadedFiles.length > 0 ? `
    <div class="flex-1">
      <div class="flex items-center justify-between mb-2">
        <p class="text-sm font-semibold text-gray-700">${uploadedFiles.length}개 사진 선택됨</p>
        <button onclick="clearAllFiles()" class="text-xs text-red-400 hover:text-red-600 flex items-center gap-1">
          <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg> 전체 삭제
        </button>
      </div>
      <div class="grid grid-cols-3 sm:grid-cols-4 gap-2">
        ${uploadedFiles.map((f, i) => `
          <div class="relative group rounded-xl overflow-hidden border border-gray-200 aspect-square bg-gray-50">
            <img src="${f.preview}" alt="${f.name}" class="w-full h-full object-cover"/>
            <div class="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-colors"></div>
            ${f.uploading ? '<div class="absolute inset-0 bg-black/40 flex items-center justify-center"><svg class="w-5 h-5 text-white animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></div>' : ''}
            ${f.failed ? '<div class="absolute inset-0 bg-red-500/40 flex items-center justify-center"><span class="text-[10px] font-bold text-white">업로드 실패</span></div>' : ''}
            <button onclick="removeFile(${i})" class="absolute top-1 right-1 bg-black/60 text-white rounded-full p-0.5 opacity-0 group-hover:opacity-100 transition-opacity hover:bg-red-500">
              <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
          </div>`).join('')}
        <button onclick="document.getElementById('fileInput').click()" class="aspect-square rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center hover:border-blue-400 hover:bg-blue-50 transition-colors">
          <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        </button>
      </div>
    </div>` : '';

  return `
    <div class="flex-1 flex flex-col">
      <div class="flex items-center gap-3 mb-5">
        <div class="w-9 h-9 bg-blue-50 rounded-xl flex items-center justify-center">
          <svg class="w-5 h-5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
        </div>
        <div>
          <h2 class="text-lg font-bold text-gray-900">이미지 업로드</h2>
          <p class="text-sm text-gray-500"><span class="font-medium text-[#FF6B35]">${selectedSite ? selectedSite.name : ''}</span>의 현장 사진을 업로드하세요</p>
        </div>
      </div>
      <div id="dropZone" onclick="document.getElementById('fileInput').click()"
           ondragover="event.preventDefault(); this.classList.add('border-blue-500','bg-blue-50','scale-[1.01]')"
           ondragleave="this.classList.remove('border-blue-500','bg-blue-50','scale-[1.01]')"
           ondrop="event.preventDefault(); this.classList.remove('border-blue-500','bg-blue-50','scale-[1.01]'); handleDropFiles(event.dataTransfer.files)"
           class="border-2 border-dashed border-gray-200 rounded-xl p-8 text-center cursor-pointer hover:border-blue-400 hover:bg-gray-50 transition-all mb-4">
        <input id="fileInput" type="file" multiple accept="image/*" class="hidden" onchange="handleFiles(this.files)"/>
        <div class="flex flex-col items-center gap-3">
          <div class="w-14 h-14 rounded-2xl flex items-center justify-center bg-blue-50 text-blue-500">
            <svg class="w-7 h-7" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
          </div>
          <div>
            <p class="font-semibold text-gray-800">사진을 드래그하거나 클릭하여 업로드</p>
            <p class="text-xs text-gray-400 mt-1">JPG, PNG, HEIC · 최대 10MB</p>
          </div>
        </div>
      </div>
      ${fileGridHtml}
    </div>`;
}

// ─── Step 3: 질문 입력 ───
function renderStep3() {
  const presets = QUESTION_PRESETS.map(q => `
    <button onclick="setQuestion(\`${q}\`)" class="text-xs px-3 py-1.5 rounded-full border transition-all ${question === q ? 'bg-purple-600 text-white border-purple-600' : 'border-gray-200 text-gray-600 hover:border-purple-300 hover:bg-purple-50'}">${q}</button>
  `).join('');

  const preview = question.trim() ? `
    <div class="mt-4 p-3 bg-purple-50 rounded-xl border border-purple-100 flex items-start gap-2">
      <svg class="w-4 h-4 text-purple-500 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
      <p class="text-sm text-gray-700 italic">"${question}"</p>
    </div>` : '';

  return `
    <div class="flex-1 flex flex-col">
      <div class="flex items-center gap-3 mb-5">
        <div class="w-9 h-9 bg-purple-50 rounded-xl flex items-center justify-center">
          <svg class="w-5 h-5 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
        </div>
        <div>
          <h2 class="text-lg font-bold text-gray-900">질문 입력</h2>
          <p class="text-sm text-gray-500">AI에게 무엇을 확인할지 알려주세요</p>
        </div>
      </div>
      <textarea id="questionInput" oninput="question=this.value; renderStep3Content()" placeholder="예: 이 사진에서 안전난간이 제대로 설치되어 있나요? 추락 위험 요소가 있는지 확인해주세요." rows="4"
        class="w-full px-4 py-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-purple-400 focus:border-transparent outline-none resize-none mb-4">${question}</textarea>
      <div>
        <p class="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wide">자주 쓰는 질문</p>
        <div class="flex flex-wrap gap-2">${presets}</div>
      </div>
      ${preview}
    </div>`;
}

function renderStep3Content() {
  const preview = question.trim() ? `
    <div class="mt-4 p-3 bg-purple-50 rounded-xl border border-purple-100 flex items-start gap-2">
      <svg class="w-4 h-4 text-purple-500 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
      <p class="text-sm text-gray-700 italic">"${question}"</p>
    </div>` : '';
  const previewEl = document.querySelector('#stepContent .mt-4.p-3.bg-purple-50');
  if (previewEl) previewEl.outerHTML = preview;
  else if (preview) document.querySelector('#stepContent .flex-wrap')?.insertAdjacentHTML('afterend', preview);
}

// ─── Step 4: AI 분석 ───
function renderStep4() {
  if (analyzing) {
    return `
      <div class="flex-1 flex flex-col">
        <div class="flex items-center gap-3 mb-5">
          <div class="w-9 h-9 bg-green-50 rounded-xl flex items-center justify-center">
            <svg class="w-5 h-5 text-green-600 animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
          </div>
          <h2 class="text-lg font-bold text-gray-900">AI 분석 중...</h2>
        </div>
        <div class="bg-gradient-to-br from-[#1B3A5F]/5 to-[#FF6B35]/5 rounded-xl p-5 border border-[#FF6B35]/20">
          <div class="flex items-center gap-3 mb-3">
            <svg class="w-5 h-5 text-[#FF6B35] animate-spin flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
            <p class="text-sm font-semibold text-gray-800 flex-1" id="progressLabel">이미지 전처리 중...</p>
            <span class="text-lg font-bold text-[#FF6B35]" id="progressPct">0%</span>
          </div>
          <div class="w-full bg-gray-200 rounded-full h-2 overflow-hidden">
            <div id="progressBar" class="bg-gradient-to-r from-[#1B3A5F] to-[#FF6B35] h-2 rounded-full transition-all duration-300" style="width:0%"></div>
          </div>
        </div>
      </div>`;
  }

  if (analysisError) {
    return `
      <div class="flex-1 flex flex-col">
        <div class="flex items-center gap-2 mb-4">
          <svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
          <p class="font-semibold text-red-700">AI 분석에 실패했습니다</p>
        </div>
        <p class="text-sm text-gray-600 mb-4">${analysisError}</p>
        <button onclick="startAnalysis()" class="w-full py-3.5 bg-[#FF6B35] text-white rounded-xl font-bold hover:bg-[#E55A2A] transition-colors shadow-lg">다시 시도</button>
      </div>`;
  }

  if (results.length > 0) {
    const resultCards = results.map((r, i) => `
      <div class="flex gap-3 p-3 rounded-xl border ${r.risk === 'high' ? 'bg-red-50 border-red-100' : 'bg-orange-50 border-orange-100'}">
        <svg class="w-4 h-4 flex-shrink-0 mt-0.5 ${r.risk === 'high' ? 'text-red-500' : 'text-orange-500'}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        <div class="flex-1">
          <p class="text-sm font-semibold text-gray-900">${r.title}</p>
          <p class="text-xs text-gray-600 mt-0.5">${r.desc}</p>
        </div>
        <span class="self-start text-[10px] font-bold px-2 py-0.5 rounded-full border flex-shrink-0 mt-0.5 ${riskBadge[r.risk]}">${riskLabel[r.risk]}</span>
      </div>`).join('');

    return `
      <div class="flex-1 flex flex-col">
        <div class="flex items-center gap-2 mb-4">
          <svg class="w-5 h-5 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
          <p class="font-semibold text-green-800">분석 완료 — ${results.length}건 위험 항목 감지</p>
        </div>
        <div class="space-y-3 mb-4 flex-1">${resultCards}</div>
        <button onclick="goToStep(5)" class="w-full py-3.5 bg-[#FF6B35] text-white rounded-xl font-bold hover:bg-[#E55A2A] transition-colors shadow-lg flex items-center justify-center gap-2 mt-2">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 0 2-2h2a2 2 0 0 0 2 2"/></svg>
          조치 등록하러 가기
        </button>
        <a href="/actions/detail?inspectionId=${currentInspectionId}" class="w-full py-3 mt-2 border border-gray-200 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
          리포트 작성하기
        </a>
      </div>`;
  }

  // Summary before analysis
  return `
    <div class="flex-1 flex flex-col">
      <div class="flex items-center gap-3 mb-5">
        <div class="w-9 h-9 bg-green-50 rounded-xl flex items-center justify-center">
          <svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 3l14 9-14 9V3z"/></svg>
        </div>
        <div>
          <h2 class="text-lg font-bold text-gray-900">AI 분석</h2>
          <p class="text-sm text-gray-500">입력 내용을 확인하고 AI 분석을 시작하세요</p>
        </div>
      </div>
      <div class="space-y-3 mb-6">
        <div class="flex items-center gap-3 p-4 bg-gray-50 rounded-xl border border-gray-100">
          <div class="w-8 h-8 bg-[#FF6B35]/10 rounded-lg flex items-center justify-center flex-shrink-0">
            <svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
          </div>
          <div class="flex-1"><p class="text-xs text-gray-400">위치</p><p class="text-sm font-semibold text-gray-800">${selectedSite ? selectedSite.name + ' (' + selectedSite.zone + ')' : '-'}</p></div>
          <button onclick="goToStep(1)" class="text-xs text-gray-400 hover:text-[#FF6B35]">수정</button>
        </div>
        <div class="flex items-center gap-3 p-4 bg-gray-50 rounded-xl border border-gray-100">
          <div class="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
            <svg class="w-4 h-4 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
          </div>
          <div class="flex-1"><p class="text-xs text-gray-400">업로드 사진</p><p class="text-sm font-semibold text-gray-800">${uploadedFiles.length}장</p></div>
          <button onclick="goToStep(2)" class="text-xs text-gray-400 hover:text-[#FF6B35]">수정</button>
        </div>
        <div class="flex items-center gap-3 p-4 bg-gray-50 rounded-xl border border-gray-100">
          <div class="w-8 h-8 bg-purple-50 rounded-lg flex items-center justify-center flex-shrink-0">
            <svg class="w-4 h-4 text-purple-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
          </div>
          <div class="flex-1 min-w-0"><p class="text-xs text-gray-400">검사 질문</p><p class="text-sm font-semibold text-gray-800 truncate">${question || '-'}</p></div>
          <button onclick="goToStep(3)" class="text-xs text-gray-400 hover:text-[#FF6B35]">수정</button>
        </div>
      </div>
      <div class="flex items-center gap-4 p-4 bg-gradient-to-r from-[#1B3A5F]/5 to-[#FF6B35]/5 rounded-xl border border-[#FF6B35]/20 mb-4">
        <img src="/images/mascot.png" alt="마스코트" class="w-12 h-12 object-contain flex-shrink-0" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
        <p class="text-sm text-gray-700">모든 내용이 입력됐어요! AI 분석을 시작하면 약 30초 내에 결과를 알려드릴게요</p>
      </div>
      <button onclick="startAnalysis()" class="w-full py-4 bg-[#FF6B35] text-white rounded-xl font-bold text-base hover:bg-[#E55A2A] transition-colors shadow-lg flex items-center justify-center gap-2 mt-auto">
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 3l14 9-14 9V3z"/></svg>
        AI 분석 시작
      </button>
    </div>`;
}

// ─── Step 5: 조치 등록 ───
function renderStep5() {
  const catBtns = CATEGORIES.map(c => `
    <button onclick="regForm.category='${c}'; renderStep()" class="px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all ${regForm.category === c ? 'bg-[#1B3A5F] text-white border-[#1B3A5F]' : 'border-gray-200 text-gray-600 hover:border-gray-400'}">${c}</button>`).join('');

  const aiBadges = results.map((r, i) => `<span class="text-[10px] font-bold px-2 py-0.5 rounded-full border ${riskBadge[r.risk]}">${r.title}</span>`).join('');

  const regBtns = REGULATION_REFS.map(r => `
    <button onclick="regForm.regulation=\`${r}\`; document.getElementById('regInput').value=\`${r}\`" class="text-xs px-3 py-1.5 rounded-full border transition-all ${regForm.regulation === r ? 'bg-[#1B3A5F] text-white border-[#1B3A5F]' : 'border-gray-200 text-gray-600 hover:border-gray-400'}">${r}</button>`).join('');

  return `
    <div class="flex-1 flex flex-col space-y-5">
      <div class="flex items-center gap-3">
        <div class="w-9 h-9 bg-[#FF6B35]/10 rounded-xl flex items-center justify-center">
          <svg class="w-5 h-5 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 0 2-2h2a2 2 0 0 0 2 2"/></svg>
        </div>
        <div><h2 class="text-lg font-bold text-gray-900">조치 등록</h2><p class="text-sm text-gray-500">AI 분석 결과를 바탕으로 조치 사항을 등록합니다</p></div>
      </div>
      ${results.length > 0 ? `<div class="flex flex-wrap gap-2 p-3 bg-orange-50 rounded-xl border border-orange-100"><span class="text-xs font-semibold text-orange-700">AI 감지 항목:</span>${aiBadges}</div>` : ''}
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">제목 <span class="text-red-500">*</span></label>
        <input type="text" id="regTitle" value="${regForm.title}" oninput="regForm.title=this.value" placeholder="조치 사항을 간략히 입력하세요"
          class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험 분류 <span class="text-red-500">*</span></label>
        <div class="flex flex-wrap gap-2">${catBtns}</div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-2">위험도 <span class="text-red-500">*</span></label>
        <div class="grid grid-cols-3 gap-3">
          ${['high','medium','low'].map(r => `
          <button onclick="regForm.risk='${r}'; renderStep()" class="flex flex-col items-center gap-1.5 py-3 rounded-xl border-2 font-semibold text-sm transition-all ${regForm.risk === r ? (r==='high'?'border-red-400 bg-red-50 text-red-700':r==='medium'?'border-orange-400 bg-orange-50 text-orange-700':'border-yellow-400 bg-yellow-50 text-yellow-700') : 'border-gray-200 text-gray-500 hover:border-gray-300'}">
            <div class="w-3 h-3 rounded-full ${r==='high'?'bg-red-500':r==='medium'?'bg-orange-500':'bg-yellow-400'}"></div>
            ${riskLabel[r]}
          </button>`).join('')}
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">담당자 <span class="text-red-500">*</span></label>
          <select id="regAssignee" onchange="regForm.assigneeId=this.value" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none bg-white">
            <option value="">${ASSIGNEES.length ? '선택' : '등록된 하청 담당자가 없습니다'}</option>
            ${ASSIGNEES.map(a => `<option value="${a.id}" ${String(regForm.assigneeId)===String(a.id)?'selected':''}>${a.username}${a.companyName ? ' (' + a.companyName + ')' : ''}</option>`).join('')}
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">발견 일시</label>
          <input type="date" value="${regForm.discoveredDate}" oninput="regForm.discoveredDate=this.value" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none"/>
        </div>
        <div class="col-span-2">
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">조치 기한 <span class="text-red-500">*</span></label>
          <input type="date" id="regDeadline" value="${regForm.deadline}" oninput="regForm.deadline=this.value" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none"/>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험 상황 설명 <span class="text-red-500">*</span></label>
        <textarea id="regDesc" oninput="regForm.description=this.value" rows="4" placeholder="발견된 위험 상황을 구체적으로 설명해주세요..."
          class="w-full px-4 py-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none">${regForm.description}</textarea>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">권장 조치 사항</label>
        <textarea oninput="regForm.recommendation=this.value" rows="2" placeholder="어떤 조치가 필요한지 설명해주세요..."
          class="w-full px-4 py-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none">${regForm.recommendation}</textarea>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">관련 법규</label>
        <div class="flex flex-wrap gap-2 mb-2">${regBtns}</div>
        <input type="text" id="regInput" value="${regForm.regulation}" oninput="regForm.regulation=this.value" placeholder="직접 입력하거나 위에서 선택"
          class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">비고</label>
        <textarea oninput="regForm.note=this.value" rows="2" placeholder="추가 메모사항이 있으면 입력하세요"
          class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none">${regForm.note}</textarea>
      </div>
      <div class="bg-blue-50 rounded-xl p-3 border border-blue-100 text-xs text-blue-700">등록 후 담당자에게 즉시 알림이 발송됩니다.</div>
      <button onclick="submitRegistration()" class="w-full py-4 bg-[#FF6B35] text-white rounded-xl font-bold text-base hover:bg-[#E55A2A] transition-colors shadow-lg flex items-center justify-center gap-2">
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
        조치관리에 등록 완료
      </button>
      <div class="pt-4 border-t border-gray-100">
        <button onclick="goToStep(4)" class="flex items-center gap-2 text-sm text-gray-500 hover:text-gray-800 transition-colors">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          AI 분석 결과로 돌아가기
        </button>
      </div>
    </div>`;
}

// ─── Navigation buttons ───
function renderNavButtons() {
  if (currentStep === 5) return '';
  if (currentStep === 4 && (analyzing || results.length > 0)) return '';

  const canNext =
    (currentStep === 1 && selectedSite !== null) ||
    (currentStep === 2 && uploadedFiles.length > 0) ||
    (currentStep === 3 && question.trim().length > 0) ||
    currentStep === 4;

  return `
    <div class="flex items-center justify-between mt-6 pt-5 border-t border-gray-100">
      <button onclick="prevStep()" ${currentStep === 1 ? 'disabled' : ''} class="flex items-center gap-2 px-5 py-2.5 border border-gray-200 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed transition-all">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg> 이전
      </button>
      <span class="text-xs text-gray-400">${currentStep} / ${STEPS.length}</span>
      ${currentStep < 4 ? `
      <button onclick="nextStep()" ${!canNext ? 'disabled' : ''} class="flex items-center gap-2 px-5 py-2.5 bg-[#FF6B35] text-white rounded-xl text-sm font-semibold hover:bg-[#E55A2A] disabled:opacity-40 disabled:cursor-not-allowed transition-all shadow-sm">
        다음 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
      </button>` : '<div class="w-20"></div>'}
    </div>`;
}

// ─── Main render ───
function renderStep() {
  renderStepIndicator();
  let content = '';
  if (currentStep === 1) content = renderStep1();
  else if (currentStep === 2) content = renderStep2();
  else if (currentStep === 3) content = renderStep3();
  else if (currentStep === 4) content = renderStep4();
  else if (currentStep === 5) content = renderStep5();
  document.getElementById('stepContent').innerHTML = content + renderNavButtons();
}

// ─── Actions ───
function selectSite(id) {
  selectedSite = SITES.find(s => s.id === id);
  renderStep();
}

function loadSites() {
  sitesLoading = true;
  sitesError = false;
  if (currentStep === 1) renderStep();

  fetch('/api/sites')
    .then(res => {
      if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
      if (!res.ok) throw new Error('현장 목록 조회 실패');
      return res.json();
    })
    .then(sites => {
      SITES = sites.map(s => ({ id: s.id, name: s.name, zone: s.zone, riskBadgeKey: s.lastRiskLevel ? RISK_LEVEL_TO_BADGE[s.lastRiskLevel] : null }));
      sitesLoading = false;
    })
    .catch(() => { sitesError = true; sitesLoading = false; })
    .finally(() => { if (currentStep === 1) renderStep(); });
}

function addSite() {
  const nameEl = document.getElementById('newSiteName');
  const zoneEl = document.getElementById('newSiteZone');
  const name = nameEl.value.trim();
  if (!name) { alert('현장 이름을 입력해주세요.'); return; }

  fetch('/api/sites', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: name, zone: zoneEl.value.trim() || null }),
  })
    .then(res => res.json().then(body => ({ ok: res.ok, body })))
    .then(({ ok, body }) => {
      if (!ok) throw new Error(body.error || '현장 추가에 실패했습니다.');
      const newSite = { id: body.id, name: body.name, zone: body.zone, riskBadgeKey: null };
      SITES = [...SITES, newSite].sort((a, b) => a.name.localeCompare(b.name));
      selectedSite = newSite;
      renderStep();
    })
    .catch(err => alert(err.message));
}

function loadAssignees() {
  fetch('/api/users/subcontractors')
    .then(res => {
      if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
      if (!res.ok) throw new Error();
      return res.json();
    })
    .then(users => {
      ASSIGNEES = users;
      if (currentStep === 5) renderStep();
    })
    .catch(() => { /* 담당자 목록만 실패, 화면은 유지 */ });
}

function loadCurrentUser() {
  fetch('/api/users/me')
    .then(res => {
      if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
      if (!res.ok) throw new Error();
      return res.json();
    })
    .then(user => {
      CURRENT_USER_ID = user.id;
      CURRENT_USER_NAME = user.username;
      const nameEl = document.getElementById('headerUserName');
      const initialEl = document.getElementById('headerUserInitial');
      if (nameEl) nameEl.textContent = user.username;
      if (initialEl) initialEl.textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(() => { /* 상단 표시만 실패, 화면은 유지 */ });
}

function handleFiles(files) {
  Array.from(files).filter(f => f.type.startsWith('image/')).forEach(f => {
    const entry = { name: f.name, size: (f.size/1024/1024).toFixed(2)+' MB', preview: URL.createObjectURL(f), s3Key: null, uploading: true };
    uploadedFiles.push(entry);
    uploadFile(f, entry);
  });
  renderStep();
}

function uploadFile(file, entry) {
  const formData = new FormData();
  formData.append('file', file);
  fetch('/api/uploads', { method: 'POST', body: formData })
    .then(res => { if (!res.ok) throw new Error('업로드 실패'); return res.json(); })
    .then(data => { entry.s3Key = data.s3Key; entry.uploading = false; renderStep(); })
    .catch(() => { entry.uploading = false; entry.failed = true; renderStep(); });
}

function handleDropFiles(files) { handleFiles(files); }

function removeFile(i) {
  URL.revokeObjectURL(uploadedFiles[i].preview);
  uploadedFiles.splice(i, 1);
  renderStep();
}

function clearAllFiles() { uploadedFiles = []; renderStep(); }

function setQuestion(q) { question = q; renderStep(); }

function goToStep(n) { currentStep = n; renderStep(); }
function nextStep() { if (currentStep < STEPS.length) { currentStep++; renderStep(); } }
function prevStep() { if (currentStep > 1) { currentStep--; renderStep(); } }

const ANALYSIS_LABELS = ['이미지 전처리 중...', '객체 감지 모델 실행 중...', '질문 기반 위험 요소 분석 중...', '법규 데이터베이스 대조 중...', '리포트 생성 중...'];
let progressValue = 0;

// 백엔드 RiskLevel(HIGH/MEDIUM/SAFE) ↔ 프론트 배지(high/medium/low) 매핑.
// SAFE는 화면상 표시할 등급이 없어 low로 보여준다(가장 가까운 표현).
const RISK_LEVEL_TO_BADGE = { HIGH: 'high', MEDIUM: 'medium', SAFE: 'low' };
const BADGE_TO_RISK_LEVEL = { high: 'HIGH', medium: 'MEDIUM', low: 'SAFE' };

function startAnalysis() {
  const readyFile = uploadedFiles.find(f => f.s3Key);
  if (!readyFile) {
    alert('사진 업로드가 아직 끝나지 않았습니다. 잠시 후 다시 시도해주세요.');
    return;
  }
  if (!CURRENT_USER_ID) {
    alert('사용자 정보를 아직 불러오지 못했습니다. 잠시 후 다시 시도해주세요.');
    return;
  }

  analyzing = true;
  analysisError = '';
  progressValue = 0;
  results = [];
  renderStep();

  progressTimer = setInterval(() => {
    progressValue = Math.min(progressValue + Math.random() * 10 + 3, 92);
    const bar = document.getElementById('progressBar');
    const pct = document.getElementById('progressPct');
    const lbl = document.getElementById('progressLabel');
    if (bar) bar.style.width = Math.round(progressValue) + '%';
    if (pct) pct.textContent = Math.round(progressValue) + '%';
    if (lbl) lbl.textContent = ANALYSIS_LABELS[Math.min(Math.floor((progressValue/100)*ANALYSIS_LABELS.length), ANALYSIS_LABELS.length-1)];
  }, 300);

  // 현재 FastAPI /analyze는 이미지 1장만 받으므로, 여러 장을 올려도 첫 번째 업로드 완료 사진으로만 분석한다.
  fetch('/api/inspections/analyze', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      siteId: String(selectedSite.id),
      imageS3Key: readyFile.s3Key,
      workInfo: question,
      location: selectedSite.name,
      workType: selectedSite.zone || '미지정',
      requestedBy: CURRENT_USER_ID,
    }),
  })
    .then(res => res.json().then(body => ({ ok: res.ok, body })))
    .then(({ ok, body }) => {
      if (!ok) throw new Error(body.error || '분석 요청이 실패했습니다.');
      currentInspectionId = body.id;
      return fetch('/api/inspections/' + body.id + '/actions').then(r => r.json());
    })
    .then(actions => {
      results = actions.map(a => ({
        title: a.title,
        risk: RISK_LEVEL_TO_BADGE[a.riskLevel] || 'medium',
        desc: a.description,
      }));
      if (results.length > 0) {
        regForm.title = results[0].title;
        regForm.risk = results.find(r => r.risk === 'high')?.risk || results[0].risk;
        regForm.description = results.map((r, i) => (i+1)+'. '+r.title+': '+r.desc).join('\n');
      }
    })
    .catch(err => { analysisError = err.message; })
    .finally(() => {
      clearInterval(progressTimer);
      analyzing = false;
      progressValue = 100;
      renderStep();
    });
}

function submitRegistration() {
  if (!regForm.title.trim()) { alert('제목을 입력하세요'); return; }
  if (!regForm.category)     { alert('위험 분류를 선택하세요'); return; }
  if (!regForm.risk)         { alert('위험도를 선택하세요'); return; }
  if (!regForm.assigneeId)   { alert('담당자를 지정하세요'); return; }
  if (!regForm.deadline)     { alert('조치 기한을 설정하세요'); return; }
  if (!regForm.description.trim()) { alert('상세 내용을 입력하세요'); return; }

  fetch('/api/actions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      inspectionId: currentInspectionId,
      title: regForm.title,
      category: regForm.category,
      riskLevel: BADGE_TO_RISK_LEVEL[regForm.risk],
      reporterId: Number(regForm.assigneeId),
      discoveredDate: regForm.discoveredDate,
      dueDate: regForm.deadline,
      description: regForm.description,
      recommendation: regForm.recommendation || null,
      regulationRef: regForm.regulation || null,
      memo: regForm.note || null,
      createdBy: CURRENT_USER_ID,
    }),
  })
    .then(res => res.json().then(body => ({ ok: res.ok, body })))
    .then(({ ok, body }) => {
      if (!ok) throw new Error(body.error || '조치 등록이 실패했습니다.');
      alert('조치 사항이 성공적으로 등록되었습니다!');
      window.location.href = '/actions';
    })
    .catch(err => alert(err.message));
}

// Init
loadCurrentUser();
loadSites();
loadAssignees();
renderStep();
</script>
</body>
</html>
