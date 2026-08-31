<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>마이페이지 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F5F7FA] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <h1 class="text-lg font-semibold text-gray-900">마이페이지</h1>
    <div class="flex items-center gap-3">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
    </div>
  </header>
  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="flex gap-6 min-h-[calc(100vh-120px)] max-w-6xl mx-auto">

      <!-- 좌측 사이드바 -->
      <aside class="w-56 flex-shrink-0 hidden lg:block">
        <div class="bg-white rounded shadow-sm border border-gray-100 overflow-hidden sticky top-4">
          <div class="px-5 py-5 bg-gradient-to-br from-[#1A2E44] to-[#003b5c]">
            <div id="profileInitial" class="w-11 h-11 rounded-full bg-[#1A2E44] flex items-center justify-center mb-3"><span class="text-white font-bold text-lg">-</span></div>
            <p id="profileName" class="text-white font-semibold text-sm">불러오는 중...</p>
            <span id="profileRoleBadge" class="inline-block mt-1 text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#1A2E44]/30 text-orange-200"></span>
          </div>

          <nav class="py-2" id="menuNav">
            <button type="button" data-menu="profile" onclick="switchMenu('profile', this)" class="menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left bg-[#1A2E44]/8 text-[#1A2E44] border-r-2 border-[#1A2E44] font-semibold">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/></svg>내 정보
            </button>
            <button type="button" data-menu="account" onclick="switchMenu('account', this)" class="menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left text-gray-600 hover:bg-gray-50 hover:text-gray-900">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>계정 설정
            </button>
            <button type="button" id="menuBtnSites" data-menu="sites" onclick="switchMenu('sites', this)" class="hidden menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left text-gray-600 hover:bg-gray-50 hover:text-gray-900">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01M12 6h.01M16 6h.01M8 10h.01M12 10h.01M16 10h.01M8 14h.01M12 14h.01M16 14h.01"/></svg>건설사 및 현장 연동
            </button>
            <button type="button" data-menu="stats" onclick="switchMenu('stats', this)" class="menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left text-gray-600 hover:bg-gray-50 hover:text-gray-900">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>활동 통계
            </button>
            <button type="button" data-menu="settings" onclick="switchMenu('settings', this)" class="menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left text-gray-600 hover:bg-gray-50 hover:text-gray-900">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>알림 설정
            </button>
            <button type="button" data-menu="security" onclick="switchMenu('security', this)" class="menu-btn w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left text-gray-600 hover:bg-gray-50 hover:text-gray-900">
              <svg class="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>보안 설정
            </button>
          </nav>

          <div class="border-t border-gray-100 p-3">
            <form action="/logout" method="post">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <button type="submit" class="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 rounded transition-colors font-medium">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>로그아웃
              </button>
            </form>
          </div>
        </div>
      </aside>

      <!-- 우측 콘텐츠 -->
      <div class="flex-1 min-w-0 space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-1">마이페이지 › 설정</p>
            <h1 id="menuTitle" class="text-xl font-bold text-gray-900">내 정보</h1>
          </div>
          <div class="lg:hidden">
            <select id="mobileMenuSelect" onchange="switchMenu(this.value, null)" class="px-3 py-2 border border-gray-200 rounded text-sm outline-none bg-white">
              <option value="profile">내 정보</option>
              <option value="account">계정 설정</option>
              <option id="mobileMenuSitesOption" value="sites" class="hidden">건설사 및 현장 연동</option>
              <option value="stats">활동 통계</option>
              <option value="settings">알림 설정</option>
              <option value="security">보안 설정</option>
            </select>
          </div>
        </div>

        <!-- panel: 내 정보 -->
        <div id="panel-profile" class="bg-white rounded shadow-sm border border-gray-100 p-6 space-y-5">
          <p id="profileSaveMessage" class="hidden text-sm px-4 py-2.5 rounded"></p>
          <form id="profileForm" class="space-y-5">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1.5">이름</label>
                <input id="profileUsernameInput" type="text" required class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent transition-all"/>
              </div>
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1.5">역할</label>
                <input id="profileRoleInput" type="text" readonly class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm bg-gray-50 text-gray-500 outline-none"/>
              </div>
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1.5">이메일 (로그인 아이디)</label>
                <input id="profileEmailInput" type="email" readonly class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm bg-gray-50 text-gray-500 outline-none"/>
              </div>
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1.5">소속 업체</label>
                <input id="profileCompanyInput" type="text" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent transition-all"/>
              </div>
            </div>
            <div class="pt-1">
              <button type="submit" class="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">저장</button>
            </div>
          </form>
        </div>

        <!-- panel: 계정 설정 (비밀번호 변경) -->
        <div id="panel-account" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-5">
          <p id="passwordChangeMessage" class="hidden text-sm px-4 py-2.5 rounded"></p>
          <form id="passwordChangeForm" class="space-y-4 max-w-md">
            <div>
              <label class="block text-xs font-semibold text-gray-500 mb-1.5">현재 비밀번호</label>
              <input id="currentPasswordInput" type="password" required placeholder="현재 비밀번호" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/>
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-500 mb-1.5">새 비밀번호</label>
              <input id="newPasswordInput" type="password" required placeholder="6자 이상" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/>
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-500 mb-1.5">새 비밀번호 확인</label>
              <input id="newPasswordConfirmInput" type="password" required placeholder="새 비밀번호 재입력" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/>
            </div>
            <button type="submit" class="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">비밀번호 변경</button>
          </form>
        </div>

        <!-- panel: 건설사 및 현장 연동 -->
        <div id="panel-sites" class="hidden space-y-6">

          <div id="siteRoleBanner" class="flex items-center gap-3 px-5 py-3 rounded border text-sm font-medium"></div>

          <!-- 원청 전용: §1 내 건설사 정보 -->
          <div id="ownerCompanySection" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-5">
            <div class="flex items-start gap-3">
              <div class="w-9 h-9 rounded bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4"/></svg></div>
              <div class="flex-1">
                <div class="flex items-center gap-2"><h2 class="text-base font-bold text-gray-900">내 건설사 정보</h2><span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#1A2E44]/10 text-[#1A2E44]">원청</span></div>
                <p class="text-xs text-gray-500 mt-0.5">건설사 정보를 등록합니다.</p>
              </div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-gray-500 mb-1.5">건설사명</label><input id="companyNameInput" placeholder="건설사명" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/></div>
              <div><label class="block text-xs font-semibold text-gray-500 mb-1.5">사업자등록번호</label><input id="companyBizNoInput" placeholder="예) 123-45-67890" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/></div>
              <div><label class="block text-xs font-semibold text-gray-500 mb-1.5">대표자명</label><input id="companyCeoInput" placeholder="대표자명" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/></div>
              <div><label class="block text-xs font-semibold text-gray-500 mb-1.5">본사 주소</label><input id="companyAddressInput" placeholder="본사 주소" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all"/></div>
            </div>
            <p id="companySaveMessage" class="hidden text-sm px-4 py-2.5 rounded"></p>
            <div class="flex flex-wrap gap-3 pt-1">
              <button id="kisconSearchBtn" type="button" class="flex items-center gap-2 px-5 py-2.5 border-2 border-[#1A2E44] text-[#1A2E44] rounded text-sm font-semibold hover:bg-[#1A2E44]/5 transition-colors">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>조회
              </button>
              <button id="saveCompanyBtn" type="button" class="px-5 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">저장</button>
            </div>
            <div id="kisconResultsWrap" class="hidden border border-gray-200 rounded divide-y divide-gray-100 max-h-56 overflow-y-auto"></div>
            <p id="kisconMessage" class="hidden text-sm px-4 py-2.5 rounded"></p>
            <p class="text-[11px] text-gray-400">※ 건설사명으로 검색하면 국토교통부 KISCON 공시 자료에서 일치하는 업체를 찾아드립니다. 목록에서 선택하면 정보가 자동으로 채워집니다.</p>
          </div>

          <!-- 원청 전용: §2 현장 등록/선택 -->
          <div id="ownerSiteSection" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-5">
            <div class="flex items-start justify-between gap-3">
              <div class="flex items-start gap-3">
                <div class="w-9 h-9 rounded bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg></div>
                <div>
                  <div class="flex items-center gap-2"><h2 class="text-base font-bold text-gray-900">진행 중인 현장</h2><span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#1A2E44]/10 text-[#1A2E44]">원청</span></div>
                  <p class="text-xs text-gray-500 mt-0.5">현장을 선택하면 공유 코드를 발급할 수 있습니다.</p>
                </div>
              </div>
              <button id="showAddSiteFormBtn" type="button" class="text-sm text-[#1A2E44] font-semibold hover:underline whitespace-nowrap">+ 새 현장 등록</button>
            </div>

            <div id="addSiteForm" class="hidden border-2 border-dashed border-gray-200 rounded p-4 space-y-3">
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <input id="newSiteNameInput" placeholder="현장명" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                <input id="newSiteAddressInput" placeholder="현장 주소" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                <input id="newSiteWorkTypeInput" placeholder="공사 구분 (예: 건축공사)" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                <div class="flex gap-2">
                  <input id="newSitePeriodStartInput" type="date" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                  <input id="newSitePeriodEndInput" type="date" class="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
                </div>
              </div>
              <div class="flex justify-end gap-2">
                <button id="cancelAddSiteBtn" type="button" class="px-4 py-2 border border-gray-300 text-gray-600 rounded text-sm font-semibold hover:bg-gray-50 transition-colors">취소</button>
                <button id="addSiteBtn" type="button" class="px-4 py-2 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#0F2233] transition-colors">등록</button>
              </div>
            </div>

            <div class="relative max-w-sm">
              <select id="siteSelect" onchange="onSiteSelected(this.value)" class="w-full px-4 py-3 border-2 border-gray-200 rounded text-sm appearance-none outline-none focus:border-[#1A2E44] bg-white pr-10 transition-colors">
                <option value="">현장을 선택하세요</option>
              </select>
              <svg class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </div>

            <div id="siteEmptyHint" class="flex flex-col items-center justify-center py-10 text-gray-300 border-2 border-dashed border-gray-200 rounded">
              <svg class="w-8 h-8 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
              <p class="text-sm text-gray-400">위에서 현장을 선택하면 상세 정보가 표시됩니다</p>
            </div>

            <div id="siteDetailCard" class="hidden border-2 border-[#1A2E44]/20 rounded overflow-hidden">
              <div class="bg-[#1A2E44] px-5 py-4 flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 bg-white/10 rounded flex items-center justify-center"><svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M2 20a6 6 0 0 1 12 0"/><circle cx="8" cy="9" r="4"/><path d="M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3"/></svg></div>
                  <div><p id="siteDetailName" class="text-white font-bold"></p><p class="text-white/60 text-xs">등록한 현장</p></div>
                </div>
              </div>
              <div id="siteDetailBody" class="p-5 bg-white grid grid-cols-1 sm:grid-cols-2 gap-4"></div>
            </div>
          </div>

          <!-- 원청 전용: §3 하청 공유 코드 -->
          <div id="ownerCodeSection" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-4">
            <div class="flex items-start gap-3">
              <div class="w-9 h-9 rounded bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 17H7A5 5 0 0 1 7 7h2"/><path d="M15 7h2a5 5 0 1 1 0 10h-2"/><line x1="8" y1="12" x2="16" y2="12"/></svg></div>
              <div><div class="flex items-center gap-2"><h2 class="text-base font-bold text-gray-900">하청 공유 코드</h2><span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#1A2E44]/10 text-[#1A2E44]">원청</span></div>
              <p class="text-xs text-gray-500 mt-0.5">선택한 현장의 공유 코드를 하청 업체에 전달하세요.</p></div>
            </div>
            <div id="codeSectionHint" class="text-sm text-gray-400">먼저 위에서 현장을 선택해주세요.</div>
            <div id="codeSectionBody" class="hidden space-y-4">
              <div class="relative rounded overflow-hidden border-2 border-[#1A2E44]/20">
                <div class="bg-[#1A2E44]/5 border-b border-[#1A2E44]/10 px-4 py-2.5 flex items-center gap-2">
                  <div class="w-2 h-2 rounded-full bg-green-400"></div><span class="text-xs font-semibold text-gray-600">현장 공유 코드</span>
                </div>
                <div class="bg-white px-6 py-6 flex items-center justify-between flex-wrap gap-3">
                  <p id="siteCodeValue" class="text-3xl font-bold tracking-widest text-[#1A2E44] font-mono"></p>
                  <div class="flex items-center gap-2">
                    <button id="copySiteCodeBtn" type="button" class="flex items-center gap-2 px-4 py-2.5 border-2 border-[#1A2E44] text-[#1A2E44] rounded text-sm font-semibold hover:bg-[#1A2E44]/5 transition-colors">복사</button>
                    <button id="regenSiteCodeBtn" type="button" class="flex items-center gap-2 px-4 py-2.5 border-2 border-gray-200 text-gray-600 rounded text-sm font-semibold hover:bg-gray-50 transition-colors">재발급</button>
                  </div>
                </div>
              </div>
              <div class="flex items-start gap-3 p-4 bg-blue-50 border border-blue-200 rounded">
                <svg class="w-4 h-4 text-blue-500 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <p class="text-xs text-blue-800 leading-relaxed">이 코드를 하청 업체 담당자에게 전달하면 해당 현장과 원청 정보가 자동 연결됩니다.</p>
              </div>
            </div>
          </div>

          <!-- 원청 전용: §4 연결된 하청 업체 -->
          <div id="ownerSubcontractorsSection" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-4">
            <div class="flex items-start gap-3">
              <div class="w-9 h-9 rounded bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-[#1A2E44]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
              <div><div class="flex items-center gap-2"><h2 class="text-base font-bold text-gray-900">연결된 하청 업체</h2><span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#1A2E44]/10 text-[#1A2E44]">원청</span></div>
              <p class="text-xs text-gray-500 mt-0.5">내 현장들에 공유 코드로 연결된 하청 업체 목록입니다.</p></div>
            </div>
            <div id="subcontractorsTableWrap" class="overflow-x-auto rounded border border-gray-200">
              <table class="w-full text-sm min-w-[560px]">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">하청 업체명</th>
                    <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">담당자</th>
                    <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">연결 현장</th>
                    <th class="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">연결일</th>
                  </tr>
                </thead>
                <tbody id="subcontractorsTableBody" class="divide-y divide-gray-100 bg-white"></tbody>
              </table>
            </div>
          </div>

          <!-- 하청 전용: §5 코드 입력 -->
          <div id="subJoinSection" class="hidden bg-gradient-to-br from-green-50/80 to-white rounded shadow-sm border border-green-200 p-6 space-y-4">
            <div class="flex items-start gap-3">
              <div class="w-9 h-9 rounded bg-green-100 flex items-center justify-center flex-shrink-0"><svg class="w-5 h-5 text-green-700" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 17H7A5 5 0 0 1 7 7h2"/><path d="M15 7h2a5 5 0 1 1 0 10h-2"/><line x1="8" y1="12" x2="16" y2="12"/></svg></div>
              <div><div class="flex items-center gap-2"><h2 class="text-base font-bold text-gray-900">원청 현장 연결</h2><span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-green-100 text-green-700">하청</span></div>
              <p class="text-xs text-gray-500 mt-0.5">원청에게 받은 현장 공유 코드를 입력하면 자동으로 연결됩니다.</p></div>
            </div>
            <p id="joinSiteMessage" class="hidden text-sm px-4 py-2.5 rounded"></p>
            <div class="flex gap-3 max-w-md">
              <input id="inviteCodeInput" placeholder="예) SITE-8F3K2Q" maxlength="12" class="flex-1 px-4 py-3 border-2 border-gray-200 rounded text-sm font-mono tracking-widest outline-none focus:border-[#1A2E44] transition-all uppercase"/>
              <button id="joinSiteBtn" type="button" class="px-5 py-3 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors whitespace-nowrap">연결하기</button>
            </div>
          </div>

          <!-- 하청 전용: 참여한 현장 목록 -->
          <div id="subJoinedSection" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6 space-y-4">
            <h2 class="text-base font-bold text-gray-900">참여한 현장</h2>
            <div id="joinedSitesList" class="space-y-3"></div>
          </div>

        </div>

        <!-- panel: 활동 통계 -->
        <div id="panel-stats" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <div class="text-center p-4 bg-gray-50 rounded"><p id="statTotalUploads" class="text-2xl font-bold text-gray-900">-</p><p class="text-xs text-gray-500 mt-1">총 업로드</p></div>
            <div class="text-center p-4 bg-gray-50 rounded"><p id="statRiskDetected" class="text-2xl font-bold text-[#1A2E44]">-</p><p class="text-xs text-gray-500 mt-1">위험 감지</p></div>
            <div class="text-center p-4 bg-gray-50 rounded"><p id="statActionsCompleted" class="text-2xl font-bold text-green-600">-</p><p class="text-xs text-gray-500 mt-1">조치 완료</p></div>
            <div class="text-center p-4 bg-gray-50 rounded"><p id="statSafetyScore" class="text-2xl font-bold text-purple-600">-</p><p class="text-xs text-gray-500 mt-1">안전 점수</p></div>
          </div>
          <h3 class="text-sm font-semibold text-gray-700 mb-3">월별 업로드 현황</h3>
          <div id="monthlyUploadChart" class="flex items-end gap-1.5 h-32 bg-gray-50 rounded p-4"></div>
          <div class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
            <div class="bg-green-50 rounded p-3 border border-green-100"><p class="text-xs text-gray-500 mb-1">이번 달 업로드</p><p id="statThisMonth" class="text-xl font-bold text-gray-900">-</p></div>
            <div class="bg-blue-50 rounded p-3 border border-blue-100"><p class="text-xs text-gray-500 mb-1">조치 완료율</p><p id="statCompletionRate" class="text-xl font-bold text-gray-900">-</p></div>
          </div>
        </div>

        <!-- panel: 알림 설정 -->
        <div id="panel-settings" class="hidden bg-white rounded shadow-sm border border-gray-100 p-6">
          <div class="space-y-4">
            <% String[] notiLabels={"고위험 감지 즉시 알림","조치 마감 D-1 알림","조치 완료 알림","일일 안전 요약 리포트","AI 인사이트 알림"}; boolean[] notiDefaults={true,true,true,false,true}; %>
            <% for(int i=0;i<notiLabels.length;i++){ String checked=notiDefaults[i]?"checked":""; String bg=notiDefaults[i]?"bg-[#1A2E44]":"bg-gray-300"; %>
            <div class="flex items-center justify-between p-4 border border-gray-100 rounded hover:border-gray-200 transition-colors">
              <div><p class="text-sm font-semibold text-gray-900"><%=notiLabels[i]%></p></div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" <%=checked%> class="sr-only peer" onchange="this.parentElement.querySelector('div').className='w-11 h-6 rounded-full peer peer-checked:bg-[#1A2E44] bg-gray-300 after:content-[\'\'] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full'"/>
                <div class="w-11 h-6 <%=bg%> rounded-full transition-colors after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all <%=notiDefaults[i]?"after:translate-x-full":""%>"></div>
              </label>
            </div>
            <% } %>
            <div class="mt-2">
              <label class="block text-sm font-semibold text-gray-700 mb-2">알림 수신 방법</label>
              <div class="flex gap-3">
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked class="accent-[#1A2E44]"/><span class="text-sm text-gray-700">앱 푸시</span></label>
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked class="accent-[#1A2E44]"/><span class="text-sm text-gray-700">이메일</span></label>
                <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" class="accent-[#1A2E44]"/><span class="text-sm text-gray-700">문자 SMS</span></label>
              </div>
            </div>
            <div class="flex justify-end pt-2"><button class="px-6 py-2.5 bg-[#1A2E44] text-white rounded font-semibold hover:bg-[#0F2233] transition-colors shadow-md">저장</button></div>
          </div>
        </div>

        <!-- panel: 보안 설정 -->
        <div id="panel-security" class="hidden space-y-5">
          <div class="bg-white rounded shadow-sm border border-gray-100 p-5">
            <h3 class="text-sm font-semibold text-gray-900 mb-4">비밀번호 변경은 "계정 설정" 메뉴에서 하실 수 있습니다.</h3>
          </div>
          <div class="bg-white rounded shadow-sm border border-gray-100 p-5">
            <div class="flex items-center justify-between mb-3">
              <h3 class="text-sm font-semibold text-gray-900">2단계 인증</h3>
              <span id="twoFactorStatusBadge" class="text-xs px-2 py-0.5 bg-red-100 text-red-600 rounded-full font-medium">미설정</span>
            </div>
            <p class="text-xs text-gray-500 mb-3">로그인 시 이메일로 전송되는 인증 코드를 추가로 입력해 계정을 더 안전하게 보호하세요.</p>
            <p id="twoFactorMessage" class="hidden text-sm mb-3 px-4 py-2.5 rounded"></p>
            <button id="twoFactorToggleBtn" type="button" class="px-4 py-2 border border-[#1A2E44] text-[#1A2E44] rounded text-sm font-semibold hover:bg-[#1A2E44] hover:text-white transition-colors">2단계 인증 켜기</button>
          </div>
          <div class="bg-red-50 rounded border border-red-100 p-5">
            <p id="withdrawMessage" class="hidden text-sm mb-3 px-4 py-2.5 rounded"></p>
            <button id="showWithdrawFormBtn" type="button" class="px-4 py-2 border border-red-400 text-red-600 rounded text-sm font-semibold hover:bg-red-500 hover:text-white transition-colors">계정 탈퇴</button>
            <form id="withdrawForm" class="hidden mt-4 space-y-3">
              <p class="text-xs text-red-700 font-medium">탈퇴하면 로그아웃되며 계정을 다시 사용할 수 없습니다. 비밀번호를 입력해 확인해주세요.</p>
              <input id="withdrawPasswordInput" type="password" required placeholder="현재 비밀번호" class="w-full px-4 py-2.5 border border-red-300 rounded text-sm focus:ring-2 focus:ring-red-400 focus:border-transparent outline-none"/>
              <div class="flex justify-end gap-2">
                <button type="button" id="cancelWithdrawBtn" class="px-4 py-2 border border-gray-300 text-gray-600 rounded text-sm font-semibold hover:bg-gray-50 transition-colors">취소</button>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded text-sm font-semibold hover:bg-red-700 transition-colors">탈퇴하기</button>
              </div>
            </form>
          </div>
        </div>

      </div>
    </div>
  </main>
</div>
<script>
var ROLE_LABELS = { '원청': '원청', '하청': '하청' };
var MENU_TITLES = { profile: '내 정보', account: '계정 설정', sites: '건설사 및 현장 연동', stats: '활동 통계', settings: '알림 설정', security: '보안 설정' };
var CURRENT_ROLE = null;
var mySites = [];
var selectedSite = null;

function switchMenu(name, btn) {
  ['profile','account','sites','stats','settings','security'].forEach(function (m) {
    document.getElementById('panel-' + m).classList.add('hidden');
  });
  document.getElementById('panel-' + name).classList.remove('hidden');
  document.getElementById('menuTitle').textContent = MENU_TITLES[name];
  document.getElementById('mobileMenuSelect').value = name;

  document.querySelectorAll('.menu-btn').forEach(function (b) {
    b.className = b.className.replace('bg-[#1A2E44]/8 text-[#1A2E44] border-r-2 border-[#1A2E44] font-semibold', 'text-gray-600 hover:bg-gray-50 hover:text-gray-900');
  });
  var target = btn || document.querySelector('.menu-btn[data-menu="' + name + '"]');
  if (target) target.className = target.className.replace('text-gray-600 hover:bg-gray-50 hover:text-gray-900', 'bg-[#1A2E44]/8 text-[#1A2E44] border-r-2 border-[#1A2E44] font-semibold');

  if (name === 'stats') loadStats();
  if (name === 'sites') loadSitesPanel();
}

function showMessage(el, text, ok) {
  el.textContent = text;
  el.className = 'text-sm px-4 py-2.5 rounded ' + (ok ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-red-50 text-red-700 border border-red-200');
}

function loadProfile() {
  fetch('/api/users/me/profile')
    .then(function (res) { if (res.status === 401) { window.location.href = '/login'; throw new Error(); } if (!res.ok) throw new Error(); return res.json(); })
    .then(function (u) {
      CURRENT_ROLE = u.role;
      document.querySelector('#profileInitial span').textContent = u.username ? u.username.charAt(0) : '?';
      document.getElementById('profileName').textContent = u.username || '';
      document.getElementById('profileRoleBadge').textContent = ROLE_LABELS[u.role] || u.role;
      var isSub = u.role === '하청';
      document.getElementById('profileInitial').className = 'w-11 h-11 rounded-full flex items-center justify-center mb-3 ' + (isSub ? 'bg-green-500' : 'bg-[#1A2E44]');
      document.getElementById('profileRoleBadge').className = 'inline-block mt-1 text-[10px] font-bold px-2 py-0.5 rounded-full ' + (isSub ? 'bg-green-500/30 text-green-200' : 'bg-[#1A2E44]/30 text-orange-200');
      document.getElementById('profileUsernameInput').value = u.username || '';
      document.getElementById('profileRoleInput').value = ROLE_LABELS[u.role] || u.role;
      document.getElementById('profileEmailInput').value = u.email || '';
      document.getElementById('profileCompanyInput').value = u.companyName || '';
      document.getElementById('companyNameInput').value = u.companyName || '';
      document.getElementById('companyBizNoInput').value = u.companyBizNo || '';
      document.getElementById('companyCeoInput').value = u.companyCeoName || '';
      document.getElementById('companyAddressInput').value = u.companyAddress || '';
      renderTwoFactorState(u.twoFactorEnabled);

      document.getElementById('menuBtnSites').classList.remove('hidden');
      document.getElementById('mobileMenuSitesOption').classList.remove('hidden');
      renderSiteRoleUi(u.role);
    })
    .catch(function () {});
}

function renderTwoFactorState(enabled) {
  var badge = document.getElementById('twoFactorStatusBadge');
  var btn = document.getElementById('twoFactorToggleBtn');
  btn.dataset.enabled = enabled ? 'true' : 'false';
  if (enabled) {
    badge.textContent = '사용 중';
    badge.className = 'text-xs px-2 py-0.5 bg-green-100 text-green-700 rounded-full font-medium';
    btn.textContent = '2단계 인증 끄기';
  } else {
    badge.textContent = '미설정';
    badge.className = 'text-xs px-2 py-0.5 bg-red-100 text-red-600 rounded-full font-medium';
    btn.textContent = '2단계 인증 켜기';
  }
}

function loadStats() {
  fetch('/api/users/me/stats')
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (s) {
      document.getElementById('statTotalUploads').textContent = s.totalUploads;
      document.getElementById('statRiskDetected').textContent = s.riskDetected;
      document.getElementById('statActionsCompleted').textContent = s.actionsCompleted;
      document.getElementById('statSafetyScore').textContent = s.safetyScore + '점';
      document.getElementById('statThisMonth').textContent = s.thisMonthUploads + '건';
      document.getElementById('statCompletionRate').textContent = Math.round(s.actionCompletionRate) + '%';

      var max = Math.max.apply(null, s.monthlyUploads.concat([1]));
      var chart = document.getElementById('monthlyUploadChart');
      chart.innerHTML = s.monthlyUploads.map(function (count, i) {
        var pct = Math.round(count * 100 / max);
        return '<div class="flex-1 flex flex-col items-center gap-1">' +
          '<div class="w-full bg-[#1A2E44] rounded-t" style="height:' + pct + '%;min-height:3px;max-height:80px"></div>' +
          '<span class="text-[10px] text-gray-400">' + (i + 1) + '</span></div>';
      }).join('');
    })
    .catch(function () {});
}

/* ── 건설사 및 현장 연동 ── */

function renderSiteRoleUi(role) {
  var banner = document.getElementById('siteRoleBanner');
  if (role === '하청') {
    banner.className = 'flex items-center gap-3 px-5 py-3 rounded border text-sm font-medium bg-green-50 border-green-200 text-green-800';
    banner.innerHTML = '<div class="w-6 h-6 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0"><span class="text-white text-[10px] font-bold">하</span></div>하청 사용자 — 원청에게 받은 공유 코드를 입력해 현장에 연결할 수 있습니다.';
    document.getElementById('subJoinSection').classList.remove('hidden');
    document.getElementById('subJoinedSection').classList.remove('hidden');
    loadJoinedSites();
  } else {
    banner.className = 'flex items-center gap-3 px-5 py-3 rounded border text-sm font-medium bg-[#1A2E44]/5 border-[#1A2E44]/20 text-[#1A2E44]';
    banner.innerHTML = '<div class="w-6 h-6 rounded-full bg-[#1A2E44] flex items-center justify-center flex-shrink-0"><span class="text-white text-[10px] font-bold">원</span></div>원청 사용자 — 건설사 및 현장을 등록하고 하청 공유 코드를 생성할 수 있습니다.';
    document.getElementById('ownerCompanySection').classList.remove('hidden');
    document.getElementById('ownerSiteSection').classList.remove('hidden');
    document.getElementById('ownerCodeSection').classList.remove('hidden');
    document.getElementById('ownerSubcontractorsSection').classList.remove('hidden');
  }
}

function loadSitesPanel() {
  if (CURRENT_ROLE === '원청') {
    loadMySites();
    loadSubcontractors();
  } else if (CURRENT_ROLE === '하청') {
    loadJoinedSites();
  }
}

function loadMySites() {
  fetch('/api/sites/mine')
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (sites) {
      mySites = sites;
      var select = document.getElementById('siteSelect');
      select.innerHTML = '<option value="">현장을 선택하세요</option>' +
        sites.map(function (s) { return '<option value="' + s.id + '">' + s.name + '</option>'; }).join('');
      if (selectedSite) {
        var stillExists = sites.find(function (s) { return s.id === selectedSite.id; });
        if (stillExists) { select.value = stillExists.id; onSiteSelected(stillExists.id, stillExists); }
      }
    })
    .catch(function () {});
}

