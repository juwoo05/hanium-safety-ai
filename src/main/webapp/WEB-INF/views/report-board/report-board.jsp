<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>신고 게시판 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>

<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <!-- Top Bar -->
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl">
      <div class="relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input type="text" id="headerSearch" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
    </div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
      </a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div>
        <span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-4xl mx-auto space-y-5">

      <!-- Page Header -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 flex items-center gap-2">
            <svg class="w-6 h-6 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            신고 게시판
          </h1>
          <p class="text-sm text-gray-500 mt-0.5">현장 위험 및 안전 위반 사항을 익명으로 신고할 수 있습니다</p>
        </div>
        <button onclick="openModal()" class="flex items-center gap-2 px-5 py-2.5 bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-md text-sm">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          신고하기
        </button>
      </div>

      <!-- Stats strip -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <div class="bg-gray-50 rounded-xl p-4 flex flex-col">
          <p class="text-xs text-gray-500 mb-1">전체 신고</p>
          <p class="text-2xl font-bold text-gray-800">${stats.total}</p>
        </div>
        <div class="bg-blue-50 rounded-xl p-4 flex flex-col">
          <p class="text-xs text-gray-500 mb-1">처리중</p>
          <p class="text-2xl font-bold text-blue-700">${stats.inProgress}</p>
        </div>
        <div class="bg-green-50 rounded-xl p-4 flex flex-col">
          <p class="text-xs text-gray-500 mb-1">완료</p>
          <p class="text-2xl font-bold text-green-700">${stats.completed}</p>
        </div>
        <div class="bg-red-50 rounded-xl p-4 flex flex-col">
          <p class="text-xs text-gray-500 mb-1">고위험</p>
          <p class="text-2xl font-bold text-red-700">${stats.highRisk}</p>
        </div>
      </div>

      <!-- Toolbar -->
      <form method="get" action="${pageContext.request.contextPath}/report-board" class="bg-white rounded-xl p-3 shadow-sm border border-gray-100 flex flex-col sm:flex-row gap-3">
        <c:if test="${!empty currentStatus}"><input type="hidden" name="status" value="${currentStatus}"/></c:if>
        <div class="relative flex-1">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
          <input type="text" name="keyword" value="${keyword}" placeholder="제목, 위치, 분류 검색..." class="w-full pl-9 pr-8 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
          <c:if test="${!empty keyword}">
            <a href="?${!empty currentStatus ? 'status='.concat(currentStatus) : ''}" class="absolute right-3 top-1/2 -translate-y-1/2">
              <svg class="w-3.5 h-3.5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </a>
          </c:if>
        </div>
        <div class="flex items-center gap-1 bg-gray-100 rounded-lg p-1">
          <a href="?keyword=${keyword}" class="px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${empty currentStatus ? 'bg-white shadow text-[#FF6B35]' : 'text-gray-500 hover:text-gray-700'}">전체</a>
          <a href="?status=IN_PROGRESS&keyword=${keyword}" class="px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${currentStatus == 'IN_PROGRESS' ? 'bg-white shadow text-[#FF6B35]' : 'text-gray-500 hover:text-gray-700'}">처리중</a>
          <a href="?status=RECEIVED&keyword=${keyword}" class="px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${currentStatus == 'RECEIVED' ? 'bg-white shadow text-[#FF6B35]' : 'text-gray-500 hover:text-gray-700'}">접수</a>
          <a href="?status=COMPLETED&keyword=${keyword}" class="px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${currentStatus == 'COMPLETED' ? 'bg-white shadow text-[#FF6B35]' : 'text-gray-500 hover:text-gray-700'}">완료</a>
        </div>
      </form>

      <!-- Report list -->
      <div class="space-y-3">
        <c:if test="${empty reports}">
          <div class="bg-white rounded-2xl p-12 text-center border border-gray-100"><p class="text-gray-500">검색 결과가 없습니다</p></div>
        </c:if>
        <c:forEach var="r" items="${reports}">
          <c:set var="catColor" value="gray"/>
          <c:set var="catIcon" value="M5 12h.01M12 12h.01M19 12h.01"/>
          <c:choose>
            <c:when test="${r.categoryLabel == '안전 위반'}"><c:set var="catColor" value="red"/><c:set var="catIcon" value="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></c:when>
            <c:when test="${r.categoryLabel == '불량 자재'}"><c:set var="catColor" value="orange"/><c:set var="catIcon" value="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></c:when>
            <c:when test="${r.categoryLabel == '작업 환경'}"><c:set var="catColor" value="blue"/><c:set var="catIcon" value="M9.59 4.59A2 2 0 1 1 11 8H2m10.59 11.41A2 2 0 1 0 14 16H2m15.73-8.27A2.5 2.5 0 1 1 19.5 12H2"/></c:when>
            <c:when test="${r.categoryLabel == '불법 하도급'}"><c:set var="catColor" value="purple"/><c:set var="catIcon" value="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/></c:when>
          </c:choose>
          <c:set var="statusPill" value="bg-gray-100 text-gray-600"/>
          <c:if test="${r.statusValue == 'IN_PROGRESS'}"><c:set var="statusPill" value="bg-blue-100 text-blue-700"/></c:if>
          <c:if test="${r.statusValue == 'COMPLETED'}"><c:set var="statusPill" value="bg-green-100 text-green-700"/></c:if>
          <c:if test="${r.statusValue == 'REJECTED'}"><c:set var="statusPill" value="bg-red-100 text-red-600"/></c:if>
          <c:set var="riskPill" value="bg-yellow-100 text-yellow-700 border-yellow-200"/>
          <c:if test="${r.riskLevelValue == 'high'}"><c:set var="riskPill" value="bg-red-100 text-red-700 border-red-200"/></c:if>
          <c:if test="${r.riskLevelValue == 'medium'}"><c:set var="riskPill" value="bg-orange-100 text-orange-700 border-orange-200"/></c:if>

          <a href="${pageContext.request.contextPath}/report-board/detail?id=${r.id}" class="block bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:border-[#FF6B35] hover:shadow-md transition-all group">
            <div class="flex items-start gap-4">
              <div class="bg-${catColor}-50 w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5">
                <svg class="w-5 h-5 text-${catColor}-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="${catIcon}"/></svg>
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between gap-2 mb-2">
                  <h3 class="font-semibold text-gray-900 text-base leading-snug group-hover:text-[#FF6B35] transition-colors">${r.title}</h3>
                  <svg class="w-4 h-4 text-gray-300 group-hover:text-[#FF6B35] flex-shrink-0 mt-1 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                </div>
                <div class="flex flex-wrap items-center gap-2 mb-3">
                  <span class="text-[10px] font-semibold px-2 py-0.5 rounded-full border ${riskPill}">${r.riskLevelLabel}</span>
                  <span class="text-[10px] font-semibold px-2 py-0.5 rounded-full ${statusPill}">${r.statusLabel}</span>
                  <span class="text-xs text-gray-400 bg-gray-50 px-2 py-0.5 rounded-full">${r.categoryLabel}</span>
                </div>
                <p class="text-sm text-gray-500 mb-3 line-clamp-1">${r.description}</p>
                <div class="flex items-center gap-4 text-xs text-gray-400 flex-wrap">
                  <span class="flex items-center gap-1"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>${r.location}</span>
                  <span class="flex items-center gap-1"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>${r.createdDateLabel}</span>
                  <span class="flex items-center gap-1"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>${r.views}</span>
                  <span class="flex items-center gap-1 ml-auto">
                    <c:choose>
                      <c:when test="${r.anonymous}">익명</c:when>
                      <c:otherwise><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg> ${r.reporterName}</c:otherwise>
                    </c:choose>
                  </span>
                </div>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>

    </div>
  </main>
