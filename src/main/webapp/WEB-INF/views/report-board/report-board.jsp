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

<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <!-- Top Bar -->
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl">
      <div class="relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input type="text" id="headerSearch" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
      </div>
    </div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
      </a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div>
        <span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-4xl mx-auto space-y-5">

      <!-- Page Header -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <p style="font-size:11px;color:#9CA3AF;letter-spacing:0.06em;text-transform:uppercase;font-weight:500;margin-bottom:5px">신고 접수</p>
          <h1 style="font-size:22px;font-weight:600;color:#0F172A;letter-spacing:-0.02em;line-height:1">신고 게시판</h1>
        </div>
        <button onclick="openModal()" style="display:flex;align-items:center;gap:6px;padding:7px 14px;background:#1A2E44;color:white;border:none;border-radius:4px;font-size:13px;font-weight:500;cursor:pointer">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          신고하기
        </button>
      </div>

      <!-- Stats -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <div style="background:#F9FAFB;border:1px solid #E5E7EB;border-radius:4px;padding:14px 18px"><p style="font-size:11px;color:#9CA3AF;margin-bottom:4px">전체 신고</p><p style="font-size:22px;font-weight:700;color:#0F172A">${stats.total}</p></div>
        <div style="background:#EFF6FF;border:1px solid #E5E7EB;border-radius:4px;padding:14px 18px"><p style="font-size:11px;color:#9CA3AF;margin-bottom:4px">처리중</p><p style="font-size:22px;font-weight:700;color:#1D4ED8">${stats.inProgress}</p></div>
        <div style="background:#F0FDF4;border:1px solid #E5E7EB;border-radius:4px;padding:14px 18px"><p style="font-size:11px;color:#9CA3AF;margin-bottom:4px">완료</p><p style="font-size:22px;font-weight:700;color:#166534">${stats.completed}</p></div>
        <div style="background:#FEF2F2;border:1px solid #E5E7EB;border-radius:4px;padding:14px 18px"><p style="font-size:11px;color:#9CA3AF;margin-bottom:4px">고위험</p><p style="font-size:22px;font-weight:700;color:#991B1B">${stats.highRisk}</p></div>
      </div>

      <!-- Filters + search -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;border-bottom-left-radius:0;border-bottom-right-radius:0;border-bottom:none;padding:0 20px" class="flex items-center justify-between flex-wrap">
        <div class="flex items-center">
          <a href="?keyword=${keyword}" style="padding:11px 14px;font-size:13px;font-weight:${empty currentStatus ? 600 : 400};color:${empty currentStatus ? '#0F172A' : '#9CA3AF'};text-decoration:none;border-bottom:2px solid ${empty currentStatus ? '#0F172A' : 'transparent'};margin-bottom:-1px;display:inline-block">전체</a>
          <a href="?status=IN_PROGRESS&keyword=${keyword}" style="padding:11px 14px;font-size:13px;font-weight:${currentStatus == 'IN_PROGRESS' ? 600 : 400};color:${currentStatus == 'IN_PROGRESS' ? '#0F172A' : '#9CA3AF'};text-decoration:none;border-bottom:2px solid ${currentStatus == 'IN_PROGRESS' ? '#0F172A' : 'transparent'};margin-bottom:-1px;display:inline-block">처리중</a>
          <a href="?status=RECEIVED&keyword=${keyword}" style="padding:11px 14px;font-size:13px;font-weight:${currentStatus == 'RECEIVED' ? 600 : 400};color:${currentStatus == 'RECEIVED' ? '#0F172A' : '#9CA3AF'};text-decoration:none;border-bottom:2px solid ${currentStatus == 'RECEIVED' ? '#0F172A' : 'transparent'};margin-bottom:-1px;display:inline-block">접수</a>
          <a href="?status=COMPLETED&keyword=${keyword}" style="padding:11px 14px;font-size:13px;font-weight:${currentStatus == 'COMPLETED' ? 600 : 400};color:${currentStatus == 'COMPLETED' ? '#0F172A' : '#9CA3AF'};text-decoration:none;border-bottom:2px solid ${currentStatus == 'COMPLETED' ? '#0F172A' : 'transparent'};margin-bottom:-1px;display:inline-block">완료</a>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/report-board" class="flex items-center" style="padding:8px 0">
          <c:if test="${!empty currentStatus}"><input type="hidden" name="status" value="${currentStatus}"/></c:if>
          <div class="relative flex items-center">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="position:absolute;left:10px"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" name="keyword" value="${keyword}" placeholder="제목, 위치, 분류 검색"
                   style="padding:6px 10px 6px 30px;font-size:12px;border:1px solid #E5E7EB;border-radius:4px;outline:none;background:#F9FAFB;color:#374151;width:220px"/>
          </div>
        </form>
      </div>

      <!-- Report table -->
      <div style="background:white;border:1px solid #E5E7EB;border-top-left-radius:0;border-top-right-radius:0;border-radius:4px;overflow:hidden">
        <table style="width:100%;border-collapse:collapse;font-size:13px">
          <thead>
            <tr style="background:#F9FAFB;border-bottom:1px solid #F3F4F6">
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">분류</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">제목</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">위치</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">신고일</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">위험</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">상태</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">조회</th>
              <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;white-space:nowrap">신고자</th>
              <th style="padding:9px 16px;border-bottom:none"></th>
            </tr>
          </thead>
          <tbody>
            <c:if test="${empty reports}">
              <tr><td colspan="9" style="padding:48px;text-align:center;color:#9CA3AF;font-size:13px">검색 결과가 없습니다.</td></tr>
            </c:if>
            <c:forEach var="r" items="${reports}">
              <c:set var="catIcon" value="M5 12h.01M12 12h.01M19 12h.01"/>
              <c:choose>
                <c:when test="${r.categoryLabel == '안전 위반'}"><c:set var="catIcon" value="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></c:when>
                <c:when test="${r.categoryLabel == '불량 자재'}"><c:set var="catIcon" value="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></c:when>
                <c:when test="${r.categoryLabel == '작업 환경'}"><c:set var="catIcon" value="M9.59 4.59A2 2 0 1 1 11 8H2m10.59 11.41A2 2 0 1 0 14 16H2m15.73-8.27A2.5 2.5 0 1 1 19.5 12H2"/></c:when>
                <c:when test="${r.categoryLabel == '불법 하도급'}"><c:set var="catIcon" value="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/></c:when>
              </c:choose>
              <c:set var="statusColor" value="#6B7280"/><c:set var="statusBg" value="#F3F4F6"/>
              <c:if test="${r.statusValue == 'IN_PROGRESS'}"><c:set var="statusColor" value="#1D4ED8"/><c:set var="statusBg" value="#EFF6FF"/></c:if>
              <c:if test="${r.statusValue == 'COMPLETED'}"><c:set var="statusColor" value="#166534"/><c:set var="statusBg" value="#F0FDF4"/></c:if>
              <c:if test="${r.statusValue == 'REJECTED'}"><c:set var="statusColor" value="#991B1B"/><c:set var="statusBg" value="#FEF2F2"/></c:if>
              <c:set var="riskColor" value="#166534"/><c:set var="riskBg" value="#F0FDF4"/>
              <c:if test="${r.riskLevelValue == 'high'}"><c:set var="riskColor" value="#991B1B"/><c:set var="riskBg" value="#FEF2F2"/></c:if>
              <c:if test="${r.riskLevelValue == 'medium'}"><c:set var="riskColor" value="#B45309"/><c:set var="riskBg" value="#FFFBEB"/></c:if>

              <tr class="report-row" onclick="window.location='${pageContext.request.contextPath}/report-board/detail?id=${r.id}'" style="border-bottom:1px solid #F9FAFB;cursor:pointer">
                <td style="padding:10px 16px"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><path d="${catIcon}"/></svg></td>
                <td style="padding:10px 16px;max-width:280px">
                  <p style="font-weight:500;color:#0F172A;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${r.title}</p>
                  <p style="font-size:11px;color:#9CA3AF;margin-top:1px">${r.categoryLabel}</p>
                </td>
                <td style="padding:10px 16px"><span style="display:flex;align-items:center;gap:4px;font-size:12px;color:#6B7280"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>${r.location}</span></td>
                <td style="padding:10px 16px;font-size:12px;color:#6B7280"><span style="display:flex;align-items:center;gap:4px"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>${r.createdDateLabel}</span></td>
                <td style="padding:10px 16px"><span style="font-size:10px;font-weight:600;padding:1px 7px;border-radius:3px;background:${riskBg};color:${riskColor}">${r.riskLevelLabel}</span></td>
                <td style="padding:10px 16px"><span style="font-size:11px;font-weight:500;padding:2px 8px;border-radius:3px;background:${statusBg};color:${statusColor}">${r.statusLabel}</span></td>
                <td style="padding:10px 16px"><span style="display:flex;align-items:center;gap:4px;font-size:12px;color:#9CA3AF"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>${r.views}</span></td>
                <td style="padding:10px 16px;font-size:12px;color:#6B7280">
                  <c:choose>
                    <c:when test="${r.anonymous}">익명</c:when>
                    <c:otherwise>${r.reporterName}</c:otherwise>
                  </c:choose>
                </td>
                <td style="padding:10px 16px"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
        <div style="padding:10px 20px;border-top:1px solid #F3F4F6"><span style="font-size:12px;color:#9CA3AF">${reports.size()}건 표시</span></div>
      </div>

    </div>
  </main>
