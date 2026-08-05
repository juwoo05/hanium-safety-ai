<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>신고 상세 - SafeMate</title>
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
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div>
        <span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-4xl mx-auto space-y-5">

      <!-- Back -->
      <a href="${pageContext.request.contextPath}/report-board" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-800 transition-colors">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        신고 게시판으로
      </a>

      <c:set var="riskPill" value="bg-yellow-100 text-yellow-700 border-yellow-200"/>
      <c:if test="${report.riskLevelValue == 'high'}"><c:set var="riskPill" value="bg-red-100 text-red-700 border-red-200"/></c:if>
      <c:if test="${report.riskLevelValue == 'medium'}"><c:set var="riskPill" value="bg-orange-100 text-orange-700 border-orange-200"/></c:if>
      <c:set var="statusPill" value="bg-gray-100 text-gray-600"/>
      <c:if test="${report.statusValue == 'IN_PROGRESS'}"><c:set var="statusPill" value="bg-blue-100 text-blue-700"/></c:if>
      <c:if test="${report.statusValue == 'COMPLETED'}"><c:set var="statusPill" value="bg-green-100 text-green-700"/></c:if>
      <c:if test="${report.statusValue == 'REJECTED'}"><c:set var="statusPill" value="bg-red-100 text-red-600"/></c:if>

      <!-- Header card -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-start justify-between gap-4 mb-4">
          <div class="flex items-start gap-3 flex-1">
            <div class="w-10 h-10 bg-red-50 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5">
              <svg class="w-5 h-5 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            </div>
            <div>
              <div class="flex flex-wrap items-center gap-2 mb-2">
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full border ${riskPill}">${report.riskLevelLabel}</span>
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full ${statusPill}">${report.statusLabel}</span>
                <span class="text-xs text-gray-400 bg-gray-50 px-2 py-1 rounded-full">${report.categoryLabel}</span>
              </div>
              <h1 class="text-xl font-bold text-gray-900">${report.title}</h1>
            </div>
          </div>
          <div class="flex flex-col gap-2 flex-shrink-0">
            <c:if test="${canManageStatus}">
              <c:if test="${report.statusValue == 'RECEIVED'}">
                <form method="post" action="${pageContext.request.contextPath}/report-board/${report.id}/status">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <input type="hidden" name="status" value="IN_PROGRESS"/>
                  <button type="submit" class="flex items-center gap-1.5 px-3 py-2 border border-blue-200 text-blue-600 rounded-lg text-xs font-medium hover:bg-blue-50 transition-colors">처리 시작</button>
                </form>
              </c:if>
              <c:if test="${report.statusValue == 'IN_PROGRESS'}">
                <form method="post" action="${pageContext.request.contextPath}/report-board/${report.id}/status">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <input type="hidden" name="status" value="COMPLETED"/>
                  <button type="submit" class="flex items-center gap-1.5 px-3 py-2 border border-green-200 text-green-600 rounded-lg text-xs font-medium hover:bg-green-50 transition-colors">완료 처리</button>
                </form>
              </c:if>
              <c:if test="${report.statusValue == 'RECEIVED' || report.statusValue == 'IN_PROGRESS'}">
                <form method="post" action="${pageContext.request.contextPath}/report-board/${report.id}/status">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <input type="hidden" name="status" value="REJECTED"/>
                  <button type="submit" class="flex items-center gap-1.5 px-3 py-2 border border-red-200 text-red-500 rounded-lg text-xs font-medium hover:bg-red-50 transition-colors">반려</button>
                </form>
              </c:if>
            </c:if>
          </div>
        </div>
        <div class="flex flex-wrap items-center gap-4 text-xs text-gray-500 pt-4 border-t border-gray-100">
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
            ${report.location}
          </span>
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            ${report.createdDateLabel}
          </span>
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            ${report.views}명 조회
          </span>
          <span class="flex items-center gap-1.5 ml-auto">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
            <c:choose><c:when test="${report.anonymous}">익명 신고</c:when><c:otherwise>실명 신고</c:otherwise></c:choose>
          </span>
        </div>
      </div>

      <!-- Main grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-5">

        <!-- Left / main -->
        <div class="lg:col-span-2 space-y-5">

          <!-- Description -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-base font-bold text-gray-900 mb-4">신고 내용</h2>
            <p class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">${report.description}</p>
          </div>

          <!-- Comments -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-base font-bold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
              댓글 <span>(${fn:length(comments)})</span>
            </h2>

            <div class="space-y-4 mb-5">
              <c:if test="${empty comments}">
                <p class="text-sm text-gray-400">아직 등록된 댓글이 없습니다.</p>
              </c:if>
              <c:forEach var="c" items="${comments}">
                <div class="p-4 rounded-xl border ${c.official ? 'bg-blue-50 border-blue-100' : 'bg-gray-50 border-gray-100'}">
                  <div class="flex items-center gap-2 mb-2">
                    <div class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold ${c.official ? 'bg-blue-600 text-white' : 'bg-gray-300 text-gray-700'}">${fn:substring(c.writerName, 0, 1)}</div>
                    <span class="text-sm font-semibold text-gray-900">${c.writerName}</span>
                    <span class="text-[10px] px-2 py-0.5 rounded-full font-medium ${c.official ? 'bg-blue-100 text-blue-700' : 'bg-gray-200 text-gray-600'}">${c.writerRole}</span>
                    <span class="text-xs text-gray-400 ml-auto">${c.createdAtLabel}</span>
                  </div>
                  <p class="text-sm text-gray-700 leading-relaxed">${c.content}</p>
                </div>
              </c:forEach>
            </div>

            <!-- Comment input -->
            <form method="post" action="${pageContext.request.contextPath}/report-board/${report.id}/comments" class="flex gap-2">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <input type="text" name="content" placeholder="댓글을 입력하세요..."
                class="flex-1 px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              <button type="submit" class="px-4 py-2.5 bg-[#FF6B35] text-white rounded-xl hover:bg-[#E55A2A] transition-colors">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
              </button>
            </form>
          </div>

        </div>

        <!-- Right sidebar -->
        <div class="space-y-5">

          <!-- Processing timeline -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h2 class="text-sm font-bold text-gray-900 mb-4">처리 현황</h2>
            <div class="space-y-4">
              <c:forEach var="t" items="${timelines}" varStatus="status">
                <div class="flex gap-3">
                  <div class="flex flex-col items-center">
                    <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ${t.done ? 'bg-[#FF6B35] text-white' : 'bg-gray-100 border-2 border-gray-200'}">
                      <c:choose>
                        <c:when test="${t.done}">
                          <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
                        </c:when>
                        <c:otherwise>
                          <div class="w-1.5 h-1.5 rounded-full bg-gray-400"></div>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <c:if test="${!status.last}">
                      <div class="w-0.5 flex-1 mt-1 min-h-[20px] ${t.done ? 'bg-[#FF6B35]/30' : 'bg-gray-100'}"></div>
                    </c:if>
                  </div>
                  <div class="pb-4">
                    <p class="text-xs font-semibold mb-0.5 ${t.done ? 'text-gray-900' : 'text-gray-400'}">${t.label}</p>
                    <p class="text-xs mb-0.5 ${t.done ? 'text-gray-600' : 'text-gray-400'}">${t.description}</p>
                    <p class="text-[10px] text-gray-400">${t.dateLabel}</p>
                  </div>
                </div>
              </c:forEach>
            </div>
          </div>

          <!-- Report info -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 space-y-3">
            <h2 class="text-sm font-bold text-gray-900">신고 정보</h2>
            <div class="space-y-0">
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">신고 번호</span><span class="text-xs font-semibold text-gray-800">#${report.id}</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">분류</span><span class="text-xs font-semibold text-gray-800">${report.categoryLabel}</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">위치</span><span class="text-xs font-semibold text-gray-800">${report.location}</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">접수일</span><span class="text-xs font-semibold text-gray-800">${report.createdDateLabel}</span>
              </div>
              <div class="flex items-center justify-between py-2">
                <span class="text-xs text-gray-500">신고자</span><span class="text-xs font-semibold text-gray-800">${report.reporterName}</span>
              </div>
            </div>
          </div>

          <!-- Notice -->
          <div class="bg-blue-50 rounded-2xl p-4 border border-blue-100 text-xs text-blue-700">
            <p class="font-semibold mb-1">신고자 보호 안내</p>
            <p class="leading-relaxed text-blue-600">익명 신고자의 정보는 안전관리 담당자만 확인할 수 있으며, 외부에 공개되지 않습니다.</p>
          </div>

        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>
