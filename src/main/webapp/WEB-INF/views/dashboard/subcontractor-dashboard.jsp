<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>하청 대시보드 - SafeMate</title>
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

    <div class="flex items-center justify-between mb-6">
      <div>
        <p style="font-size:11px;color:#9CA3AF;letter-spacing:0.06em;text-transform:uppercase;font-weight:500;margin-bottom:5px">현황 개요</p>
        <h1 id="bannerGreeting" style="font-size:22px;font-weight:600;color:#0F172A;letter-spacing:-0.02em;line-height:1">대시보드</h1>
      </div>
      <a href="/upload" style="display:flex;align-items:center;gap:6px;padding:7px 14px;background:#1A2E44;color:white;border:none;border-radius:4px;font-size:13px;font-weight:500;cursor:pointer;text-decoration:none">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
        사진 업로드
      </a>
    </div>

    <!-- KPI -->
    <div class="grid grid-cols-4 gap-4 mb-5">
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="margin-bottom:12px"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:3px">내 조치 건수</p>
        <p id="kpiMyTotal" style="font-size:22px;font-weight:700;color:#0F172A">-</p>
      </div>
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="margin-bottom:12px"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:3px">고위험 항목</p>
        <p id="kpiMyHighRisk" style="font-size:22px;font-weight:700;color:#0F172A">-</p>
      </div>
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="margin-bottom:12px"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:3px">진행 중 조치</p>
        <p id="kpiMyInProgress" style="font-size:22px;font-weight:700;color:#0F172A">-</p>
      </div>
      <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" style="margin-bottom:12px"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        <p style="font-size:11px;color:#9CA3AF;margin-bottom:3px">완료율</p>
        <p id="kpiMyCompletionRate" style="font-size:22px;font-weight:700;color:#0F172A">-</p>
      </div>
    </div>

    <div class="grid gap-5" style="grid-template-columns:1fr 300px">
      <!-- Left -->
      <div class="flex flex-col" style="gap:16px">
        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 20px">
          <div class="flex items-center justify-between mb-3">
            <h3 style="font-size:14px;font-weight:600;color:#0F172A">안전 점수</h3>
            <span id="safetyScoreValue" style="font-size:20px;font-weight:700;color:#B45309">-점</span>
          </div>
          <div style="width:100%;height:6px;background:#F3F4F6;border-radius:3px;margin-bottom:6px;overflow:hidden"><div id="safetyScoreBar" style="width:0%;height:100%;background:#B45309;border-radius:3px;transition:width .4s"></div></div>
          <div class="flex justify-between" style="font-size:11px;color:#9CA3AF">
            <span>0</span><span id="safetyScoreLabel" style="font-weight:500"></span><span>100</span>
          </div>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;overflow:hidden">
          <div class="flex items-center justify-between" style="padding:14px 20px;border-bottom:1px solid #F3F4F6">
            <h3 style="font-size:14px;font-weight:600;color:#0F172A">내 조치 목록</h3>
            <a href="/actions" style="font-size:12px;color:#1A2E44;display:flex;align-items:center;gap:4px;font-weight:500;text-decoration:none">전체 보기
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>
          </div>
          <table style="width:100%;border-collapse:collapse;font-size:13px">
            <thead><tr style="background:#F9FAFB;border-bottom:1px solid #F3F4F6">
              <th style="padding:8px 16px;width:12px"></th>
              <th style="padding:8px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em">조치 항목</th>
              <th style="padding:8px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em">마감</th>
              <th style="padding:8px 16px;text-align:left;font-size:11px;font-weight:600;color:#9CA3AF;letter-spacing:0.04em">상태</th>
            </tr></thead>
            <tbody id="myTasksBody"><tr><td colspan="4" style="padding:24px;text-align:center;color:#9CA3AF;font-size:13px">불러오는 중...</td></tr></tbody>
          </table>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 20px">
          <h3 style="font-size:14px;font-weight:600;color:#0F172A;margin-bottom:16px">주간 위험 감지 현황</h3>
          <div id="weeklyChart" style="display:flex;align-items:flex-end;gap:8px;height:100px"></div>
        </div>
      </div>

      <!-- Right -->
      <div class="flex flex-col" style="gap:14px">
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

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
          <h3 style="font-size:13px;font-weight:600;color:#0F172A;margin-bottom:12px">빠른 실행</h3>
          <div class="grid grid-cols-2 gap-2">
            <a href="/upload" class="quick-action" style="display:flex;flex-direction:column;align-items:center;gap:6px;padding:12px 8px;background:#F9FAFB;border:1px solid #E5E7EB;border-radius:4px;cursor:pointer;font-size:11px;color:#374151;font-weight:500;text-decoration:none">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1A2E44" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              사진 업로드</a>
            <a href="/upload" class="quick-action" style="display:flex;flex-direction:column;align-items:center;gap:6px;padding:12px 8px;background:#F9FAFB;border:1px solid #E5E7EB;border-radius:4px;cursor:pointer;font-size:11px;color:#374151;font-weight:500;text-decoration:none">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1A2E44" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
              위험 분석</a>
            <a href="/actions" class="quick-action" style="display:flex;flex-direction:column;align-items:center;gap:6px;padding:12px 8px;background:#F9FAFB;border:1px solid #E5E7EB;border-radius:4px;cursor:pointer;font-size:11px;color:#374151;font-weight:500;text-decoration:none">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1A2E44" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              조치 목록</a>
            <a href="/actions/detail" class="quick-action" style="display:flex;flex-direction:column;align-items:center;gap:6px;padding:12px 8px;background:#F9FAFB;border:1px solid #E5E7EB;border-radius:4px;cursor:pointer;font-size:11px;color:#374151;font-weight:500;text-decoration:none">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1A2E44" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
              보고서 확인</a>
          </div>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
          <h3 style="font-size:13px;font-weight:600;color:#0F172A;margin-bottom:10px;display:flex;align-items:center;gap:6px">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#991B1B" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>
            긴급 조치 필요
          </h3>
          <div id="myUrgentList" style="display:flex;flex-direction:column;gap:8px"><p style="font-size:12px;color:#9CA3AF">불러오는 중...</p></div>
        </div>

        <div style="background:white;border:1px solid #E5E7EB;border-radius:4px;padding:16px 18px">
          <h3 style="font-size:13px;font-weight:600;color:#0F172A;margin-bottom:12px">조치 성과</h3>
          <div style="margin-bottom:12px">
            <div class="flex justify-between" style="margin-bottom:4px"><span style="font-size:12px;color:#374151;font-weight:500">조치 완료율</span><span id="perfCompletionRate" style="font-size:12px;font-weight:700;color:#0F172A">-</span></div>
            <div style="width:100%;height:4px;background:#F3F4F6;border-radius:2px"><div id="perfCompletionBar" style="width:0%;height:100%;background:#1A2E44;border-radius:2px;transition:width .4s"></div></div>
          </div>
          <div>
            <div class="flex justify-between" style="margin-bottom:4px"><span style="font-size:12px;color:#374151;font-weight:500">기한 준수율</span><span id="perfOnTimeRate" style="font-size:12px;font-weight:700;color:#0F172A">-</span></div>
            <div style="width:100%;height:4px;background:#F3F4F6;border-radius:2px"><div id="perfOnTimeBar" style="width:0%;height:100%;background:#1A2E44;border-radius:2px;transition:width .4s"></div></div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<style>.quick-action:hover{background:#F3F4F6}</style>
<script>
(function () {
  var STATUS_LABEL = { REQUESTED: '미완료', IN_PROGRESS: '진행 중', PENDING_APPROVAL: '승인 대기', COMPLETED: '완료' };
  var STATUS_COLOR = { REQUESTED: '#991B1B', IN_PROGRESS: '#1D4ED8', PENDING_APPROVAL: '#6D28D9', COMPLETED: '#166534' };
  var STATUS_BG    = { REQUESTED: '#FEF2F2', IN_PROGRESS: '#EFF6FF', PENDING_APPROVAL: '#F5F3FF', COMPLETED: '#F0FDF4' };
  var CURRENT_USER_ID = null;
  var DAY_LABELS = ['일', '월', '화', '수', '목', '금', '토'];

  function qs(sel) { return document.querySelector(sel); }
  function esc(s) { return (s || '').toString().replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
  function detailLinkFor(a) { return a.inspectionId ? '/actions/detail?inspectionId=' + a.inspectionId : '/actions/detail?actionId=' + a.id; }

  function renderMyTasks(actions) {
    if (!actions.length) {
      qs('#myTasksBody').innerHTML = '<tr><td colspan="4" style="padding:24px;text-align:center;color:#9CA3AF;font-size:13px">배정된 조치가 없습니다.</td></tr>';
      return;
    }
    qs('#myTasksBody').innerHTML = actions.slice(0, 6).map(function (a) {
      var dot = a.status === 'COMPLETED' ? '#166534' : (a.riskLevel === 'HIGH' ? '#991B1B' : '#B45309');
      var titleStyle = a.status === 'COMPLETED' ? 'font-weight:500;color:#9CA3AF;text-decoration:line-through' : 'font-weight:500;color:#0F172A';
      return '<tr class="task-row" data-id="' + a.id + '" style="border-bottom:1px solid #F9FAFB;cursor:pointer">' +
        '<td style="padding:10px 16px"><span style="display:block;width:8px;height:8px;border-radius:50%;background:' + dot + '"></span></td>' +
        '<td style="padding:10px 16px"><span style="' + titleStyle + '">' + esc(a.title) + '</span></td>' +
        '<td style="padding:10px 16px;font-size:12px;color:#6B7280">' + (a.dueDate || '-') + '</td>' +
        '<td style="padding:10px 16px"><span style="font-size:11px;font-weight:500;padding:2px 8px;border-radius:3px;background:' + STATUS_BG[a.status] + ';color:' + STATUS_COLOR[a.status] + '">' + STATUS_LABEL[a.status] + '</span></td></tr>';
    }).join('');
    document.querySelectorAll('.task-row').forEach(function (row) {
      row.addEventListener('click', function () {
        var a = actions.find(function (x) { return String(x.id) === String(row.dataset.id); });
        if (a) window.location.href = detailLinkFor(a);
      });
    });
  }

  function renderUrgent(actions) {
    var today = new Date().toISOString().slice(0, 10);
    var urgent = actions.filter(function (a) { return a.status !== 'COMPLETED'; })
      .sort(function (a, b) { return (a.dueDate || '') < (b.dueDate || '') ? -1 : 1; }).slice(0, 4);
    qs('#myUrgentList').innerHTML = urgent.length
      ? urgent.map(function (a) {
          return '<div class="urgent-item" data-id="' + a.id + '" style="padding:10px 12px;background:#FEF2F2;border:1px solid #FECACA;border-radius:4px;cursor:pointer">' +
            '<p style="font-size:12px;font-weight:500;color:#0F172A;margin-bottom:4px">' + esc(a.title) + '</p>' +
            '<div class="flex items-center justify-between"><span style="font-size:11px;color:#991B1B">마감: ' + (a.dueDate || '-') + '</span></div></div>';
        }).join('')
      : '<p style="font-size:12px;color:#9CA3AF">긴급 조치가 없습니다.</p>';
    document.querySelectorAll('.urgent-item').forEach(function (el) {
      el.addEventListener('click', function () {
        var a = actions.find(function (x) { return String(x.id) === String(el.dataset.id); });
        if (a) window.location.href = detailLinkFor(a);
      });
    });
  }

  function renderWeeklyChart(actions) {
    var counts = [0, 0, 0, 0, 0, 0, 0];
    var start = new Date(); start.setHours(0, 0, 0, 0); start.setDate(start.getDate() - 6);
    actions.forEach(function (a) {
      if (!a.discoveredAt) return;
      var d = new Date(a.discoveredAt);
      if (d >= start) counts[d.getDay()]++;
    });
    var max = Math.max.apply(null, counts.concat([1]));
    var html = '';
    for (var i = 0; i < 7; i++) {
      var dayIdx = (start.getDay() + i) % 7;
      var pct = counts[dayIdx] * 100 / max;
      html += '<div style="flex:1;display:flex;flex-direction:column;align-items:center;gap:4px">' +
        '<span style="font-size:10px;color:#9CA3AF">' + counts[dayIdx] + '</span>' +
        '<div style="width:100%;height:72px;display:flex;align-items:flex-end"><div style="width:100%;height:' + pct + '%;min-height:3px;background:#1A2E44;border-radius:2px 2px 0 0"></div></div>' +
        '<span style="font-size:10px;color:#9CA3AF">' + DAY_LABELS[dayIdx] + '</span></div>';
    }
    qs('#weeklyChart').innerHTML = html;
  }

  function renderKpiAndPerformance(actions) {
    var total = actions.length;
    var high = actions.filter(function (a) { return a.riskLevel === 'HIGH'; }).length;
    var inProgress = actions.filter(function (a) { return a.status === 'IN_PROGRESS'; }).length;
    var completed = actions.filter(function (a) { return a.status === 'COMPLETED'; });
    var completionRate = total === 0 ? 0 : Math.round(completed.length * 100 / total);
    var onTime = completed.filter(function (a) { return a.updatedAt && a.dueDate && a.updatedAt.slice(0, 10) <= a.dueDate; }).length;
    var onTimeRate = completed.length === 0 ? 0 : Math.round(onTime * 100 / completed.length);
    var good = completionRate >= 80;

    qs('#kpiMyTotal').textContent = total;
    qs('#kpiMyHighRisk').textContent = high;
    qs('#kpiMyInProgress').textContent = inProgress;
    qs('#kpiMyCompletionRate').textContent = completionRate + '%';
    qs('#perfCompletionRate').textContent = completionRate + '%';
    qs('#perfCompletionBar').style.width = completionRate + '%';
    qs('#perfOnTimeRate').textContent = completed.length ? onTimeRate + '%' : '완료 이력 없음';
    qs('#perfOnTimeBar').style.width = onTimeRate + '%';

    qs('#safetyScoreValue').textContent = completionRate + '점';
    qs('#safetyScoreValue').style.color = good ? '#166534' : '#B45309';
    qs('#safetyScoreBar').style.width = completionRate + '%';
    qs('#safetyScoreBar').style.background = good ? '#166534' : '#B45309';
    var scoreLabel = completionRate >= 90 ? '최우수' : completionRate >= 80 ? '우수' : completionRate >= 70 ? '양호' : '개선 필요';
    var labelEl = qs('#safetyScoreLabel');
    labelEl.textContent = scoreLabel + ' (' + completionRate + '/100)';
    labelEl.style.color = good ? '#166534' : '#B45309';
  }

  function loadMyActions() {
    fetch('/api/actions/search')
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
        if (!res.ok) throw new Error();
        return res.json();
      })
      .then(function (all) {
        var mine = all.filter(function (a) { return a.reporterId === CURRENT_USER_ID; });
        renderKpiAndPerformance(mine);
        renderMyTasks(mine);
        renderUrgent(mine);
        renderWeeklyChart(mine);
      })
      .catch(function () {
        qs('#myTasksBody').innerHTML = '<tr><td colspan="4" style="padding:24px;text-align:center;color:#991B1B;font-size:13px">조치 목록을 불러오지 못했습니다.</td></tr>';
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

  fetch('/api/users/me')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (user) {
      CURRENT_USER_ID = user.id;
      qs('#headerUserName').textContent = user.username;
      qs('#headerUserInitial').textContent = user.username ? user.username.charAt(0) : '?';
      qs('#bannerGreeting').textContent = user.username + '님의 대시보드';
      loadMyActions();
      loadWeather();
    })
    .catch(function () {});
})();
</script>
</body>
</html>