</div>

<!-- New Report Modal -->
<div id="reportModal" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto">
    <div class="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between rounded-t-2xl">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
        <h2 class="font-bold text-gray-900">신고하기</h2>
      </div>
      <button onclick="closeModal()" class="p-1.5 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-4 h-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
    </div>
    <form id="reportForm" method="post" action="${pageContext.request.contextPath}/report-board" class="p-6 space-y-4">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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
        <button type="button" onclick="toggleAnon()" id="anonToggle" class="relative w-11 h-6 rounded-full transition-colors bg-[#1A2E44]">
          <div id="anonThumb" class="absolute top-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform translate-x-5"></div>
        </button>
      </div>
      <!-- Fields -->
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">제목 <span class="text-red-500">*</span></label>
        <input type="text" name="title" id="fTitle" placeholder="신고 내용을 간략히 입력하세요" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
      </div>
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">분류</label>
          <select name="category" id="fCategory" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] outline-none bg-white">
            <option value="SAFETY_VIOLATION">안전 위반</option>
            <option value="DEFECTIVE_MATERIAL">불량 자재</option>
            <option value="WORK_ENVIRONMENT">작업 환경</option>
            <option value="ILLEGAL_SUBCONTRACT">불법 하도급</option>
            <option value="ETC">기타</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-1.5">위험도</label>
          <select name="riskLevel" id="fRisk" class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] outline-none bg-white">
            <option value="HIGH">고위험</option><option value="MEDIUM">중위험</option><option value="LOW">저위험</option>
          </select>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">위치 <span class="text-red-500">*</span></label>
        <div class="relative">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
          <input type="text" name="location" id="fLocation" placeholder="예: 3동 옥상, 지하 주차장" class="w-full pl-9 pr-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/>
        </div>
      </div>
      <div>
        <label class="block text-sm font-semibold text-gray-700 mb-1.5">상세 내용 <span class="text-red-500">*</span></label>
        <textarea name="description" id="fDesc" rows="4" placeholder="발견한 위험 상황이나 안전 위반 사항을 구체적으로 설명해주세요." class="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none"></textarea>
      </div>
      <div class="bg-blue-50 rounded-xl p-3 border border-blue-100 text-xs text-blue-700">
        신고 내용은 현장 안전 관리자와 담당 부서에 전달되며, 익명 신고 시 신고자 정보는 보호됩니다.
      </div>
      <div class="flex gap-3 pt-1">
        <button type="button" onclick="closeModal()" class="flex-1 py-3 border border-gray-200 rounded-xl text-sm font-semibold text-gray-600 hover:bg-gray-50 transition-colors">취소</button>
        <button type="button" onclick="submitReport()" class="flex-1 py-3 bg-[#1A2E44] text-white rounded-xl text-sm font-bold hover:bg-[#0F2233] transition-colors shadow-md">신고 접수하기</button>
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
function loadCurrentUser() {
  fetch('/api/users/me')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (user) {
      document.getElementById('headerUserName').textContent = user.username;
      document.getElementById('headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(function () {});
}
loadCurrentUser();

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
    btn.classList.remove('bg-gray-300'); btn.classList.add('bg-[#1A2E44]');
    thumb.classList.remove('translate-x-0.5'); thumb.classList.add('translate-x-5');
    label.textContent='익명으로 신고';
  } else {
    btn.classList.remove('bg-[#1A2E44]'); btn.classList.add('bg-gray-300');
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
