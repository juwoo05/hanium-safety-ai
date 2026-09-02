function sanitizeFileName(value: string) {
  return value.replace(/[\\/:*?"<>|]/g, '_').replace(/\s+/g, '_');
}

function escapeHtml(value: unknown) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function downloadBlob(fileName: string, blob: Blob) {
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = sanitizeFileName(fileName);
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  window.setTimeout(() => URL.revokeObjectURL(url), 1000);
}

export function downloadCsv(fileName: string, headers: string[], rows: Array<Array<string | number>>) {
  const quote = (value: string | number) => `"${String(value).replace(/"/g, '""')}"`;
  const csv = [headers, ...rows].map(row => row.map(quote).join(',')).join('\r\n');
  downloadBlob(fileName, new Blob([`\uFEFF${csv}`], { type: 'text/csv;charset=utf-8' }));
}

export interface DemoReportFile {
  id?: string;
  title: string;
  site: string;
  author: string;
  createdAt: string;
  actionCount?: number;
  details?: Array<{ label: string; value: unknown }>;
}

export function downloadReportHtml(report: DemoReportFile) {
  const details = report.details ?? [];
  const rows = [
    ['문서번호', report.id || 'DEMO-' + Date.now()],
    ['현장명', report.site],
    ['작성자', report.author],
    ['작성일', report.createdAt],
    ...(report.actionCount == null ? [] : [['포함 조치', `${report.actionCount}건`]]),
    ...details.map(item => [item.label, item.value]),
  ];
  const html = `<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>${escapeHtml(report.title)}</title><style>body{font-family:Arial,'Malgun Gothic',sans-serif;color:#172033;max-width:820px;margin:40px auto;padding:0 24px}h1{text-align:center;font-size:24px;margin-bottom:8px}.sub{text-align:center;color:#64748b;margin-bottom:32px}table{width:100%;border-collapse:collapse}th,td{border:1px solid #cbd5e1;padding:12px;text-align:left;vertical-align:top}th{width:150px;background:#f1f5f9}footer{margin-top:36px;padding-top:12px;border-top:1px solid #e2e8f0;color:#94a3b8;font-size:12px;text-align:right}</style></head><body><h1>${escapeHtml(report.title)}</h1><p class="sub">건설현장 안전관리 플랫폼 연결고리</p><table><tbody>${rows.map(([label,value]) => `<tr><th>${escapeHtml(label)}</th><td>${escapeHtml(value)}</td></tr>`).join('')}</tbody></table><footer>공모전 시연용 자동 생성 문서</footer></body></html>`;
  downloadBlob(`${report.site}_${report.title}_${report.createdAt}.html`, new Blob([html], { type: 'text/html;charset=utf-8' }));
}

export function downloadSafetyDocumentHtml(document: SafetyDocumentSnapshot) {
  const infoRows = document.information.map(([label, value]) => `<tr><th>${escapeHtml(label)}</th><td>${escapeHtml(value)}</td></tr>`).join('');
  const sections = document.tables.map((table, index) => `
    <section><h2>${index + 1}. ${escapeHtml(table.title)}</h2><table><thead><tr>${table.headers.map(header => `<th>${escapeHtml(header)}</th>`).join('')}</tr></thead><tbody>
    ${table.rows.map(row => `<tr>${row.map(value => `<td>${escapeHtml(value)}</td>`).join('')}</tr>`).join('')}
    </tbody></table></section>`).join('');
  const signatures = document.signatures.map((label, index) => `<td><strong>${escapeHtml(label)}</strong><div class="sign">${index === 0 ? escapeHtml(document.writer) : ''} (서명)</div></td>`).join('');
  const html = `<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>${escapeHtml(document.templateName)}</title><style>
    @page{size:A4;margin:14mm}body{font-family:Arial,'Malgun Gothic',sans-serif;color:#172033;max-width:1000px;margin:28px auto;padding:0 18px;font-size:12px}header{text-align:center;border-bottom:2px solid #172033;padding-bottom:14px}header .meta{display:flex;justify-content:space-between;color:#64748b;font-size:11px}h1{font-size:24px;margin:12px 0 4px}h2{font-size:14px;margin:22px 0 8px}table{width:100%;border-collapse:collapse;table-layout:auto}th,td{border:1px solid #64748b;padding:7px;text-align:center;vertical-align:top;word-break:keep-all}th{background:#f1f5f9}.info th{width:120px}.summary{border:1px solid #64748b;background:#f8fafc;padding:12px;line-height:1.7}.sign{height:46px;display:flex;align-items:flex-end;justify-content:center;color:#64748b}footer{margin-top:20px;padding-top:8px;border-top:1px solid #cbd5e1;text-align:right;color:#94a3b8;font-size:10px}@media print{body{margin:0;max-width:none}section{break-inside:avoid}}
  </style></head><body><header><div class="meta"><span>문서번호: ${escapeHtml(document.documentNumber)}</span><span>AI 자동작성 · 원본 보존</span></div><h1>${escapeHtml(document.templateName)}</h1><div>${escapeHtml(document.siteName)} · ${escapeHtml(document.documentDate)}</div></header>
  <h2>현장 및 문서 정보</h2><table class="info"><tbody><tr><th>현장명</th><td>${escapeHtml(document.siteName)}</td><th>작성자</th><td>${escapeHtml(document.writer)}</td></tr><tr><th>원청사</th><td>${escapeHtml(document.contractor)}</td><th>협력사</th><td>${escapeHtml(document.subcontractor)}</td></tr>${infoRows}</tbody></table>
  <h2>종합 내용</h2><div class="summary">${escapeHtml(document.summary)}</div>${sections}<h2>확인 및 승인</h2><table><tbody><tr>${signatures}</tr></tbody></table><footer>${escapeHtml(document.sourceNote)}</footer></body></html>`;
  downloadBlob(`${document.siteName}_${document.templateName}_${document.documentDate}.html`, new Blob([html], { type: 'text/html;charset=utf-8' }));
}
import type { SafetyDocumentSnapshot } from '../components/SafetyDocumentTemplate';
