<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>由ы룷???곸꽭 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <a href="/actions" class="p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg></a>
      <h1 class="text-lg font-semibold text-gray-900">由ы룷???곸꽭</h1>
    </div>
    <div class="flex items-center gap-2">
      <button class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 flex items-center gap-2"><svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>PDF ?ㅼ슫濡쒕뱶</button>
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-5xl mx-auto space-y-6">

      <!-- Report Header -->
      <div class="bg-gradient-to-r from-[#1B3A5F] to-[#2C5282] rounded-2xl p-6 text-white">
        <div class="flex items-start justify-between">
          <div class="flex-1">
            <div class="flex items-center gap-3 mb-3">
              <span class="bg-red-500 text-white text-xs font-bold px-3 py-1 rounded-full">怨좎쐞??/span>
              <span class="text-white/60 text-sm">RPT-2026-0601-001</span>
            </div>
            <h2 class="text-2xl font-bold mb-2">?덉쟾 ?쒓컙 誘몄꽕移?諛?異붾씫 ?꾪뿕 媛먯?</h2>
            <p class="text-white/70 text-sm mb-4">3???μ긽 쨌 2026-06-01 14:32 쨌 AI ?먮룞 媛먯?</p>
            <div class="flex flex-wrap gap-4 text-sm">
              <div class="flex items-center gap-2"><svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg><span class="text-white/70">?대떦: (二??쒓뎅嫄댁꽕</span></div>
              <div class="flex items-center gap-2"><svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg><span class="text-white/70">留덇컧: 2026-06-19</span></div>
            </div>
          </div>
          <div class="hidden md:flex flex-col items-end gap-3">
            <div class="bg-white/10 rounded-xl px-4 py-3 text-center"><p class="text-white/60 text-xs mb-1">AI ?꾪뿕??/p><p class="text-3xl font-bold text-[#FF6B35]">94</p><p class="text-white/60 text-xs">/ 100</p></div>
            <span class="text-xs px-3 py-1 bg-orange-500 text-white rounded-full font-medium">議곗튂 以?/span>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">

          <!-- Image Analysis -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">AI 遺꾩꽍 ?대?吏</h3>
            <div class="relative bg-gray-100 rounded-xl overflow-hidden aspect-video flex items-center justify-center">
              <div class="text-center">
                <svg class="w-12 h-12 text-gray-300 mx-auto mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                <p class="text-sm text-gray-400">?꾩옣?꾧꼍_0601.jpg</p>
              </div>
              <!-- Detection Boxes -->
              <div class="absolute top-8 left-12 border-2 border-red-500 rounded px-1">
                <span class="bg-red-500 text-white text-[10px] px-1 py-0.5 font-bold">?덉쟾?쒓컙 誘몄꽕移?94%</span>
              </div>
              <div class="absolute bottom-12 right-16 border-2 border-orange-500 rounded px-1">
                <span class="bg-orange-500 text-white text-[10px] px-1 py-0.5 font-bold">?덉쟾紐?誘몄갑??82%</span>
              </div>
            </div>
            <!-- Detected Items -->
            <div class="mt-4 space-y-2">
              <div class="flex items-center gap-3 p-3 bg-red-50 rounded-xl border border-red-100">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">?덉쟾?쒓컙 誘몄꽕移?/p><p class="text-xs text-gray-500">?곗뾽?덉쟾蹂닿굔湲곗???愿??洹쒖튃 ??2議??꾨컲</p></div>
                <div class="text-right flex-shrink-0"><p class="text-sm font-bold text-red-600">94%</p><p class="text-xs text-gray-400">?좊ː??/p></div>
              </div>
              <div class="flex items-center gap-3 p-3 bg-red-50 rounded-xl border border-red-100">
                <div class="w-3 h-3 rounded-full bg-red-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">異붾씫 ?꾪뿕 援ш컙</p><p class="text-xs text-gray-500">?믪씠 2m ?댁긽 媛쒓뎄遺 諛⑺샇 誘몄꽕移?/p></div>
                <div class="text-right flex-shrink-0"><p class="text-sm font-bold text-red-600">89%</p><p class="text-xs text-gray-400">?좊ː??/p></div>
              </div>
              <div class="flex items-center gap-3 p-3 bg-orange-50 rounded-xl border border-orange-100">
                <div class="w-3 h-3 rounded-full bg-orange-500 flex-shrink-0"></div>
                <div class="flex-1 min-w-0"><p class="text-sm font-semibold text-gray-900">?덉쟾紐?誘몄갑??/p><p class="text-xs text-gray-500">?묒뾽??2紐??덉쟾蹂댄샇援?誘몄갑??/p></div>
                <div class="text-right flex-shrink-0"><p class="text-sm font-bold text-orange-600">82%</p><p class="text-xs text-gray-400">?좊ː??/p></div>
              </div>
            </div>
          </div>

          <!-- Action Timeline -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-5">議곗튂 吏꾪뻾 ?꾪솴</h3>
            <div class="relative">
              <div class="absolute left-4 top-0 bottom-0 w-0.5 bg-gray-200"></div>
              <div class="space-y-6">
                <div class="relative flex gap-4">
                  <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0 z-10"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                  <div class="pt-1"><p class="text-sm font-semibold text-gray-900">AI ?꾪뿕 媛먯?</p><p class="text-xs text-gray-500">2026-06-01 14:32</p><p class="text-sm text-gray-600 mt-1">?꾩옣 ?ъ쭊 ?낅줈????3嫄댁쓽 ?꾪뿕 ?붿냼 媛먯???/p></div>
                </div>
                <div class="relative flex gap-4">
                  <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0 z-10"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                  <div class="pt-1"><p class="text-sm font-semibold text-gray-900">?먯껌 ?뺤씤 諛?議곗튂 吏??/p><p class="text-xs text-gray-500">2026-06-01 15:10</p><p class="text-sm text-gray-600 mt-1">?덉쟾愿由ъ옄 ?뺤씤 ??(二??쒓뎅嫄댁꽕??議곗튂 吏??/p></div>
                </div>
                <div class="relative flex gap-4">
                  <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center flex-shrink-0 z-10 animate-pulse"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
                  <div class="pt-1"><p class="text-sm font-semibold text-gray-900">議곗튂 吏꾪뻾 以?/p><p class="text-xs text-gray-500">2026-06-02 ~</p><p class="text-sm text-gray-600 mt-1">?덉쟾?쒓컙 ?ㅼ튂 ?먯옱 諛쒖＜ ?꾨즺, ?쒓났 ?덉젙</p></div>
                </div>
                <div class="relative flex gap-4 opacity-40">
                  <div class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center flex-shrink-0 z-10"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                  <div class="pt-1"><p class="text-sm font-semibold text-gray-500">寃利?諛??꾨즺</p><p class="text-xs text-gray-400">?덉젙</p></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Comments -->
          <div class="bg-white rounded-2xl p-6 shadow-md">
            <h3 class="text-base font-semibold text-gray-900 mb-4">?섍껄 諛??묒쓽</h3>
            <div class="space-y-4 mb-5">
              <div class="flex gap-3">
                <div class="w-8 h-8 bg-[#1B3A5F] rounded-full flex items-center justify-center flex-shrink-0"><span class="text-white text-xs font-bold">諛?/span></div>
                <div class="flex-1 bg-gray-50 rounded-xl p-3"><p class="text-xs text-gray-500 mb-1">諛뺤븞??쨌 2026-06-01 15:10</p><p class="text-sm text-gray-800">3???μ긽 ?덉쟾?쒓컙 利됱떆 ?ㅼ튂 ?꾩슂?⑸땲?? ?먯옱??李쎄퀬???덉쑝???ㅻ뒛 ?ㅽ썑 以?泥섎━ 遺?곷뱶由쎈땲??</p></div>
              </div>
              <div class="flex gap-3">
                <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center flex-shrink-0"><span class="text-white text-xs font-bold">??/span></div>
                <div class="flex-1 bg-gray-50 rounded-xl p-3"><p class="text-xs text-gray-500 mb-1">?댁옉??쨌 2026-06-02 09:00</p><p class="text-sm text-gray-800">?먯옱 ?뺤씤 ?꾨즺?덉뒿?덈떎. ?ㅻ뒛 ?ㅼ쟾 以??ㅼ튂 吏꾪뻾?섍쿋?듬땲??</p></div>
              </div>
            </div>
            <div class="flex gap-3">
              <div class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center flex-shrink-0"><svg class="w-4 h-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
              <div class="flex-1 flex gap-2"><input type="text" placeholder="?섍껄???④꺼二쇱꽭??.." class="flex-1 px-4 py-2 border border-gray-300 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/><button class="px-4 py-2 bg-[#FF6B35] text-white rounded-xl text-sm font-semibold hover:bg-[#E55A2A]">?꾩넚</button></div>
            </div>
          </div>
        </div>

        <!-- Side Panel -->
        <div class="space-y-5">
          <!-- Status Control -->
          <div class="bg-white rounded-2xl p-5 shadow-md">
            <h3 class="text-sm font-semibold text-gray-900 mb-3">?곹깭 蹂寃?/h3>
            <div class="space-y-2">
              <button class="w-full py-2.5 border-2 border-gray-200 text-gray-600 rounded-xl text-sm font-medium hover:border-red-300 hover:text-red-600 transition-colors">議곗튂 ??/button>
              <button class="w-full py-2.5 border-2 border-[#FF6B35] bg-[#FF6B35]/10 text-[#FF6B35] rounded-xl text-sm font-bold">議곗튂 以???/button>
              <button class="w-full py-2.5 border-2 border-gray-200 text-gray-600 rounded-xl text-sm font-medium hover:border-yellow-300 hover:text-yellow-600 transition-colors">寃利?以?/button>
              <button class="w-full py-2.5 border-2 border-gray-200 text-gray-600 rounded-xl text-sm font-medium hover:border-green-300 hover:text-green-600 transition-colors">?꾨즺</button>
            </div>
          </div>

          <!-- Info -->
          <div class="bg-white rounded-2xl p-5 shadow-md">
            <h3 class="text-sm font-semibold text-gray-900 mb-3">議곗튂 ?뺣낫</h3>
            <dl class="space-y-2.5 text-sm">
              <div class="flex justify-between"><dt class="text-gray-500">?꾪뿕??/dt><dd><span class="px-2 py-0.5 bg-red-100 text-red-700 rounded-full text-xs font-medium">怨좎쐞??/span></dd></div>
              <div class="flex justify-between"><dt class="text-gray-500">?꾩옣</dt><dd class="text-gray-800 font-medium">3???μ긽</dd></div>
              <div class="flex justify-between"><dt class="text-gray-500">?대떦 ?낆껜</dt><dd class="text-gray-800 font-medium">(二??쒓뎅嫄댁꽕</dd></div>
              <div class="flex justify-between"><dt class="text-gray-500">媛먯? ?쇱떆</dt><dd class="text-gray-800 font-medium">2026-06-01</dd></div>
              <div class="flex justify-between"><dt class="text-gray-500">留덇컧??/dt><dd class="text-red-600 font-bold">2026-06-19</dd></div>
              <div class="flex justify-between"><dt class="text-gray-500">踰뺢퇋 議고빆</dt><dd class="text-gray-800 font-medium text-right text-xs">?곗븞踰???2議?/dd></div>
            </dl>
          </div>

          <!-- AI Score -->
          <div class="bg-gradient-to-br from-[#1B3A5F] to-[#2C5282] rounded-2xl p-5 text-white">
            <h3 class="text-sm font-semibold text-white/80 mb-3">AI ?꾪뿕 ?먯닔</h3>
            <div class="text-center mb-3">
              <p class="text-5xl font-bold">94</p>
              <p class="text-white/60 text-xs mt-1">/ 100??/p>
            </div>
            <div class="space-y-2 text-xs">
              <div><div class="flex justify-between mb-0.5"><span class="text-white/70">異붾씫 ?꾪뿕</span><span>95%</span></div><div class="w-full bg-white/20 rounded-full h-1.5"><div class="bg-red-400 h-1.5 rounded-full" style="width:95%"></div></div></div>
              <div><div class="flex justify-between mb-0.5"><span class="text-white/70">踰뺢퇋 ?꾨컲</span><span>89%</span></div><div class="w-full bg-white/20 rounded-full h-1.5"><div class="bg-orange-400 h-1.5 rounded-full" style="width:89%"></div></div></div>
              <div><div class="flex justify-between mb-0.5"><span class="text-white/70">蹂댄샇援?誘몄갑??/span><span>82%</span></div><div class="w-full bg-white/20 rounded-full h-1.5"><div class="bg-yellow-400 h-1.5 rounded-full" style="width:82%"></div></div></div>
            </div>
          </div>

          <a href="/actions/new" class="block w-full py-3 text-center bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-md">??議곗튂 異붽?</a>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>

