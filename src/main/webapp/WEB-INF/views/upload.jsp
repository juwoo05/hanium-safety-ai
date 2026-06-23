<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>현장 사진 업로드 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div><span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-6xl mx-auto space-y-6">
      <div><h1 class="text-2xl font-bold text-gray-900">현장 사진 업로드</h1><p class="text-sm text-gray-500 mt-1">사진을 업로드하면 AI가 위험 요소를 자동 분석합니다</p></div>
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-5">
          <!-- Drop Zone -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h3 class="text-base font-semibold text-gray-900 mb-4">사진 업로드</h3>
            <div id="dropZone" class="border-2 border-dashed border-gray-200 rounded-xl p-10 text-center cursor-pointer hover:border-[#FF6B35] hover:bg-gray-50 transition-all" onclick="document.getElementById('fileInput').click()" ondragover="onDragOver(event)" ondragleave="onDragLeave()" ondrop="onDrop(event)">
              <input id="fileInput" type="file" multiple accept="image/*" class="hidden" onchange="handleFiles(this.files)"/>
              <div class="flex flex-col items-center gap-3">
                <div class="w-16 h-16 rounded-2xl bg-[#FF6B35]/10 text-[#FF6B35] flex items-center justify-center">
                  <svg class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                </div>
                <div><p class="font-semibold text-gray-800 mb-1">파일을 드래그하거나 클릭하여 업로드</p><p class="text-sm text-gray-500">JPG, PNG, HEIC · 최대 10MB · 한 번에 최대 20장</p></div>
                <button type="button" class="px-5 py-2 bg-[#FF6B35] text-white rounded-lg text-sm font-semibold hover:bg-[#E55A2A] transition-colors shadow-sm">파일 선택</button>
              </div>
            </div>

            <!-- File List -->
            <div id="fileList" class="hidden mt-5 space-y-3">
              <div class="flex items-center justify-between">
                <h4 class="text-sm font-semibold text-gray-700">업로드된 파일 (<span id="fileCount">0</span>)</h4>
                <button onclick="clearFiles()" class="text-xs text-gray-400 hover:text-red-500 transition-colors">전체 삭제</button>
              </div>
              <div id="fileGrid" class="grid grid-cols-2 sm:grid-cols-3 gap-3"></div>
              <!-- Analyze Button -->
              <div id="analyzeSection">
                <button onclick="startAnalysis()" class="w-full py-3.5 bg-[#1B3A5F] text-white rounded-xl font-semibold hover:bg-[#2C5282] transition-colors flex items-center justify-center gap-2 shadow-md mt-2">
                  <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                  AI 위험 분석 시작
                </button>
              </div>
              <!-- Progress -->
              <div id="progressSection" class="hidden bg-gradient-to-br from-[#1B3A5F]/5 to-[#FF6B35]/5 rounded-xl p-5 border border-[#FF6B35]/20 mt-2">
                <div class="flex items-center gap-3 mb-3">
                  <svg class="w-5 h-5 text-[#FF6B35] animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>
                  <p id="analysisStep" class="text-sm font-semibold text-gray-900 flex-1">이미지 전처리 중...</p>
                  <span id="progressPct" class="text-lg font-bold text-[#FF6B35]">0%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2 overflow-hidden"><div id="progressBar" class="bg-gradient-to-r from-[#1B3A5F] to-[#FF6B35] h-2 rounded-full transition-all duration-300" style="width:0%"></div></div>
              </div>
              <!-- Result -->
              <div id="resultSection" class="hidden bg-green-50 rounded-xl p-4 border border-green-200 mt-2">
                <div class="flex items-center gap-2 mb-3"><svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg><p class="font-semibold text-green-900 text-sm">분석 완료 — 3건 감지</p></div>
                <div class="space-y-1.5 mb-4">
                  <div class="flex items-center gap-2 text-sm"><div class="w-2 h-2 rounded-full bg-red-500 flex-shrink-0"></div><span class="text-gray-700 flex-1">안전난간 미설치</span><span class="text-xs px-1.5 py-0.5 rounded bg-red-100 text-red-700 font-medium">고위험</span></div>
                  <div class="flex items-center gap-2 text-sm"><div class="w-2 h-2 rounded-full bg-red-500 flex-shrink-0"></div><span class="text-gray-700 flex-1">임시 배선 노출</span><span class="text-xs px-1.5 py-0.5 rounded bg-red-100 text-red-700 font-medium">고위험</span></div>
                  <div class="flex items-center gap-2 text-sm"><div class="w-2 h-2 rounded-full bg-orange-500 flex-shrink-0"></div><span class="text-gray-700 flex-1">안전모 미착용</span><span class="text-xs px-1.5 py-0.5 rounded bg-orange-100 text-orange-700 font-medium">중위험</span></div>
                </div>
                <a href="/actions/detail" class="block w-full py-2.5 bg-[#1B3A5F] text-white rounded-lg text-sm font-semibold hover:bg-[#2C5282] transition-colors text-center">리포트 상세 보기 →</a>
              </div>
            </div>
          </div>

          <!-- Recent Uploads -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h3 class="text-base font-semibold text-gray-900 mb-4">최근 업로드</h3>
            <div class="space-y-2.5">
              <a href="/actions/detail" class="flex items-center gap-3 p-3 border border-gray-100 rounded-xl hover:border-[#FF6B35] hover:bg-orange-50/30 transition-all group">
                <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 group-hover:bg-[#FF6B35]/10"><svg class="w-5 h-5 text-gray-400 group-hover:text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate">현장전경_0601.jpg</p><p class="text-xs text-gray-400">2026-06-01</p></div>
                <span class="text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-700 font-medium flex-shrink-0">위험 5건</span>
                <svg class="w-4 h-4 text-gray-300 group-hover:text-[#FF6B35] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-3 border border-gray-100 rounded-xl hover:border-[#FF6B35] hover:bg-orange-50/30 transition-all group">
                <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 group-hover:bg-[#FF6B35]/10"><svg class="w-5 h-5 text-gray-400 group-hover:text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate">작업장_안전점검.jpg</p><p class="text-xs text-gray-400">2026-05-31</p></div>
                <span class="text-xs px-2 py-0.5 rounded-full bg-orange-100 text-orange-700 font-medium flex-shrink-0">위험 3건</span>
                <svg class="w-4 h-4 text-gray-300 group-hover:text-[#FF6B35] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-3 border border-gray-100 rounded-xl hover:border-[#FF6B35] hover:bg-orange-50/30 transition-all group">
                <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 group-hover:bg-[#FF6B35]/10"><svg class="w-5 h-5 text-gray-400 group-hover:text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate">철골구조_확인.jpg</p><p class="text-xs text-gray-400">2026-05-30</p></div>
                <span class="text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-700 font-medium flex-shrink-0">위험 7건</span>
                <svg class="w-4 h-4 text-gray-300 group-hover:text-[#FF6B35] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
              </a>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="space-y-5">
          <div class="bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] rounded-2xl p-6">
            <div class="flex flex-col items-center gap-3 mb-4">
              <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain" style="mix-blend-mode:multiply"/>
              <div class="relative bg-white rounded-2xl shadow-lg px-4 py-3"><div class="absolute -top-2 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-8 border-l-transparent border-r-transparent border-b-white"></div><p class="text-sm text-gray-700">전체가 잘 보이는 사진을 올려주세요 📸</p></div>
            </div>
            <ul class="space-y-2 mt-3">
              <li class="flex items-start gap-2 text-sm text-white/80"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>조명이 밝을수록 정확도 ↑</li>
              <li class="flex items-start gap-2 text-sm text-white/80"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>여러 각도에서 촬영 권장</li>
              <li class="flex items-start gap-2 text-sm text-white/80"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>한 번에 최대 20장 가능</li>
            </ul>
          </div>

          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center gap-2"><svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>촬영 가이드</h3>
            <ol class="space-y-3">
              <li class="flex items-start gap-3"><span class="w-5 h-5 bg-[#FF6B35]/10 text-[#FF6B35] rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">1</span><div><p class="text-sm font-medium text-gray-800">현장 전체 포함</p><p class="text-xs text-gray-500">작업 구역과 주변 환경 모두</p></div></li>
              <li class="flex items-start gap-3"><span class="w-5 h-5 bg-[#FF6B35]/10 text-[#FF6B35] rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">2</span><div><p class="text-sm font-medium text-gray-800">밝은 조명 확보</p><p class="text-xs text-gray-500">AI 분석 정확도 향상</p></div></li>
              <li class="flex items-start gap-3"><span class="w-5 h-5 bg-[#FF6B35]/10 text-[#FF6B35] rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">3</span><div><p class="text-sm font-medium text-gray-800">여러 각도 촬영</p><p class="text-xs text-gray-500">사각지대 없이 꼼꼼하게</p></div></li>
              <li class="flex items-start gap-3"><span class="w-5 h-5 bg-[#FF6B35]/10 text-[#FF6B35] rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">4</span><div><p class="text-sm font-medium text-gray-800">1920×1080 이상</p><p class="text-xs text-gray-500">세밀한 위험 요소 감지</p></div></li>
            </ol>
          </div>

          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-semibold text-gray-900 mb-3">지원 형식</h3>
            <div class="space-y-2">
              <div class="flex items-center justify-between py-1.5 border-b border-gray-50"><span class="text-xs text-gray-500">형식</span><span class="text-xs font-medium text-gray-700">JPG, PNG, HEIC</span></div>
              <div class="flex items-center justify-between py-1.5 border-b border-gray-50"><span class="text-xs text-gray-500">최대 크기</span><span class="text-xs font-medium text-gray-700">10MB / 장</span></div>
              <div class="flex items-center justify-between py-1.5 border-b border-gray-50"><span class="text-xs text-gray-500">권장 해상도</span><span class="text-xs font-medium text-gray-700">1920×1080+</span></div>
              <div class="flex items-center justify-between py-1.5"><span class="text-xs text-gray-500">분석 시간</span><span class="text-xs font-medium text-gray-700">약 30초</span></div>
            </div>
          </div>

          <div class="bg-yellow-50 rounded-2xl p-4 border border-yellow-200">
            <div class="flex gap-2"><svg class="w-4 h-4 text-yellow-600 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg><div><p class="text-xs font-semibold text-yellow-900 mb-1">개인정보 보호</p><p class="text-xs text-yellow-800">업로드 파일은 암호화 보관되며 분석 후 30일간 저장됩니다.</p></div></div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
var uploadedFiles = [];
var steps = ['이미지 전처리 중...','객체 감지 모델 로딩...','위험 요소 스캔 중...','법규 데이터베이스 대조 중...','리포트 생성 중...'];

function onDragOver(e) { e.preventDefault(); document.getElementById('dropZone').classList.add('border-[#FF6B35]', 'bg-[#FF6B35]/5'); }
function onDragLeave() { document.getElementById('dropZone').classList.remove('border-[#FF6B35]', 'bg-[#FF6B35]/5'); }
function onDrop(e) { e.preventDefault(); onDragLeave(); handleFiles(e.dataTransfer.files); }

function handleFiles(files) {
  var arr = Array.from(files).filter(function(f) { return f.type.startsWith('image/'); });
  if (!arr.length) { alert('이미지 파일만 업로드 가능합니다'); return; }
  arr.forEach(function(file) {
    var reader = new FileReader();
    reader.onload = function(e) {
      uploadedFiles.push({ name: file.name, size: (file.size/1024/1024).toFixed(2) + ' MB', preview: e.target.result });
      renderFiles();
    };
    reader.readAsDataURL(file);
  });
}

function renderFiles() {
  var grid = document.getElementById('fileGrid');
  document.getElementById('fileCount').textContent = uploadedFiles.length;
  document.getElementById('fileList').classList.remove('hidden');
  document.getElementById('analyzeSection').classList.remove('hidden');
  document.getElementById('progressSection').classList.add('hidden');
  document.getElementById('resultSection').classList.add('hidden');
  grid.innerHTML = uploadedFiles.map(function(f, i) {
    return '<div class="relative group rounded-xl overflow-hidden border border-gray-200 bg-gray-50">' +
      '<img src="' + f.preview + '" class="w-full aspect-video object-cover"/>' +
      '<button onclick="removeFile(' + i + ')" class="absolute top-1.5 right-1.5 bg-black/50 text-white rounded-full p-0.5 opacity-0 group-hover:opacity-100 hover:bg-red-500 transition-all"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>' +
      '<div class="px-2 py-1.5 bg-white"><p class="text-xs font-medium text-gray-700 truncate">' + f.name + '</p><p class="text-[10px] text-gray-400">' + f.size + '</p></div></div>';
  }).join('');
}

function removeFile(i) { uploadedFiles.splice(i, 1); renderFiles(); if (!uploadedFiles.length) document.getElementById('fileList').classList.add('hidden'); }
function clearFiles() { uploadedFiles = []; document.getElementById('fileList').classList.add('hidden'); }

function startAnalysis() {
  document.getElementById('analyzeSection').classList.add('hidden');
  document.getElementById('progressSection').classList.remove('hidden');
  var progress = 0;
  var interval = setInterval(function() {
    progress += Math.random() * 12 + 3;
    if (progress >= 100) { progress = 100; clearInterval(interval); showResult(); }
    var idx = Math.floor((progress / 100) * steps.length);
    document.getElementById('analysisStep').textContent = steps[Math.min(idx, steps.length-1)];
    document.getElementById('progressPct').textContent = Math.round(progress) + '%';
    document.getElementById('progressBar').style.width = progress + '%';
  }, 350);
}

function showResult() {
  document.getElementById('progressSection').classList.add('hidden');
  document.getElementById('resultSection').classList.remove('hidden');
}
</script>
</body>
</html>