function onSiteSelected(siteId, siteObj) {
  var site = siteObj || mySites.find(function (s) { return String(s.id) === String(siteId); });
  selectedSite = site || null;

  if (!site) {
    document.getElementById('siteEmptyHint').classList.remove('hidden');
    document.getElementById('siteDetailCard').classList.add('hidden');
    document.getElementById('codeSectionHint').classList.remove('hidden');
    document.getElementById('codeSectionBody').classList.add('hidden');
    return;
  }

  document.getElementById('siteEmptyHint').classList.add('hidden');
  document.getElementById('siteDetailCard').classList.remove('hidden');
  document.getElementById('siteDetailName').textContent = site.name;

  var rows = [
    ['현장 주소', site.address || '-'],
    ['공사 구분', site.workType || '-'],
    ['공사 기간', (site.periodStart || '-') + ' ~ ' + (site.periodEnd || '-')]
  ];
  document.getElementById('siteDetailBody').innerHTML = rows.map(function (r) {
    return '<div class="p-3 bg-gray-50 rounded"><p class="text-[10px] font-semibold text-gray-400 uppercase tracking-wide">' + r[0] + '</p>' +
      '<p class="text-sm font-semibold text-gray-900 mt-0.5">' + r[1] + '</p></div>';
  }).join('');

  document.getElementById('codeSectionHint').classList.add('hidden');
  document.getElementById('codeSectionBody').classList.remove('hidden');
  document.getElementById('siteCodeValue').textContent = site.inviteCode;
}

