<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>?섏껌 ??쒕낫??- SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="寃??.." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-green-600 rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">??/span></div><span class="text-sm font-medium text-gray-700 hidden sm:block">?댁옉?낆옄</span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-6">
      <!-- Welcome Banner -->
      <div class="bg-gradient-to-r from-green-700 to-green-600 rounded-2xl p-8 text-white">
        <div class="flex items-center justify-between">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-1"><span class="bg-white text-green-700 text-xs font-bold px-3 py-1 rounded-full">?섏껌</span><span class="text-white/70 text-sm">(二??쒓뎅嫄댁꽕</span></div>
            <h1 class="text-3xl font-bold mb-2">?덈뀞?섏꽭?? ?댁옉?낆옄?? ?뫕</h1>
            <p class="text-white/80 text-lg">?ㅻ뒛 ???꾩옣 ?덉쟾 ?낅Т瑜??뺤씤?섏꽭??/p>
            <div class="flex items-center gap-6 mt-4">
              <div class="flex items-center gap-2"><svg class="w-4 h-4 text-yellow-300" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg><span class="text-sm font-semibold">?덉쟾 ?먯닔: 87??/span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-400 rounded-full"></div><span class="text-sm">?ㅻ뒛 留덇컧: 2嫄?/span></div>
            </div>
          </div>
          <div class="hidden lg:block"><img src="/images/mascot.png" alt="留덉뒪肄뷀듃" class="w-24 h-24 object-contain" style="mix-blend-mode:multiply"/></div>
        </div>
      </div>

      <!-- Safety Score -->
      <div class="bg-white rounded-2xl p-6 shadow-md">
        <div class="flex items-center justify-between mb-3">
          <div class="flex items-center gap-2"><svg class="w-5 h-5 text-yellow-500" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg><h3 class="text-base font-semibold text-gray-900">?섏쓽 ?덉쟾 ?먯닔</h3></div>
          <span class="text-3xl font-bold text-green-600">87??/span>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-gradient-to-r from-green-500 to-green-400 h-3 rounded-full" style="width:87%"></div></div>
        <div class="flex justify-between text-xs text-gray-500 mt-1"><span>0??/span><span class="text-green-600 font-medium">?곗닔 (87/100)</span><span>100??/span></div>
      </div>

      <!-- KPI -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-blue-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div><span class="text-sm font-semibold text-green-600">??+8</span></div>
          <p class="text-gray-500 text-xs mb-1">??由ы룷????/p><p class="text-3xl font-bold text-gray-900">45</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-red-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div><span class="text-sm font-semibold text-red-500">??-2</span></div>
          <p class="text-gray-500 text-xs mb-1">怨좎쐞????ぉ</p><p class="text-3xl font-bold text-gray-900">3</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-orange-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><span class="text-sm font-semibold text-green-600">??+3</span></div>
          <p class="text-gray-500 text-xs mb-1">吏꾪뻾 以?議곗튂</p><p class="text-3xl font-bold text-gray-900">11</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg border-2 border-transparent hover:border-green-500 cursor-pointer">
          <div class="flex items-start justify-between mb-3"><div class="bg-green-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div><span class="text-sm font-semibold text-green-600">??+5%</span></div>
          <p class="text-gray-500 text-xs mb-1">?꾨즺??/p><p class="text-3xl font-bold text-gray-900">87%</p>
        </div>
      </div>

      <!-- Mascot Tip -->
      <div class="bg-gradient-to-r from-green-500/10 to-green-500/5 rounded-2xl p-5 border-2 border-green-500/20 flex items-start gap-4">
        <img src="/images/mascot.png" alt="留덉뒪肄뷀듃" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
        <div>
          <h3 class="text-base font-semibold text-green-800 mb-1">?뮕 ?ㅻ뒛???덉쟾 ??/h3>
          <p class="text-sm text-gray-700">?ㅻ뒛 留덇컧??怨좎쐞??議곗튂 2嫄댁씠 ?덉뒿?덈떎. 5痢??몃꼍 ?덉쟾留??먭???癒쇱? ?꾨즺?댁＜?몄슂!</p>
          <a href="/actions" class="inline-block mt-2 text-sm bg-green-600 text-white px-4 py-1.5 rounded-lg hover:bg-green-700 transition-colors font-medium">??議곗튂 紐⑸줉 蹂닿린</a>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">
          <!-- Quick Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">鍮좊Ⅸ ?ㅽ뻾</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-blue-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></div><span class="text-xs font-medium text-gray-700">?ъ쭊 ?낅줈??/span></a>
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-[#FF6B35] w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></div><span class="text-xs font-medium text-gray-700">?꾪뿕 遺꾩꽍</span></a>
              <a href="/actions/new" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-green-600 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg></div><span class="text-xs font-medium text-gray-700">議곗튂 ?깅줉</span></a>
              <a href="/actions/detail" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group"><div class="bg-purple-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div><span class="text-xs font-medium text-gray-700">由ы룷??蹂닿린</span></a>
            </div>
          </div>

          <!-- My Tasks -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                ??議곗튂 紐⑸줉
              </h3>
              <a href="/actions" class="text-green-600 hover:text-green-700 text-sm font-medium flex items-center gap-1">?꾩껜 蹂닿린 <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>
            </div>
            <div class="space-y-3">
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-red-200 bg-red-50 hover:border-red-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">5痢??몃꼍 ?덉쟾留??먭?</p><p class="text-xs text-gray-500">留덇컧: ?ㅻ뒛 18:00</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-gray-100 text-gray-600">誘몄셿猷?/span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-red-200 bg-red-50 hover:border-red-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">?묒뾽???덉쟾?λ퉬 ?뺤씤</p><p class="text-xs text-gray-500">留덇컧: ?ㅻ뒛 15:00</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-blue-100 text-blue-700">吏꾪뻾 以?/span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-gray-200 bg-gray-50 hover:border-gray-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-orange-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">?꾧린 諛곗꽑 ?꾩떆 議곗튂</p><p class="text-xs text-gray-500">留덇컧: ?댁씪</p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-gray-100 text-gray-600">誘몄셿猷?/span>
              </a>
              <a href="/actions/detail" class="flex items-center gap-3 p-4 rounded-xl border-2 border-green-200 bg-green-50 hover:border-green-300 transition-colors">
                <div class="w-3 h-3 rounded-full bg-green-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-400 line-through">?뚰솕湲??꾩튂 ?щ같移?/p><p class="text-xs text-gray-500">留덇컧: ?대쾲 二?/p></div>
                <span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-700">?꾨즺</span>
              </a>
            </div>
          </div>

          <!-- Weekly Chart -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">二쇨컙 ?꾪뿕 媛먯? ?꾪솴</h3>
            <div class="flex items-end justify-between gap-2 h-40 px-2">
              <% int[] subData={5,9,7,12,10,3,2}; String[] subDays={"??,"??,"??,"紐?,"湲?,"??,"??}; int subMax=12; %>
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
            <div class="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100"><div class="w-3 h-3 rounded-sm bg-green-600"></div><span class="text-xs text-gray-500">?꾪뿕 媛먯? 嫄댁닔</span></div>
          </div>
        </div>

        <div class="space-y-6">
          <!-- Weather -->
          <div class="bg-gradient-to-br from-sky-500 to-blue-600 rounded-2xl p-5 text-white shadow-md">
            <div class="flex items-center justify-between">
              <div><p class="text-sky-200 text-xs font-medium mb-1">?쒖슱 媛뺣궓援?/p><div class="flex items-end gap-2"><span class="text-4xl font-bold">28째</span><span class="text-sky-200 text-sm mb-1">留묒쓬</span></div></div>
              <svg class="w-14 h-14 text-yellow-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/></svg>
            </div>
            <div class="flex gap-4 mt-3 text-xs text-sky-200"><span>?뮛 62%</span><span>?뙩 3.2m/s</span><span>?뙜 泥닿컧 31째</span></div>
            <div class="mt-3 px-3 py-2 rounded-lg border border-yellow-200 bg-yellow-50 text-xs font-medium text-yellow-800">?쇱쇅 ?묒뾽 ?곹빀 ???먯쇅??吏???믪쓬, 李④킅 ?꾩슂</div>
          </div>

          <!-- Urgent -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2"><svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>湲닿툒 議곗튂 ?꾩슂</h3>
            <div class="space-y-3">
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-200 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">5痢??몃꼍 ?덉쟾留??먭?</p>
                <div class="flex justify-between items-center"><span class="text-xs text-red-600">留덇컧: ?ㅻ뒛 18:00</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-200 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">?묒뾽???덉쟾?λ퉬 ?뺤씤</p>
                <div class="flex justify-between items-center"><span class="text-xs text-red-600">留덇컧: ?ㅻ뒛 15:00</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
            </div>
          </div>

          <!-- Performance -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">?대쾲 ???깃낵</h3>
            <div class="mb-4"><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">由ы룷???쒖텧</span><span class="font-bold text-gray-900">45/50</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-blue-500 h-2 rounded-full" style="width:90%"></div></div></div>
            <div class="mb-4"><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">議곗튂 ?꾨즺??/span><span class="font-bold text-gray-900">87%</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-green-500 h-2 rounded-full" style="width:87%"></div></div></div>
            <div><div class="flex justify-between text-sm mb-1"><span class="text-gray-700 font-medium">?쒕븣 ?꾨즺</span><span class="font-bold text-gray-900">92%</span></div><div class="w-full bg-gray-200 rounded-full h-2"><div class="bg-orange-500 h-2 rounded-full" style="width:92%"></div></div></div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>

