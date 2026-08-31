<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>조치 등록 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <a href="/actions" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
      </a>
      <h1 class="text-lg font-semibold text-gray-900">새 조치 등록</h1>
    </div>
    <div class="flex items-center gap-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-2xl mx-auto space-y-5">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">조치 사항 등록</h1>
        <p class="text-sm text-gray-500 mt-1">새로운 안전 조치 사항을 단계별로 등록합니다</p>
      </div>

      <!-- Step indicator -->
      <div class="bg-white rounded px-6 py-5 shadow-sm border border-gray-100">
        <div class="flex items-center" id="stepIndicator">
          <!-- step 1 -->
          <div class="flex items-center flex-1">
            <div class="flex flex-col items-center gap-1.5">
              <div id="stepDot1" class="w-9 h-9 rounded-full flex items-center justify-center transition-all bg-[#1A2E44] text-white shadow-md shadow-[#1A2E44]/40 scale-110">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              </div>
              <span id="stepLabel1" class="text-[10px] font-medium whitespace-nowrap text-[#1A2E44]">기본 정보</span>
            </div>
            <div id="stepBar1" class="flex-1 h-0.5 mx-2 mb-5 bg-gray-200"></div>
          </div>
          <!-- step 2 -->
          <div class="flex items-center flex-1">
            <div class="flex flex-col items-center gap-1.5">
              <div id="stepDot2" class="w-9 h-9 rounded-full flex items-center justify-center transition-all bg-gray-100 text-gray-400">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
              </div>
              <span id="stepLabel2" class="text-[10px] font-medium whitespace-nowrap text-gray-400">담당자·일정</span>
            </div>
            <div id="stepBar2" class="flex-1 h-0.5 mx-2 mb-5 bg-gray-200"></div>
          </div>
          <!-- step 3 -->
          <div class="flex items-center flex-none">
            <div class="flex flex-col items-center gap-1.5">
              <div id="stepDot3" class="w-9 h-9 rounded-full flex items-center justify-center transition-all bg-gray-100 text-gray-400">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
              </div>
              <span id="stepLabel3" class="text-[10px] font-medium whitespace-nowrap text-gray-400">검토·제출</span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded p-6 shadow-sm border border-gray-100">

        <!-- STEP 1: 기본 정보 -->
        <div id="panel1">
          <div class="flex items-center gap-2 mb-4">
            <svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            <h2 class="text-base font-bold text-gray-900">기본 정보</h2>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">조치명 <span class="text-red-500">*</span></label>
              <input id="fieldTitle" type="text" placeholder="조치 내용을 간략히 입력하세요"
                     class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
              <p id="errTitle" class="text-red-500 text-xs mt-1 hidden">조치명을 입력하세요</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험 분류 <span class="text-red-500">*</span></label>
                <select id="fieldCategory" class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                  <option value="">선택</option>
                  <option>추락 위험</option><option>전기 위험</option><option>화재 위험</option>
                  <option>협착 위험</option><option>붕괴 위험</option><option>화학물질</option><option>기타</option>
                </select>
                <p id="errCategory" class="text-red-500 text-xs mt-1 hidden">위험 분류를 선택하세요</p>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험 등급 <span class="text-red-500">*</span></label>
                <select id="fieldRiskLevel" class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                  <option value="">선택</option>
                  <option value="HIGH">고위험</option>
                  <option value="MEDIUM">중위험</option>
                  <option value="SAFE">안전</option>
                </select>
                <p id="errRiskLevel" class="text-red-500 text-xs mt-1 hidden">위험 등급을 선택하세요</p>
              </div>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">현장 위치 <span class="text-red-500">*</span></label>
              <input id="fieldLocation" type="text" placeholder="예: 3동 옥상"
                     class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
              <p id="errLocation" class="text-red-500 text-xs mt-1 hidden">현장 위치를 입력하세요</p>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">상세 설명</label>
              <textarea id="fieldDescription" rows="4" placeholder="위험 상황 및 조치 내용을 상세히 기입하세요"
                        class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none"></textarea>
            </div>
          </div>
        </div>

        <!-- STEP 2: 담당자 및 일정 -->
        <div id="panel2" class="hidden">
          <div class="flex items-center gap-2 mb-4">
            <svg class="w-5 h-5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
            <h2 class="text-base font-bold text-gray-900">담당자 및 일정</h2>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">담당자 <span class="text-red-500">*</span></label>
              <select id="fieldAssignee" class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                <option value="">불러오는 중...</option>
              </select>
              <p id="errAssignee" class="text-red-500 text-xs mt-1 hidden">담당자를 지정하세요</p>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-1.5">마감일 <span class="text-red-500">*</span></label>
              <input id="fieldDeadline" type="date"
                     class="w-full px-4 py-3 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
              <p id="errDeadline" class="text-red-500 text-xs mt-1 hidden">마감일을 설정하세요</p>
            </div>
          </div>
          <p class="text-xs text-gray-400 mt-3">새로 등록된 조치는 "조치 전" 상태로 시작합니다.</p>
        </div>

        <!-- STEP 3: 검토 및 제출 -->
        <div id="panel3" class="hidden space-y-4">
          <div class="flex items-center gap-2 mb-1">
            <svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <h2 class="text-base font-bold text-gray-900">검토 및 제출</h2>
          </div>
          <div class="space-y-2.5">
            <div class="flex items-start justify-between gap-4 py-2.5 border-b border-gray-50">
              <span class="text-xs text-gray-500 w-20 flex-shrink-0 pt-0.5">조치명</span>
              <span id="reviewTitle" class="text-sm font-medium text-gray-900 flex-1 text-right">-</span>
              <button onclick="goToStep(1)" class="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
            </div>
            <div class="flex items-start justify-between gap-4 py-2.5 border-b border-gray-50">
              <span class="text-xs text-gray-500 w-20 flex-shrink-0 pt-0.5">위험 분류/등급</span>
              <span id="reviewRisk" class="text-sm font-medium text-gray-900 flex-1 text-right">-</span>
              <button onclick="goToStep(1)" class="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
            </div>
            <div class="flex items-start justify-between gap-4 py-2.5 border-b border-gray-50">
              <span class="text-xs text-gray-500 w-20 flex-shrink-0 pt-0.5">현장 위치</span>
              <span id="reviewLocation" class="text-sm font-medium text-gray-900 flex-1 text-right">-</span>
              <button onclick="goToStep(1)" class="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
            </div>
            <div class="flex items-start justify-between gap-4 py-2.5 border-b border-gray-50">
              <span class="text-xs text-gray-500 w-20 flex-shrink-0 pt-0.5">담당자</span>
              <span id="reviewAssignee" class="text-sm font-medium text-gray-900 flex-1 text-right">-</span>
              <button onclick="goToStep(2)" class="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
            </div>
            <div class="flex items-start justify-between gap-4 py-2.5">
              <span class="text-xs text-gray-500 w-20 flex-shrink-0 pt-0.5">마감일</span>
              <span id="reviewDeadline" class="text-sm font-medium text-gray-900 flex-1 text-right">-</span>
              <button onclick="goToStep(2)" class="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
            </div>
          </div>
          <div class="bg-blue-50 rounded p-3 border border-blue-100 text-xs text-blue-700">
            등록 후 담당자에게 조치가 배정됩니다.
          </div>
          <button id="submitBtn" onclick="submitAction()" class="w-full py-4 bg-[#1A2E44] text-white rounded font-bold hover:bg-[#0F2233] transition-colors shadow-lg shadow-[#1A2E44]/30 flex items-center justify-center gap-2 text-base">
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            조치 사항 등록 완료
          </button>
        </div>

        <!-- Navigation -->
        <div id="navRow" class="flex items-center justify-between mt-6 pt-5 border-t border-gray-100">
          <button id="prevBtn" onclick="prevStep()" disabled
                  class="flex items-center gap-2 px-5 py-2.5 border border-gray-200 rounded text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed transition-all">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m15 18-6-6 6-6"/></svg> 이전
          </button>
          <span id="stepCounter" class="text-xs text-gray-400">1 / 3</span>
          <button id="nextBtn" onclick="nextStep()"
                  class="flex items-center gap-2 px-5 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#0F2233] transition-colors shadow-sm">
            다음 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
          </button>
        </div>
      </div>
    </div>
  </main>