document.getElementById('showAddSiteFormBtn').addEventListener('click', function () {
  document.getElementById('addSiteForm').classList.toggle('hidden');
});
document.getElementById('cancelAddSiteBtn').addEventListener('click', function () {
  document.getElementById('addSiteForm').classList.add('hidden');
});

document.getElementById('addSiteBtn').addEventListener('click', function () {
  var name = document.getElementById('newSiteNameInput').value.trim();
  if (!name) { alert('현장명을 입력해주세요.'); return; }
  fetch('/api/sites/with-detail', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      name: name,
      address: document.getElementById('newSiteAddressInput').value.trim() || null,
      workType: document.getElementById('newSiteWorkTypeInput').value.trim() || null,
      periodStart: document.getElementById('newSitePeriodStartInput').value || null,
      periodEnd: document.getElementById('newSitePeriodEndInput').value || null
    })
  })
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (created) {
      ['newSiteNameInput', 'newSiteAddressInput', 'newSiteWorkTypeInput', 'newSitePeriodStartInput', 'newSitePeriodEndInput'].forEach(function (id) {
        document.getElementById(id).value = '';
      });
      document.getElementById('addSiteForm').classList.add('hidden');
      loadMySites();
    })
    .catch(function () { alert('현장 등록에 실패했습니다.'); });
});

