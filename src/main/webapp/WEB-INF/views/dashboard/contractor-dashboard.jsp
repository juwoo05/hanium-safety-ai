<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>원청 대시보드 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div><span id="headerUserName" class="text-sm font-medium text-gray-700 hidden sm:block">-</span></a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1280px">

    <!-- Page header -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <p style="font-size:11px;color:#9CA3AF;letter-spacing:0.06em;text-transform:uppercase;font-weight:500;margin-bottom:5px">현황 개요</p>
        <h1 id="bannerGreeting" style="font-size:22px;font-weight:600;color:#0F172A;letter-spacing:-0.02em;line-height:1">대시보드</h1>
      </div>
      <div class="flex items-center gap-2">
        <a href="/upload" style="padding:7px 14px;font-size:12px;font-weight:500;background:white;color:#374151;border:1px solid #E2E6EA;border-radius:4px;cursor:pointer;box-shadow:0 1px 2px rgba(0,0,0,0.04);text-decoration:none">사진업로드</a>
        <a href="/actions" style="padding:7px 16px;font-size:12px;font-weight:500;background:#1A2E44;color:white;border:none;border-radius:4px;cursor:pointer;text-decoration:none">조치 등록</a>
      </div>
    </div>

    <!-- KPI -->
    <div class="grid gap-3 mb-6 dash-kpi" style="grid-template-columns:repeat(auto-fit, minmax(150px, 1fr))">
      <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:10px">전체 현장</p>
        <div class="flex items-end gap-1.5"><span id="kpiSites" style="font-size:26px;font-weight:700;color:#0F172A;line-height:1;letter-spacing:-0.03em">-</span><span style="font-size:12px;color:#CBD5E1;margin-bottom:2px">개</span></div>
      </div>
      <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:10px">미조치 위험요소</p>
        <div class="flex items-end gap-1.5"><span id="kpiPending" style="font-size:26px;font-weight:700;color:#0F172A;line-height:1;letter-spacing:-0.03em">-</span><span style="font-size:12px;color:#CBD5E1;margin-bottom:2px">건</span></div>
      </div>
      <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:10px">진행중 조치</p>
        <div class="flex items-end gap-1.5"><span id="kpiInProgress" style="font-size:26px;font-weight:700;color:#0F172A;line-height:1;letter-spacing:-0.03em">-</span><span style="font-size:12px;color:#CBD5E1;margin-bottom:2px">건</span></div>
      </div>
      <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:10px">기한 초과</p>
        <div class="flex items-end gap-1.5"><span id="kpiOverdue" style="font-size:26px;font-weight:700;color:#0F172A;line-height:1;letter-spacing:-0.03em">-</span><span style="font-size:12px;color:#CBD5E1;margin-bottom:2px">건</span></div>
      </div>
      <div style="background:white;border:1px solid #E2E6EA;border-radius:4px;padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,0.03)">
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:10px">완료율</p>
        <div class="flex items-end gap-1.5"><span id="kpiCompletionRate" style="font-size:26px;font-weight:700;color:#0F172A;line-height:1;letter-spacing:-0.03em">-</span><span style="font-size:12px;color:#CBD5E1;margin-bottom:2px">%</span></div>
      </div>
    </div>

    <!-- Main grid -->
    <div class="grid gap-5 dash-2col" style="grid-template-columns:minmax(0, 1fr) 300px">

      <!-- Issues table -->
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px">
        <div class="flex items-center justify-between flex-wrap gap-2" style="padding:14px 20px;border-bottom:1px solid #F3F4F6">
          <span style="font-size:14px;font-weight:600;color:#0F172A">위험요소 현황</span>
          <div class="flex items-center gap-2 flex-wrap">
            <div id="gradeFilterBtns" class="flex items-center gap-1"></div>
            <div style="width:1px;height:16px;background:#E5E7EB"></div>
            <div id="statusFilterBtns" class="flex items-center gap-1"></div>
          </div>
        </div>
        <div style="overflow-x:auto">
          <table style="width:100%;border-collapse:collapse;font-size:13px">
            <thead>
              <tr style="background:#F9FAFB">
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">위험등급</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">위치</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">위험유형</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">담당자</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">조치상태</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">마감기한</th>
                <th style="padding:9px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em;text-transform:uppercase;border-bottom:1px solid #F3F4F6;white-space:nowrap">최근 업데이트</th>
                <th style="padding:9px 16px;border-bottom:1px solid #F3F4F6"></th>
              </tr>
            </thead>
            <tbody id="issuesTableBody">
              <tr><td colspan="8" style="padding:32px;text-align:center;font-size:13px;color:#9CA3AF">불러오는 중...</td></tr>
            </tbody>
          </table>
        </div>
        <div class="flex items-center justify-between" style="padding:10px 20px;border-top:1px solid #F3F4F6">
          <span id="issuesFooterCount" style="font-size:12px;color:#9CA3AF"></span>
          <a href="/actions" class="flex items-center gap-1" style="font-size:12px;color:#1A2E44;font-weight:500;text-decoration:none">전체 보기
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
          </a>
        </div>
      </div>

      <!-- Right sidebar -->
      <div class="flex flex-col gap-4">
        <div id="weatherBox" style="background:linear-gradient(135deg,#0ea5e9,#2563eb);border-radius:4px;padding:16px 18px;color:white">
          <p style="font-size:11px;color:#BAE6FD;margin-bottom:6px">서울 · 현재 날씨</p>
          <div class="flex items-end justify-between">
            <div class="flex items-end gap-2">
              <span id="weatherTemp" style="font-size:30px;font-weight:700;line-height:1">-</span>
              <span id="weatherCondition" style="font-size:13px;color:#E0F2FE;margin-bottom:3px">불러오는 중...</span>
            </div>
          </div>
          <div id="weatherPrecip" style="margin-top:8px;font-size:11px;color:#BAE6FD"></div>
        </div>

        <div id="overdueAlertBox" class="hidden" style="background:#FEF2F2;border:1px solid #FECACA;border-radius:4px;padding:14px 16px">
          <div class="flex items-center gap-2 mb-2">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#991B1B" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
            <span style="font-size:12px;font-weight:600;color:#991B1B">기한 초과 항목</span>
          </div>
          <div id="overdueList" class="flex flex-col gap-2"></div>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px">
          <div style="padding:12px 16px;border-bottom:1px solid #F3F4F6"><span style="font-size:13px;font-weight:600;color:#0F172A">협력사 조치 현황</span></div>
          <div id="companyStatusList" style="padding:4px 0">
            <p style="padding:16px;font-size:13px;color:#9CA3AF">불러오는 중...</p>
          </div>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px">
          <div style="padding:12px 16px;border-bottom:1px solid #F3F4F6"><span style="font-size:13px;font-weight:600;color:#0F172A">바로가기</span></div>
          <a href="/upload" class="w-full flex items-center justify-between quick-link" style="padding:10px 16px;font-size:13px;color:#374151;border-bottom:1px solid #F9FAFB;text-decoration:none">위험요소 사진 분석
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></a>
          <a href="/actions" class="w-full flex items-center justify-between quick-link" style="padding:10px 16px;font-size:13px;color:#374151;border-bottom:1px solid #F9FAFB;text-decoration:none">조치관리 전체 보기
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></a>
          <a href="/analytics" class="w-full flex items-center justify-between quick-link" style="padding:10px 16px;font-size:13px;color:#374151;border-bottom:1px solid #F9FAFB;text-decoration:none">분석 리포트
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></a>
          <a href="/actions/detail" class="w-full flex items-center justify-between quick-link" style="padding:10px 16px;font-size:13px;color:#374151;text-decoration:none">보고서
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></a>
        </div>
      </div>
    </div>
  </main>
