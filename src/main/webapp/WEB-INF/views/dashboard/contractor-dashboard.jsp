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
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div>
        <span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span>
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
              <span class="text-white/60 text-sm">삼성건설(주)</span>
            </div>
            <h1 class="text-3xl font-bold mb-2">안녕하세요, 김현장님! 👋</h1>
            <p class="text-white/80 text-lg">전체 현장 안전 현황 — 협력사 12개사 관리 중</p>
            <div class="flex items-center gap-6 mt-4">
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-green-400 rounded-full"></div><span class="text-sm">전체 현장: 5개</span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-400 rounded-full"></div><span class="text-sm">긴급 조치: 7건</span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-blue-400 rounded-full"></div><span class="text-sm">협력사: 12개</span></div>
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
            <span class="text-sm font-semibold text-green-600">↑ +23</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">전체 리포트 수</p>
          <p class="text-3xl font-bold text-gray-900">247</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-red-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
            <span class="text-sm font-semibold text-red-500">↓ -5</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">고위험 항목</p>
          <p class="text-3xl font-bold text-gray-900">18</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-orange-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
            <span class="text-sm font-semibold text-green-600">↑ +8</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">조치 진행 중</p>
          <p class="text-3xl font-bold text-gray-900">42</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-purple-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg></div>
            <span class="text-sm font-semibold text-green-600">↑ +2</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">협력사 수</p>
          <p class="text-3xl font-bold text-gray-900">12</p>
        </div>
      </div>

      <!-- Mascot Tip -->
      <div class="bg-gradient-to-r from-[#FF6B35]/10 to-[#FF6B35]/5 rounded-2xl p-5 border-2 border-[#FF6B35]/20 flex items-start gap-4">
        <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
        <div>
          <h3 class="text-base font-semibold text-[#1B3A5F] mb-1">💡 원청 안전 현황 요약</h3>
          <p class="text-sm text-gray-700">대성철골(주)의 고위험 항목이 7건으로 가장 많습니다. 오늘 마감 긴급 조치 2건을 우선 확인해주세요.</p>
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

          <!-- Weekly Chart -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">주간 위험 발생 현황</h3>
              <div class="flex items-center gap-3 text-xs text-gray-500">
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#1B3A5F] inline-block"></span>원청</span>
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#FF6B35] inline-block"></span>하청</span>
              </div>
            </div>
            <div class="flex items-end justify-between gap-1" style="height:160px">
              <% int[][] weekData = {{8,12},{12,19},{9,15},{15,25},{11,22},{5,8},{3,5}}; String[] days={"월","화","수","목","금","토","일"}; int max=25; %>
              <% for(int i=0;i<7;i++){ int p1=(weekData[i][0]*100/max); int p2=(weekData[i][1]*100/max); %>
              <div class="flex-1 flex flex-col items-center gap-1">
                <div class="w-full flex items-end justify-center gap-0.5" style="height:120px">
                  <div class="flex-1 bg-[#1B3A5F] rounded-t hover:opacity-80 transition-opacity" style="height:<%=p1%>%;min-height:3px"></div>
                  <div class="flex-1 bg-[#FF6B35] rounded-t hover:opacity-80 transition-opacity" style="height:<%=p2%>%;min-height:3px"></div>
                </div>
                <span class="text-xs text-gray-500"><%=days[i]%></span>
              </div>
              <% } %>
            </div>
          </div>

          <!-- Subcontractor Status -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-5 h-5 text-[#1B3A5F]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              협력사 안전 현황
            </h3>
            <div class="space-y-3">
              <div class="p-4 rounded-xl border-2 border-gray-100 bg-gray-50">
                <div class="flex items-center justify-between mb-2">
                  <span class="font-semibold text-gray-900 text-sm">(주)한국건설</span>
                  <span class="text-sm font-bold text-green-600">87%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>리포트 45건</span><span class="text-red-500 font-medium">고위험 3건</span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-green-500" style="width:87%"></div></div>
              </div>
              <div class="p-4 rounded-xl border-2 border-orange-200 bg-orange-50">
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center gap-2"><span class="font-semibold text-gray-900 text-sm">대성철골(주)</span><span class="text-xs bg-orange-100 text-orange-700 px-2 py-0.5 rounded-full">주의</span></div>
                  <span class="text-sm font-bold text-orange-500">62%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>리포트 38건</span><span class="text-red-500 font-medium">고위험 7건</span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-orange-500" style="width:62%"></div></div>
              </div>
              <div class="p-4 rounded-xl border-2 border-gray-100 bg-gray-50">
                <div class="flex items-center justify-between mb-2">
                  <span class="font-semibold text-gray-900 text-sm">미래전기설비</span>
                  <span class="text-sm font-bold text-green-600">95%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>리포트 29건</span><span class="text-red-500 font-medium">고위험 1건</span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-green-500" style="width:95%"></div></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Sidebar -->
        <div class="space-y-6">
          <!-- Risk Distribution -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">위험 등급 분포</h3>
            <div class="flex items-center gap-4">
              <svg width="120" height="120" viewBox="0 0 120 120" class="flex-shrink-0">
                <circle cx="60" cy="60" r="40" fill="none" stroke="#ef4444" stroke-width="20" stroke-dasharray="15.27 235.6" stroke-dashoffset="0" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#f97316" stroke-width="20" stroke-dasharray="28.84 235.6" stroke-dashoffset="-15.27" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#eab308" stroke-width="20" stroke-dasharray="44.12 235.6" stroke-dashoffset="-44.11" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#22c55e" stroke-width="20" stroke-dasharray="121.37 235.6" stroke-dashoffset="-88.23" transform="rotate(-90 60 60)"/>
                <text x="60" y="54" text-anchor="middle" fill="#374151" font-size="11" font-weight="600">247</text>
                <text x="60" y="68" text-anchor="middle" fill="#9CA3AF" font-size="9">전체</text>
              </svg>
              <div class="flex-1 space-y-2">
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-red-500"></span><span class="text-xs">고위험</span></span><span class="font-semibold text-xs">18건</span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-orange-500"></span><span class="text-xs">중위험</span></span><span class="font-semibold text-xs">34건</span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-yellow-500"></span><span class="text-xs">저위험</span></span><span class="font-semibold text-xs">52건</span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-green-500"></span><span class="text-xs">정상</span></span><span class="font-semibold text-xs">143건</span></div>
              </div>
            </div>
          </div>

          <!-- Urgent Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
              긴급 조치 필요
            </h3>
            <div class="space-y-3">
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">안전 난간 미설치</p>
                <p class="text-xs text-gray-600">3동 옥상 · (주)한국건설</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">마감: 오늘</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">임시 배선 노출</p>
                <p class="text-xs text-gray-600">지하 1층 · 대성철골(주)</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">마감: 오늘</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">소화기 점검 필요</p>
                <p class="text-xs text-gray-600">4동 1층 · 미래전기설비</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">마감: 내일</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
            </div>
            <a href="/actions" class="block w-full mt-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium text-center">전체 긴급 조치</a>
          </div>

          <!-- Weather -->
          <div class="bg-gradient-to-br from-sky-500 to-blue-600 rounded-2xl p-5 text-white shadow-md">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sky-200 text-xs font-medium mb-1">서울 강남구</p>
                <div class="flex items-end gap-2"><span class="text-4xl font-bold">28°</span><span class="text-sky-200 text-sm mb-1">맑음</span></div>
              </div>
              <svg class="w-14 h-14 text-yellow-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/></svg>
            </div>
            <div class="flex gap-4 mt-3 text-xs text-sky-200">
              <span>💧 62%</span><span>🌬 3.2m/s</span><span>🌡 체감 31°</span>
            </div>
            <div class="mt-3 px-3 py-2 rounded-lg border border-yellow-200 bg-yellow-50 text-xs font-medium text-yellow-800 flex items-center gap-2">
              <svg class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>
              야외 작업 적합 — 자외선 지수 높음, 차광 필요
            </div>
          </div>

          <!-- Today Alerts -->
          <div class="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-2xl p-5 border-2 border-yellow-200">
            <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <svg class="w-4 h-4 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              오늘의 안전 알림
            </h3>
            <ul class="space-y-2 text-sm text-gray-700">
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">•</span><span>3동 외벽 작업 시 안전난간 필수</span></li>
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">•</span><span>지하주차장 환기 작업 14:00~17:00</span></li>
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">•</span><span>내일 오전 협력사 안전 교육 예정</span></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>