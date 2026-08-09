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
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-5">
      <div><h1 class="text-2xl font-bold text-gray-900">통계 분석</h1><p class="text-sm text-gray-500 mt-0.5">현장 안전 데이터 인사이트</p></div>

      <!-- KPI Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div class="w-9 h-9 bg-blue-50 rounded-lg flex items-center justify-center mb-3"><svg class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          <p class="text-xs text-gray-500 mb-1">총 업로드 수</p>
          <p id="kpiTotalUploads" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div class="w-9 h-9 bg-red-50 rounded-lg flex items-center justify-center mb-3"><svg class="w-4 h-4 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg></div>
          <p class="text-xs text-gray-500 mb-1">위험 감지 건수</p>
          <p id="kpiTotalDetections" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div class="w-9 h-9 bg-green-50 rounded-lg flex items-center justify-center mb-3"><svg class="w-4 h-4 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
          <p class="text-xs text-gray-500 mb-1">조치 완료율</p>
          <p id="kpiCompletionRate" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div class="w-9 h-9 bg-purple-50 rounded-lg flex items-center justify-center mb-3"><svg class="w-4 h-4 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          <p class="text-xs text-gray-500 mb-1">평균 조치 기간</p>
          <p id="kpiAvgActionDays" class="text-2xl font-bold text-gray-900">-</p>
        </div>
      </div>

      <!-- AI Insights -->
      <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
        <div class="flex items-center gap-2 mb-4">
          <div class="w-8 h-8 bg-purple-50 rounded-lg flex items-center justify-center">
            <svg class="w-4 h-4 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z"/></svg>
          </div>
          <h3 class="text-base font-bold text-gray-900">AI 인사이트</h3>
        </div>
        <div id="insightGrid" class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <p class="text-sm text-gray-400 col-span-2">데이터를 불러오는 중...</p>
        </div>
      </div>

      <!-- Monthly Trend (line) -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-5">
          <h3 class="text-base font-bold text-gray-900">월별 위험도 추이</h3>
          <div class="flex items-center gap-4 text-xs text-gray-500">
            <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded-full bg-red-500 inline-block"></span>고위험</span>
            <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded-full bg-orange-400 inline-block"></span>중위험</span>
            <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded-full bg-yellow-400 inline-block"></span>안전</span>
          </div>
        </div>
        <svg id="trendLineChart" viewBox="0 0 600 220" class="w-full" style="height:220px" preserveAspectRatio="none"></svg>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
        <!-- Category -->
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h3 class="text-base font-bold text-gray-900 mb-5">위험 유형별 분류</h3>
          <div id="categoryBreakdown" class="space-y-4"></div>
        </div>

        <!-- Donuts -->
        <div class="space-y-4">
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-bold text-gray-900 mb-4">조치 상태 분포</h3>
            <div id="statusDonut" class="flex items-center gap-4">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-bold text-gray-900 mb-4">위험도 분포</h3>
            <div id="riskDonut" class="flex items-center gap-4">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Company Ranking -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <h3 class="text-base font-bold text-gray-900 mb-5">업체별 조치 완료율</h3>
        <div id="companyRanking" class="space-y-3"></div>
      </div>

      <!-- Manager leaderboard -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <h3 class="text-base font-bold text-gray-900 mb-5">담당자 성과 순위</h3>
        <div id="managerLeaderboard" class="space-y-3">
          <p class="text-sm text-gray-400">불러오는 중...</p>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  function qs(sel, root) { return (root || document).querySelector(sel); }
  var CATEGORY_COLORS = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-blue-500', 'bg-purple-500'];
  var RISK_COLORS = { '고위험': '#ef4444', '중위험': '#f97316', '안전': '#eab308' };
  var STATUS_COLORS = { REQUESTED: '#ef4444', IN_PROGRESS: '#f97316', PENDING_APPROVAL: '#3b82f6', COMPLETED: '#22c55e' };
  var STATUS_LABEL = { REQUESTED: '조치 전', IN_PROGRESS: '조치 중', PENDING_APPROVAL: '검증 중', COMPLETED: '완료' };

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
      qs('#insightGrid').innerHTML = '<p class="text-sm text-gray-400 col-span-2">' + err.message + '</p>';
    });

  fetch('/api/actions/search')
    .then(function (res) { return res.ok ? res.json() : []; })
    .then(renderActionDerived)
    .catch(function () {
      qs('#statusDonut').innerHTML = '<p class="text-sm text-red-400">불러오지 못했습니다.</p>';
      qs('#managerLeaderboard').innerHTML = '<p class="text-sm text-red-400">불러오지 못했습니다.</p>';
    });

  function render(data) {
    qs('#kpiTotalUploads').textContent = data.totalUploads.toLocaleString();
    qs('#kpiTotalDetections').textContent = data.totalDetections.toLocaleString();
    qs('#kpiCompletionRate').textContent = data.completionRate.toFixed(1) + '%';
    qs('#kpiAvgActionDays').textContent = data.avgActionDays.toFixed(1) + '일';

    renderTrendLine(data.monthlyTrend);
    renderDonut('#riskDonut', Object.keys(data.riskDistribution).map(function (k) {
      return { name: k, value: data.riskDistribution[k], color: RISK_COLORS[k] || '#9ca3af' };
    }));
    renderCategoryBreakdown(data.categoryBreakdown);
    renderCompanyRanking(data.companyRanking);
    renderInsights(data);
  }

  function renderTrendLine(monthlyTrend) {
    var svg = qs('#trendLineChart');
    var W = 600, H = 220, padL = 30, padR = 10, padT = 15, padB = 25;
    var n = monthlyTrend.length;
    if (!n) { svg.innerHTML = '<text x="300" y="110" text-anchor="middle" fill="#9ca3af" font-size="12">데이터가 없습니다</text>'; return; }
    var max = 1;
    monthlyTrend.forEach(function (m) { max = Math.max(max, m.high, m.medium, m.safe); });
    var stepX = n > 1 ? (W - padL - padR) / (n - 1) : 0;

    function points(key) {
      return monthlyTrend.map(function (m, i) {
        var x = padL + stepX * i;
        var y = padT + (1 - m[key] / max) * (H - padT - padB);
        return x + ',' + y;
      }).join(' ');
    }

    var gridLines = '';
    for (var g = 0; g <= 4; g++) {
      var gy = padT + (H - padT - padB) * g / 4;
      gridLines += '<line x1="' + padL + '" y1="' + gy + '" x2="' + (W - padR) + '" y2="' + gy + '" stroke="#f0f0f0" stroke-width="1"/>';
    }

    var labels = monthlyTrend.map(function (m, i) {
      var x = padL + stepX * i;
      return '<text x="' + x + '" y="' + (H - 6) + '" text-anchor="middle" fill="#9ca3af" font-size="10">' + m.month + '월</text>';
    }).join('');

    function dots(key, color) {
      return monthlyTrend.map(function (m, i) {
        var x = padL + stepX * i;
        var y = padT + (1 - m[key] / max) * (H - padT - padB);
        return '<circle cx="' + x + '" cy="' + y + '" r="3.5" fill="' + color + '"><title>' + m.month + '월 ' + m[key] + '건</title></circle>';
      }).join('');
    }

    svg.innerHTML = gridLines +
      '<polyline points="' + points('high') + '" fill="none" stroke="#ef4444" stroke-width="2.5"/>' + dots('high', '#ef4444') +
      '<polyline points="' + points('medium') + '" fill="none" stroke="#f97316" stroke-width="2.5"/>' + dots('medium', '#f97316') +
      '<polyline points="' + points('safe') + '" fill="none" stroke="#eab308" stroke-width="2.5"/>' + dots('safe', '#eab308') +
      labels;
  }

  function renderDonut(selector, data) {
    var total = data.reduce(function (s, d) { return s + d.value; }, 0);
    var size = 110, r = size * 0.33, cx = size / 2, cy = size / 2, strokeW = size * 0.16;
    var circ = 2 * Math.PI * r;
    var offset = 0;
    var segs = '';
    data.forEach(function (d) {
      if (total === 0 || d.value === 0) return;
      var pct = d.value / total * 100;
      segs += '<circle cx="' + cx + '" cy="' + cy + '" r="' + r + '" fill="none" stroke="' + d.color + '" stroke-width="' + strokeW +
        '" stroke-dasharray="' + (pct / 100 * circ) + ' ' + circ + '" stroke-dashoffset="' + (-(offset / 100 * circ)) +
        '" transform="rotate(-90 ' + cx + ' ' + cy + ')"/>';
      offset += pct;
    });
    var svg = '<svg width="' + size + '" height="' + size + '" viewBox="0 0 ' + size + ' ' + size + '" class="flex-shrink-0">' +
      (total === 0 ? '<circle cx="' + cx + '" cy="' + cy + '" r="' + r + '" fill="none" stroke="#f3f4f6" stroke-width="' + strokeW + '"/>' : segs) +
      '<text x="' + cx + '" y="' + (cy - 5) + '" text-anchor="middle" fill="#111827" font-size="' + (size * 0.12) + '" font-weight="700">' + total + '</text>' +
      '<text x="' + cx + '" y="' + (cy + size * 0.1) + '" text-anchor="middle" fill="#9CA3AF" font-size="' + (size * 0.08) + '">전체</text></svg>';
    var legend = '<div class="space-y-2">' + data.map(function (d) {
      var pct = total === 0 ? 0 : Math.round(d.value / total * 100);
      return '<div class="flex items-center gap-2 text-sm"><span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background:' + d.color + '"></span>' +
        '<span class="text-gray-600 w-16">' + d.name + '</span><span class="font-bold text-gray-900">' + d.value + '</span>' +
        '<span class="text-gray-400 text-xs">(' + pct + '%)</span></div>';
    }).join('') + '</div>';
    qs(selector).innerHTML = svg + legend;
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
      items.push({ type: 'info', text: '아직 감지된 위험요소가 없습니다.' });
    } else {
      var topCategory = data.categoryBreakdown[0];
      if (topCategory) items.push({ type: 'warn', text: '가장 많이 감지된 위험 유형은 "' + topCategory.category + '"(' + topCategory.count + '건)입니다.' });
      items.push({ type: data.completionRate >= 80 ? 'good' : 'alert', text: '전체 조치 완료율은 ' + data.completionRate.toFixed(1) + '%, 평균 조치 소요기간은 ' + data.avgActionDays.toFixed(1) + '일입니다.' });
      var topCompany = data.companyRanking[0];
      if (topCompany) items.push({ type: 'good', text: '"' + topCompany.companyName + '"의 조치 완료율이 ' + topCompany.completionRate.toFixed(0) + '%로 가장 높습니다.' });
    }
    var cfg = {
      warn:  { bg: 'bg-orange-50 border-orange-200', dot: 'bg-orange-500', text: 'text-orange-800' },
      good:  { bg: 'bg-green-50 border-green-200',   dot: 'bg-green-500',  text: 'text-green-800' },
      alert: { bg: 'bg-red-50 border-red-200',       dot: 'bg-red-500',    text: 'text-red-800' },
      info:  { bg: 'bg-blue-50 border-blue-200',     dot: 'bg-blue-500',   text: 'text-blue-800' },
    };
    qs('#insightGrid').innerHTML = items.map(function (item) {
      var c = cfg[item.type];
      return '<div class="flex items-start gap-2.5 p-3 rounded-xl border ' + c.bg + '">' +
        '<div class="w-2 h-2 rounded-full ' + c.dot + ' flex-shrink-0 mt-1.5"></div>' +
        '<p class="text-xs leading-relaxed ' + c.text + '">' + item.text + '</p></div>';
    }).join('');
  }

  function renderActionDerived(actions) {
    // 조치 상태 분포
    var statusCounts = { REQUESTED: 0, IN_PROGRESS: 0, PENDING_APPROVAL: 0, COMPLETED: 0 };
    actions.forEach(function (a) { if (statusCounts[a.status] !== undefined) statusCounts[a.status]++; });
    renderDonut('#statusDonut', Object.keys(statusCounts).map(function (k) {
      return { name: STATUS_LABEL[k], value: statusCounts[k], color: STATUS_COLORS[k] };
    }));

    // 담당자 성과 순위
    var byReporter = {};
    actions.forEach(function (a) {
      var key = a.reporterName || '미배정';
      if (!byReporter[key]) byReporter[key] = { name: key, assigned: 0, completed: 0 };
      byReporter[key].assigned++;
      if (a.status === 'COMPLETED') byReporter[key].completed++;
    });
    var ranking = Object.values(byReporter)
      .map(function (r) { r.rate = r.assigned ? Math.round(r.completed * 100 / r.assigned) : 0; return r; })
      .sort(function (a, b) { return b.rate - a.rate || b.assigned - a.assigned; })
      .slice(0, 5);

    if (!ranking.length) {
      qs('#managerLeaderboard').innerHTML = '<p class="text-sm text-gray-400">데이터가 없습니다.</p>';
      return;
    }
    var medals = ['🥇', '🥈', '🥉'];
    qs('#managerLeaderboard').innerHTML = ranking.map(function (m, i) {
      return '<div class="flex items-center gap-4 p-4 rounded-xl border ' + (i === 0 ? 'border-yellow-200 bg-yellow-50' : 'border-gray-100 bg-gray-50') + '">' +
        '<span class="text-xl flex-shrink-0 w-7 text-center">' + (medals[i] || (i + 1)) + '</span>' +
        '<div class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold text-sm flex-shrink-0" style="background:' + (i === 0 ? '#FF6B35' : '#1B3A5F') + '">' +
        m.name.charAt(0) + '</div>' +
        '<div class="flex-1 min-w-0"><div class="flex items-center gap-2 mb-1.5">' +
        '<span class="font-semibold text-gray-900 text-sm">' + m.name + '</span>' +
        '<span class="ml-auto text-xs text-gray-500">담당 ' + m.assigned + '건 · 완료 ' + m.completed + '건</span></div>' +
        '<div class="h-1.5 bg-gray-200 rounded-full"><div class="h-full rounded-full" style="width:' + m.rate + '%;background:#FF6B35"></div></div>' +
        '</div><span class="text-sm font-bold text-gray-900 flex-shrink-0">' + m.rate + '%</span></div>';
    }).join('');
  }
})();
</script>
</body>
</html>
