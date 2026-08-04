<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>원청 대시보드 - SafeMate</title>
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
    <div class="space-y-6">

      <!-- Welcome Banner -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-8 text-white">
        <div class="flex items-center justify-between">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-1">
              <span class="bg-[#FF6B35] text-white text-xs font-bold px-3 py-1 rounded-full">원청</span>
              <span id="bannerCompany" class="text-white/60 text-sm"></span>
            </div>
            <h1 id="bannerGreeting" class="text-3xl font-bold mb-2">안녕하세요! 👋</h1>
            <p id="bannerSubtitle" class="text-white/80 text-lg">전체 현장 안전 현황을 불러오는 중...</p>
            <div class="flex items-center gap-6 mt-4">
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-green-400 rounded-full"></div><span id="bannerSiteCount" class="text-sm">전체 현장: -개</span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-400 rounded-full"></div><span id="bannerUrgentCount" class="text-sm">긴급 조치: -건</span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-blue-400 rounded-full"></div><span id="bannerCompanyCount" class="text-sm">협력사: -개</span></div>
            </div>
          </div>
          <div class="hidden lg:block">
            <img src="/images/mascot.png" alt="마스코트" class="w-24 h-24 object-contain" style="mix-blend-mode:multiply"/>
          </div>
        </div>
      </div>

      <!-- KPI -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-blue-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          </div>
          <p class="text-gray-500 text-xs mb-1">전체 리포트 수</p>
          <p id="kpiTotalReports" class="text-3xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-red-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          </div>
          <p class="text-gray-500 text-xs mb-1">고위험 항목</p>
          <p id="kpiHighRisk" class="text-3xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-orange-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          </div>
          <p class="text-gray-500 text-xs mb-1">조치 진행 중</p>
          <p id="kpiInProgress" class="text-3xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-purple-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg></div>
          </div>
          <p class="text-gray-500 text-xs mb-1">협력사 수</p>
          <p id="kpiCompanyCount" class="text-3xl font-bold text-gray-900">-</p>
        </div>
      </div>

      <!-- Mascot Tip -->
      <div id="mascotTipCard" class="hidden bg-gradient-to-r from-[#FF6B35]/10 to-[#FF6B35]/5 rounded-2xl p-5 border-2 border-[#FF6B35]/20 flex items-start gap-4">
        <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
        <div>
          <h3 class="text-base font-semibold text-[#1B3A5F] mb-1">💡 원청 안전 현황 요약</h3>
          <p id="mascotTipText" class="text-sm text-gray-700"></p>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">

          <!-- Quick Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">빠른 실행</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-blue-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">사진 업로드</span>
              </a>
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-[#FF6B35] w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">위험 분석</span>
              </a>
              <a href="/actions/new" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-green-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">조치 등록</span>
              </a>
              <a href="/actions/detail" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-purple-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">리포트 보기</span>
              </a>
            </div>
          </div>

          <!-- Monthly Chart -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">월별 위험 발생 현황</h3>
              <div class="flex items-center gap-3 text-xs text-gray-500">
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#FF6B35] inline-block"></span>고위험</span>
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-orange-400 inline-block"></span>중위험</span>
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-yellow-400 inline-block"></span>안전</span>
              </div>
            </div>
            <div id="monthlyChart" class="flex items-end justify-between gap-1" style="height:160px"></div>
          </div>

          <!-- Subcontractor Status -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-5 h-5 text-[#1B3A5F]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              협력사 조치 완료율
            </h3>
            <div id="companyStatusList" class="space-y-3">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
        </div>

        <!-- Right Sidebar -->
        <div class="space-y-6">
          <!-- Risk Distribution -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">위험 등급 분포</h3>
            <div class="flex items-center gap-4">
              <svg id="riskPieSvg" width="120" height="120" viewBox="0 0 120 120" class="flex-shrink-0"></svg>
              <div id="riskLegend" class="flex-1 space-y-2"></div>
            </div>
          </div>

          <!-- Urgent Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
              긴급 조치 필요
            </h3>
            <div id="urgentActionsList" class="space-y-3">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
            <a href="/actions" class="block w-full mt-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium text-center">전체 조치 관리</a>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  var RISK_COLORS = { '고위험': '#ef4444', '중위험': '#f97316', '안전': '#22c55e' };
  function qs(sel) { return document.querySelector(sel); }

  function loadCurrentUser() {
    return fetch('/api/users/me')
      .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
      .then(function (user) {
        qs('#headerUserName').textContent = user.username;
        qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
        qs('#bannerGreeting').textContent = '안녕하세요, ' + user.username + '님! 👋';
        qs('#bannerCompany').textContent = user.companyName || '';
        qs('#bannerSubtitle').textContent = '전체 현장 안전 현황';
        return user;
      });
  }

  function loadSiteCount() {
    return fetch('/api/sites').then(function (res) { return res.ok ? res.json() : []; }).then(function (sites) {
      qs('#bannerSiteCount').textContent = '전체 현장: ' + sites.length + '개';
    });
  }

  function renderMonthlyChart(monthlyTrend) {
    var max = 1;
    monthlyTrend.forEach(function (m) { max = Math.max(max, m.high + m.medium + m.safe); });
    qs('#monthlyChart').innerHTML = monthlyTrend.map(function (m) {
      var hp = m.high * 100 / max, mp = m.medium * 100 / max, sp = m.safe * 100 / max;
      return '<div class="flex-1 flex flex-col items-center gap-1">' +
        '<div class="w-full flex flex-col items-stretch gap-0.5" style="height:120px;justify-content:flex-end">' +
        '<div class="w-full bg-[#FF6B35] rounded-t" style="height:' + hp + '%;min-height:2px"></div>' +
        '<div class="w-full bg-orange-400" style="height:' + mp + '%;min-height:2px"></div>' +
        '<div class="w-full bg-yellow-400 rounded-b" style="height:' + sp + '%;min-height:2px"></div>' +
        '</div><span class="text-xs text-gray-500">' + m.month + '월</span></div>';
    }).join('');
  }

  function renderRiskPie(distribution) {
    var total = Object.values(distribution).reduce(function (a, b) { return a + b; }, 0);
    var circumference = 2 * Math.PI * 40;
    var offset = 0;
    var circles = '<circle cx="60" cy="60" r="40" fill="none" stroke="#f3f4f6" stroke-width="20"/>';
    Object.keys(distribution).forEach(function (label) {
      var count = distribution[label];
      if (total === 0 || count === 0) return;
      var len = count / total * circumference;
      circles += '<circle cx="60" cy="60" r="40" fill="none" stroke="' + RISK_COLORS[label] + '" stroke-width="20" ' +
        'stroke-dasharray="' + len + ' ' + (circumference - len) + '" stroke-dashoffset="-' + offset + '" transform="rotate(-90 60 60)"/>';
      offset += len;
    });
    circles += '<text x="60" y="54" text-anchor="middle" fill="#374151" font-size="11" font-weight="600">' + total + '</text>' +
      '<text x="60" y="68" text-anchor="middle" fill="#9CA3AF" font-size="9">전체</text>';
    qs('#riskPieSvg').innerHTML = circles;

    qs('#riskLegend').innerHTML = Object.keys(distribution).map(function (label) {
      return '<div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5">' +
        '<span class="w-2.5 h-2.5 rounded-full" style="background:' + RISK_COLORS[label] + '"></span><span class="text-xs">' + label + '</span></span>' +
        '<span class="font-semibold text-xs">' + distribution[label] + '건</span></div>';
    }).join('');
  }

  function renderCompanyStatus(companyRanking) {
    if (!companyRanking.length) {
      qs('#companyStatusList').innerHTML = '<p class="text-sm text-gray-400">아직 등록된 조치 데이터가 없습니다.</p>';
      return;
    }
    qs('#companyStatusList').innerHTML = companyRanking.slice(0, 5).map(function (c) {
      var pct = Math.round(c.completionRate);
      var caution = pct < 70;
      return '<div class="p-4 rounded-xl border-2 ' + (caution ? 'border-orange-200 bg-orange-50' : 'border-gray-100 bg-gray-50') + '">' +
        '<div class="flex items-center justify-between mb-2"><div class="flex items-center gap-2">' +
        '<span class="font-semibold text-gray-900 text-sm">' + c.companyName + '</span>' +
        (caution ? '<span class="text-xs bg-orange-100 text-orange-700 px-2 py-0.5 rounded-full">주의</span>' : '') + '</div>' +
        '<span class="text-sm font-bold ' + (caution ? 'text-orange-500' : 'text-green-600') + '">' + pct + '%</span></div>' +
        '<div class="text-xs text-gray-600 mb-2">조치 ' + c.total + '건 중 ' + c.completed + '건 완료</div>' +
        '<div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full ' + (caution ? 'bg-orange-500' : 'bg-green-500') + '" style="width:' + pct + '%"></div></div></div>';
    }).join('');
  }

  function loadAnalytics() {
    return fetch('/api/analytics/summary')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (data) {
        qs('#kpiTotalReports').textContent = data.totalUploads.toLocaleString();
        qs('#kpiHighRisk').textContent = data.riskDistribution['고위험'] || 0;
        qs('#kpiCompanyCount').textContent = data.companyRanking.length;
        qs('#bannerCompanyCount').textContent = '협력사: ' + data.companyRanking.length + '개';
        renderMonthlyChart(data.monthlyTrend);
        renderRiskPie(data.riskDistribution);
        renderCompanyStatus(data.companyRanking);

        var topCompany = data.companyRanking.slice().sort(function (a, b) { return b.total - a.total; })[0];
        if (topCompany) {
          qs('#mascotTipCard').classList.remove('hidden');
          qs('#mascotTipText').textContent = topCompany.companyName + '의 조치 건수가 ' + topCompany.total + '건으로 가장 많습니다. 완료율 ' + topCompany.completionRate.toFixed(0) + '%.';
        }
      })
      .catch(function () {});
  }

  function loadUrgentActions() {
    fetch('/api/actions/search?status=REQUESTED')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (actions) {
        var sorted = actions.slice().sort(function (a, b) { return (a.dueDate || '') < (b.dueDate || '') ? -1 : 1; }).slice(0, 3);
        qs('#bannerUrgentCount').textContent = '긴급 조치: ' + actions.length + '건';
        qs('#urgentActionsList').innerHTML = sorted.length
          ? sorted.map(function (a) {
              var link = a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions';
              return '<a href="' + link + '" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">' +
                '<p class="text-sm font-semibold text-gray-900 mb-1">' + a.title + '</p>' +
                '<p class="text-xs text-gray-600">' + (a.location || '현장 미지정') + (a.reporterName ? ' · ' + a.reporterName : '') + '</p>' +
                '<div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">마감: ' + (a.dueDate || '-') + '</span>' +
                '<svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div></a>';
            }).join('')
          : '<p class="text-sm text-gray-400">긴급 조치가 없습니다.</p>';
      })
      .catch(function () {
        qs('#urgentActionsList').innerHTML = '<p class="text-sm text-red-400">조치 목록을 불러오지 못했습니다.</p>';
      });
  }

  loadCurrentUser();
  loadSiteCount();
  loadAnalytics();
  loadUrgentActions();
})();
</script>
</body>
</html>