</div>

<style>.quick-link:hover{background:#FAFAFA}</style>
<script>
(function () {
  var RISK_LABEL = { HIGH: '고위험', MEDIUM: '중위험', SAFE: '안전' };
  var RISK_COLOR = { HIGH: '#991B1B', MEDIUM: '#B45309', SAFE: '#166534' };
  var RISK_BG    = { HIGH: '#FEF2F2', MEDIUM: '#FFFBEB', SAFE: '#F0FDF4' };
  var STATUSES = ['REQUESTED', 'IN_PROGRESS', 'PENDING_APPROVAL', 'COMPLETED'];
  var STATUS_LABEL = { REQUESTED: '조치 전', IN_PROGRESS: '조치 중', PENDING_APPROVAL: '승인 대기', COMPLETED: '완료' };
  var STATUS_COLOR = { REQUESTED: '#B45309', IN_PROGRESS: '#1D4ED8', PENDING_APPROVAL: '#6D28D9', COMPLETED: '#166534' };
  var STATUS_BG    = { REQUESTED: '#FFFBEB', IN_PROGRESS: '#EFF6FF', PENDING_APPROVAL: '#F5F3FF', COMPLETED: '#F0FDF4' };

  var gradeFilter = 'ALL';
  var statusFilter = 'ALL';
  var allActions = [];

  function qs(sel) { return document.querySelector(sel); }
  function todayStr() { return new Date().toISOString().slice(0, 10); }
  function isOverdue(a) { return a.status !== 'COMPLETED' && a.dueDate && a.dueDate < todayStr(); }
  function detailLinkFor(a) { return a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id; }
  function esc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  function relativeTime(iso) {
    if (!iso) return '-';
    var diffMs = new Date() - new Date(iso);
    var mins = Math.floor(diffMs / 60000);
    if (mins < 1) return '방금 전';
    if (mins < 60) return mins + '분 전';
    var hours = Math.floor(mins / 60);
    if (hours < 24) return hours + '시간 전';
    var days = Math.floor(hours / 24);
    return days + '일 전';
  }

  function loadCurrentUser() {
    fetch('/api/users/me')
      .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
      .then(function (user) {
        qs('#headerUserName').textContent = user.username;
        qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
        qs('#bannerGreeting').textContent = user.username + '님의 대시보드';
      })
      .catch(function () {});
  }

  function loadSiteCount() {
    fetch('/api/sites').then(function (res) { return res.ok ? res.json() : []; }).then(function (sites) {
      qs('#kpiSites').textContent = sites.length;
    }).catch(function () {});
  }

  function renderFilterButtons() {
    var grades = [{ key: 'ALL', label: '전체' }, { key: 'HIGH', label: '고위험' }, { key: 'MEDIUM', label: '중위험' }, { key: 'SAFE', label: '안전' }];
    qs('#gradeFilterBtns').innerHTML = grades.map(function (g) {
      var active = gradeFilter === g.key;
      return '<button type="button" class="grade-filter-btn" data-key="' + g.key + '" style="padding:3px 10px;font-size:12px;border-radius:3px;cursor:pointer;border:1px solid ' + (active ? '#1A2E44' : '#E5E7EB') + ';background:' + (active ? '#1A2E44' : 'white') + ';color:' + (active ? 'white' : '#6B7280') + ';font-weight:' + (active ? 500 : 400) + '">' + g.label + '</button>';
    }).join('');
    var statuses = [{ key: 'ALL', label: '전체' }].concat(STATUSES.map(function (s) { return { key: s, label: STATUS_LABEL[s] }; }));
    qs('#statusFilterBtns').innerHTML = statuses.map(function (s) {
      var active = statusFilter === s.key;
      return '<button type="button" class="status-filter-btn" data-key="' + s.key + '" style="padding:3px 10px;font-size:12px;border-radius:3px;cursor:pointer;border:1px solid ' + (active ? '#1A2E44' : '#E5E7EB') + ';background:' + (active ? '#1A2E44' : 'white') + ';color:' + (active ? 'white' : '#6B7280') + ';font-weight:' + (active ? 500 : 400) + '">' + s.label + '</button>';
    }).join('');
    document.querySelectorAll('.grade-filter-btn').forEach(function (b) { b.addEventListener('click', function () { gradeFilter = b.dataset.key; renderFilterButtons(); renderIssuesTable(); }); });
    document.querySelectorAll('.status-filter-btn').forEach(function (b) { b.addEventListener('click', function () { statusFilter = b.dataset.key; renderFilterButtons(); renderIssuesTable(); }); });
  }

  function renderIssuesTable() {
    var filtered = allActions.filter(function (a) {
      return (gradeFilter === 'ALL' || a.riskLevel === gradeFilter) && (statusFilter === 'ALL' || a.status === statusFilter);
    });
    qs('#issuesTableBody').innerHTML = filtered.length ? filtered.map(function (a) {
      var overdue = isOverdue(a);
      return '<tr class="issue-row" data-id="' + a.id + '" style="border-bottom:1px solid #F9FAFB;cursor:pointer">' +
        '<td style="padding:11px 16px"><span style="display:inline-flex;align-items:center;gap:4px;padding:2px 8px;border-radius:3px;font-size:11px;font-weight:600;background:' + RISK_BG[a.riskLevel] + ';color:' + RISK_COLOR[a.riskLevel] + '">' + RISK_LABEL[a.riskLevel] + '</span></td>' +
        '<td style="padding:11px 16px;color:#374151;font-weight:500">' + esc(a.location || '-') + '</td>' +
        '<td style="padding:11px 16px;color:#0F172A;font-weight:500">' + esc(a.title) + '</td>' +
        '<td style="padding:11px 16px;color:#6B7280">' + esc(a.reporterName || '미배정') + '</td>' +
        '<td style="padding:11px 16px"><span style="display:inline-block;padding:2px 8px;border-radius:3px;font-size:11px;font-weight:500;background:' + STATUS_BG[a.status] + ';color:' + STATUS_COLOR[a.status] + '">' + STATUS_LABEL[a.status] + '</span></td>' +
        '<td style="padding:11px 16px"><span style="white-space:nowrap;color:' + (overdue ? '#991B1B' : '#6B7280') + ';font-weight:' + (overdue ? 600 : 400) + '">' + (a.dueDate || '-') +
          (overdue ? '<span style="margin-left:4px;font-size:10px;padding:1px 5px;background:#FEF2F2;color:#991B1B;border-radius:3px">초과</span>' : '') + '</span></td>' +
        '<td style="padding:11px 16px;color:#9CA3AF;font-size:12px">' + relativeTime(a.updatedAt) + '</td>' +
        '<td style="padding:11px 16px"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg></td></tr>';
    }).join('') : '<tr><td colspan="8" style="padding:48px;text-align:center;color:#9CA3AF;font-size:13px">해당 조건의 위험요소가 없습니다.</td></tr>';
    qs('#issuesFooterCount').textContent = filtered.length + '건 표시 / 전체 ' + allActions.length + '건';
    document.querySelectorAll('.issue-row').forEach(function (row) {
      row.addEventListener('click', function () {
        var a = allActions.find(function (x) { return String(x.id) === String(row.dataset.id); });
        if (a) window.location.href = detailLinkFor(a);
      });
    });
  }

  function renderKpisAndSidebar(actions) {
    allActions = actions;
    qs('#kpiPending').textContent = actions.filter(function (a) { return a.status === 'REQUESTED'; }).length;
    qs('#kpiInProgress').textContent = actions.filter(function (a) { return a.status === 'IN_PROGRESS'; }).length;
    var overdueActions = actions.filter(isOverdue);
    qs('#kpiOverdue').textContent = overdueActions.length;
    var completed = actions.filter(function (a) { return a.status === 'COMPLETED'; }).length;
    qs('#kpiCompletionRate').textContent = actions.length ? Math.round(completed * 100 / actions.length) : 0;

    if (overdueActions.length) {
      qs('#overdueAlertBox').classList.remove('hidden');
      qs('#overdueList').innerHTML = overdueActions.slice(0, 5).map(function (a) {
        return '<div class="overdue-item" data-id="' + a.id + '" style="cursor:pointer"><p style="font-size:12px;font-weight:500;color:#0F172A">' + esc(a.title) + '</p><p style="font-size:11px;color:#9CA3AF;margin-top:1px">' + esc(a.location || '-') + (a.reporterName ? ' · ' + esc(a.reporterName) : '') + '</p></div>';
      }).join('');
      document.querySelectorAll('.overdue-item').forEach(function (el) {
        el.addEventListener('click', function () {
          var a = actions.find(function (x) { return String(x.id) === String(el.dataset.id); });
          if (a) window.location.href = detailLinkFor(a);
        });
      });
    }

    renderFilterButtons();
    renderIssuesTable();
  }

  function renderCompanyStatus(companyRanking) {
    if (!companyRanking.length) {
      qs('#companyStatusList').innerHTML = '<p style="padding:16px;font-size:13px;color:#9CA3AF">아직 등록된 조치 데이터가 없습니다.</p>';
      return;
    }
    qs('#companyStatusList').innerHTML = companyRanking.slice(0, 5).map(function (c) {
      var pct = Math.round(c.completionRate);
      var good = pct >= 80;
      return '<div style="padding:10px 16px;border-bottom:1px solid #F9FAFB">' +
        '<div class="flex items-center justify-between mb-1.5"><span style="font-size:12px;font-weight:500;color:#0F172A">' + esc(c.companyName) + '</span>' +
        '<span style="font-size:12px;font-weight:600;color:' + (good ? '#166534' : '#B45309') + '">' + pct + '%</span></div>' +
        '<div style="height:4px;background:#F3F4F6;border-radius:2px;overflow:hidden"><div style="height:100%;border-radius:2px;width:' + pct + '%;background:' + (good ? '#166534' : '#B45309') + '"></div></div>' +
        '<div class="flex items-center justify-between mt-1"><span style="font-size:11px;color:#9CA3AF">전체 ' + c.total + '건</span>' +
        (c.total - c.completed > 0 ? '<span style="font-size:11px;color:#991B1B">미조치 ' + (c.total - c.completed) + '건</span>' : '') + '</div></div>';
    }).join('');
  }

  function loadAnalytics() {
    fetch('/api/analytics/summary')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (data) { renderCompanyStatus(data.companyRanking); })
      .catch(function () {});
  }

  function loadActions() {
    fetch('/api/actions/search')
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(renderKpisAndSidebar)
      .catch(function () {
        qs('#issuesTableBody').innerHTML = '<tr><td colspan="8" style="padding:32px;text-align:center;font-size:13px;color:#991B1B">위험요소 목록을 불러오지 못했습니다.</td></tr>';
      });
  }

  function loadWeather() {
    fetch('/api/weather/today')
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (w) {
        qs('#weatherTemp').textContent = (w.temperature != null ? w.temperature : '-') + '°';
        qs('#weatherCondition').textContent = w.skyCondition || '-';
        var precip = (w.precipitationType && w.precipitationType !== '없음')
          ? w.precipitationType + (w.precipitationAmount && w.precipitationAmount !== '-' ? ' · ' + w.precipitationAmount : '')
          : '강수 없음';
        qs('#weatherPrecip').textContent = precip;
      })
      .catch(function () {
        qs('#weatherBox').classList.add('hidden');
      });
  }

  loadCurrentUser();
  loadSiteCount();
  loadAnalytics();
  loadActions();
  loadWeather();
})();
</script>
</body>
</html>
