<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>알림 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <h1 class="text-lg font-semibold text-gray-900">알림</h1>
      <c:if test="${unreadCount > 0}">
        <span class="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">${unreadCount}</span>
      </c:if>
    </div>
    <div class="flex items-center gap-3">
      <form action="${pageContext.request.contextPath}/notifications/read-all" method="post">
        <button type="submit" class="text-sm text-[#FF6B35] hover:text-[#E55A2A] font-medium transition-colors">모두 읽음 처리</button>
      </form>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto space-y-3">

      <!-- Filter Tabs -->
      <div class="flex gap-2 bg-white rounded-xl p-1.5 shadow-sm border border-gray-100">
        <a href="?filter=all" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${empty currentFilter || currentFilter == 'all' ? 'bg-[#FF6B35] text-white' : 'text-gray-500 hover:bg-gray-50'}">전체</a>
        <a href="?filter=unread" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'unread' ? 'bg-[#FF6B35] text-white' : 'text-gray-500 hover:bg-gray-50'}">읽지 않음</a>
        <a href="?filter=danger" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'danger' ? 'bg-[#FF6B35] text-white' : 'text-gray-500 hover:bg-gray-50'}">위험 알림</a>
        <a href="?filter=action" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'action' ? 'bg-[#FF6B35] text-white' : 'text-gray-500 hover:bg-gray-50'}">조치 알림</a>
        <a href="?filter=report" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'report' ? 'bg-[#FF6B35] text-white' : 'text-gray-500 hover:bg-gray-50'}">신고 알림</a>
      </div>

      <c:if test="${empty notifications}">
        <div class="bg-white rounded-2xl p-12 text-center border border-gray-100">
          <p class="text-gray-500">표시할 알림이 없습니다</p>
        </div>
      </c:if>

      <c:set var="prevDateGroup" value=""/>
      <c:forEach var="n" items="${notifications}">
        <c:if test="${n.dateGroupLabel != prevDateGroup}">
          <p class="text-xs font-semibold text-gray-400 px-1 pt-2">${n.dateGroupLabel}</p>
          <c:set var="prevDateGroup" value="${n.dateGroupLabel}"/>
        </c:if>

        <c:set var="severityColor" value="gray"/>
        <c:if test="${n.severity == 'HIGH'}"><c:set var="severityColor" value="red"/></c:if>
        <c:if test="${n.severity == 'MEDIUM'}"><c:set var="severityColor" value="orange"/></c:if>
        <c:if test="${n.severity == 'LOW'}"><c:set var="severityColor" value="blue"/></c:if>
        <c:if test="${n.severity == 'INFO'}"><c:set var="severityColor" value="green"/></c:if>

        <a href="${pageContext.request.contextPath}/notifications/${n.id}/redirect"
           class="block bg-white rounded-2xl p-4 shadow-sm border transition-all hover:shadow-md
             ${n.read ? 'border-gray-100 opacity-70' : (severityColor == 'red' ? 'border-l-4 border-l-red-500 border-red-100' : severityColor == 'orange' ? 'border-l-4 border-l-orange-500 border-orange-100' : severityColor == 'blue' ? 'border-l-4 border-l-blue-500 border-blue-100' : 'border-l-4 border-l-green-500 border-green-100')}">
          <div class="flex items-start gap-3">
            <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0
              ${n.read ? 'bg-gray-100' : (severityColor == 'red' ? 'bg-red-100' : severityColor == 'orange' ? 'bg-orange-100' : severityColor == 'blue' ? 'bg-blue-100' : 'bg-green-100')}">
              <c:choose>
                <c:when test="${n.type == 'DANGER'}">
                  <svg class="w-5 h-5 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-500' : severityColor == 'orange' ? 'text-orange-500' : severityColor == 'blue' ? 'text-blue-500' : 'text-green-500')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
                </c:when>
                <c:when test="${n.type == 'ACTION'}">
                  <svg class="w-5 h-5 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-500' : severityColor == 'orange' ? 'text-orange-500' : severityColor == 'blue' ? 'text-blue-500' : 'text-green-500')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </c:when>
                <c:when test="${n.type == 'REPORT'}">
                  <svg class="w-5 h-5 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-500' : severityColor == 'orange' ? 'text-orange-500' : severityColor == 'blue' ? 'text-blue-500' : 'text-green-500')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2Z"/></svg>
                </c:when>
                <c:otherwise>
                  <img src="/images/mascot.png" alt="마스코트" class="w-7 h-7 object-contain" style="mix-blend-mode:multiply"/>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="flex-1 min-w-0">
              <div class="flex items-center gap-2 mb-1">
                <span class="text-xs px-2 py-0.5 rounded-full font-medium
                  ${n.read ? 'bg-gray-100 text-gray-600' : (severityColor == 'red' ? 'bg-red-100 text-red-700' : severityColor == 'orange' ? 'bg-orange-100 text-orange-700' : severityColor == 'blue' ? 'bg-blue-100 text-blue-700' : 'bg-green-100 text-green-700')}">${n.typeLabel}</span>
                <c:if test="${!n.read}"><span class="w-2 h-2 bg-red-500 rounded-full"></span></c:if>
              </div>
              <p class="text-sm font-semibold ${n.read ? 'text-gray-700' : 'text-gray-900'}">${n.title}</p>
              <p class="text-xs text-gray-500 mt-0.5">${n.message}</p>
              <p class="text-xs text-gray-400 mt-1.5">${n.relativeTime}</p>
            </div>
            <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
          </div>
        </a>
      </c:forEach>
    </div>
  </main>
</div>
</body>
</html>
