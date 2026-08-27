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
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <h1 class="text-lg font-semibold text-gray-900">알림</h1>
      <c:if test="${unreadCount > 0}">
        <span class="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">${unreadCount}</span>
      </c:if>
    </div>
    <div class="flex items-center gap-3">
      <form action="${pageContext.request.contextPath}/notifications/read-all" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="text-sm text-[#1A2E44] hover:text-[#0F2233] font-medium transition-colors">모두 읽음 처리</button>
      </form>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 max-w-5xl mx-auto">

      <!-- Notifications list -->
      <div class="lg:col-span-2 space-y-3">
        <!-- Filter Tabs -->
        <div class="flex gap-2 bg-white rounded p-1.5 shadow-sm border border-gray-100">
          <a href="?filter=all" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${empty currentFilter || currentFilter == 'all' ? 'bg-[#1A2E44] text-white' : 'text-gray-500 hover:bg-gray-50'}">전체</a>
          <a href="?filter=unread" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'unread' ? 'bg-[#1A2E44] text-white' : 'text-gray-500 hover:bg-gray-50'}">읽지 않음</a>
          <a href="?filter=danger" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'danger' ? 'bg-[#1A2E44] text-white' : 'text-gray-500 hover:bg-gray-50'}">위험 알림</a>
          <a href="?filter=action" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'action' ? 'bg-[#1A2E44] text-white' : 'text-gray-500 hover:bg-gray-50'}">조치 알림</a>
          <a href="?filter=report" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg transition-all ${currentFilter == 'report' ? 'bg-[#1A2E44] text-white' : 'text-gray-500 hover:bg-gray-50'}">신고 알림</a>
        </div>

        <c:if test="${empty notifications}">
          <div class="bg-white rounded p-12 text-center border border-gray-100">
            <svg class="w-10 h-10 text-gray-200 mx-auto mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
            <p class="text-gray-500 font-medium">표시할 알림이 없습니다</p>
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
             class="relative group block bg-white rounded border transition-all hover:shadow-md
               ${n.read ? 'border-gray-100' : (severityColor == 'red' ? 'border-red-200 shadow-sm' : severityColor == 'orange' ? 'border-orange-200 shadow-sm' : severityColor == 'blue' ? 'border-blue-200 shadow-sm' : 'border-green-200 shadow-sm')}">
            <c:if test="${!n.read}">
              <div class="absolute left-0 top-0 bottom-0 w-1 rounded-l-xl ${severityColor == 'red' ? 'bg-red-500' : severityColor == 'orange' ? 'bg-orange-500' : severityColor == 'blue' ? 'bg-blue-500' : 'bg-green-500'}"></div>
            </c:if>
            <div class="flex gap-4 p-4 pl-5">
              <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5
                ${n.read ? 'bg-gray-100' : (severityColor == 'red' ? 'bg-red-50' : severityColor == 'orange' ? 'bg-orange-50' : severityColor == 'blue' ? 'bg-blue-50' : 'bg-green-50')}">
                <c:choose>
                  <c:when test="${n.type == 'DANGER'}">
                    <svg class="w-4 h-4 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-600' : severityColor == 'orange' ? 'text-orange-600' : severityColor == 'blue' ? 'text-blue-600' : 'text-green-600')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
                  </c:when>
                  <c:when test="${n.type == 'ACTION'}">
                    <svg class="w-4 h-4 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-600' : severityColor == 'orange' ? 'text-orange-600' : severityColor == 'blue' ? 'text-blue-600' : 'text-green-600')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                  </c:when>
                  <c:when test="${n.type == 'REPORT'}">
                    <svg class="w-4 h-4 ${n.read ? 'text-gray-400' : (severityColor == 'red' ? 'text-red-600' : severityColor == 'orange' ? 'text-orange-600' : severityColor == 'blue' ? 'text-blue-600' : 'text-green-600')}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2Z"/></svg>
                  </c:when>
                  <c:otherwise>
                    <img src="/images/mascot.png" alt="마스코트" class="w-6 h-6 object-contain" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
                  </c:otherwise>
                </c:choose>
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between gap-2 mb-1">
                  <h3 class="text-sm font-semibold ${n.read ? 'text-gray-700' : 'text-gray-900'}">${n.title}</h3>
                  <div class="flex items-center gap-1 flex-shrink-0">
                    <span class="text-xs text-gray-400 whitespace-nowrap">${n.relativeTime}</span>
                    <c:if test="${!n.read}"><div class="w-2 h-2 rounded-full bg-[#1A2E44] flex-shrink-0"></div></c:if>
                  </div>
                </div>
                <p class="text-sm text-gray-600 leading-relaxed">${n.message}</p>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>

      <!-- Right sidebar -->
      <div class="space-y-5">
        <!-- Mascot -->
        <div class="bg-gradient-to-br from-[#1A2E44] to-[#2C5282] rounded p-5 flex items-center gap-3">
          <img src="/images/mascot.png" alt="마스코트" class="w-12 h-12 object-contain flex-shrink-0" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
          <p id="mascotDeadlineText" class="text-sm text-white/90"></p>
        </div>

        <!-- Deadlines (실제 조치 데이터 기반) -->
        <div class="bg-white rounded p-5 shadow-sm border border-gray-100">
          <h2 class="text-sm font-semibold text-gray-900 mb-4 flex items-center gap-2">
            <svg class="w-4 h-4 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            마감 일정
          </h2>
          <div id="deadlineGroups" class="space-y-5">
            <p class="text-sm text-gray-400">불러오는 중...</p>
          </div>
          <a href="/actions" class="w-full mt-4 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-2">
            전체 조치 관리 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
          </a>
        </div>

        <!-- Notification Settings (브라우저 로컬 저장 - 서버에 알림 설정 API가 없어 기기별로만 저장됨) -->
        <div class="bg-white rounded p-5 shadow-sm border border-gray-100">
          <h2 class="text-sm font-semibold text-gray-900 mb-1">알림 설정</h2>
          <p class="text-xs text-gray-400 mb-4">이 브라우저에만 저장됩니다</p>
          <div id="settingsList" class="space-y-3"></div>
        </div>
      </div>
    </div>
  </main>