</div>
<script>
(function () {
  var CURRENT_USER_ID = null;
  var step = 1;
  var CATEGORY_LABEL = {};
  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };

  function qs(sel) { return document.querySelector(sel); }
  function hide(el) { el.classList.add('hidden'); }
  function show(el) { el.classList.remove('hidden'); }

  function renderStepIndicator() {
    for (var i = 1; i <= 3; i++) {
      var dot = qs('#stepDot' + i);
      var label = qs('#stepLabel' + i);
      if (i < step) {
        dot.className = 'w-9 h-9 rounded-full flex items-center justify-center transition-all bg-green-500 text-white';
        dot.innerHTML = '<svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>';
        label.className = 'text-[10px] font-medium whitespace-nowrap text-green-600';
      } else if (i === step) {
        dot.className = 'w-9 h-9 rounded-full flex items-center justify-center transition-all bg-[#1A2E44] text-white shadow-md shadow-[#1A2E44]/40 scale-110';
        label.className = 'text-[10px] font-medium whitespace-nowrap text-[#1A2E44]';
      } else {
        dot.className = 'w-9 h-9 rounded-full flex items-center justify-center transition-all bg-gray-100 text-gray-400';
        label.className = 'text-[10px] font-medium whitespace-nowrap text-gray-400';
      }
    }
    var bar1 = qs('#stepBar1'), bar2 = qs('#stepBar2');
    bar1.className = 'flex-1 h-0.5 mx-2 mb-5 ' + (step > 1 ? 'bg-green-400' : 'bg-gray-200');
    bar2.className = 'flex-1 h-0.5 mx-2 mb-5 ' + (step > 2 ? 'bg-green-400' : 'bg-gray-200');
  }

  function renderPanels() {
    [1, 2, 3].forEach(function (i) {
      var panel = qs('#panel' + i);
      if (i === step) show(panel); else hide(panel);
    });
    qs('#stepCounter').textContent = step + ' / 3';
    qs('#prevBtn').disabled = step === 1;
    if (step === 3) {
      hide(qs('#nextBtn'));
      populateReview();
    } else {
      show(qs('#nextBtn'));
    }
  }

  function clearErrors(ids) {
    ids.forEach(function (id) { hide(qs('#err' + id)); });
  }

  function validateStep1() {
    var ok = true;
    clearErrors(['Title', 'Category', 'RiskLevel', 'Location']);
    if (!qs('#fieldTitle').value.trim()) { show(qs('#errTitle')); ok = false; }
    if (!qs('#fieldCategory').value) { show(qs('#errCategory')); ok = false; }
    if (!qs('#fieldRiskLevel').value) { show(qs('#errRiskLevel')); ok = false; }
    if (!qs('#fieldLocation').value.trim()) { show(qs('#errLocation')); ok = false; }
    return ok;
  }

  function validateStep2() {
    var ok = true;
    clearErrors(['Assignee', 'Deadline']);
    if (!qs('#fieldAssignee').value) { show(qs('#errAssignee')); ok = false; }
    if (!qs('#fieldDeadline').value) { show(qs('#errDeadline')); ok = false; }
    return ok;
  }

  function populateReview() {
    qs('#reviewTitle').textContent = qs('#fieldTitle').value.trim() || '-';
    var category = qs('#fieldCategory').value;
    var riskLevel = qs('#fieldRiskLevel').value;
    qs('#reviewRisk').textContent = (category || '-') + ' / ' + (RISK_LABEL[riskLevel] || '-');
    qs('#reviewLocation').textContent = qs('#fieldLocation').value.trim() || '-';
    var assigneeSel = qs('#fieldAssignee');
    qs('#reviewAssignee').textContent = assigneeSel.options[assigneeSel.selectedIndex] ? assigneeSel.options[assigneeSel.selectedIndex].text : '-';
    qs('#reviewDeadline').textContent = qs('#fieldDeadline').value || '-';
  }

  window.goToStep = function (n) { step = n; renderStepIndicator(); renderPanels(); };
  window.nextStep = function () {
    if (step === 1 && !validateStep1()) return;
    if (step === 2 && !validateStep2()) return;
    step = Math.min(3, step + 1);
    renderStepIndicator();
    renderPanels();
  };
  window.prevStep = function () {
    step = Math.max(1, step - 1);
    renderStepIndicator();
    renderPanels();
  };

  fetch('/api/users/me')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (user) {
      CURRENT_USER_ID = user.id;
      qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(function () {});

  fetch('/api/users/subcontractors')
    .then(function (res) { return res.ok ? res.json() : []; })
    .then(function (users) {
      var sel = qs('#fieldAssignee');
      sel.innerHTML = users.length ? '<option value="">선택</option>' : '<option value="">등록된 하청 담당자가 없습니다</option>';
      users.forEach(function (u) {
        var opt = document.createElement('option');
        opt.value = u.id;
        opt.textContent = u.username + (u.companyName ? ' (' + u.companyName + ')' : '');
        sel.appendChild(opt);
      });
    })
    .catch(function () { qs('#fieldAssignee').innerHTML = '<option value="">담당자 목록을 불러오지 못했습니다</option>'; });

  window.submitAction = function () {
    var title = qs('#fieldTitle').value.trim();
    var category = qs('#fieldCategory').value;
    var riskLevel = qs('#fieldRiskLevel').value;
    var location = qs('#fieldLocation').value.trim();
    var assigneeId = qs('#fieldAssignee').value;
    var deadline = qs('#fieldDeadline').value;
    var description = qs('#fieldDescription').value.trim();

    if (!title || !category || !riskLevel || !location) { goToStep(1); return; }
    if (!assigneeId || !deadline) { goToStep(2); return; }
    if (!CURRENT_USER_ID) { alert('사용자 정보를 아직 불러오지 못했습니다. 잠시 후 다시 시도해주세요.'); return; }

    var btn = qs('#submitBtn');
    btn.disabled = true;
    btn.textContent = '등록 중...';

    fetch('/api/actions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        inspectionId: null,
        title: title,
        category: category,
        riskLevel: riskLevel,
        reporterId: Number(assigneeId),
        discoveredDate: new Date().toISOString().slice(0, 10),
        dueDate: deadline,
        description: description || null,
        recommendation: null,
        regulationRef: null,
        memo: null,
        location: location,
        createdBy: CURRENT_USER_ID,
      }),
    })
      .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
      .then(function (result) {
        if (!result.ok) throw new Error(result.body.error || '조치 등록이 실패했습니다.');
        alert('조치가 등록되었습니다.');
        window.location.href = '/actions';
      })
      .catch(function (err) {
        alert(err.message);
        btn.disabled = false;
        btn.textContent = '조치 사항 등록 완료';
      });
  };

  renderStepIndicator();
  renderPanels();
})();
</script>
</body>
</html>
