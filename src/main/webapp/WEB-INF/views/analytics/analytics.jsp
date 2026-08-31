<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>통계 분석 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"
          integrity="sha384-NrKB+u6Ts6AtkIhwPixiKTzgSKNblyhlk0Sohlgar9UHUBzai/sgnNNWWd291xqt"
          crossorigin="anonymous"></script>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1280px">
    <div style="display:flex;flex-direction:column;gap:20px">
      <div class="flex items-center justify-between flex-wrap gap-3">
        <div>
          <p style="font-size:11px;color:#9CA3AF;letter-spacing:0.06em;text-transform:uppercase;font-weight:500;margin-bottom:5px">통계 현황</p>
          <h1 style="font-size:22px;font-weight:600;color:#0F172A;letter-spacing:-0.02em;line-height:1">분석 리포트</h1>
        </div>
        <div id="periodToggle" class="flex items-center" style="background:#F3F4F6;border-radius:4px;padding:3px;gap:1px"></div>
      </div>

      <!-- KPI Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C4CBD4" stroke-width="1.5" style="margin-bottom:12px"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
          <p style="font-size:10px;color:#9CA3AF;margin-bottom:5px;letter-spacing:0.01em">총 업로드 수</p>
          <p id="kpiTotalUploads" style="font-size:22px;font-weight:700;color:#0F172A;letter-spacing:-0.03em">-</p>
        </div>
        <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C4CBD4" stroke-width="1.5" style="margin-bottom:12px"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>
          <p style="font-size:10px;color:#9CA3AF;margin-bottom:5px;letter-spacing:0.01em">위험 감지 건수</p>
          <p id="kpiTotalDetections" style="font-size:22px;font-weight:700;color:#0F172A;letter-spacing:-0.03em">-</p>
        </div>
        <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C4CBD4" stroke-width="1.5" style="margin-bottom:12px"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
          <p style="font-size:10px;color:#9CA3AF;margin-bottom:5px;letter-spacing:0.01em">조치 완료율</p>
          <p id="kpiCompletionRate" style="font-size:22px;font-weight:700;color:#0F172A;letter-spacing:-0.03em">-</p>
        </div>
        <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C4CBD4" stroke-width="1.5" style="margin-bottom:12px"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          <p style="font-size:10px;color:#9CA3AF;margin-bottom:5px;letter-spacing:0.01em">평균 조치 기간</p>
          <p id="kpiAvgActionDays" style="font-size:22px;font-weight:700;color:#0F172A;letter-spacing:-0.03em">-</p>
        </div>
      </div>

      <!-- AI Insights -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 20px">
        <div class="flex items-center justify-between mb-3">
          <h3 style="font-size:14px;font-weight:600;color:#0F172A">주요 지표 분석</h3>
          <span id="insightPeriodLabel" style="font-size:11px;color:#9CA3AF"></span>
        </div>
        <div id="insightGrid" class="grid grid-cols-1 sm:grid-cols-2 gap-2">
          <p class="text-sm text-gray-400 col-span-2">데이터를 불러오는 중...</p>
        </div>
      </div>

      <!-- Monthly Trend (line) -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:18px 20px">
        <div class="flex items-center justify-between mb-5">
          <h3 style="font-size:14px;font-weight:600;color:#0F172A">월별 위험도 추이</h3>
          <div class="flex items-center gap-3">
            <div id="metricToggle" class="flex items-center" style="background:#F3F4F6;border-radius:4px;padding:3px;gap:1px"></div>
          </div>
        </div>
        <div style="height:240px"><canvas id="trendLineChart"></canvas></div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <!-- Category -->
        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:18px 20px">
          <h3 style="font-size:14px;font-weight:600;color:#0F172A;margin-bottom:16px">위험 유형별 분류</h3>
          <div id="categoryBreakdown" class="space-y-4"></div>
        </div>

        <!-- Donuts -->
        <div class="flex flex-col" style="gap:12px">
          <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 20px;flex:1">
            <h3 style="font-size:13px;font-weight:600;color:#0F172A;margin-bottom:12px">조치 상태 분포</h3>
            <div id="statusDonut" class="flex items-center gap-4">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
          <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 20px;flex:1">
            <h3 style="font-size:13px;font-weight:600;color:#0F172A;margin-bottom:12px">위험도 분포</h3>
            <div id="riskDonut" class="flex items-center gap-4">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Company Ranking -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:18px 20px">
        <h3 style="font-size:14px;font-weight:600;color:#0F172A;margin-bottom:16px">업체별 조치 완료율</h3>
        <div id="companyRanking" class="space-y-3"></div>
      </div>

      <!-- Manager leaderboard -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:18px 20px">
        <h3 style="font-size:14px;font-weight:600;color:#0F172A;margin-bottom:16px">담당자 성과 순위</h3>
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
  var PERIODS = [{ key: '3개월', months: 3 }, { key: '6개월', months: 6 }, { key: '1년', months: 12 }];
  var fullMonthlyTrend = [];
  var currentPeriod = '6개월';
  var activeMetric = 'risk';
  var allActionsGlobal = [];

  function renderPeriodToggle() {
    qs('#periodToggle').innerHTML = PERIODS.map(function (p) {
      var active = currentPeriod === p.key;
      return '<button type="button" class="period-btn" data-key="' + p.key + '" style="padding:4px 10px;font-size:12px;font-weight:' + (active ? 600 : 400) +
        ';border-radius:3px;background:' + (active ? 'white' : 'transparent') + ';color:' + (active ? '#0F172A' : '#9CA3AF') +
        ';border:none;cursor:pointer;box-shadow:' + (active ? '0 1px 3px rgba(0,0,0,0.1)' : 'none') + '">' + p.key + '</button>';
    }).join('');
    qs('#insightPeriodLabel').textContent = currentPeriod + ' 기준 자동 분석';
    document.querySelectorAll('.period-btn').forEach(function (btn) {
      btn.addEventListener('click', function () {
        currentPeriod = btn.dataset.key;
        renderPeriodToggle();
        var months = PERIODS.filter(function (p) { return p.key === currentPeriod; })[0].months;
        renderTrendLine(fullMonthlyTrend.slice(-months));
      });
    });
  }

  function renderMetricToggle() {
    var options = [['risk', '위험도별'], ['completed', '완료 건수']];
    qs('#metricToggle').innerHTML = options.map(function (o) {
      var active = activeMetric === o[0];
      return '<button type="button" class="metric-btn" data-key="' + o[0] + '" style="padding:4px 10px;font-size:11px;font-weight:' + (active ? 600 : 400) +
        ';border-radius:3px;background:' + (active ? 'white' : 'transparent') + ';color:' + (active ? '#0F172A' : '#9CA3AF') +
        ';border:none;cursor:pointer;box-shadow:' + (active ? '0 1px 3px rgba(0,0,0,0.1)' : 'none') + '">' + o[1] + '</button>';
    }).join('');
    document.querySelectorAll('.metric-btn').forEach(function (btn) {
      btn.addEventListener('click', function () {
        activeMetric = btn.dataset.key;
        renderMetricToggle();
        var months = PERIODS.filter(function (p) { return p.key === currentPeriod; })[0].months;
        renderTrendLine(fullMonthlyTrend.slice(-months));
      });
    });
  }

  // 실제 조치 완료 건을 updatedAt 기준 월별로 묶어 "완료 건수" 뷰에 쓴다 (React mock의 completed 필드에 대응).
  function withCompletedCounts(monthlyTrend) {
    var counts = {};
    monthlyTrend.forEach(function (m) { counts[m.month] = 0; });
    allActionsGlobal.forEach(function (a) {
      if (a.status !== 'COMPLETED' || !a.updatedAt) return;
      var m = new Date(a.updatedAt).getMonth() + 1;
      if (counts.hasOwnProperty(m)) counts[m]++;
    });
    return monthlyTrend.map(function (m) { return { month: m.month, completed: counts[m.month] }; });
  }

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
    .then(function (actions) {
      allActionsGlobal = actions;
      renderActionDerived(actions);
      if (activeMetric === 'completed' && fullMonthlyTrend.length) {
        var months = PERIODS.filter(function (p) { return p.key === currentPeriod; })[0].months;
        renderTrendLine(fullMonthlyTrend.slice(-months));
      }
    })
    .catch(function () {
      qs('#statusDonut').innerHTML = '<p class="text-sm text-red-400">불러오지 못했습니다.</p>';
      qs('#managerLeaderboard').innerHTML = '<p class="text-sm text-red-400">불러오지 못했습니다.</p>';
    });

  function render(data) {
    qs('#kpiTotalUploads').textContent = data.totalUploads.toLocaleString();
    qs('#kpiTotalDetections').textContent = data.totalDetections.toLocaleString();
    qs('#kpiCompletionRate').textContent = data.completionRate.toFixed(1) + '%';
    qs('#kpiAvgActionDays').textContent = data.avgActionDays.toFixed(1) + '일';

    fullMonthlyTrend = data.monthlyTrend;
    renderPeriodToggle();
    renderMetricToggle();
    var initMonths = PERIODS.filter(function (p) { return p.key === currentPeriod; })[0].months;
    renderTrendLine(fullMonthlyTrend.slice(-initMonths));
    renderDonut('#riskDonut', Object.keys(data.riskDistribution).map(function (k) {
      return { name: k, value: data.riskDistribution[k], color: RISK_COLORS[k] || '#9ca3af' };
    }));
    renderCategoryBreakdown(data.categoryBreakdown);
    renderCompanyRanking(data.companyRanking);
    renderInsights(data);
  }

  var trendChartInstance = null;

  function renderTrendLine(monthlyTrend) {
    var canvas = qs('#trendLineChart');
    var n = monthlyTrend.length;
    if (trendChartInstance) { trendChartInstance.destroy(); trendChartInstance = null; }
    if (!n) return;

    var series = activeMetric === 'risk' ? monthlyTrend : withCompletedCounts(monthlyTrend);
    var labels = series.map(function (m) { return m.month + '월'; });

    var datasets = activeMetric === 'risk'
      ? [
          { key: 'high',   label: '고위험', color: '#ef4444' },
          { key: 'medium', label: '중위험', color: '#f97316' },
          { key: 'safe',   label: '안전',   color: '#eab308' }
        ].map(function (s) {
          return {
            label: s.label,
            data: series.map(function (m) { return m[s.key]; }),
            borderColor: s.color,
            backgroundColor: s.color,
            tension: 0.35,
            borderWidth: 2,
            pointRadius: 3,
            pointHoverRadius: 4,
          };
        })
      : [{
          label: '완료 건수',
          data: series.map(function (m) { return m.completed; }),
          borderColor: '#1A2E44',
          backgroundColor: '#1A2E44',
          tension: 0.35,
          borderWidth: 2,
          pointRadius: 3,
          pointHoverRadius: 4,
        }];

    trendChartInstance = new Chart(canvas, {
      type: 'line',
      data: { labels: labels, datasets: datasets },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', align: 'end', labels: { usePointStyle: true, pointStyle: 'circle', boxWidth: 7, font: { size: 11 }, color: '#6B7280' } },
          tooltip: {
            backgroundColor: 'white', titleColor: '#0F172A', bodyColor: '#374151',
            borderColor: '#E5E7EB', borderWidth: 1, cornerRadius: 4, padding: 8,
            titleFont: { size: 12 }, bodyFont: { size: 12 },
          },
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11 }, color: '#9CA3AF' } },
          y: {
            beginAtZero: true,
            grid: { color: '#f0f0f0', borderDash: [3, 3] },
            ticks: { font: { size: 11 }, color: '#9CA3AF', precision: 0 },
          },
        },
      },
    });
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
      return '<div class="flex items-center gap-3 p-3 border border-gray-100 rounded hover:border-gray-200 transition-colors">' +
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
      return '<div class="flex items-start gap-2.5 p-3 rounded border ' + c.bg + '">' +
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
    var medals = ['1위', '2위', '3위'];
    qs('#managerLeaderboard').innerHTML = ranking.map(function (m, i) {
      return '<div class="flex items-center gap-4 p-4 rounded border ' + (i === 0 ? 'border-yellow-200 bg-yellow-50' : 'border-gray-100 bg-gray-50') + '">' +
        '<span class="text-xl flex-shrink-0 w-7 text-center">' + (medals[i] || (i + 1)) + '</span>' +
        '<div class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold text-sm flex-shrink-0" style="background:' + (i === 0 ? '#1A2E44' : '#1A2E44') + '">' +
        m.name.charAt(0) + '</div>' +
        '<div class="flex-1 min-w-0"><div class="flex items-center gap-2 mb-1.5">' +
        '<span class="font-semibold text-gray-900 text-sm">' + m.name + '</span>' +
        '<span class="ml-auto text-xs text-gray-500">담당 ' + m.assigned + '건 · 완료 ' + m.completed + '건</span></div>' +
        '<div class="h-1.5 bg-gray-200 rounded-full"><div class="h-full rounded-full" style="width:' + m.rate + '%;background:#1A2E44"></div></div>' +
        '</div><span class="text-sm font-bold text-gray-900 flex-shrink-0">' + m.rate + '%</span></div>';
    }).join('');
  }
})();
</script>
</body>
</html>