</div>

<!-- New Report Modal -->
<div id="reportModal" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto">
    <div class="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between rounded-t-2xl">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
        <h2 class="font-bold text-gray-900">신고하기</h2>
      </div>
      <button onclick="closeModal()" class="p-1.5 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-4 h-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
    </div>
    <form id="reportForm" method="post" action="${pageContext.request.contextPath}/report-board" class="p-6 space-y-4">
      <input type="hidden" name="anonymous" id="anonymousInput" value="true"/>
      <!-- Anonymous toggle -->
      <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100">
        <div class="flex items-center gap-3">
          <svg id="anonIcon" class="w-5 h-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
          <div>
            <p class="text-sm font-semibold text-gray-800" id="anonLabel">익명으로 신고</p>
            <p class="text-xs text-gray-500">신고자 정보는 관리자만 확인 가능합니다</p>
          </div>
        </div>
        <button type="button" onclick="toggleAnon()" id="anonToggle" class="relative w-11 h-6 rounded-full transition-colors bg-[#FF6B35]">
          <div id="anonThumb" class="absolute top-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform translate-x-5"></div>
        </button>
      </div>
      <!-- Fields -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">제목 <span class="text-red-500">*</span></label>
        <input type="text" name="title" id="fTitle" placeholder="신고 내용을 간략히 입력하세요" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">분류</label>
          <select name="category" id="fCategory" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none bg-white">
            <option value="SAFETY_VIOLATION">안전 위반</option>
            <option value="DEFECTIVE_MATERIAL">불량 자재</option>
            <option value="WORK_ENVIRONMENT">작업 환경</option>
            <option value="ILLEGAL_SUBCONTRACT">불법 하도급</option>
            <option value="ETC">기타</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험도</label>
          <select name="riskLevel" id="fRisk" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none bg-white">
            <option value="HIGH">고위험</option><option value="MEDIUM">중위험</option><option value="LOW">저위험</option>
          </select>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">위치 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
          <input type="text" name="location" id="fLocation" placeholder="예: 3동 옥상, 지하 주차장" class="w-full pl-9 pr-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">상세 내용 <span class="text-red-500">*</span></label>
        <textarea name="description" id="fDesc" rows="4" placeholder="발견한 위험 상황이나 안전 위반 사항을 구체적으로 설명해주세요." class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none"></textarea>
      </div>
      <div class="bg-blue-50 rounded-xl p-3 border border-blue-100 text-xs text-blue-700">
        신고 내용은 현장 안전 관리자와 담당 부서에 전달되며, 익명 신고 시 신고자 정보는 보호됩니다.
      </div>
      <div class="flex gap-3 pt-1">
        <button type="button" onclick="closeModal()" class="flex-1 py-3 border border-gray-200 rounded-xl text-sm font-semibold text-gray-600 hover:bg-gray-50 transition-colors">취소</button>
        <button type="button" onclick="submitReport()" class="flex-1 py-3 bg-[#FF6B35] text-white rounded-xl text-sm font-bold hover:bg-[#E55A2A] transition-colors shadow-md">신고 접수하기</button>
      </div>
    </form>
  </div>
