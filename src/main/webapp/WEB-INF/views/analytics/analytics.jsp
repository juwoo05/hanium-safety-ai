<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>통계 분석 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<%@ include file="../common/_topnav.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <select class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none">
        <option>이번 달</option><option>지난 달</option><option>최근 3개월</option><option>올해</option>
      </select>
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-6">
      <div><h1 class="text-2xl font-bold text-gray-900">통계 분석</h1><p class="text-sm text-gray-500 mt-1">현장 안전 데이터를 한눈에 파악하세요</p></div>

      <!-- KPI Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-blue-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div></div><p id="kpiTotalUploads" class="text-3xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">총 업로드 수</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-red-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg></div></div><p id="kpiTotalDetections" class="text-3xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">위험 감지 건수</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-green-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div></div><p id="kpiCompletionRate" class="text-3xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">조치 완료율</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-purple-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div></div><p id="kpiAvgActionDays" class="text-3xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">평균 조치 기간</p></div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Monthly Trend -->
        <div class="lg:col-span-2 bg-white rounded-2xl p-6 shadow-md">
          <div class="flex items-center justify-between mb-5">
            <h3 class="text-base font-semibold text-gray-900">월별 위험 감지 추이</h3>
            <div class="flex items-center gap-4 text-xs text-gray-500">
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#FF6B35] inline-block"></span>고위험</span>
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-orange-400 inline-block"></span>중위험</span>
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-yellow-400 inline-block"></span>안전</span>
            </div>
          </div>
          <div id="monthlyTrendChart" class="flex items-end gap-1.5 h-48 px-2"></div>
        </div>

        <!-- Risk Pie -->
        <div class="bg-white rounded-2xl p-6 shadow-md flex flex-col">
          <h3 class="text-base font-semibold text-gray-900 mb-5">위험도 분포</h3>
          <div class="flex-1 flex flex-col items-center justify-center">
            <svg id="riskPieChart" viewBox="0 0 120 120" class="w-40 h-40 -rotate-90">
              <circle cx="60" cy="60" r="50" fill="none" stroke="#fee2e2" stroke-width="20"/>
            </svg>
            <div id="riskPieLegend" class="mt-5 space-y-2 w-full"></div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Category -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h3 class="text-base font-semibold text-gray-900 mb-5">위험 유형별 분류</h3>
          <div id="categoryBreakdown" class="space-y-4"></div>
        </div>

        <!-- Company Ranking -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h3 class="text-base font-semibold text-gray-900 mb-5">업체별 조치 완료율</h3>
          <div id="companyRanking" class="space-y-3"></div>
        </div>
      </div>

      <!-- AI Insight -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-6 text-white">
        <div class="flex items-start gap-4">
          <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
          <div>
            <h3 class="text-base font-bold mb-2">이번 해 핵심 포인트</h3>
            <ul id="insightList" class="space-y-1.5 text-white/80 text-sm">
              <li class="flex items-start gap-2"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>데이터를 불러오는 중...</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  function qs(sel, root) { return (root || document).querySelector(sel); }
  var CATEGORY_COLORS = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-blue-500', 'bg-purple-500'];
  var RISK_COLORS = { '고위험': '#FF6B35', '중위험': '#fb923c', '안전': '#fbbf24' };

  fetch('/api/users/me')
    .then(function (res) { return res.ok ? res.json() : null; })
    .then(function (user) {
      if (user) qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
    })
    .catch(function () {});

  fetch('/api/analytics/summary')
    .then(function (res) {
      if (res.status === 401) { window.location.href = '/login'; throw new Error('로그인이 필요합니다.'); }
      if (!res.ok) throw new Error('통계 조회 실패');
      return res.json();
    })
    .then(render)
    .catch(function (err) {
      qs('#insightList').innerHTML = '<li class="text-white/60">' + err.message + '</li>';
    });

  function render(data) {
    qs('#kpiTotalUploads').textContent = data.totalUploads.toLocaleString();
    qs('#kpiTotalDetections').textContent = data.totalDetections.toLocaleString();
    qs('#kpiCompletionRate').textContent = data.completionRate.toFixed(1) + '%';
    qs('#kpiAvgActionDays').textContent = data.avgActionDays.toFixed(1) + '일';

    renderMonthlyTrend(data.monthlyTrend);
    renderRiskPie(data.riskDistribution);
    renderCategoryBreakdown(data.categoryBreakdown);
    renderCompanyRanking(data.companyRanking);
    renderInsights(data);
  }

  function renderMonthlyTrend(monthlyTrend) {
    var max = 1;
    monthlyTrend.forEach(function (m) { max = Math.max(max, m.high + m.medium + m.safe); });

    var html = monthlyTrend.map(function (m) {
      var hp = m.high * 100 / max, mp = m.medium * 100 / max, sp = m.safe * 100 / max;
      return '<div class="flex-1 flex flex-col gap-0.5 items-center group">' +
        '<div class="w-full flex flex-col gap-0.5 items-stretch" style="height:180px;justify-content:flex-end">' +
        '<div class="w-full bg-[#FF6B35] rounded-t" style="height:' + hp + '%;min-height:2px" title="고위험 ' + m.high + '건"></div>' +
        '<div class="w-full bg-orange-400" style="height:' + mp + '%;min-height:2px" title="중위험 ' + m.medium + '건"></div>' +
        '<div class="w-full bg-yellow-400 rounded-b" style="height:' + sp + '%;min-height:2px" title="안전 ' + m.safe + '건"></div>' +
        '</div><span class="text-xs text-gray-400 mt-1">' + m.month + '</span></div>';
    }).join('');
    qs('#monthlyTrendChart').innerHTML = html;
  }

  function renderRiskPie(distribution) {
    var total = Object.values(distribution).reduce(function (a, b) { return a + b; }, 0);
    var svg = qs('#riskPieChart');
    var circumference = 2 * Math.PI * 50;
    var offset = 0;
    var circles = '<circle cx="60" cy="60" r="50" fill="none" stroke="#f3f4f6" stroke-width="20"/>';
    Object.keys(distribution).forEach(function (label) {
      var count = distribution[label];
      if (total === 0 || count === 0) return;
      var len = count / total * circumference;
      circles += '<circle cx="60" cy="60" r="50" fill="none" stroke="' + RISK_COLORS[label] + '" stroke-width="20" ' +
        'stroke-dasharray="' + len + ' ' + (circumference - len) + '" stroke-dashoffset="-' + offset + '"/>';
      offset += len;
    });
    svg.innerHTML = circles;

    qs('#riskPieLegend').innerHTML = Object.keys(distribution).map(function (label) {
      var count = distribution[label];
      var pct = total === 0 ? 0 : Math.round(count * 100 / total);
      return '<div class="flex items-center justify-between text-sm"><span class="flex items-center gap-2">' +
        '<span class="w-3 h-3 rounded-full inline-block" style="background:' + RISK_COLORS[label] + '"></span>' + label + '</span>' +
        '<span class="font-bold text-gray-900">' + pct + '% (' + count + '건)</span></div>';
    }).join('');
  }

  function renderCategoryBreakdown(categories) {
    if (!categories.length) {
      qs('#categoryBreakdown').innerHTML = '<p class="text-sm text-gray-400">데이터가 없습니다.</p>';
      return;
    }
    var max = categories[0].count;
    qs('#categoryBreakdown').innerHTML = categories.map(function (c, i) {
      var pct = max === 0 ? 0 : c.count * 100 / max;
      return '<div><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">' + c.category +
        '</span><span class="font-bold text-gray-900">' + c.count + '건</span></div>' +
        '<div class="w-full bg-gray-100 rounded-full h-2.5"><div class="' + CATEGORY_COLORS[i % CATEGORY_COLORS.length] +
        ' h-2.5 rounded-full" style="width:' + pct + '%"></div></div></div>';
    }).join('');
  }

  function renderCompanyRanking(companies) {
    if (!companies.length) {
      qs('#companyRanking').innerHTML = '<p class="text-sm text-gray-400">데이터가 없습니다.</p>';
      return;
    }
    qs('#companyRanking').innerHTML = companies.map(function (c, i) {
      var pct = Math.round(c.completionRate);
      var color = pct >= 90 ? 'text-green-600' : pct >= 80 ? 'text-blue-600' : 'text-orange-600';
      return '<div class="flex items-center gap-3 p-3 border border-gray-100 rounded-xl hover:border-gray-200 transition-colors">' +
        '<span class="w-6 h-6 bg-gray-100 rounded-full flex items-center justify-center text-xs font-bold text-gray-600">' + (i + 1) + '</span>' +
        '<div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate">' + c.companyName +
        '</p><div class="flex items-center gap-2 mt-0.5"><div class="flex-1 bg-gray-100 rounded-full h-1.5">' +
        '<div class="bg-green-500 h-1.5 rounded-full" style="width:' + pct + '%"></div></div></div></div>' +
        '<div class="text-right flex-shrink-0"><p class="text-sm font-bold ' + color + '">' + pct + '%</p>' +
        '<p class="text-xs text-gray-400">' + c.completed + '/' + c.total + '건</p></div></div>';
    }).join('');
  }

  function renderInsights(data) {
    var items = [];
    if (data.totalDetections === 0) {
      items.push('아직 감지된 위험요소가 없습니다.');
    } else {
      var topCategory = data.categoryBreakdown[0];
      if (topCategory) items.push('가장 많이 감지된 위험 유형은 "' + topCategory.category + '"(' + topCategory.count + '건)입니다.');
      items.push('전체 조치 완료율은 ' + data.completionRate.toFixed(1) + '%, 평균 조치 소요기간은 ' + data.avgActionDays.toFixed(1) + '일입니다.');
      var topCompany = data.companyRanking[0];
      if (topCompany) items.push('"' + topCompany.companyName + '"의 조치 완료율이 ' + topCompany.completionRate.toFixed(0) + '%로 가장 높습니다.');
    }
    qs('#insightList').innerHTML = items.map(function (text) {
      return '<li class="flex items-start gap-2"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>' + text + '</li>';
    }).join('');
  }
})();
</script>
</body>
</html>