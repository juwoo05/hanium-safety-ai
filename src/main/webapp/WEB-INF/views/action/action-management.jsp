<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>조치 관리 - SafeMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen transition-all duration-300 ml-16">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex-1 max-w-xl"><div class="relative"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg><input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/></div></div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div><span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="space-y-6">
      <div class="flex items-center justify-between">
        <div><h1 class="text-2xl font-bold text-gray-900">조치 관리</h1><p class="text-gray-600 text-sm mt-1">현장 위험 조치 현황을 관리합니다</p></div>
        <a href="/actions/new" class="flex items-center gap-2 px-4 py-2 bg-[#FF6B35] text-white rounded-lg hover:bg-[#E55A2A] transition-colors font-medium">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          새 조치 등록
        </a>
      </div>

      <!-- Filter Bar -->
      <div class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 flex flex-wrap gap-3 items-center">
        <select class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option>전체 상태</option><option>조치 전</option><option>조치 중</option><option>검증 중</option><option>완료</option>
        </select>
        <select class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option>전체 위험도</option><option>고위험</option><option>중위험</option><option>저위험</option>
        </select>
        <select class="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none">
          <option>전체 현장</option><option>1동</option><option>2동</option><option>3동</option><option>4동</option><option>5동</option>
        </select>
        <div class="flex-1 relative min-w-48">
          <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
          <input type="text" placeholder="조치명 검색..." class="w-full pl-9 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
        </div>
      </div>

      <!-- Stats -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div class="bg-white rounded-xl p-4 shadow-sm border border-gray-100 text-center"><p class="text-2xl font-bold text-gray-900">94</p><p class="text-xs text-gray-500 mt-1">전체 조치</p></div>
        <div class="bg-red-50 rounded-xl p-4 shadow-sm border border-red-100 text-center"><p class="text-2xl font-bold text-red-600">24</p><p class="text-xs text-red-500 mt-1">조치 전</p></div>
        <div class="bg-orange-50 rounded-xl p-4 shadow-sm border border-orange-100 text-center"><p class="text-2xl font-bold text-orange-600">35</p><p class="text-xs text-orange-500 mt-1">진행 중</p></div>
        <div class="bg-green-50 rounded-xl p-4 shadow-sm border border-green-100 text-center"><p class="text-2xl font-bold text-green-600">35</p><p class="text-xs text-green-500 mt-1">완료</p></div>
      </div>

      <!-- Action List -->
      <div class="bg-white rounded-2xl shadow-md overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">조치명</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">위험도</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">현장</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">담당자</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">마감일</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500">상태</th>
                <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500"></th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">안전 난간 미설치</p><p class="text-xs text-gray-500">3동 옥상</p></td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-red-100 text-red-700 font-medium">고위험</span></td>
                <td class="px-4 py-4 text-sm text-gray-700">3동</td>
                <td class="px-4 py-4 text-sm text-gray-700">(주)한국건설</td>
                <td class="px-4 py-4 text-sm text-red-600 font-medium">오늘</td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-red-100 text-red-700">조치 전</span></td>
                <td class="px-4 py-4"><a href="/actions/detail" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a></td>
              </tr>
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">임시 배선 노출</p><p class="text-xs text-gray-500">지하 1층</p></td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-red-100 text-red-700 font-medium">고위험</span></td>
                <td class="px-4 py-4 text-sm text-gray-700">지하</td>
                <td class="px-4 py-4 text-sm text-gray-700">대성철골(주)</td>
                <td class="px-4 py-4 text-sm text-red-600 font-medium">오늘</td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-orange-100 text-orange-700">조치 중</span></td>
                <td class="px-4 py-4"><a href="/actions/detail" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a></td>
              </tr>
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">소화기 점검 필요</p><p class="text-xs text-gray-500">4동 1층</p></td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-orange-100 text-orange-700 font-medium">중위험</span></td>
                <td class="px-4 py-4 text-sm text-gray-700">4동</td>
                <td class="px-4 py-4 text-sm text-gray-700">미래전기설비</td>
                <td class="px-4 py-4 text-sm text-gray-700">내일</td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-yellow-100 text-yellow-700">검증 중</span></td>
                <td class="px-4 py-4"><a href="/actions/detail" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a></td>
              </tr>
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">안전모 미착용 조치</p><p class="text-xs text-gray-500">2동 외벽</p></td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-yellow-100 text-yellow-700 font-medium">저위험</span></td>
                <td class="px-4 py-4 text-sm text-gray-700">2동</td>
                <td class="px-4 py-4 text-sm text-gray-700">안전파트너스</td>
                <td class="px-4 py-4 text-sm text-gray-700">2026-06-25</td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-700">완료</span></td>
                <td class="px-4 py-4"><a href="/actions/detail" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a></td>
              </tr>
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-4 py-4"><p class="text-sm font-semibold text-gray-900">비상구 표시 미비</p><p class="text-xs text-gray-500">1동 출입구</p></td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-yellow-100 text-yellow-700 font-medium">저위험</span></td>
                <td class="px-4 py-4 text-sm text-gray-700">1동</td>
                <td class="px-4 py-4 text-sm text-gray-700">(주)한국건설</td>
                <td class="px-4 py-4 text-sm text-gray-700">2026-06-30</td>
                <td class="px-4 py-4"><span class="text-xs px-2 py-1 rounded-full bg-red-100 text-red-700">조치 전</span></td>
                <td class="px-4 py-4"><a href="/actions/detail" class="text-xs text-[#FF6B35] hover:underline font-medium">상세보기</a></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="px-4 py-3 border-t border-gray-100 flex items-center justify-between text-sm text-gray-500">
          <span>총 94건</span>
          <div class="flex items-center gap-1">
            <button class="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50">이전</button>
            <button class="px-3 py-1 rounded bg-[#FF6B35] text-white">1</button>
            <button class="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50">2</button>
            <button class="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50">3</button>
            <button class="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50">다음</button>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>