document.getElementById('copySiteCodeBtn').addEventListener('click', function () {
  var code = document.getElementById('siteCodeValue').textContent;
  navigator.clipboard.writeText(code).then(function () {
    var btn = document.getElementById('copySiteCodeBtn');
    var original = btn.textContent;
    btn.textContent = '복사됨';
    setTimeout(function () { btn.textContent = original; }, 1500);
  });
});

document.getElementById('regenSiteCodeBtn').addEventListener('click', function () {
  if (!selectedSite) return;
  if (!confirm('코드를 재발급하면 기존 코드는 더 이상 사용할 수 없습니다. 계속할까요?')) return;
  fetch('/api/sites/' + selectedSite.id + '/invite-code/regenerate', { method: 'POST' })
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (updated) {
      document.getElementById('siteCodeValue').textContent = updated.inviteCode;
      loadMySites();
    })
    .catch(function () { alert('재발급에 실패했습니다.'); });
});

function loadSubcontractors() {
  fetch('/api/sites/subcontractors')
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (rows) {
      var tbody = document.getElementById('subcontractorsTableBody');
      if (!rows.length) {
        tbody.innerHTML = '<tr><td colspan="4" class="px-4 py-8 text-center text-sm text-gray-400">아직 연결된 하청 업체가 없습니다.</td></tr>';
        return;
      }
      tbody.innerHTML = rows.map(function (r) {
        return '<tr class="hover:bg-gray-50 transition-colors">' +
          '<td class="px-4 py-3.5 font-semibold text-gray-900">' + (r.companyName || '-') + '</td>' +
          '<td class="px-4 py-3.5 text-gray-700">' + (r.managerName || '-') + '</td>' +
          '<td class="px-4 py-3.5"><span class="text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-lg font-medium">' + r.siteName + '</span></td>' +
          '<td class="px-4 py-3.5 text-gray-500 text-xs whitespace-nowrap">' + (r.joinedAt ? r.joinedAt.replace('T', ' ').slice(0, 16) : '-') + '</td></tr>';
      }).join('');
    })
    .catch(function () {});
}