</div>

<!-- Toast -->
<div id="toast" class="hidden fixed bottom-6 left-1/2 -translate-x-1/2 bg-gray-900 text-white text-sm font-medium px-5 py-3 rounded-xl shadow-xl z-50 flex items-center gap-2">
  <svg class="w-4 h-4 text-green-400 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
  <span id="toastMsg"></span>
</div>

<script>
function openModal() {
  document.getElementById('fTitle').value='';
  document.getElementById('fLocation').value='';
  document.getElementById('fDesc').value='';
  document.getElementById('fCategory').value='SAFETY_VIOLATION';
  document.getElementById('fRisk').value='HIGH';
  document.getElementById('anonymousInput').value='true';
  updateAnonUI();
  document.getElementById('reportModal').classList.remove('hidden');
}

function closeModal() { document.getElementById('reportModal').classList.add('hidden'); }

function toggleAnon() {
  var input = document.getElementById('anonymousInput');
  input.value = (input.value === 'true') ? 'false' : 'true';
  updateAnonUI();
}

function updateAnonUI() {
  var isAnon = document.getElementById('anonymousInput').value === 'true';
  const btn = document.getElementById('anonToggle');
  const thumb = document.getElementById('anonThumb');
  const label = document.getElementById('anonLabel');
  if (isAnon) {
    btn.classList.remove('bg-gray-300'); btn.classList.add('bg-[#FF6B35]');
    thumb.classList.remove('translate-x-0.5'); thumb.classList.add('translate-x-5');
    label.textContent='익명으로 신고';
  } else {
    btn.classList.remove('bg-[#FF6B35]'); btn.classList.add('bg-gray-300');
    thumb.classList.remove('translate-x-5'); thumb.classList.add('translate-x-0.5');
    label.textContent='실명으로 신고';
  }
}

function submitReport() {
  const title = document.getElementById('fTitle').value.trim();
  const location = document.getElementById('fLocation').value.trim();
  const desc = document.getElementById('fDesc').value.trim();
  if (!title||!location||!desc) { showToast('제목, 위치, 내용을 모두 입력해주세요', true); return; }
  document.getElementById('reportForm').submit();
}

let toastTimer;
function showToast(msg) {
  const el = document.getElementById('toast');
  document.getElementById('toastMsg').textContent=msg;
  el.classList.remove('hidden');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(()=>el.classList.add('hidden'),3000);
}
</script>
</body>
</html>
