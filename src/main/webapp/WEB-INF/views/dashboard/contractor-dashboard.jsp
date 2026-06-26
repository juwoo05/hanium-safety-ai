<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>?먯껌 ??쒕낫??- SafeMate</title>
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
        <input type="text" placeholder="寃??.." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
    </div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
      </a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">源</span></div>
        <span class="text-sm font-medium text-gray-700 hidden sm:block">源?꾩옣</span>
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
              <span class="bg-[#FF6B35] text-white text-xs font-bold px-3 py-1 rounded-full">?먯껌</span>
              <span class="text-white/60 text-sm">?쇱꽦嫄댁꽕(二?</span>
            </div>
            <h1 class="text-3xl font-bold mb-2">?덈뀞?섏꽭?? 源?꾩옣?? ?몝</h1>
            <p class="text-white/80 text-lg">?꾩껜 ?꾩옣 ?덉쟾 ?꾪솴 ???묐젰??12媛쒖궗 愿由?以?/p>
            <div class="flex items-center gap-6 mt-4">
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-green-400 rounded-full"></div><span class="text-sm">?꾩껜 ?꾩옣: 5媛?/span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-400 rounded-full"></div><span class="text-sm">湲닿툒 議곗튂: 7嫄?/span></div>
              <div class="flex items-center gap-2"><div class="w-2 h-2 bg-blue-400 rounded-full"></div><span class="text-sm">?묐젰?? 12媛?/span></div>
            </div>
          </div>
          <div class="hidden lg:block">
            <img src="/images/mascot.png" alt="留덉뒪肄뷀듃" class="w-24 h-24 object-contain" style="mix-blend-mode:multiply"/>
          </div>
        </div>
      </div>

      <!-- KPI -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-blue-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
            <span class="text-sm font-semibold text-green-600">??+23</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">?꾩껜 由ы룷????/p>
          <p class="text-3xl font-bold text-gray-900">247</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-red-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
            <span class="text-sm font-semibold text-red-500">??-5</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">怨좎쐞????ぉ</p>
          <p class="text-3xl font-bold text-gray-900">18</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-orange-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
            <span class="text-sm font-semibold text-green-600">??+8</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">議곗튂 吏꾪뻾 以?/p>
          <p class="text-3xl font-bold text-gray-900">42</p>
        </div>
        <div class="bg-white rounded-2xl p-5 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-[#FF6B35] cursor-pointer">
          <div class="flex items-start justify-between mb-3">
            <div class="bg-purple-500 w-12 h-12 rounded-xl flex items-center justify-center shadow"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg></div>
            <span class="text-sm font-semibold text-green-600">??+2</span>
          </div>
          <p class="text-gray-500 text-xs mb-1">?묐젰????/p>
          <p class="text-3xl font-bold text-gray-900">12</p>
        </div>
      </div>

      <!-- Mascot Tip -->
      <div class="bg-gradient-to-r from-[#FF6B35]/10 to-[#FF6B35]/5 rounded-2xl p-5 border-2 border-[#FF6B35]/20 flex items-start gap-4">
        <img src="/images/mascot.png" alt="留덉뒪肄뷀듃" class="w-16 h-16 object-contain flex-shrink-0" style="mix-blend-mode:multiply"/>
        <div>
          <h3 class="text-base font-semibold text-[#1B3A5F] mb-1">?뮕 ?먯껌 ?덉쟾 ?꾪솴 ?붿빟</h3>
          <p class="text-sm text-gray-700">??깆쿋怨?二???怨좎쐞????ぉ??7嫄댁쑝濡?媛??留롮뒿?덈떎. ?ㅻ뒛 留덇컧 湲닿툒 議곗튂 2嫄댁쓣 ?곗꽑 ?뺤씤?댁＜?몄슂.</p>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">

          <!-- Quick Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">鍮좊Ⅸ ?ㅽ뻾</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-blue-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">?ъ쭊 ?낅줈??/span>
              </a>
              <a href="/upload" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-[#FF6B35] w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">?꾪뿕 遺꾩꽍</span>
              </a>
              <a href="/actions/new" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-green-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">議곗튂 ?깅줉</span>
              </a>
              <a href="/actions/detail" class="flex flex-col items-center gap-2 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors group">
                <div class="bg-purple-500 w-10 h-10 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div>
                <span class="text-xs font-medium text-gray-700 text-center">由ы룷??蹂닿린</span>
              </a>
            </div>
          </div>

          <!-- Weekly Chart -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">二쇨컙 ?꾪뿕 諛쒖깮 ?꾪솴</h3>
              <div class="flex items-center gap-3 text-xs text-gray-500">
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#1B3A5F] inline-block"></span>?먯껌</span>
                <span class="flex items-center gap-1"><span class="w-3 h-3 rounded-sm bg-[#FF6B35] inline-block"></span>?섏껌</span>
              </div>
            </div>
            <div class="flex items-end justify-between gap-1" style="height:160px">
              <% int[][] weekData = {{8,12},{12,19},{9,15},{15,25},{11,22},{5,8},{3,5}}; String[] days={"??,"??,"??,"紐?,"湲?,"??,"??}; int max=25; %>
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
              ?묐젰???덉쟾 ?꾪솴
            </h3>
            <div class="space-y-3">
              <div class="p-4 rounded-xl border-2 border-gray-100 bg-gray-50">
                <div class="flex items-center justify-between mb-2">
                  <span class="font-semibold text-gray-900 text-sm">(二??쒓뎅嫄댁꽕</span>
                  <span class="text-sm font-bold text-green-600">87%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>由ы룷??45嫄?/span><span class="text-red-500 font-medium">怨좎쐞??3嫄?/span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-green-500" style="width:87%"></div></div>
              </div>
              <div class="p-4 rounded-xl border-2 border-orange-200 bg-orange-50">
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center gap-2"><span class="font-semibold text-gray-900 text-sm">??깆쿋怨?二?</span><span class="text-xs bg-orange-100 text-orange-700 px-2 py-0.5 rounded-full">二쇱쓽</span></div>
                  <span class="text-sm font-bold text-orange-500">62%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>由ы룷??38嫄?/span><span class="text-red-500 font-medium">怨좎쐞??7嫄?/span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-orange-500" style="width:62%"></div></div>
              </div>
              <div class="p-4 rounded-xl border-2 border-gray-100 bg-gray-50">
                <div class="flex items-center justify-between mb-2">
                  <span class="font-semibold text-gray-900 text-sm">誘몃옒?꾧린?ㅻ퉬</span>
                  <span class="text-sm font-bold text-green-600">95%</span>
                </div>
                <div class="flex items-center gap-4 text-xs text-gray-600 mb-2"><span>由ы룷??29嫄?/span><span class="text-red-500 font-medium">怨좎쐞??1嫄?/span></div>
                <div class="w-full bg-gray-200 rounded-full h-1.5"><div class="h-1.5 rounded-full bg-green-500" style="width:95%"></div></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Sidebar -->
        <div class="space-y-6">
          <!-- Risk Distribution -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">?꾪뿕 ?깃툒 遺꾪룷</h3>
            <div class="flex items-center gap-4">
              <svg width="120" height="120" viewBox="0 0 120 120" class="flex-shrink-0">
                <circle cx="60" cy="60" r="40" fill="none" stroke="#ef4444" stroke-width="20" stroke-dasharray="15.27 235.6" stroke-dashoffset="0" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#f97316" stroke-width="20" stroke-dasharray="28.84 235.6" stroke-dashoffset="-15.27" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#eab308" stroke-width="20" stroke-dasharray="44.12 235.6" stroke-dashoffset="-44.11" transform="rotate(-90 60 60)"/>
                <circle cx="60" cy="60" r="40" fill="none" stroke="#22c55e" stroke-width="20" stroke-dasharray="121.37 235.6" stroke-dashoffset="-88.23" transform="rotate(-90 60 60)"/>
                <text x="60" y="54" text-anchor="middle" fill="#374151" font-size="11" font-weight="600">247</text>
                <text x="60" y="68" text-anchor="middle" fill="#9CA3AF" font-size="9">?꾩껜</text>
              </svg>
              <div class="flex-1 space-y-2">
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-red-500"></span><span class="text-xs">怨좎쐞??/span></span><span class="font-semibold text-xs">18嫄?/span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-orange-500"></span><span class="text-xs">以묒쐞??/span></span><span class="font-semibold text-xs">34嫄?/span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-yellow-500"></span><span class="text-xs">??꾪뿕</span></span><span class="font-semibold text-xs">52嫄?/span></div>
                <div class="flex items-center justify-between text-sm"><span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-green-500"></span><span class="text-xs">?뺤긽</span></span><span class="font-semibold text-xs">143嫄?/span></div>
              </div>
            </div>
          </div>

          <!-- Urgent Actions -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
              湲닿툒 議곗튂 ?꾩슂
            </h3>
            <div class="space-y-3">
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">?덉쟾 ?쒓컙 誘몄꽕移?/p>
                <p class="text-xs text-gray-600">3???μ긽 쨌 (二??쒓뎅嫄댁꽕</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">留덇컧: ?ㅻ뒛</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">?꾩떆 諛곗꽑 ?몄텧</p>
                <p class="text-xs text-gray-600">吏??1痢?쨌 ??깆쿋怨?二?</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">留덇컧: ?ㅻ뒛</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
              <a href="/actions/detail" class="block p-3 bg-red-50 rounded-xl border border-red-100 hover:border-red-300 transition-colors">
                <p class="text-sm font-semibold text-gray-900 mb-1">?뚰솕湲??먭? ?꾩슂</p>
                <p class="text-xs text-gray-600">4??1痢?쨌 誘몃옒?꾧린?ㅻ퉬</p>
                <div class="flex items-center justify-between mt-2"><span class="text-xs text-red-600 font-medium">留덇컧: ?댁씪</span><svg class="w-4 h-4 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></div>
              </a>
            </div>
            <a href="/actions" class="block w-full mt-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium text-center">?꾩껜 湲닿툒 議곗튂</a>
          </div>

          <!-- Weather -->
          <div class="bg-gradient-to-br from-sky-500 to-blue-600 rounded-2xl p-5 text-white shadow-md">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sky-200 text-xs font-medium mb-1">?쒖슱 媛뺣궓援?/p>
                <div class="flex items-end gap-2"><span class="text-4xl font-bold">28째</span><span class="text-sky-200 text-sm mb-1">留묒쓬</span></div>
              </div>
              <svg class="w-14 h-14 text-yellow-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/></svg>
            </div>
            <div class="flex gap-4 mt-3 text-xs text-sky-200">
              <span>?뮛 62%</span><span>?뙩 3.2m/s</span><span>?뙜 泥닿컧 31째</span>
            </div>
            <div class="mt-3 px-3 py-2 rounded-lg border border-yellow-200 bg-yellow-50 text-xs font-medium text-yellow-800 flex items-center gap-2">
              <svg class="w-3.5 h-3.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>
              ?쇱쇅 ?묒뾽 ?곹빀 ???먯쇅??吏???믪쓬, 李④킅 ?꾩슂
            </div>
          </div>

          <!-- Today Alerts -->
          <div class="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-2xl p-5 border-2 border-yellow-200">
            <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <svg class="w-4 h-4 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              ?ㅻ뒛???덉쟾 ?뚮┝
            </h3>
            <ul class="space-y-2 text-sm text-gray-700">
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">??/span><span>3???몃꼍 ?묒뾽 ???덉쟾?쒓컙 ?꾩닔</span></li>
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">??/span><span>吏?섏＜李⑥옣 ?섍린 ?묒뾽 14:00~17:00</span></li>
              <li class="flex items-start gap-2"><span class="text-orange-500 mt-0.5">??/span><span>?댁씪 ?ㅼ쟾 ?묐젰???덉쟾 援먯쑁 ?덉젙</span></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>