/* ── 하청: 현장 연결 ── */

document.getElementById('joinSiteBtn').addEventListener('click', function () {
  var input = document.getElementById('inviteCodeInput');
  var code = input.value.trim();
  var msg = document.getElementById('joinSiteMessage');
  if (!code) return;

  fetch('/api/sites/join', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ inviteCode: code })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      msg.classList.remove('hidden');
      if (r.ok) {
        showMessage(msg, '"' + r.body.name + '" 현장에 연결되었습니다.', true);
        input.value = '';
        loadJoinedSites();
      } else {
        showMessage(msg, r.body.error || '연결에 실패했습니다.', false);
      }
    })
    .catch(function () {
      msg.classList.remove('hidden');
      showMessage(msg, '연결에 실패했습니다.', false);
    });
});

function loadJoinedSites() {
  fetch('/api/sites/joined')
    .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
    .then(function (sites) {
      var list = document.getElementById('joinedSitesList');
      if (!sites.length) {
        list.innerHTML = '<p class="text-sm text-gray-400">아직 연결된 현장이 없습니다.</p>';
        return;
      }
      list.innerHTML = sites.map(function (s) {
        return '<div class="border border-green-200 rounded p-4 bg-green-50/40">' +
          '<div class="flex items-center gap-2 mb-2"><svg class="w-4 h-4 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>' +
          '<span class="text-sm font-semibold text-gray-900">' + s.name + '</span></div>' +
          '<div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs text-gray-600">' +
          '<p>원청 건설사: ' + (s.ownerCompanyName || '-') + '</p>' +
          '<p>현장 주소: ' + (s.address || '-') + '</p>' +
          '<p>공사 구분: ' + (s.workType || '-') + '</p>' +
          '<p>공사 기간: ' + (s.periodStart || '-') + ' ~ ' + (s.periodEnd || '-') + '</p>' +
          '</div></div>';
      }).join('');
    })
    .catch(function () {});
}

