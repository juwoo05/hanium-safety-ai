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
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div>
        <span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-5">

      <!-- Welcome Banner -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-6 text-white">
        <div class="flex items-center justify-between gap-4">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-1">
              <span class="bg-[#FF6B35] text-white text-xs font-bold px-3 py-1 rounded-full">원청</span>
              <span id="bannerCompany" class="text-white/60 text-sm"></span>
            </div>
            <h1 id="bannerGreeting" class="text-2xl font-bold mb-1">안녕하세요!</h1>
            <p id="bannerSubtitle" class="text-white/70 text-sm mb-4">전체 현장 안전 현황을 불러오는 중...</p>
            <div class="grid grid-cols-3 gap-3">
              <div class="bg-white/10 rounded-xl px-3 py-2.5 flex items-center gap-2">
                <svg class="w-4 h-4 text-white/60 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                <div><p class="text-xs text-white/60">현장 수</p><p id="bannerSiteCount" class="text-base font-bold">-</p></div>
              </div>
              <div class="bg-white/10 rounded-xl px-3 py-2.5 flex items-center gap-2">
                <svg class="w-4 h-4 text-white/60 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
                <div><p class="text-xs text-white/60">긴급 조치</p><p id="bannerUrgentCount" class="text-base font-bold">-</p></div>
              </div>
              <div class="bg-white/10 rounded-xl px-3 py-2.5 flex items-center gap-2">
                <svg class="w-4 h-4 text-white/60 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                <div><p class="text-xs text-white/60">협력사</p><p id="bannerCompanyCount" class="text-base font-bold">-</p></div>
              </div>
            </div>
          </div>
          <div class="hidden md:flex flex-col items-center gap-1 bg-white/10 rounded-2xl px-5 py-4 flex-shrink-0">
            <svg id="safetyGaugeSvg" width="140" height="80" viewBox="0 0 140 80"></svg>
            <span id="safetyGaugeLabel" class="text-xs font-bold px-3 py-1 rounded-full mt-1"></span>
            <p class="text-xs text-white/60 mt-1">협력사 평균 완료율</p>
          </div>
          <div id="weatherWidget" class="hidden lg:flex flex-col justify-center gap-1 bg-white/10 rounded-2xl px-5 py-4 flex-shrink-0 min-w-[150px]">
            <p class="text-xs text-white/60">서울 오늘 날씨</p>
            <div class="flex items-center gap-2">
              <p id="weatherTemp" class="text-2xl font-bold">-</p>
              <p id="weatherSky" class="text-sm text-white/80">-</p>
            </div>
            <p id="weatherDetail" class="text-xs text-white/60">강수확률 - · 최저/최고 -/-</p>
          </div>
        </div>
      </div>

      <!-- KPI -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-[#FF6B35]/30 transition-all cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-blue-500 w-11 h-11 rounded-xl flex items-center justify-center shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
          </div>
          <p class="text-gray-400 text-xs mb-0.5">전체 리포트 수</p>
          <p id="kpiTotalReports" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-[#FF6B35]/30 transition-all cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-red-500 w-11 h-11 rounded-xl flex items-center justify-center shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          </div>
          <p class="text-gray-400 text-xs mb-0.5">고위험 항목</p>
          <p id="kpiHighRisk" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-[#FF6B35]/30 transition-all cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-orange-500 w-11 h-11 rounded-xl flex items-center justify-center shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          </div>
          <p class="text-gray-400 text-xs mb-0.5">조치 진행 중</p>
          <p id="kpiInProgress" class="text-2xl font-bold text-gray-900">-</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-[#FF6B35]/30 transition-all cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-purple-500 w-11 h-11 rounded-xl flex items-center justify-center shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg></div>
          </div>
          <p class="text-gray-400 text-xs mb-0.5">협력사 수</p>
          <p id="kpiCompanyCount" class="text-2xl font-bold text-gray-900">-</p>
        </div>
      </div>

      <!-- AI Tip -->
      <div id="mascotTipCard" class="hidden bg-gradient-to-r from-[#FF6B35]/10 to-[#FF6B35]/5 rounded-2xl p-4 border border-[#FF6B35]/20 flex items-start gap-3">
        <img src="/images/mascot.png" alt="마스코트" class="w-10 h-10 object-contain flex-shrink-0" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
        <div class="flex-1">
          <p class="text-sm font-semibold text-[#1B3A5F]">AI 안전 현황 요약</p>
          <p id="mascotTipText" class="text-xs text-gray-600 mt-0.5 leading-relaxed"></p>
        </div>
        <a href="/analytics" class="flex-shrink-0 text-xs text-[#FF6B35] font-semibold flex items-center gap-1 hover:gap-2 transition-all">
          상세 <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
        </a>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-5">
        <div class="lg:col-span-2 space-y-5">

          <!-- Quick Actions -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-base font-semibold text-gray-900 mb-4">빠른 실행</h3>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group text-center">
                <div class="bg-blue-500 w-11 h-11 rounded-xl flex items-center justify-center group-hover:scale-105 transition-transform shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></div>
                <div><p class="text-xs font-semibold text-gray-700">사진 업로드</p><p class="text-[10px] text-gray-400">AI 분석 시작</p></div>
              </a>
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group text-center">
                <div class="bg-[#FF6B35] w-11 h-11 rounded-xl flex items-center justify-center group-hover:scale-105 transition-transform shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
                <div><p class="text-xs font-semibold text-gray-700">AI 분석</p><p class="text-[10px] text-gray-400">위험요소 탐지</p></div>
              </a>
              <a href="/actions/new" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group text-center">
                <div class="bg-green-500 w-11 h-11 rounded-xl flex items-center justify-center group-hover:scale-105 transition-transform shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg></div>
                <div><p class="text-xs font-semibold text-gray-700">조치 등록</p><p class="text-[10px] text-gray-400">신규 조치 추가</p></div>
              </a>
              <a href="/actions/detail" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group text-center">
                <div class="bg-purple-500 w-11 h-11 rounded-xl flex items-center justify-center group-hover:scale-105 transition-transform shadow-sm"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div>
                <div><p class="text-xs font-semibold text-gray-700">리포트 보기</p><p class="text-[10px] text-gray-400">상세 분석 조회</p></div>
              </a>
            </div>
          </div>

          <!-- Monthly Chart -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-base font-semibold text-gray-900">월별 위험 발생 현황</h3>
              <div class="flex items-center gap-3 text-xs text-gray-500">
                <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded bg-[#FF6B35] inline-block"></span>고위험</span>
                <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded bg-orange-400 inline-block"></span>중위험</span>
                <span class="flex items-center gap-1"><span class="w-2.5 h-2.5 rounded bg-yellow-400 inline-block"></span>안전</span>
              </div>
            </div>
            <div id="monthlyChart" class="flex items-end justify-between gap-1.5" style="height:140px"></div>
          </div>

          <!-- Subcontractor Status -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-4 h-4 text-[#1B3A5F]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              협력사 안전 현황
            </h3>
            <div id="companyStatusList" class="space-y-3">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
          </div>
        </div>

        <!-- Right Sidebar -->
        <div class="space-y-5">
          <!-- Urgent Actions -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <svg class="w-4 h-4 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
              긴급 조치 필요
              <span id="urgentBadge" class="ml-auto text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full font-bold"></span>
            </h3>
            <div id="urgentActionsList" class="space-y-2">
              <p class="text-sm text-gray-400">불러오는 중...</p>
            </div>
            <a href="/actions" class="block w-full mt-3 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-xs font-semibold text-center">전체 긴급 조치 보기</a>
          </div>

          <!-- Risk Distribution -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h3 class="text-sm font-semibold text-gray-900 mb-4">위험 등급 분포</h3>
            <div class="flex items-center gap-4">
              <svg id="riskPieSvg" width="110" height="110" viewBox="0 0 120 120" class="flex-shrink-0"></svg>
              <div id="riskLegend" class="flex-1 space-y-2"></div>
            </div>
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
        qs('#bannerGreeting').textContent = '안녕하세요, ' + user.username + '님!';
        qs('#bannerCompany').textContent = user.companyName || '';
        qs('#bannerSubtitle').textContent = '전체 현장 안전 현황';
        return user;
      });
  }

  function loadSiteCount() {
    return fetch('/api/sites').then(function (res) { return res.ok ? res.json() : []; }).then(function (sites) {
      qs('#bannerSiteCount').textContent = sites.length + '개';
    });
  }

  function renderSafetyGauge(score) {
    var r = 52, cx = 70, cy = 70, strokeW = 10;
    var circ = Math.PI * r;
    var dash = (score / 100) * circ;
    var color = score >= 80 ? '#22c55e' : score >= 60 ? '#f97316' : '#ef4444';
    var label = score >= 80 ? '양호' : score >= 60 ? '주의' : '위험';
    var path = 'M ' + (cx - r) + ' ' + cy + ' A ' + r + ' ' + r + ' 0 0 1 ' + (cx + r) + ' ' + cy;
    qs('#safetyGaugeSvg').innerHTML =
      '<path d="' + path + '" fill="none" stroke="#ffffff33" stroke-width="' + strokeW + '" stroke-linecap="round"/>' +
      '<path d="' + path + '" fill="none" stroke="' + color + '" stroke-width="' + strokeW + '" stroke-linecap="round" stroke-dasharray="' + dash + ' ' + circ + '"/>' +
      '<text x="' + cx + '" y="' + (cy - 8) + '" text-anchor="middle" font-size="22" font-weight="700" fill="#fff">' + score + '</text>' +
      '<text x="' + cx + '" y="' + (cy + 8) + '" text-anchor="middle" font-size="11" fill="#ffffffb3">안전점수</text>';
    var labelEl = qs('#safetyGaugeLabel');
    labelEl.textContent = label;
    labelEl.style.background = color + '33';
    labelEl.style.color = '#fff';
  }

  function renderMonthlyChart(monthlyTrend) {
    var max = 1;
    monthlyTrend.forEach(function (m) { max = Math.max(max, m.high + m.medium + m.safe); });
    qs('#monthlyChart').innerHTML = monthlyTrend.map(function (m) {
      var hp = m.high * 100 / max, mp = m.medium * 100 / max, sp = m.safe * 100 / max;
      return '<div class="flex-1 flex flex-col items-center gap-1">' +
        '<div class="w-full flex flex-col items-stretch gap-0.5" style="height:110px;justify-content:flex-end">' +
        '<div class="w-full bg-[#FF6B35] rounded-t" style="height:' + hp + '%;min-height:2px"></div>' +
        '<div class="w-full bg-orange-400" style="height:' + mp + '%;min-height:2px"></div>' +
        '<div class="w-full bg-yellow-400 rounded-b" style="height:' + sp + '%;min-height:2px"></div>' +
        '</div><span class="text-xs text-gray-400">' + m.month + '월</span></div>';
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
      return '<div class="p-4 rounded-xl border ' + (caution ? 'border-orange-200 bg-orange-50' : 'border-gray-100 bg-gray-50') + '">' +
        '<div class="flex items-center justify-between mb-2"><div class="flex items-center gap-2">' +
        '<svg class="w-4 h-4 ' + (caution ? 'text-orange-500' : 'text-green-600') + '" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M2 20h20"/><path d="M4 20V10l8-6 8 6v10"/></svg>' +
        '<span class="font-semibold text-gray-900 text-sm">' + c.companyName + '</span>' +
        (caution ? '<span class="text-xs bg-orange-100 text-orange-700 border border-orange-200 px-2 py-0.5 rounded-full">주의</span>' : '') + '</div>' +
        '<span class="text-sm font-bold ' + (caution ? 'text-orange-500' : 'text-green-600') + '">' + pct + '%</span></div>' +
        '<div class="flex items-center gap-4 text-xs text-gray-500 mb-2"><span>조치 ' + c.total + '건</span><span class="text-gray-600">완료 ' + c.completed + '건</span></div>' +
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
        qs('#bannerCompanyCount').textContent = data.companyRanking.length + '개';
        renderMonthlyChart(data.monthlyTrend);
        renderRiskPie(data.riskDistribution);
        renderCompanyStatus(data.companyRanking);

        var ranking = data.companyRanking;
        var avgCompletion = ranking.length
          ? Math.round(ranking.reduce(function (sum, c) { return sum + c.completionRate; }, 0) / ranking.length)
          : 0;
        renderSafetyGauge(avgCompletion);

        var topCompany = ranking.slice().sort(function (a, b) { return b.total - a.total; })[0];
        if (topCompany) {
          qs('#mascotTipCard').classList.remove('hidden');
          qs('#mascotTipText').textContent = topCompany.companyName + '의 조치 건수가 ' + topCompany.total + '건으로 가장 많습니다. 완료율 ' + topCompany.completionRate.toFixed(0) + '%.';
        }
      })
      .catch(function () { renderSafetyGauge(0); });
  }

  function loadUrgentActions() {
    fetch('/api/actions/search?status=REQUESTED')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (actions) {
        var sorted = actions.slice().sort(function (a, b) { return (a.dueDate || '') < (b.dueDate || '') ? -1 : 1; }).slice(0, 4);
        qs('#bannerUrgentCount').textContent = actions.length + '건';
        qs('#urgentBadge').textContent = actions.length + '건';
        qs('#urgentActionsList').innerHTML = sorted.length
          ? sorted.map(function (a) {
              var link = a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id;
              return '<a href="' + link + '" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors group">' +
                '<p class="text-sm font-semibold text-gray-900 mb-0.5">' + a.title + '</p>' +
                '<p class="text-xs text-gray-500">' + (a.location || '현장 미지정') + (a.reporterName ? ' · ' + a.reporterName : '') + '</p>' +
                '<div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">마감: ' + (a.dueDate || '-') + '</span>' +
                '<svg class="w-3.5 h-3.5 text-red-400 group-hover:translate-x-0.5 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div></a>';
            }).join('')
          : '<p class="text-sm text-gray-400">긴급 조치가 없습니다.</p>';
      })
      .catch(function () {
        qs('#urgentActionsList').innerHTML = '<p class="text-sm text-red-400">조치 목록을 불러오지 못했습니다.</p>';
      });
  }

  function loadWeather() {
    fetch('/api/weather/today')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (w) {
        qs('#weatherTemp').textContent = (w.temperature != null ? w.temperature : '-') + '°';
        qs('#weatherSky').textContent = w.skyCondition + (w.precipitationType && w.precipitationType !== '없음' ? ' · ' + w.precipitationType : '');
        qs('#weatherDetail').textContent = '강수확률 ' + (w.precipitationProbability != null ? w.precipitationProbability : '-') + '% · 최저/최고 '
          + (w.todayMin != null ? w.todayMin : '-') + '°/' + (w.todayMax != null ? w.todayMax : '-') + '°';
      })
      .catch(function () {});
  }

  loadCurrentUser();
  loadSiteCount();
  loadAnalytics();
  loadUrgentActions();
  loadWeather();
})();
</script>
</body>
</html>
