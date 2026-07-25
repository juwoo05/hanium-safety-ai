<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>신고 상세 - SafeMate</title>
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
        <input type="text" placeholder="검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
      </div>
    </div>
    <div class="flex items-center gap-4 ml-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
      </a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg transition-colors">
        <div class="w-8 h-8 bg-[#FF6B35] rounded-full flex items-center justify-center"><span class="text-white font-semibold text-sm">김</span></div>
        <span class="text-sm font-medium text-gray-700 hidden sm:block">김현장</span>
      </a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto p-6 lg:p-8">
    <div class="max-w-4xl mx-auto space-y-5">

      <!-- Back -->
      <a href="/report-board" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-800 transition-colors">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
        신고 게시판으로
      </a>

      <!-- Header card -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-start justify-between gap-4 mb-4">
          <div class="flex items-start gap-3 flex-1">
            <div class="w-10 h-10 bg-red-50 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5">
              <svg class="w-5 h-5 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            </div>
            <div>
              <div class="flex flex-wrap items-center gap-2 mb-2">
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full border bg-red-100 text-red-700 border-red-200">고위험</span>
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-blue-100 text-blue-700">처리중</span>
                <span class="text-xs text-gray-400 bg-gray-50 px-2 py-1 rounded-full">안전 위반</span>
              </div>
              <h1 class="text-xl font-bold text-gray-900">3동 옥상 안전난간 파손 방치</h1>
            </div>
          </div>
          <button onclick="showToast('처리 요청이 접수되었습니다.')" class="flex items-center gap-1.5 px-3 py-2 border border-red-200 text-red-500 rounded-lg text-xs font-medium hover:bg-red-50 transition-colors flex-shrink-0">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>
            처리 요청
          </button>
        </div>
        <div class="flex flex-wrap items-center gap-4 text-xs text-gray-500 pt-4 border-t border-gray-100">
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
            3동 옥상
          </span>
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            2026-06-01
          </span>
          <span class="flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            42명 조회
          </span>
          <span class="flex items-center gap-1.5 ml-auto">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
            익명 신고
          </span>
        </div>
      </div>

      <!-- Main grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-5">

        <!-- Left / main -->
        <div class="lg:col-span-2 space-y-5">

          <!-- Description -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-base font-bold text-gray-900 mb-4">신고 내용</h2>
            <p class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">3동 옥상 남쪽 가장자리 안전난간이 파손된 채로 2주 이상 방치되고 있습니다.

현재 해당 구역에서 외벽 도색 작업이 진행 중인데, 파손된 난간 근처에서 작업자들이 안전장치 없이 작업하는 것을 여러 차례 목격했습니다.

추락 사고가 발생하기 전에 즉각적인 조치가 필요합니다. 최소한 해당 구역 출입을 통제하고 임시 안전장치라도 설치해야 합니다.</p>
          </div>

          <!-- Images -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-base font-bold text-gray-900 mb-4">첨부 사진 (2)</h2>
            <div class="rounded-xl overflow-hidden mb-3 bg-gray-100 aspect-video">
              <img id="mainImg" src="https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&h=450&fit=crop&auto=format" alt="신고 사진" class="w-full h-full object-cover"/>
            </div>
            <div class="flex gap-2">
              <button onclick="setImg(0)" id="thumb0" class="w-16 h-12 rounded-lg overflow-hidden border-2 border-[#FF6B35] ring-2 ring-[#FF6B35]/20 transition-all">
                <img src="https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=200&h=120&fit=crop&auto=format" alt="" class="w-full h-full object-cover"/>
              </button>
              <button onclick="setImg(1)" id="thumb1" class="w-16 h-12 rounded-lg overflow-hidden border-2 border-gray-200 transition-all">
                <img src="https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=200&h=120&fit=crop&auto=format" alt="" class="w-full h-full object-cover"/>
              </button>
            </div>
          </div>

          <!-- Comments -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-base font-bold text-gray-900 mb-4 flex items-center gap-2">
              <svg class="w-4 h-4 text-[#FF6B35]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
              댓글 <span id="commentCount">(2)</span>
            </h2>

            <div id="commentList" class="space-y-4 mb-5">
              <!-- rendered by JS -->
            </div>

            <!-- Comment input -->
            <div class="flex gap-2">
              <input type="text" id="commentInput" onkeydown="if(event.key==='Enter') addComment()" placeholder="댓글을 입력하세요..."
                class="flex-1 px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#FF6B35] focus:border-transparent outline-none"/>
              <button onclick="addComment()" class="px-4 py-2.5 bg-[#FF6B35] text-white rounded-xl hover:bg-[#E55A2A] transition-colors">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
              </button>
            </div>
          </div>

        </div>

        <!-- Right sidebar -->
        <div class="space-y-5">

          <!-- Processing timeline -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <h2 class="text-sm font-bold text-gray-900 mb-4">처리 현황</h2>
            <div class="space-y-4" id="timeline">
              <!-- rendered by JS -->
            </div>
          </div>

          <!-- Report info -->
          <div class="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 space-y-3">
            <h2 class="text-sm font-bold text-gray-900">신고 정보</h2>
            <div class="space-y-0">
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">신고 번호</span><span class="text-xs font-semibold text-gray-800">#0001</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">분류</span><span class="text-xs font-semibold text-gray-800">안전 위반</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">위치</span><span class="text-xs font-semibold text-gray-800">3동 옥상</span>
              </div>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <span class="text-xs text-gray-500">접수일</span><span class="text-xs font-semibold text-gray-800">2026-06-01</span>
              </div>
              <div class="flex items-center justify-between py-2">
                <span class="text-xs text-gray-500">신고자</span><span class="text-xs font-semibold text-gray-800">익명</span>
              </div>
            </div>
          </div>

          <!-- Notice -->
          <div class="bg-blue-50 rounded-2xl p-4 border border-blue-100 text-xs text-blue-700">
            <p class="font-semibold mb-1">신고자 보호 안내</p>
            <p class="leading-relaxed text-blue-600">익명 신고자의 정보는 안전관리 담당자만 확인할 수 있으며, 외부에 공개되지 않습니다.</p>
          </div>

        </div>
      </div>
    </div>
  </main>