/* ── KISCON 건설업체정보 조회 ── */
document.getElementById('kisconSearchBtn').addEventListener('click', function () {
  var keyword = document.getElementById('companyNameInput').value.trim();
  var msg = document.getElementById('kisconMessage');
  var resultsWrap = document.getElementById('kisconResultsWrap');
  resultsWrap.innerHTML = '';
  resultsWrap.classList.add('hidden');

  if (!keyword) {
    msg.classList.remove('hidden');
    showMessage(msg, '건설사명을 입력한 뒤 조회해주세요.', false);
    return;
  }

  msg.classList.remove('hidden');
  showMessage(msg, '조회 중...', true);

  fetch('/api/kiscon/companies?keyword=' + encodeURIComponent(keyword))
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      if (!r.ok) {
        showMessage(msg, r.body.error || 'KISCON 조회에 실패했습니다.', false);
        return;
      }
      var companies = r.body;
      if (!companies.length) {
        showMessage(msg, '일치하는 건설업체를 찾지 못했습니다. 직접 입력 후 저장해주세요.', false);
        return;
      }
      msg.classList.add('hidden');
      resultsWrap.classList.remove('hidden');
      resultsWrap.innerHTML = companies.map(function (c, i) {
        return '<button type="button" data-idx="' + i + '" class="kisconResultItem w-full text-left px-4 py-2.5 hover:bg-gray-50 transition-colors">' +
          '<p class="text-sm font-semibold text-gray-900">' + c.name + '</p>' +
          '<p class="text-xs text-gray-500">' + (c.bizNo || '-') + ' · ' + (c.address || '-') + '</p></button>';
      }).join('');
      resultsWrap.querySelectorAll('.kisconResultItem').forEach(function (btn) {
        btn.addEventListener('click', function () {
          var c = companies[Number(btn.dataset.idx)];
          document.getElementById('companyNameInput').value = c.name || '';
          document.getElementById('companyBizNoInput').value = c.bizNo || '';
          document.getElementById('companyCeoInput').value = c.ceoName || '';
          document.getElementById('companyAddressInput').value = c.address || '';
          resultsWrap.classList.add('hidden');
          resultsWrap.innerHTML = '';
        });
      });
    })
    .catch(function () {
      showMessage(msg, 'KISCON 조회에 실패했습니다.', false);
    });
});