</div>
<script>
(function () {
  var PRIORITY_COLOR = { HIGH: 'bg-red-500', MEDIUM: 'bg-orange-500', LOW: 'bg-yellow-400' };
  var PRIORITY_LABEL = { HIGH: '고위험', MEDIUM: '중위험', LOW: '저위험' };
  var PRIORITY_BADGE = { HIGH: 'bg-red-100 text-red-700', MEDIUM: 'bg-orange-100 text-orange-700', LOW: 'bg-yellow-100 text-yellow-700' };

  function qs(sel) { return document.querySelector(sel); }

  function riskToPriority(riskLevel) {
    if (riskLevel === 'HIGH') return 'HIGH';
    if (riskLevel === 'MEDIUM') return 'MEDIUM';
    return 'LOW';
  }

  function loadDeadlines() {
    fetch('/api/actions/search?status=REQUESTED')
      .then(function (res) { return res.ok ? res.json() : []; })
      .then(function (actions) {
        var todayStr = new Date().toISOString().slice(0, 10);
        var withDue = actions.filter(function (a) { return a.dueDate; })
          .sort(function (a, b) { return a.dueDate < b.dueDate ? -1 : 1; });

        if (!withDue.length) {
          qs('#deadlineGroups').innerHTML = '<p class="text-sm text-gray-400">마감 예정인 조치가 없습니다.</p>';
          qs('#mascotDeadlineText').textContent = '지금은 마감 임박 조치가 없어요. 안전한 하루 보내세요!';
          return;
        }

        var groups = {};
        var order = [];
        withDue.forEach(function (a) {
          if (!groups[a.dueDate]) { groups[a.dueDate] = []; order.push(a.dueDate); }
          groups[a.dueDate].push(a);
        });

        qs('#deadlineGroups').innerHTML = order.slice(0, 4).map(function (date) {
          var urgent = date === todayStr;
          var items = groups[date].slice(0, 4).map(function (a) {
            var link = a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id;
            var p = riskToPriority(a.riskLevel);
            return '<a href="' + link + '" class="flex items-center gap-2.5 p-2.5 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors group">' +
              '<div class="w-2 h-2 rounded-full flex-shrink-0 ' + PRIORITY_COLOR[p] + '"></div>' +
              '<div class="flex-1 min-w-0"><p class="text-xs font-medium text-gray-800 truncate">' + a.title + '</p>' +
              '<p class="text-[10px] text-gray-500">' + (a.location || '현장 미지정') + '</p></div>' +
              '<span class="text-[10px] px-1.5 py-0.5 rounded font-medium flex-shrink-0 ' + PRIORITY_BADGE[p] + '">' + PRIORITY_LABEL[p] + '</span>' +
              '<svg class="w-3 h-3 text-gray-300 group-hover:text-[#1A2E44] transition-colors flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>';
          }).join('');
          return '<div><div class="flex items-center gap-2 mb-2.5">' +
            '<div class="w-2 h-2 rounded-full flex-shrink-0 ' + (urgent ? 'bg-red-500 animate-pulse' : 'bg-gray-300') + '"></div>' +
            '<span class="text-xs font-semibold ' + (urgent ? 'text-red-600' : 'text-gray-600') + '">' + date + (urgent ? ' (오늘)' : '') + '</span>' +
            '</div><div class="space-y-2 ml-4">' + items + '</div></div>';
        }).join('');

        var todayCount = (groups[todayStr] || []).length;
        qs('#mascotDeadlineText').textContent = todayCount > 0
          ? '마감 임박 조치가 ' + todayCount + '건 있습니다!'
          : '다가오는 마감 조치가 ' + withDue.length + '건 있습니다.';
      })
      .catch(function () {
        qs('#deadlineGroups').innerHTML = '<p class="text-sm text-red-400">불러오지 못했습니다.</p>';
      });
  }

  var SETTINGS_KEY = 'safemate.notificationSettings';
  var SETTINGS_DEFS = [
    { key: 'deadline', label: '조치 마감 알림', desc: '마감 1일 전 알림' },
    { key: 'comment',  label: '댓글 알림',      desc: '새 댓글 등록 시' },
    { key: 'complete', label: '조치 완료 알림', desc: '완료 처리 시' },
    { key: 'weekly',   label: '주간 리포트',    desc: '매주 월요일' }
  ];

  function loadSettings() {
    try { return JSON.parse(localStorage.getItem(SETTINGS_KEY)) || {}; } catch (e) { return {}; }
  }
  function saveSettings(settings) {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
  }

  function renderSettings() {
    var settings = loadSettings();
    qs('#settingsList').innerHTML = SETTINGS_DEFS.map(function (s) {
      var on = settings[s.key] !== false;
      return '<label class="flex items-center justify-between cursor-pointer" data-key="' + s.key + '">' +
        '<div><p class="text-sm font-medium text-gray-800">' + s.label + '</p><p class="text-xs text-gray-400">' + s.desc + '</p></div>' +
        '<div class="toggle relative w-10 h-5 rounded-full transition-colors flex-shrink-0 ' + (on ? 'bg-[#1A2E44]' : 'bg-gray-200') + '">' +
        '<div class="absolute top-0.5 w-4 h-4 bg-white rounded-full shadow-sm transition-transform ' + (on ? 'translate-x-5' : 'translate-x-0.5') + '"></div>' +
        '</div></label>';
    }).join('');

    qs('#settingsList').querySelectorAll('label').forEach(function (label) {
      label.addEventListener('click', function () {
        var key = label.getAttribute('data-key');
        var settings = loadSettings();
        settings[key] = settings[key] === false ? true : false;
        saveSettings(settings);
        renderSettings();
      });
    });
  }

  fetch('/api/users/me')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (user) {
      qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(function () {});

  loadDeadlines();
  renderSettings();
})();
</script>
</body>
</html>
