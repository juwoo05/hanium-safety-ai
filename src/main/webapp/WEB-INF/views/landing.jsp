<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SafeMate - AI 현장 안전 솔루션</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>tailwind.config = { theme: { extend: {} } }</script>
</head>
<body class="min-h-screen bg-gradient-to-b from-[#F5F7FA] to-white">

<!-- Header -->
<header class="container mx-auto px-6 py-4 flex items-center justify-between">
  <div class="flex items-center gap-2">
    <div class="w-10 h-10 bg-[#1A2E44] rounded-lg flex items-center justify-center">
      <svg class="w-6 h-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
    </div>
    <span class="font-bold text-xl text-[#1A2E44]">SafeMate</span>
  </div>
  <div class="flex items-center gap-4">
    <button class="px-4 py-2 text-[#1A2E44] hover:text-[#1A2E44] transition-colors">제품 소개</button>
    <button class="px-4 py-2 text-[#1A2E44] hover:text-[#1A2E44] transition-colors">가격</button>
    <a href="/login" class="px-6 py-2 bg-[#1A2E44] text-white rounded-lg hover:bg-[#0F2233] transition-colors shadow-md">시작하기</a>
  </div>
</header>

<!-- Hero Section -->
<section class="container mx-auto px-6 py-16">
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
    <div>
      <div class="inline-block px-4 py-2 bg-[#1A2E44]/10 rounded-full mb-6">
        <span class="text-[#1A2E44] font-semibold text-sm">AI 기반 현장 안전 솔루션</span>
      </div>
      <h1 class="text-5xl lg:text-6xl font-bold text-[#1A2E44] mb-6 leading-tight">
        AI가 현장 위험을<br/>분석하고 안전 조치까지<br/>도와드립니다
      </h1>
      <p class="text-xl text-gray-600 mb-8 leading-relaxed">
        현장 사진 업로드부터 위험 탐지, 조치 등록, 리포트 관리까지<br/>
        현장 안전 업무를 한 번에 관리할 수 있는 스마트 안전 플랫폼
      </p>
      <div class="flex items-center gap-4 mb-8">
        <a href="/upload" class="px-8 py-4 bg-[#1A2E44] text-white text-lg font-semibold rounded-xl hover:bg-[#0F2233] transition-all shadow-lg hover:shadow-xl transform hover:-translate-y-1">현장 사진 분석하기</a>
        <a href="/dashboard" class="px-8 py-4 border-2 border-[#1A2E44] text-[#1A2E44] text-lg font-semibold rounded-xl hover:bg-[#1A2E44] hover:text-white transition-all">대시보드 보기</a>
      </div>
      <div class="flex items-center gap-8 text-sm text-gray-600">
        <div class="flex items-center gap-2"><div class="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center"><svg class="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg></div><span>무료 체험</span></div>
        <div class="flex items-center gap-2"><div class="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center"><svg class="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg></div><span>설치 불필요</span></div>
        <div class="flex items-center gap-2"><div class="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center"><svg class="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg></div><span>24시간 지원</span></div>
      </div>
    </div>
    <div class="relative">
      <div class="bg-[#F0F4F8] rounded-3xl p-12">
        <div class="flex flex-col items-center gap-3 mb-6">
          <img src="/images/mascot.png" alt="SafeMate 안전 도우미" class="w-32 h-32 object-contain" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
          <div class="relative bg-white rounded-2xl shadow-lg px-4 py-3 max-w-xs">
            <div class="absolute -top-2 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-8 border-l-transparent border-r-transparent border-b-white"></div>
            <p class="text-sm text-gray-700">사진을 올리면 AI가 위험 요소를 분석해드려요</p>
          </div>
        </div>
        <div class="bg-white rounded-2xl p-6 shadow-xl">
          <div class="flex items-center justify-between mb-4"><span class="text-sm text-gray-600">분석 진행 중...</span><span class="text-sm font-semibold text-[#1A2E44]">87%</span></div>
          <div class="w-full bg-gray-200 rounded-full h-2 mb-4"><div class="bg-[#1A2E44] h-2 rounded-full" style="width:87%"></div></div>
          <div class="space-y-2 text-sm">
            <div class="flex items-center gap-2"><div class="w-2 h-2 bg-red-500 rounded-full"></div><span class="text-gray-700">고위험 항목 3건 감지</span></div>
            <div class="flex items-center gap-2"><div class="w-2 h-2 bg-yellow-500 rounded-full"></div><span class="text-gray-700">중위험 항목 5건 감지</span></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Stats Section -->
