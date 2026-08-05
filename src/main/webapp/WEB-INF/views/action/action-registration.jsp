<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>조치 등록 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<%@ include file="../common/_topnav.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <a href="/actions" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
      </a>
      <h1 class="text-lg font-semibold text-gray-900">새 조치 등록</h1>
    </div>
    <div class="flex items-center gap-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto">
      <div class="space-y-6">

        <!-- 기본 정보 -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h2 class="text-base font-semibold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-6 h-6 bg-[#FF6B35] text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
            기본 정보
          </h2>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">조치명 <span class="text-red-500">*</span></label>
              <input id="fieldTitle" type="text" placeholder="조치 내용을 간략히 입력하세요"
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">위험 분류 <span class="text-red-500">*</span></label>
                <select id="fieldCategory" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                  <option value="">선택</option>
                  <option>추락 위험</option><option>전기 위험</option><option>화재 위험</option>
                  <option>협착 위험</option><option>붕괴 위험</option><option>화학물질</option><option>기타</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">위험 등급 <span class="text-red-500">*</span></label>
                <select id="fieldRiskLevel" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                  <option value="">선택</option>
                  <option value="HIGH">고위험</option>
                  <option value="MEDIUM">중위험</option>
                  <option value="SAFE">안전</option>
                </select>
              </div>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">현장 위치 <span class="text-red-500">*</span></label>
              <input id="fieldLocation" type="text" placeholder="예: 3동 옥상"
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">상세 설명</label>
              <textarea id="fieldDescription" rows="4" placeholder="위험 상황 및 조치 내용을 상세히 기입하세요"
                        class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none"></textarea>
            </div>
          </div>
        </div>

        <!-- 담당자 & 일정 -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h2 class="text-base font-semibold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-6 h-6 bg-[#FF6B35] text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
            담당자 및 일정
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">담당자 <span class="text-red-500">*</span></label>
              <select id="fieldAssignee" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                <option value="">불러오는 중...</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">마감일 <span class="text-red-500">*</span></label>
              <input id="fieldDeadline" type="date"
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
          </div>
          <p class="text-xs text-gray-400 mt-3">새로 등록된 조치는 "조치 전" 상태로 시작합니다.</p>
        </div>

        <!-- Submit -->
        <div class="flex gap-3">
          <a href="/actions" class="flex-1 py-3 text-center border-2 border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors">취소</a>
          <button id="submitBtn" onclick="submitAction()" class="flex-1 py-3 bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-lg">조치 등록</button>
        </div>
      </div>
    </div>
  </main>
</div>
<script>
(function () {
  var CURRENT_USER_ID = null;

  function qs(sel) { return document.querySelector(sel); }

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

    if (!title) { alert('조치명을 입력하세요'); return; }
    if (!category) { alert('위험 분류를 선택하세요'); return; }
    if (!riskLevel) { alert('위험 등급을 선택하세요'); return; }
    if (!location) { alert('현장 위치를 입력하세요'); return; }
    if (!assigneeId) { alert('담당자를 지정하세요'); return; }
    if (!deadline) { alert('마감일을 설정하세요'); return; }
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
        btn.textContent = '조치 등록';
      });
  };
})();
</script>
</body>
</html>