document.getElementById('saveCompanyBtn').addEventListener('click', function () {
  var msg = document.getElementById('companySaveMessage');
  fetch('/api/users/me/company', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      companyName: document.getElementById('companyNameInput').value.trim(),
      companyBizNo: document.getElementById('companyBizNoInput').value.trim(),
      companyCeoName: document.getElementById('companyCeoInput').value.trim(),
      companyAddress: document.getElementById('companyAddressInput').value.trim()
    })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      msg.classList.remove('hidden');
      if (r.ok) { showMessage(msg, '건설사 정보가 저장되었습니다.', true); }
      else { showMessage(msg, r.body.error || '저장에 실패했습니다.', false); }
    })
    .catch(function () {
      msg.classList.remove('hidden');
      showMessage(msg, '저장에 실패했습니다.', false);
    });
});

/* ── 기존 폼 핸들러 ── */

document.getElementById('profileForm').addEventListener('submit', function (e) {
  e.preventDefault();
  var msgEl = document.getElementById('profileSaveMessage');
  fetch('/api/users/me/profile', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: document.getElementById('profileUsernameInput').value.trim(),
      companyName: document.getElementById('profileCompanyInput').value.trim()
    })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      msgEl.classList.remove('hidden');
      if (r.ok) {
        showMessage(msgEl, '저장되었습니다.', true);
        loadProfile();
      } else {
        showMessage(msgEl, r.body.error || '저장에 실패했습니다.', false);
      }
    })
    .catch(function () {
      msgEl.classList.remove('hidden');
      showMessage(msgEl, '저장에 실패했습니다.', false);
    });
});