<section class="bg-[#1A2E44] py-16">
  <div class="container mx-auto px-6">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center text-white">
      <div><div class="text-4xl font-bold mb-2">15,000+</div><div class="text-white/80">분석 완료</div></div>
      <div><div class="text-4xl font-bold mb-2">98.7%</div><div class="text-white/80">정확도</div></div>
      <div><div class="text-4xl font-bold mb-2">500+</div><div class="text-white/80">현장 사용</div></div>
      <div><div class="text-4xl font-bold mb-2">24시간</div><div class="text-white/80">실시간 지원</div></div>
    </div>
  </div>
</section>

<!-- Benefits Section -->
<section class="container mx-auto px-6 py-20">
  <div class="text-center mb-16">
    <h2 class="text-4xl font-bold text-[#1A2E44] mb-4">SafeMate를 선택해야 하는 이유</h2>
    <p class="text-xl text-gray-600">AI 기술로 현장 안전 관리가 달라집니다</p>
  </div>
  <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
    <div class="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-center">
      <div class="w-20 h-20 bg-blue-500 rounded-2xl flex items-center justify-center mx-auto mb-6"><span class="text-3xl font-bold text-white">70%</span></div>
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-3">시간 절약</h3>
      <p class="text-gray-600">수작업 점검 대비 70% 이상 시간 단축</p>
    </div>
    <div class="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-center">
      <div class="w-20 h-20 bg-green-500 rounded-2xl flex items-center justify-center mx-auto mb-6"><span class="text-3xl font-bold text-white">60%</span></div>
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-3">비용 절감</h3>
      <p class="text-gray-600">사고 예방으로 평균 60% 비용 감소</p>
    </div>
    <div class="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-center">
      <div class="w-20 h-20 bg-[#1A2E44] rounded-2xl flex items-center justify-center mx-auto mb-6"><span class="text-3xl font-bold text-white">98%</span></div>
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-3">정확성 향상</h3>
      <p class="text-gray-600">숙련 전문가 수준의 높은 정확도</p>
    </div>
  </div>
</section>

<!-- Process Section -->
<section class="bg-gradient-to-b from-[#F5F7FA] to-white py-20">
  <div class="container mx-auto px-6">
    <div class="text-center mb-16">
      <h2 class="text-4xl font-bold text-[#1A2E44] mb-4">간단한 3단계로 시작하세요</h2>
      <p class="text-xl text-gray-600">복잡한 설정 없이 바로 사용 가능합니다</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
      <div class="bg-white rounded-2xl p-8 shadow-md hover:shadow-lg transition-shadow">
        <div class="text-6xl font-bold text-[#1A2E44]/20 mb-4">01</div>
        <h3 class="text-xl font-bold text-[#1A2E44] mb-3">현장 사진 업로드</h3>
        <p class="text-gray-600 leading-relaxed">스마트폰으로 찍은 현장 사진을 드래그 앤 드롭으로 간편하게 업로드하세요</p>
      </div>
      <div class="bg-white rounded-2xl p-8 shadow-md hover:shadow-lg transition-shadow">
        <div class="text-6xl font-bold text-[#1A2E44]/20 mb-4">02</div>
        <h3 class="text-xl font-bold text-[#1A2E44] mb-3">AI 자동 분석</h3>
        <p class="text-gray-600 leading-relaxed">AI가 위험 요소를 자동으로 감지하고 위험도를 평가합니다</p>
      </div>
      <div class="bg-white rounded-2xl p-8 shadow-md hover:shadow-lg transition-shadow">
        <div class="text-6xl font-bold text-[#1A2E44]/20 mb-4">03</div>
        <h3 class="text-xl font-bold text-[#1A2E44] mb-3">조치 및 리포트</h3>
        <p class="text-gray-600 leading-relaxed">감지된 위험에 대한 조치를 등록하고 리포트를 생성합니다</p>
      </div>
    </div>
  </div>
