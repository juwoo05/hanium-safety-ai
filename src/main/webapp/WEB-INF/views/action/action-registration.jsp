<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>議곗튂 ?깅줉 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <a href="/actions" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
      </a>
      <h1 class="text-lg font-semibold text-gray-900">??議곗튂 ?깅줉</h1>
    </div>
    <div class="flex items-center gap-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">源</span></div></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-3xl mx-auto">
      <form action="/actions/new" method="post" class="space-y-6">

        <!-- 湲곕낯 ?뺣낫 -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h2 class="text-base font-semibold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-6 h-6 bg-[#FF6B35] text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
            湲곕낯 ?뺣낫
          </h2>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">議곗튂紐?<span class="text-red-500">*</span></label>
              <input type="text" name="title" placeholder="議곗튂 ?댁슜??媛꾨왂???낅젰?섏꽭?? required
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">?꾪뿕 ?깃툒 <span class="text-red-500">*</span></label>
                <select name="riskLevel" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                  <option value="">?좏깮</option>
                  <option value="high">怨좎쐞??/option>
                  <option value="medium">以묒쐞??/option>
                  <option value="low">??꾪뿕</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">?꾩옣 ?꾩튂 <span class="text-red-500">*</span></label>
                <input type="text" name="location" placeholder="?? 3???μ긽" required
                       class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              </div>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">?곸꽭 ?ㅻ챸</label>
              <textarea name="description" rows="4" placeholder="?꾪뿕 ?곹솴 諛?議곗튂 ?댁슜???곸꽭??湲곗엯?섏꽭??
                        class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none resize-none"></textarea>
            </div>
          </div>
        </div>

        <!-- ?대떦??& ?쇱젙 -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h2 class="text-base font-semibold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-6 h-6 bg-[#FF6B35] text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
            ?대떦??諛??쇱젙
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">?대떦 ?낆껜 <span class="text-red-500">*</span></label>
              <select name="company" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                <option value="">(二??쒓뎅嫄댁꽕</option>
                <option>??깆쿋怨?二?</option>
                <option>誘몃옒?꾧린?ㅻ퉬</option>
                <option>?덉쟾?뚰듃?덉뒪</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">?대떦??/label>
              <input type="text" name="assignee" placeholder="?대떦???대쫫"
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">留덇컧??<span class="text-red-500">*</span></label>
              <input type="date" name="deadline" required
                     class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">珥덇린 ?곹깭</label>
              <select name="status" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
                <option value="before">議곗튂 ??/option>
                <option value="inprogress">議곗튂 以?/option>
              </select>
            </div>
          </div>
        </div>

        <!-- ?ъ쭊 泥⑤? -->
        <div class="bg-white rounded-2xl p-6 shadow-md">
          <h2 class="text-base font-semibold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-6 h-6 bg-[#FF6B35] text-white rounded-full flex items-center justify-center text-xs font-bold">3</span>
            ?ъ쭊 泥⑤?
          </h2>
          <div class="border-2 border-dashed border-gray-200 rounded-xl p-8 text-center hover:border-[#FF6B35] transition-colors cursor-pointer" onclick="document.getElementById('attachInput').click()">
            <input id="attachInput" type="file" name="photos" multiple accept="image/*" class="hidden" onchange="previewPhotos(this.files)"/>
            <svg class="w-10 h-10 text-gray-400 mx-auto mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
            <p class="text-sm text-gray-600 mb-1">?꾩옣 ?ъ쭊??泥⑤??섏꽭??/p>
            <p class="text-xs text-gray-400">JPG, PNG 쨌 理쒕? 10MB</p>
          </div>
          <div id="photoPreview" class="grid grid-cols-3 gap-3 mt-4"></div>
        </div>

        <!-- Submit -->
        <div class="flex gap-3">
          <a href="/actions" class="flex-1 py-3 text-center border-2 border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors">痍⑥냼</a>
          <button type="submit" class="flex-1 py-3 bg-[#FF6B35] text-white rounded-xl font-semibold hover:bg-[#E55A2A] transition-colors shadow-lg">議곗튂 ?깅줉</button>
        </div>
      </form>
    </div>
  </main>
</div>
<script>
function previewPhotos(files) {
  var preview = document.getElementById('photoPreview');
  preview.innerHTML = '';
  Array.from(files).forEach(function(f) {
    var reader = new FileReader();
    reader.onload = function(e) {
      var div = document.createElement('div');
      div.className = 'relative rounded-xl overflow-hidden border border-gray-200 aspect-video';
      div.innerHTML = '<img src="' + e.target.result + '" class="w-full h-full object-cover"/>';
      preview.appendChild(div);
    };
    reader.readAsDataURL(f);
  });
}
</script>
</body>
</html>

