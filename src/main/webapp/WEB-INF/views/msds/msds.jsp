<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MSDS 조회 - 연결고리</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-[#F3F5F7] flex">
<%@ include file="../common/_sidebar.jsp" %>
<div id="mainContent" class="flex-1 flex flex-col min-h-screen ml-[220px]">
  <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
    <div class="flex items-center gap-3">
      <h1 class="text-lg font-semibold text-gray-900">MSDS 조회</h1>
      <span class="text-xs text-gray-400 hidden sm:inline">사진으로 물질을 인식해 공식 MSDS/SDS 자료를 찾습니다</span>
    </div>
    <div class="flex items-center gap-4">
      <a href="/notifications" class="relative p-2 hover:bg-gray-100 rounded-lg"><svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span></a>
      <a href="/mypage" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-lg"><div class="w-8 h-8 bg-[#1A2E44] rounded-full flex items-center justify-center"><span id="headerUserInitial" class="text-white font-semibold text-sm">-</span></div></a>
    </div>
  </header>

  <main class="flex-1 overflow-y-auto" style="padding:28px 32px 56px;max-width:1100px">
    <div class="space-y-5">

      <!-- 1. 사진 업로드 / 촬영 -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <h2 class="text-base font-semibold text-gray-900 mb-1">1. 위험물·화학제품 사진</h2>
        <p class="text-xs text-gray-500 mb-4">용기 라벨, 경고표지, 제품명이 보이게 촬영하거나 사진 파일을 올리세요. AI가 물질명·CAS 번호를 읽습니다.</p>

        <div id="msdsDrop" class="relative rounded-xl border-2 border-dashed border-gray-200 overflow-hidden cursor-pointer hover:border-[#1A2E44] hover:bg-orange-50/40 transition-colors">
          <input id="msdsPhotoInput" type="file" accept="image/*" capture="environment" class="hidden"/>
          <div id="msdsDropEmpty" class="flex flex-col items-center justify-center gap-2 text-center px-4" style="min-height:320px">
            <svg class="w-11 h-11 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
            <span class="text-sm font-medium text-gray-600">촬영 또는 파일 선택</span>
            <span class="text-[11px] text-gray-400">사진을 여기로 끌어다 놓아도 됩니다</span>
          </div>
          <img id="msdsPreviewImg" class="hidden w-full object-contain" style="max-height:600px;background:#0F172A" alt="선택한 사진"/>
          <button id="msdsPreviewRemove" type="button" class="hidden absolute top-3 right-3 bg-black/55 hover:bg-black/75 rounded-full p-2"><svg class="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>
        </div>

        <div class="mt-3 flex items-center justify-end gap-3">
          <button id="msdsAnalyzeBtn" type="button" disabled class="px-5 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] disabled:opacity-40 disabled:cursor-not-allowed flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 3l1.6 4.9L18 9.5l-4.4 1.6L12 16l-1.6-4.9L6 9.5l4.4-1.6z"/></svg>
            AI로 분석
          </button>
        </div>

        <div id="msdsDetectKeywords" class="hidden flex-wrap gap-1.5 mt-4"></div>
        <div id="msdsCandidates" class="hidden grid grid-cols-1 sm:grid-cols-2 gap-2 mt-3"></div>
        <p id="msdsDetectHint" class="text-xs text-gray-400 mt-3">사진을 올리면 분석 버튼이 활성화됩니다.</p>
      </div>

      <!-- 2. MSDS 검색 -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <h2 class="text-base font-semibold text-gray-900 mb-3">2. MSDS / SDS 검색</h2>
        <div class="flex gap-2 mb-3">
          <input id="msdsSearchInput" type="text" placeholder="물질명, CAS 번호 또는 제품명 (예: 톨루엔 / 108-88-3)" class="flex-1 px-3 py-2 border border-gray-200 rounded-lg text-sm outline-none focus:ring-2 focus:ring-[#1A2E44]"/>
          <button id="msdsSearchBtn" type="button" class="px-5 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] flex-shrink-0">검색</button>
        </div>
        <p class="text-[11px] text-gray-400 mb-2">출처 구분 — <span class="font-semibold text-[#1A6DE0]">KOSHA 참고자료</span> · <span class="font-semibold text-[#B45309]">제조사 제공자료</span> · <span class="font-semibold text-gray-600">내부 등록자료</span>. 법적으로 유효한 MSDS는 제조사/수입사/판매자 제공본입니다.</p>
        <div style="overflow-x:auto">
          <table class="w-full text-sm" style="border-collapse:collapse">
            <thead>
              <tr class="text-left text-[11px] font-semibold text-gray-400 border-b border-gray-100">
                <th class="py-2 pr-3 whitespace-nowrap">물질명 / 제품명</th>
                <th class="py-2 pr-3 whitespace-nowrap">CAS No.</th>
                <th class="py-2 pr-3 whitespace-nowrap">개정일</th>
                <th class="py-2 pr-3 whitespace-nowrap">출처</th>
                <th class="py-2 pr-3 whitespace-nowrap">신뢰도</th>
                <th class="py-2 pr-3 whitespace-nowrap">KOSHA MSDS</th>
                <th class="py-2 whitespace-nowrap">저장</th>
              </tr>
            </thead>
            <tbody id="msdsSearchResults">
              <tr><td colspan="7" class="py-8 text-center text-gray-400 text-sm">검색어를 입력하거나 위에서 사진을 분석하세요.</td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 3. 내 MSDS 자료함 -->
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
        <div class="flex items-center justify-between mb-3">
          <h2 class="text-base font-semibold text-gray-900">내 MSDS 자료함</h2>
          <span id="msdsMineCount" class="text-xs text-gray-400">0건</span>
        </div>
        <div id="msdsMineList" class="space-y-2">
          <p class="text-sm text-gray-400">저장한 MSDS가 없습니다. 검색 결과에서 "저장"을 누르면 여기에 담깁니다.</p>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  function qs(s, r) { return (r || document).querySelector(s); }
  function qsa(s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); }
  function esc(s) { return (s == null ? '' : String(s)).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }

  var SOURCE_BADGE = {
    KOSHA: 'bg-blue-50 text-[#1A6DE0]', MANUFACTURER: 'bg-orange-50 text-[#B45309]',
    INTERNAL: 'bg-gray-100 text-gray-600', UNKNOWN: 'bg-gray-100 text-gray-500'
  };
  var SOURCE_LABEL = { KOSHA: 'KOSHA 참고자료', MANUFACTURER: '제조사 제공자료', INTERNAL: '내부 등록자료', UNKNOWN: '출처 미상' };

  var pendingFile = null;
  var lastResults = [];

  fetch('/api/users/me').then(function (r) { return r.ok ? r.json() : null; })
    .then(function (u) { if (u) qs('#headerUserInitial').textContent = u.username ? u.username.charAt(0) : '?'; })
    .catch(function () {});

  function koshaLink(url, label) {
    return url
      ? '<a href="' + esc(url) + '" target="_blank" rel="noopener noreferrer" class="text-xs font-semibold text-[#1A2E44] hover:underline whitespace-nowrap flex-shrink-0">' + (label || 'KOSHA MSDS') + ' ↗</a>'
      : '<span class="text-xs text-gray-400 flex-shrink-0">-</span>';
  }

  // ── 사진 선택 / 미리보기 (선택하면 그 자리에 크게 표시) ──
  var drop = qs('#msdsDrop');
  function setFile(file) {
    if (!file || !/^image\//.test(file.type)) return;
    pendingFile = file;
    qs('#msdsPreviewImg').src = URL.createObjectURL(file);
    qs('#msdsPreviewImg').classList.remove('hidden');
    qs('#msdsDropEmpty').classList.add('hidden');
    qs('#msdsPreviewRemove').classList.remove('hidden');
    drop.classList.remove('border-dashed', 'hover:bg-orange-50/40');
    drop.classList.add('border-solid');
    qs('#msdsAnalyzeBtn').disabled = false;
    qs('#msdsDetectHint').textContent = '"AI로 분석"을 눌러 물질을 인식하세요.';
  }
  function clearFile() {
    pendingFile = null;
    qs('#msdsPreviewImg').classList.add('hidden');
    qs('#msdsPreviewImg').removeAttribute('src');
    qs('#msdsDropEmpty').classList.remove('hidden');
    qs('#msdsPreviewRemove').classList.add('hidden');
    drop.classList.add('border-dashed', 'hover:bg-orange-50/40');
    drop.classList.remove('border-solid');
    qs('#msdsPhotoInput').value = '';
    qs('#msdsAnalyzeBtn').disabled = true;
  }
  drop.addEventListener('click', function (e) {
    if (e.target.closest('#msdsPreviewRemove')) return;
    qs('#msdsPhotoInput').click();
  });
  qs('#msdsPhotoInput').addEventListener('change', function (e) { setFile(e.target.files[0]); });
  drop.addEventListener('dragover', function (e) { e.preventDefault(); drop.classList.add('border-[#1A2E44]'); });
  drop.addEventListener('dragleave', function () { drop.classList.remove('border-[#1A2E44]'); });
  drop.addEventListener('drop', function (e) { e.preventDefault(); drop.classList.remove('border-[#1A2E44]'); setFile(e.dataTransfer.files[0]); });
  qs('#msdsPreviewRemove').addEventListener('click', function (e) { e.preventDefault(); e.stopPropagation(); clearFile(); });

  // ── 분석: 업로드 → detect ──
  qs('#msdsAnalyzeBtn').addEventListener('click', function () {
    if (!pendingFile) return;
    var btn = qs('#msdsAnalyzeBtn');
    btn.disabled = true;
    qs('#msdsDetectHint').textContent = '사진 업로드 중...';

    var fd = new FormData();
    fd.append('file', pendingFile);
    fetch('/api/uploads', { method: 'POST', body: fd })
      .then(function (res) {
        if (res.status === 401) { window.location.href = '/login'; throw new Error(); }
        if (!res.ok) throw new Error('사진 업로드 실패');
        return res.json();
      })
      .then(function (up) {
        qs('#msdsDetectHint').textContent = 'AI가 사진을 분석하는 중...';
        return fetch('/api/msds/detect', {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ imageS3Key: up.s3Key })
        });
      })
      .then(function (res) {
        if (!res.ok) return res.json().then(function (e) { throw new Error(e.error || '물질 인식 실패'); });
        return res.json();
      })
      .then(renderDetect)
      .catch(function (err) { qs('#msdsDetectHint').textContent = (err && err.message) || 'AI 분석 서버에 연결하지 못했습니다. 아래에서 직접 검색하세요.'; })
      .finally(function () { btn.disabled = false; });
  });

  function renderDetect(data) {
    // 서버 DTO가 ai-pipeline(FastAPI) 응답과 1:1 대응하도록 @JsonProperty로 snake_case를
    // 강제하고 있어(chemical_candidates, cas_no 등), 여기서도 snake_case로 읽어야 한다.
    var kws = (data && data.detected_keywords) || [];
    var kwWrap = qs('#msdsDetectKeywords');
    if (kws.length) {
      kwWrap.innerHTML = kws.map(function (k) { return '<span class="text-[11px] px-2 py-0.5 rounded-full bg-gray-100 text-gray-600">' + esc(k) + '</span>'; }).join('');
      kwWrap.classList.remove('hidden'); kwWrap.classList.add('flex');
    } else { kwWrap.classList.add('hidden'); }

    var cands = (data && data.chemical_candidates) || [];
    var cWrap = qs('#msdsCandidates');
    if (cands.length) {
      cWrap.innerHTML = cands.map(function (c) {
        return '<button type="button" class="cand-btn text-left px-3 py-2 rounded-lg border border-gray-200 hover:border-[#1A2E44] hover:bg-orange-50/40" data-q="' + esc(c.cas_no || c.chemical_name) + '">' +
          '<span class="block text-sm font-semibold text-gray-900">' + esc(c.chemical_name) + '</span>' +
          '<span class="block text-xs text-gray-500">' + esc(c.cas_no || 'CAS 미상') + (c.product_name ? ' · ' + esc(c.product_name) : '') + ' · 신뢰도 ' + (c.confidence || 0) + '%</span>' +
          '</button>';
      }).join('');
      cWrap.classList.remove('hidden'); cWrap.classList.add('grid');
      qsa('#msdsCandidates .cand-btn').forEach(function (b) { b.addEventListener('click', function () { qs('#msdsSearchInput').value = b.dataset.q; doSearch(); }); });
      qs('#msdsDetectHint').textContent = cands.length + '개 후보를 찾았습니다. 물질을 선택하면 자동 검색합니다.';
    } else {
      cWrap.classList.add('hidden');
      qs('#msdsDetectHint').textContent = '사진에서 화학물질을 확정하지 못했습니다. 아래에서 직접 검색하세요.';
    }
  }

  // ── 검색 ──
  function doSearch() {
    var q = qs('#msdsSearchInput').value.trim();
    if (!q) return;
    var body = qs('#msdsSearchResults');
    body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-gray-400 text-sm">검색 중...</td></tr>';
    fetch('/api/msds/search?query=' + encodeURIComponent(q))
      .then(function (res) { if (!res.ok) throw new Error(); return res.json(); })
      .then(function (r) { lastResults = r || []; renderResults(); })
      .catch(function () { body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-red-400 text-sm">검색에 실패했습니다.</td></tr>'; });
  }
  qs('#msdsSearchBtn').addEventListener('click', doSearch);
  qs('#msdsSearchInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') doSearch(); });

  function renderResults() {
    var body = qs('#msdsSearchResults');
    if (!lastResults.length) { body.innerHTML = '<tr><td colspan="7" class="py-6 text-center text-gray-400 text-sm">검색 결과가 없습니다.</td></tr>'; return; }
    body.innerHTML = lastResults.map(function (r, i) {
      var badge = SOURCE_BADGE[r.sourceType] || SOURCE_BADGE.UNKNOWN;
      return '<tr class="border-b border-gray-50 align-top">' +
        '<td class="py-2.5 pr-3"><p class="font-semibold text-gray-900">' + esc(r.chemicalName) + '</p>' + (r.productName ? '<p class="text-xs text-gray-500">' + esc(r.productName) + '</p>' : '') + '</td>' +
        '<td class="py-2.5 pr-3 text-gray-600 whitespace-nowrap">' + esc(r.casNo || '-') + '</td>' +
        '<td class="py-2.5 pr-3 text-gray-500 whitespace-nowrap">' + esc(r.revisionDate || '-') + '</td>' +
        '<td class="py-2.5 pr-3 whitespace-nowrap"><span class="text-[11px] font-semibold px-2 py-0.5 rounded-full ' + badge + '">' + esc(SOURCE_LABEL[r.sourceType] || '출처 미상') + '</span>' + (r.sourceName ? '<span class="block text-[10px] text-gray-400 mt-0.5">' + esc(r.sourceName) + '</span>' : '') + '</td>' +
        '<td class="py-2.5 pr-3 text-gray-600 whitespace-nowrap">' + (r.confidence || 0) + '%</td>' +
        '<td class="py-2.5 pr-3 whitespace-nowrap">' + koshaLink(r.documentUrl || r.sourceUrl) + '</td>' +
        '<td class="py-2.5 whitespace-nowrap"><button type="button" class="r-save px-2.5 py-1 rounded-lg text-xs font-semibold bg-[#1A2E44] text-white hover:bg-[#0F2233]" data-i="' + i + '">저장</button></td>' +
        '</tr>';
    }).join('');
    qsa('#msdsSearchResults .r-save').forEach(function (b) { b.addEventListener('click', function () { save(lastResults[b.dataset.i], b); }); });
  }

  // ── 저장(내 자료함) ──
  function save(r, btn) {
    btn.disabled = true;
    fetch('/api/msds/attach', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chemicalName: r.chemicalName, casNo: r.casNo, productName: r.productName,
        sourceType: r.sourceType, sourceName: r.sourceName, sourceUrl: r.sourceUrl,
        documentUrl: r.documentUrl, revisionDate: r.revisionDate, confidence: r.confidence, verified: false
      })
    })
      .then(function (res) { if (!res.ok) return res.json().then(function (e) { throw new Error(e.error || '저장 실패'); }); return res.json(); })
      .then(function () { btn.textContent = '저장됨'; loadMine(); })
      .catch(function (err) { alert((err && err.message) || '저장에 실패했습니다.'); btn.disabled = false; });
  }

  // ── 내 자료함 ──
  function loadMine() {
    fetch('/api/msds/mine').then(function (res) { return res.ok ? res.json() : []; })
      .then(function (list) { renderMine(list || []); }).catch(function () {});
  }
  function renderMine(list) {
    qs('#msdsMineCount').textContent = list.length + '건';
    var wrap = qs('#msdsMineList');
    if (!list.length) { wrap.innerHTML = '<p class="text-sm text-gray-400">저장한 MSDS가 없습니다. 검색 결과에서 "저장"을 누르면 여기에 담깁니다.</p>'; return; }
    wrap.innerHTML = list.map(function (d) {
      var badge = SOURCE_BADGE[d.sourceType] || SOURCE_BADGE.UNKNOWN;
      return '<div class="flex items-center gap-3 p-3 rounded-xl border border-gray-100">' +
        '<div class="flex-1 min-w-0">' +
          '<p class="text-sm font-semibold text-gray-900">' + esc(d.chemicalName) + (d.casNo ? ' <span class="text-xs font-normal text-gray-500">(' + esc(d.casNo) + ')</span>' : '') + (d.inspectionId ? ' <span class="text-[10px] text-gray-400">· 점검 #' + d.inspectionId + '</span>' : '') + '</p>' +
          '<p class="text-xs text-gray-500 mt-0.5"><span class="font-semibold px-1.5 py-0.5 rounded-full ' + badge + '">' + esc(d.sourceTypeLabel) + '</span> ' + esc(d.sourceName || '') + (d.revisionDate ? ' · 개정 ' + esc(d.revisionDate) : '') + '</p>' +
        '</div>' +
        koshaLink(d.documentUrl || d.sourceUrl) +
        '<button type="button" class="m-verify text-xs font-semibold flex-shrink-0 px-2 py-1 rounded-lg ' + (d.verified ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500') + '" data-id="' + d.id + '" data-v="' + d.verified + '">' + (d.verified ? '✓ 확인됨' : '확인') + '</button>' +
        '</div>';
    }).join('');
    qsa('#msdsMineList .m-verify').forEach(function (b) {
      b.addEventListener('click', function () {
        fetch('/api/msds/' + b.dataset.id + '/verify', { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ verified: b.dataset.v !== 'true' }) })
          .then(function (res) { return res.ok ? res.json() : null; }).then(loadMine).catch(function () {});
      });
    });
  }

  loadMine();
})();
</script>
</body>
</html>