</section>

<!-- Features -->
<section class="container mx-auto px-6 py-20">
  <h2 class="text-4xl font-bold text-[#1A2E44] text-center mb-4">SafeMate의 핵심 기능</h2>
  <p class="text-xl text-gray-600 text-center mb-12">현장 안전 관리에 필요한 모든 기능을 제공합니다</p>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">AI 위험 분석</h3>
      <p class="text-gray-600">사진을 업로드하면 AI가 자동으로 위험 요소를 분석합니다</p>
    </div>
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">실시간 모니터링</h3>
      <p class="text-gray-600">현장의 안전 상황을 실시간으로 모니터링하고 대응합니다</p>
    </div>
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">스마트 리포팅</h3>
      <p class="text-gray-600">조치 현황을 한눈에 파악하고 리포트를 자동 생성합니다</p>
    </div>
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">데이터 분석</h3>
      <p class="text-gray-600">현장별, 기간별 안전 통계를 분석하여 인사이트를 제공합니다</p>
    </div>
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">협업 관리</h3>
      <p class="text-gray-600">담당자 지정, 알림, 댓글로 팀 협업을 강화합니다</p>
    </div>
    <div class="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
      <div class="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4"><svg class="w-6 h-6 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
      <h3 class="text-lg font-semibold text-[#1A2E44] mb-2">규정 준수</h3>
      <p class="text-gray-600">안전 규정 체크리스트와 감사 자료를 자동으로 관리합니다</p>
    </div>
  </div>
</section>

