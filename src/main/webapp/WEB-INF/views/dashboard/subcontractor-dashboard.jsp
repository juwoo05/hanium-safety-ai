<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>하청 대시보드 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-green-600 rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">이</span></div><span class="text-sm font-medium text-gray-700 hidden sm:block">이작업자</span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-6">
      <!-- Welcome Banner -->
      <div class="bg-gradient-to-r from-green-700 to-green-600 rounded-2xl p-8 text-white">
        <div class="flex items-center justify-between">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-1"><span class="bg-white text-green-700 text-xs font-bold px-3 py-1 rounded-full">하청</span><span class="text-white/70 text-sm">(주)한국건설</span></div>
            <h1 class="text-3xl font-bold mb-2">안녕하세요, 이작업자님! 👷</h1>
            <p class="text-white/80 text-lg">오늘 내 현장 안전 업무를 확인하세요</p>
            <div class="flex items-center gap-6 mt-4">
              <div class="flex items-center gap-2"><svg class="w-4 h-4 text-yellow-300" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg><span class="text-sm font-semibold">안전 점수: 87점</span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-400 rounded-full"></div><span class="text-sm">오늘 마감: 2건</span></div>
            </div>
          </div>
          <div class="hidden lg:block"><img src="/images/mascot.png" alt="마스코트" class="w-24 h-24 object-contain" style="mix-blend-mode:multiply"/></div>
        </div>
      </div>

      <!-- Safety Score -->
      <div class="bg-white rounded-2xl p-6 shadow-md">
        <div class="flex items-center justify-between mb-3">
          <div class="flex items-center gap-2"><svg class="w-5 h-5 text-yellow-500" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg><h3 class="text-base font-semibold text-gray-900">나의 안전 점수</h3></div>
          <span class="text-3xl font-bold text-green-600">87점</span>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-gradient-to-r from-green-500 to-green-400 h-3 rounded-full" style="width:87%"></div></div>
        <div class="flex justify-between text-xs text-gray-500 mt-1"><span>0점</span><span class="text-green-600 font-medium">우수 (87/100)</span><span>100점</span></div>
      </div>

      <!-- KPI -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-blue-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><span class="text-sm font-semibold text-green-600">↑ +8</span></div>
          <p class="text-gray-500 text-xs mb-1">내 리포트 수</p><p class="text-3xl font-bold text-gray-900">45</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-red-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div><span class="text-sm font-semibold text-red-500">↓ -2</span></div>
          <p class="text-gray-500 text-xs mb-1">고위험 항목</p><p class="text-3xl font-bold text-gray-900">3</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-orange-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><span class="text-sm font-semibold text-green-600">↑ +3</span></div>
          <p class="text-gray-500 text-xs mb-1">진행 중 조치</p><p class="text-3xl font-bold text-gray-900">11</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-green-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div><span class="text-sm font-semibold text-green-600">↑ +5%</span></div>
          <p class="text-gray-500 text-xs mb-1">완료율</p><p class="text-3xl font-bold text-gray-900">87%</p>
        </div>
      </div>

      <!-- Mascot Tip -->
      <div class="bg-gradient-to-r from-green-500/10 to-green-500/5 rounded-2xl p-5 border-2 border-green-500/20 flex items-start gap-4">
        <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
        <div>
          <h3 class="text-base font-semibold text-green-800 mb-1">💡 오늘의 안전 팁</h3>
          <p class="text-sm text-gray-700">오늘 마감인 고위험 조치 2건이 있습니다. 5층 외벽 안전망 점검을 먼저 완료해주세요!</p>
          <a href="/actions" class="inline-block mt-2 text-sm bg-green-600 text-white px-4 py-1.5 rounded-lg hover:bg-green-700 transition-colors font-medium">내 조치 목록 보기</a>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">
          <!-- Quick Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">빠른 실행</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-blue-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></div><span class="text-xs font-medium text-gray-700">사진 업로드</span></a>
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-[#FF6B35] w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></div><span class="text-xs font-medium text-gray-700">위험 분석</span></a>
              <a href="/actions/new" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-green-600 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg></div><span class="text-xs font-medium text-gray-700">조치 등록</span></a>
              <a href="/actions/detail" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-purple-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div><span class="text-xs font-medium text-gray-700">리포트 보기</span></a>
            </div>
          </div>

          <!-- My Tasks -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                내 조치 목록
              </h3>
              <a href="/actions" class="text-green-600 hover:text-green-700 text-sm font-medium flex items-center gap-1">전체 보기 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>
            </div>
            <div class="space-y-3">
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-red-200 bg-red-50 hover:border-red-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">5층 외벽 안전망 점검</p><p class="text-xs text-gray-500">마감: 오늘 18:00</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-gray-100 text-gray-600">미완료</span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-red-200 bg-red-50 hover:border-red-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">작업자 안전장비 확인</p><p class="text-xs text-gray-500">마감: 오늘 15:00</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-blue-100 text-blue-700">진행 중</span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-gray-200 bg-gray-50 hover:border-gray-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-orange-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">전기 배선 임시 조치</p><p class="text-xs text-gray-500">마감: 내일</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-gray-100 text-gray-600">미완료</span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-green-200 bg-green-50 hover:border-green-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-green-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-400 line-through">소화기 위치 재배치</p><p class="text-xs text-gray-500">마감: 이번 주</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-700">완료</span>
              </a>
            </div>
          </div>

          <!-- Weekly Chart -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">주간 위험 감지 현황</h3>
            <div class="flex items-end justify-between gap-2 h-40 px-2">
              <% int[] subData={5,9,7,12,10,3,2}; String[] subDays={"월","화","수","목","금","토","일"}; int subMax=12; %>
              <% for(int i=0;i<7;i++){ int pct=(subData[i]*100/subMax); %>
              <div class="flex-1 flex flex-col items-center gap-1 group">
                <span class="text-xs font-semibold text-gray-500 opacity-0 group-hover:opacity-100 transition-opacity"><%=subData[i]%></span>
                <div class="w-full relative flex items-end" style="height:120px">
                  <div class="w-full bg-green-600 rounded-t-lg hover:bg-green-500 transition-all" style="height:<%=pct%>%;min-height:4px"></div>
                </div>
                <span class="text-xs text-gray-500 font-medium"><%=subDays[i]%></span>
              </div>
              <% } %>
            </div>
            <div class="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100"><div class="w-3 h-3 rounded-sm bg-green-600"></div><span class="text-xs text-gray-500">위험 감지 건수</span></div>
          </div>
        </div>

        <div class="space-y-6">
          <!-- Weather -->
          <div class="bg-gradient-to-br from-sky-500 to-blue-600 rounded-2xl p-5 text-white shadow-md">
            <div class="flex items-center justify-between">
              <div><p class="text-sky-200 text-xs font-medium mb-1">서울 강남구</p><div class="flex items-end gap-2"><span class="text-4xl font-bold">28°</span><span class="text-sky-200 text-sm mb-1">맑음</span></div></div>
              <svg class="w-14 h-14 text-yellow-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/></svg>
            </div>
            <div class="flex gap-4 mt-3 text-xs text-sky-200"><span>💧 62%</span><span>🌬 3.2m/s</span><span>🌡 체감 31°</span></div>
            <div class="mt-3 px-3 py-2 rounded-lg border border-yellow-200 bg-yellow-50 text-xs font-medium text-yellow-800">야외 작업 적합 — 자외선 지수 높음, 차광 필요</div>
          </div>

          <!-- Urgent -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2"><svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>긴급 조치 필요</h3>
            <div class="space-y-3">
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-200 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">5층 외벽 안전망 점검</p>
                <div class="flex justify-between items-center"><span class="text-xs text-red-600">마감: 오늘 18:00</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-200 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">작업자 안전장비 확인</p>
                <div class="flex justify-between items-center"><span class="text-xs text-red-600">마감: 오늘 15:00</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
            </div>
          </div>

          <!-- Performance -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">이번 달 성과</h3>
            <div class="mb-4"><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">리포트 제출</span><span class="font-bold text-gray-900">45/50</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-blue-500 h-2 rounded-full" style="width:90%"></div></div></div>
            <div class="mb-4"><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">조치 완료율</span><span class="font-bold text-gray-900">87%</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-green-500 h-2 rounded-full" style="width:87%"></div></div></div>
            <div><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">제때 완료</span><span class="font-bold text-gray-900">92%</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-orange-500 h-2 rounded-full" style="width:92%"></div></div></div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>