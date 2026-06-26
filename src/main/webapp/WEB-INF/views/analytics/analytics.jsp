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
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <select class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] outline-none">
        <option>이번 달</option><option>지난 달</option><option>최근 3개월</option><option>올해</option>
      </select>
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-6">
      <div><h1 class="text-2xl font-bold text-gray-900">통계 분석</h1><p class="text-sm text-gray-500 mt-1">현장 안전 데이터를 한눈에 파악하세요</p></div>

      <!-- KPI Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-blue-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><span class="text-sm text-green-600 font-semibold">↑ 12%</span></div><p class="text-3xl font-bold text-gray-900">1,284</p><p class="text-xs text-gray-500 mt-1">총 업로드 수</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-red-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg></div><span class="text-sm text-red-500 font-semibold">↑ 3%</span></div><p class="text-3xl font-bold text-gray-900">342</p><p class="text-xs text-gray-500 mt-1">위험 감지 건수</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-green-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div><span class="text-sm text-green-600 font-semibold">↑ 5%</span></div><p class="text-3xl font-bold text-gray-900">87%</p><p class="text-xs text-gray-500 mt-1">조치 완료율</p></div>
        <div class="bg-white rounded-2xl p-5 shadow-md"><div class="flex items-center justify-between mb-3"><div class="w-10 h-10 bg-purple-500 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><span class="text-sm text-green-600 font-semibold">↓ 8%</span></div><p class="text-3xl font-bold text-gray-900">2.3일</p><p class="text-xs text-gray-500 mt-1">평균 조치 기간</p></div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Monthly Trend -->
        <div class="lg:col-span-2 bg-white rounded-2xl p-6 shadow-md">
          <div class="flex items-center justify-between mb-5">
            <h3 class="text-base font-semibold text-gray-900">월별 위험 감지 추이</h3>
            <div class="flex items-center gap-4 text-xs text-gray-500">
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#FF6B35] inline-block"></span>고위험</span>
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-orange-400 inline-block"></span>중위험</span>
              <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-yellow-400 inline-block"></span>저위험</span>
            </div>
          </div>
          <%
            int[] highRisk  = {8,12,10,15,11,9,13,16,14,12,10,11};
            int[] midRisk   = {14,18,16,20,17,15,19,22,20,18,16,18};
            int[] lowRisk   = {10,12,11,14,13,12,14,15,13,12,11,13};
            String[] months = {"1","2","3","4","5","6","7","8","9","10","11","12"};
            int max = 22;
          %>
          <div class="flex items-end gap-1.5 h-48 px-2">
            <% for(int i=0;i<12;i++){
              int hp = highRisk[i]*100/max;
              int mp = midRisk[i]*100/max;
              int lp = lowRisk[i]*100/max;
            %>
            <div class="flex-1 flex flex-col gap-0.5 items-center group">
              <div class="w-full flex flex-col gap-0.5 items-stretch" style="height:180px;justify-content:flex-end">
                <div class="w-full bg-[#FF6B35] rounded-t" style="height:<%=hp%>%;min-height:2px" title="고위험 <%=highRisk[i]%>건"></div>
                <div class="w-full bg-orange-400" style="height:<%=mp%>%;min-height:2px"></div>
                <div class="w-full bg-yellow-400 rounded-b" style="height:<%=lp%>%;min-height:2px"></div>
              </div>
              <span class="text-xs text-gray-400 mt-1"><%=months[i]%></span>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Risk Pie -->
        <div class="bg-white rounded-2xl p-6 shadow-md flex flex-col">
          <h3 class="text-base font-semibold text-gray-900 mb-5">위험도 분포</h3>
          <div class="flex-1 flex flex-col items-center justify-center">
            <svg viewBox="0 0 120 120" class="w-40 h-40 -rotate-90">
              <circle cx="60" cy="60" r="50" fill="none" stroke="#fee2e2" stroke-width="20"/>
              <circle cx="60" cy="60" r="50" fill="none" stroke="#FF6B35" stroke-width="20" stroke-dasharray="94.2 219.8" stroke-linecap="round"/>
              <circle cx="60" cy="60" r="50" fill="none" stroke="#fb923c" stroke-width="20" stroke-dasharray="69.1 244.9" stroke-dashoffset="-94.2"/>
              <circle cx="60" cy="60" r="50" fill="none" stroke="#fbbf24" stroke-width="20" stroke-dasharray="150.7 163.3" stroke-dashoffset="-163.3"/>
            </svg>
            <div class="mt-5 space-y-2 w-full">
              <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-2"><span class="w-3 h-3 rounded-full bg-[#FF6B35] inline-block"></span>고위험</span><span class="font-bold text-gray-900">30% (103건)</span></div>
              <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-2"><span class="w-3 h-3 rounded-full bg-orange-400 inline-block"></span>중위험</span><span class="font-bold text-gray-900">22% (75건)</span></div>
              <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-2"><span class="w-3 h-3 rounded-full bg-yellow-400 inline-block"></span>저위험</span><span class="font-bold text-gray-900">48% (164건)</span></div>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Category -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h3 class="text-base font-semibold text-gray-900 mb-5">위험 유형별 분류</h3>
          <div class="space-y-4">
            <% String[] cats={"추락 위험","전기 위험","화재 위험","안전장비 미착용","구조물 불안정"}; int[] catVals={45,28,18,35,22}; String[] catColors={"bg-red-500","bg-orange-500","bg-yellow-500","bg-blue-500","bg-purple-500"}; int catMax=45; %>
            <% for(int i=0;i<cats.length;i++){ int pct=catVals[i]*100/catMax; %>
            <div>
              <div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium"><%=cats[i]%></span><span class="font-bold text-gray-900"><%=catVals[i]%>건</span></div>
              <div class="w-full bg-gray-100 rounded-full h-2.5"><div class="<%=catColors[i]%> h-2.5 rounded-full" style="width:<%=pct%>%"></div></div>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Company Ranking -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h3 class="text-base font-semibold text-gray-900 mb-5">업체별 조치 완료율</h3>
          <div class="space-y-3">
            <% String[] companies={"(주)한국건설","대성철골(주)","미래전기설비","안전파트너스","현대설비(주)"}; int[] completion={92,87,78,95,71}; String[] grades={"A","B+","B-","A+","C+"}; %>
            <% for(int i=0;i<companies.length;i++){ String color=completion[i]>=90?"text-green-600":completion[i]>=80?"text-blue-600":"text-orange-600"; %>
            <div class="flex items-center gap-3 p-3 border border-gray-100 rounded-xl hover:border-gray-200 transition-colors">
              <span class="w-6 h-6 bg-gray-100 rounded-full flex items-center justify-center text-xs font-bold text-gray-600"><%=i+1%></span>
              <div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate"><%=companies[i]%></p><div class="flex items-center gap-2 mt-0.5"><div class="flex-1 bg-gray-100 rounded-full h-1.5"><div class="bg-green-500 h-1.5 rounded-full" style="width:<%=completion[i]%>%"></div></div></div></div>
              <div class="text-right flex-shrink-0"><p class="text-sm font-bold <%=color%>"><%=completion[i]%>%</p><p class="text-xs text-gray-400"><%=grades[i]%></p></div>
            </div>
            <% } %>
          </div>
        </div>
      </div>

      <!-- AI Insight -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-6 text-white">
        <div class="flex items-start gap-4">
          <img src="/images/mascot.png" alt="마스코트" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
          <div>
            <h3 class="text-base font-bold mb-2">AI 인사이트 — 이번 달 핵심 포인트</h3>
            <ul class="space-y-1.5 text-white/80 text-sm">
              <li class="flex items-start gap-2"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>추락 위험 감지 건수가 전월 대비 15% 증가했습니다. 3동 옥상 작업 시 특별 주의가 필요합니다.</li>
              <li class="flex items-start gap-2"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>안전파트너스(95%)와 (주)한국건설(92%)이 조치 완료율 상위권입니다. 우수 사례를 공유하세요.</li>
              <li class="flex items-start gap-2"><span class="text-[#FF6B35] mt-0.5 flex-shrink-0">•</span>평균 조치 기간이 2.3일로 단축되었습니다. 지난 달 대비 8% 개선되었습니다.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>