<!-- Pricing -->
<section class="container mx-auto px-6 py-20">
  <h2 class="text-3xl font-bold text-[#1A2E44] text-center mb-12">간편한 요금제</h2>
  <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
    <div class="bg-white rounded-2xl p-8 shadow-md">
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-4">Basic</h3>
      <div class="mb-6"><span class="text-3xl font-bold text-[#1A2E44]">₩99,000</span><span class="text-gray-600">/월</span></div>
      <ul class="space-y-3 mb-8">
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>현장 5개</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>월 100건 조치</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>기본 리포트</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>이메일 지원</li>
      </ul>
      <button class="w-full py-3 rounded-lg font-semibold border-2 border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44] hover:text-white transition-colors">시작하기</button>
    </div>
    <div class="bg-white rounded-2xl p-8 shadow-md ring-2 ring-[#1A2E44] relative">
      <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-[#1A2E44] text-white px-4 py-1 rounded-full text-sm font-semibold">인기</div>
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-4">Pro</h3>
      <div class="mb-6"><span class="text-3xl font-bold text-[#1A2E44]">₩249,000</span><span class="text-gray-600">/월</span></div>
      <ul class="space-y-3 mb-8">
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>현장 20개</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>월 500건 조치</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>고급 분석</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>AI 위험 분석</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>우선 지원</li>
      </ul>
      <button class="w-full py-3 rounded-lg font-semibold bg-[#1A2E44] text-white hover:bg-[#0F2233] transition-colors">시작하기</button>
    </div>
    <div class="bg-white rounded-2xl p-8 shadow-md">
      <h3 class="text-2xl font-bold text-[#1A2E44] mb-4">Enterprise</h3>
      <div class="mb-6"><span class="text-3xl font-bold text-[#1A2E44]">문의</span></div>
      <ul class="space-y-3 mb-8">
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>무제한 현장</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>무제한 조치</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>맞춤형 리포트</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>API 연동</li>
        <li class="flex items-center gap-2 text-gray-600"><div class="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><div class="w-2 h-2 rounded-full bg-[#1A2E44]"></div></div>전담 매니저</li>
      </ul>
      <button class="w-full py-3 rounded-lg font-semibold border-2 border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44] hover:text-white transition-colors">문의하기</button>
    </div>
  </div>
</section>

<!-- Final CTA -->
<section class="bg-gradient-to-r from-[#1A2E44] to-[#2C5282] py-20">
  <div class="container mx-auto px-6 text-center">
    <div class="flex flex-col items-center gap-3 mb-8">
      <img src="/images/mascot.png" alt="SafeMate 마스코트" class="w-32 h-32 object-contain" style="filter:drop-shadow(0 6px 14px rgba(15,32,56,0.22))"/>
      <div class="relative bg-white rounded-2xl shadow-lg px-4 py-3 max-w-xs">
        <div class="absolute -top-2 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-8 border-l-transparent border-r-transparent border-b-white"></div>
        <p class="text-sm text-gray-700">오늘은 고위험 항목 3건을 먼저 확인해보세요</p>
      </div>
    </div>
    <h2 class="text-4xl font-bold text-white mb-6">지금 바로 SafeMate를 시작하세요</h2>
    <p class="text-xl text-white/90 mb-10 max-w-2xl mx-auto">14일 무료 체험으로 현장 안전 관리의 새로운 경험을 시작하세요.<br/>신용카드 등록 없이 즉시 사용 가능합니다.</p>
    <div class="flex items-center justify-center gap-4">
      <a href="/signup" class="px-10 py-5 bg-[#1A2E44] text-white text-lg font-semibold rounded-xl hover:bg-[#0F2233] transition-all shadow-2xl transform hover:-translate-y-1">무료로 시작하기</a>
      <a href="/login" class="px-10 py-5 bg-white text-[#1A2E44] text-lg font-semibold rounded-xl hover:bg-gray-100 transition-all shadow-xl">영업팀 문의하기</a>
    </div>
  </div>
</section>

<!-- Footer -->
<footer class="bg-[#1A2E44] text-white py-16 border-t border-white/10">
  <div class="container mx-auto px-6">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
      <div class="md:col-span-1">
        <div class="flex items-center gap-2 mb-4">
          <div class="w-10 h-10 bg-[#1A2E44] rounded-lg flex items-center justify-center"><svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
          <span class="font-bold text-xl">SafeMate</span>
        </div>
        <p class="text-gray-300 mb-4">AI가 지켜주는<br/>현장 안전 관리 시스템</p>
        <p class="text-gray-400 text-sm">© 2026 SafeMate.<br/>All rights reserved.</p>
      </div>
      <div>
        <h4 class="font-semibold mb-4">제품</h4>
        <ul class="space-y-2 text-gray-300">
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">기능 소개</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">가격 안내</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">고객 사례</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">업데이트</a></li>
        </ul>
      </div>
      <div>
        <h4 class="font-semibold mb-4">지원</h4>
        <ul class="space-y-2 text-gray-300">
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">도움말 센터</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">사용 가이드</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">API 문서</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">문의하기</a></li>
        </ul>
      </div>
      <div>
        <h4 class="font-semibold mb-4">회사</h4>
        <ul class="space-y-2 text-gray-300">
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">회사 소개</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">블로그</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">채용</a></li>
          <li><a href="#" class="hover:text-[#1A2E44] transition-colors">파트너십</a></li>
        </ul>
      </div>
    </div>
    <div class="border-t border-white/10 pt-8">
      <div class="flex flex-col md:flex-row justify-between items-center gap-4">
        <div class="flex items-center gap-6 text-sm text-gray-400">
          <a href="#" class="hover:text-white transition-colors">이용약관</a>
          <a href="#" class="hover:text-white transition-colors">개인정보처리방침</a>
          <a href="#" class="hover:text-white transition-colors">쿠키 정책</a>
        </div>
        <div class="flex items-center gap-4">
          <span class="text-gray-400 text-sm">고객센터: 1588-1234</span>
          <span class="text-gray-400 text-sm">|</span>
          <span class="text-gray-400 text-sm">support@safemate.com</span>
        </div>
      </div>
    </div>
  </div>
</footer>

</body>
</html>