document.getElementById('passwordChangeForm').addEventListener('submit', function (e) {
  e.preventDefault();
  var msgEl = document.getElementById('passwordChangeMessage');
  fetch('/api/users/me/password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      currentPassword: document.getElementById('currentPasswordInput').value,
      newPassword: document.getElementById('newPasswordInput').value,
      newPasswordConfirm: document.getElementById('newPasswordConfirmInput').value
    })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      msgEl.classList.remove('hidden');
      if (r.ok) {
        showMessage(msgEl, '비밀번호가 변경되었습니다.', true);
        document.getElementById('passwordChangeForm').reset();
      } else {
        showMessage(msgEl, r.body.error || '비밀번호 변경에 실패했습니다.', false);
      }
    })
    .catch(function () {
      msgEl.classList.remove('hidden');
      showMessage(msgEl, '비밀번호 변경에 실패했습니다.', false);
    });
});

document.getElementById('twoFactorToggleBtn').addEventListener('click', function () {
  var btn = document.getElementById('twoFactorToggleBtn');
  var enabling = btn.dataset.enabled !== 'true';
  var msgEl = document.getElementById('twoFactorMessage');
  var confirmText = enabling
    ? '2단계 인증을 켤까요? 다음 로그인부터 이메일로 받은 코드를 추가로 입력해야 합니다.'
    : '2단계 인증을 끌까요? 이후 로그인 시 코드 입력 없이 바로 로그인됩니다.';
  if (!confirm(confirmText)) return;

  fetch('/api/users/me/two-factor', {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ enabled: enabling })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      msgEl.classList.remove('hidden');
      if (r.ok) {
        showMessage(msgEl, enabling ? '2단계 인증이 켜졌습니다.' : '2단계 인증이 꺼졌습니다.', true);
        renderTwoFactorState(r.body.twoFactorEnabled);
      } else {
        showMessage(msgEl, r.body.error || '변경에 실패했습니다.', false);
      }
    })
    .catch(function () {
      msgEl.classList.remove('hidden');
      showMessage(msgEl, '변경에 실패했습니다.', false);
    });
});

document.getElementById('showWithdrawFormBtn').addEventListener('click', function () {
  document.getElementById('showWithdrawFormBtn').classList.add('hidden');
  document.getElementById('withdrawForm').classList.remove('hidden');
});

document.getElementById('cancelWithdrawBtn').addEventListener('click', function () {
  document.getElementById('withdrawForm').classList.add('hidden');
  document.getElementById('showWithdrawFormBtn').classList.remove('hidden');
  document.getElementById('withdrawPasswordInput').value = '';
});

document.getElementById('withdrawForm').addEventListener('submit', function (e) {
  e.preventDefault();
  var msgEl = document.getElementById('withdrawMessage');
  var password = document.getElementById('withdrawPasswordInput').value;
  if (!confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) return;

  fetch('/api/users/me/withdraw', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ password: password })
  })
    .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
    .then(function (r) {
      if (r.ok) {
        window.location.href = '/login';
      } else {
        msgEl.classList.remove('hidden');
        showMessage(msgEl, r.body.error || '탈퇴에 실패했습니다.', false);
      }
    })
    .catch(function () {
      msgEl.classList.remove('hidden');
      showMessage(msgEl, '탈퇴에 실패했습니다.', false);
    });
});

loadProfile();
</script>
</body>
</html>
