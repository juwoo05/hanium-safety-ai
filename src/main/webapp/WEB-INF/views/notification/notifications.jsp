<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>?뚮┝ - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <h1 class="text-lg font-semibold text-gray-900">?뚮┝</h1>
      <span class="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">5</span>
    </div>
    <div class="flex items-center gap-3">
      <button onclick="markAllRead()" class="text-sm text-[#FF6B35] hover:text-[#E55A2A] font-medium transition-colors">紐⑤몢 ?쎌쓬 泥섎━</button>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">源</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto space-y-3">

      <!-- Filter Tabs -->
      <div class="flex gap-2 bg-white rounded-xl p-1.5 shadow-sm border border-gray-100">
        <button onclick="filterNoti('all',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg bg-[#FF6B35] text-white transition-all">?꾩껜</button>
        <button onclick="filterNoti('unread',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">?쎌? ?딆쓬</button>
        <button onclick="filterNoti('danger',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">?꾪뿕 ?뚮┝</button>
        <button onclick="filterNoti('action',this)" class="flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all">議곗튂 ?뚮┝</button>
      </div>

      <!-- Today -->
      <p class="text-xs font-semibold text-gray-400 px-1 pt-2">?ㅻ뒛</p>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-red-500 border border-red-100 hover:shadow-md transition-all" data-type="danger unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-red-100 text-red-700 rounded-full font-medium">怨좎쐞??/span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">3???μ긽 ?덉쟾?쒓컙 誘몄꽕移?媛먯?</p>
            <p class="text-xs text-gray-500 mt-0.5">AI媛 怨좎쐞???붿냼瑜?媛먯??덉뒿?덈떎. 利됱떆 ?뺤씤???꾩슂?⑸땲??</p>
            <p class="text-xs text-gray-400 mt-1.5">諛⑷툑 ??/p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-orange-500 border border-orange-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-orange-100 text-orange-700 rounded-full font-medium">議곗튂 留덇컧</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">?꾩떆 諛곗꽑 ?몄텧 議곗튂 留덇컧 ?꾨컯</p>
            <p class="text-xs text-gray-500 mt-0.5">?ㅻ뒛 18:00源뚯? ?꾨즺?댁빞 ?⑸땲??</p>
            <p class="text-xs text-gray-400 mt-1.5">1?쒓컙 ??/p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-blue-500 border border-blue-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-blue-100 text-blue-700 rounded-full font-medium">議곗튂 ?꾨즺</span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">?뚰솕湲??꾩튂 ?щ같移?議곗튂 ?꾨즺</p>
            <p class="text-xs text-gray-500 mt-0.5">??깆쿋怨?二???議곗튂瑜??꾨즺?덉뒿?덈떎. 寃利?遺?곷뱶由쎈땲??</p>
            <p class="text-xs text-gray-400 mt-1.5">3?쒓컙 ??/p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/dashboard" class="block bg-white rounded-2xl p-4 shadow-sm border-l-4 border-l-green-500 border border-green-100 hover:shadow-md transition-all" data-type="action unread">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0"><img src="/images/mascot.png" alt="留덉뒪肄뷀듃" class="w-7 h-7 object-contain" style="mix-blend-mode:multiply"/></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-green-100 text-green-700 rounded-full font-medium">AI ??/span><span class="w-2 h-2 bg-red-500 rounded-full"></span></div>
            <p class="text-sm font-semibold text-gray-900">?ㅻ뒛???덉쟾 ?먯닔: 87??/p>
            <p class="text-xs text-gray-500 mt-0.5">吏?쒖＜ ?鍮?3???곸듅?덉뒿?덈떎! 議곗튂 ?꾨즺?⑥쓣 ?믪씠硫?90???ъ꽦 媛?ν빀?덈떎.</p>
            <p class="text-xs text-gray-400 mt-1.5">5?쒓컙 ??/p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <!-- Yesterday -->
      <p class="text-xs font-semibold text-gray-400 px-1 pt-3">?댁젣</p>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all opacity-70" data-type="danger">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full font-medium">怨좎쐞??/span></div>
            <p class="text-sm font-semibold text-gray-700">吏??1痢??꾩떆 諛곗꽑 ?몄텧 媛먯?</p>
            <p class="text-xs text-gray-500 mt-0.5">AI ?먮룞 媛먯? ???꾧린 ?꾪뿕</p>
            <p class="text-xs text-gray-400 mt-1.5">?댁젣 09:15</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>

      <a href="/actions/detail" class="block bg-white rounded-2xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all opacity-70" data-type="action">
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg></div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1"><span class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full font-medium">議곗튂 諛곗젙</span></div>
            <p class="text-sm font-semibold text-gray-700">??議곗튂媛 諛곗젙?섏뿀?듬땲??/p>
            <p class="text-xs text-gray-500 mt-0.5">5痢??몃꼍 ?덉쟾留??먭? 쨌 留덇컧 2026-06-19</p>
            <p class="text-xs text-gray-400 mt-1.5">?댁젣 08:30</p>
          </div>
          <svg class="w-4 h-4 text-gray-300 flex-shrink-0 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </div>
      </a>
    </div>
  </main>
</div>
<script>
function markAllRead() {
  document.querySelectorAll('[data-type]').forEach(function(el) {
    el.classList.add('opacity-70');
    var dot = el.querySelector('.w-2.h-2.bg-red-500');
    if (dot) dot.classList.replace('bg-red-500', 'bg-transparent');
  });
  var badge = document.querySelector('header span.bg-red-500');
  if (badge) badge.remove();
}

function filterNoti(type, btn) {
  document.querySelectorAll('[data-type]').forEach(function(el) {
    if (type === 'all') { el.style.display = ''; }
    else if (type === 'unread') { el.style.display = el.dataset.type.includes('unread') ? '' : 'none'; }
    else { el.style.display = el.dataset.type.includes(type) ? '' : 'none'; }
  });
  document.querySelectorAll('button[onclick^="filterNoti"]').forEach(function(b) {
    b.className = 'flex-1 py-2 text-sm font-semibold rounded-lg text-gray-500 hover:bg-gray-50 transition-all';
  });
  btn.className = 'flex-1 py-2 text-sm font-semibold rounded-lg bg-[#FF6B35] text-white transition-all';
}
</script>
</body>
</html>