</div>

<!-- Toast -->
<div id="toast" class="hidden fixed bottom-6 left-1/2 -translate-x-1/2 bg-gray-900 text-white text-sm font-medium px-5 py-3 rounded-xl shadow-xl z-50 flex items-center gap-2">
  <svg class="w-4 h-4 text-green-400 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
  <span id="toastMsg"></span>
</div>

<script>
const IMGS = [
  'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&h=450&fit=crop&auto=format',
  'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=800&h=450&fit=crop&auto=format',
];

function setImg(i) {
  document.getElementById('mainImg').src = IMGS[i];
  [0,1].forEach(j => {
    const t = document.getElementById('thumb'+j);
    if (j===i) { t.classList.add('border-[#FF6B35]','ring-2','ring-[#FF6B35]/20'); t.classList.remove('border-gray-200'); }
    else        { t.classList.remove('border-[#FF6B35]','ring-2','ring-[#FF6B35]/20'); t.classList.add('border-gray-200'); }
  });
}

const TIMELINE = [
  { date:'2026-06-01 09:15', label:'신고 접수',    desc:'신고가 안전 관리팀에 접수되었습니다.',         done:true },
  { date:'2026-06-01 11:30', label:'담당자 배정',   desc:'김현장 안전관리자가 담당자로 배정되었습니다.', done:true },
  { date:'2026-06-02 14:00', label:'현장 확인 중',  desc:'담당자가 현장 실태를 확인하고 있습니다.',       done:true },
  { date:'처리 예정',         label:'조치 완료',    desc:'안전난간 교체 작업 예정',                      done:false },
];

function renderTimeline() {
  document.getElementById('timeline').innerHTML = TIMELINE.map((s,i)=>`
    <div class="flex gap-3">
      <div class="flex flex-col items-center">
        <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ${s.done?'bg-[#FF6B35] text-white':'bg-gray-100 border-2 border-gray-200'}">
          ${s.done
            ?'<svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>'
            :'<div class="w-1.5 h-1.5 rounded-full bg-gray-400"></div>'}
        </div>
        ${i<TIMELINE.length-1?`<div class="w-0.5 flex-1 mt-1 min-h-[20px] ${s.done?'bg-[#FF6B35]/30':'bg-gray-100'}"></div>`:''}
      </div>
      <div class="pb-4">
        <p class="text-xs font-semibold mb-0.5 ${s.done?'text-gray-900':'text-gray-400'}">${s.label}</p>
        <p class="text-xs mb-0.5 ${s.done?'text-gray-600':'text-gray-400'}">${s.desc}</p>
        <p class="text-[10px] text-gray-400">${s.date}</p>
      </div>
    </div>`).join('');
}

let comments = [
  { id:1, author:'김현장', role:'안전관리자', date:'2026-06-01 14:20', text:'현장 확인 결과 신고 내용이 사실임을 확인했습니다. 오늘 오후 안전 테이프로 임시 통제하고, 내일 난간 교체 작업을 진행할 예정입니다.', official:true },
  { id:2, author:'익명',   role:'신고자',     date:'2026-06-01 16:05', text:'빠른 확인 감사합니다. 오늘 오후에도 작업자들이 해당 구역에 접근하고 있으니 빠른 조치 부탁드립니다.',                         official:false },
];

function renderComments() {
  document.getElementById('commentList').innerHTML = comments.map(c=>`
    <div class="p-4 rounded-xl border ${c.official?'bg-blue-50 border-blue-100':'bg-gray-50 border-gray-100'}">
      <div class="flex items-center gap-2 mb-2">
        <div class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold ${c.official?'bg-blue-600 text-white':'bg-gray-300 text-gray-700'}">${c.author[0]}</div>
        <span class="text-sm font-semibold text-gray-900">${c.author}</span>
        <span class="text-[10px] px-2 py-0.5 rounded-full font-medium ${c.official?'bg-blue-100 text-blue-700':'bg-gray-200 text-gray-600'}">${c.role}</span>
        ${c.official?'<svg class="w-3.5 h-3.5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>':''}
        <span class="text-xs text-gray-400 ml-auto">${c.date}</span>
      </div>
      <p class="text-sm text-gray-700 leading-relaxed">${c.text}</p>
    </div>`).join('');
  document.getElementById('commentCount').textContent = `(${comments.length})`;
}

function addComment() {
  const input = document.getElementById('commentInput');
  const text = input.value.trim();
  if (!text) return;
  comments.push({ id:comments.length+1, author:'나', role:'작업자', date:new Date().toLocaleString('ko-KR'), text, official:false });
  input.value='';
  renderComments();
  showToast('댓글이 등록되었습니다.');
}

let toastTimer;
function showToast(msg) {
  const el = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = msg;
  el.classList.remove('hidden');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(()=>el.classList.add('hidden'), 3000);
}

renderTimeline();
renderComments();
</script>
</body>
</html>
