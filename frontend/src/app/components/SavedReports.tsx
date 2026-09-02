import { useMemo, useState } from 'react';
import { CheckCircle2, Download, Eye, FileCheck2, Search, Sparkles, X } from 'lucide-react';
import { toast } from 'sonner';
import type { SavedReport } from '../App';
import Layout from './Layout';
import { downloadSafetyDocumentHtml } from '../utils/demoFiles';
import { SafetyDocumentPreview } from './SafetyDocumentTemplate';

interface SavedReportsProps {
  onNavigate: (page: string) => void;
  reports: SavedReport[];
}

export default function SavedReports({ onNavigate, reports }: SavedReportsProps) {
  const [query, setQuery] = useState('');
  const [selected, setSelected] = useState<SavedReport | null>(null);

  const filteredReports = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    if (!keyword) return reports;
    return reports.filter(report =>
      [report.id, report.title, report.site, report.author].some(value => value.toLowerCase().includes(keyword))
    );
  }, [query, reports]);

  const downloadReport = (report: SavedReport) => {
    downloadSafetyDocumentHtml(report.snapshot);
    toast.success(`${report.title} 문서를 내려받았습니다.`);
  };

  return (
    <Layout currentPath="saved-reports" onNavigate={onNavigate}>
      <div className="flex items-start justify-between gap-4 mb-6">
        <div>
          <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', lineHeight: 1, marginBottom: 6 }}>완료된 보고서</h1>
          <p style={{ fontSize: 13, color: '#64748B' }}>AI가 작성한 당시의 양식과 내용을 그대로 다시 열고 내려받을 수 있습니다.</p>
        </div>
        <button
          onClick={() => onNavigate('documents')}
          className="flex items-center gap-2 px-4 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#254d7a] transition-colors"
        >
          <FileCheck2 className="w-4 h-4" /> 안전서류 작성
        </button>
      </div>

      <div className="flex items-center justify-between gap-4 mb-4">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            value={query}
            onChange={event => setQuery(event.target.value)}
            placeholder="보고서명, 현장, 작성자 검색"
            className="w-full h-10 pl-9 pr-3 border border-gray-200 rounded bg-white text-sm outline-none focus:border-[#4A90D9]"
          />
        </div>
        <span className="text-sm text-gray-500 whitespace-nowrap">총 {filteredReports.length}건</span>
      </div>

      <div className="bg-white border border-gray-200 rounded overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200 text-gray-500">
              <tr>
                <th className="px-4 py-3 text-left font-medium">문서번호</th>
                <th className="px-4 py-3 text-left font-medium">보고서</th>
                <th className="px-4 py-3 text-left font-medium">현장</th>
                <th className="px-4 py-3 text-left font-medium">작성자</th>
                <th className="px-4 py-3 text-left font-medium">저장일</th>
                <th className="px-4 py-3 text-center font-medium">조치</th>
                <th className="px-4 py-3 text-right font-medium">관리</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredReports.map(report => (
                <tr key={report.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-4 py-3 text-gray-500 font-mono text-xs">{report.id}</td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-gray-800">{report.title}</span>
                      {report.aiGenerated && (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-50 text-blue-700 border border-blue-100 rounded text-[11px] whitespace-nowrap">
                          <Sparkles className="w-3 h-3" /> AI 자동작성
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="px-4 py-3 text-gray-600">{report.site}</td>
                  <td className="px-4 py-3 text-gray-600">{report.author}</td>
                  <td className="px-4 py-3 text-gray-500 whitespace-nowrap">{report.createdAt}</td>
                  <td className="px-4 py-3 text-center text-gray-700">{report.actionCount}건</td>
                  <td className="px-4 py-3">
                    <div className="flex items-center justify-end gap-1">
                      <button
                        onClick={() => setSelected(report)}
                        title="보고서 보기"
                        className="w-8 h-8 inline-flex items-center justify-center border border-gray-200 rounded text-gray-500 hover:text-[#1D4ED8] hover:border-blue-200"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => downloadReport(report)}
                        title="보고서 다운로드"
                        className="w-8 h-8 inline-flex items-center justify-center border border-gray-200 rounded text-gray-500 hover:text-[#1D4ED8] hover:border-blue-200"
                      >
                        <Download className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {filteredReports.length === 0 && (
          <div className="py-16 text-center text-sm text-gray-400">검색 결과가 없습니다.</div>
        )}
      </div>

      {selected && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/35 p-4" onClick={() => setSelected(null)}>
          <div className="w-full max-w-5xl max-h-[92vh] flex flex-col bg-white rounded border border-gray-200 shadow-xl" onClick={event => event.stopPropagation()}>
            <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
              <div>
                <p className="text-xs text-gray-400 mb-1">{selected.id}</p>
                <h2 className="font-semibold text-gray-900">{selected.title}</h2>
              </div>
              <button onClick={() => setSelected(null)} title="닫기" className="w-8 h-8 inline-flex items-center justify-center rounded hover:bg-gray-100">
                <X className="w-4 h-4 text-gray-500" />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto px-6 py-5 bg-slate-100">
              <div className="max-w-4xl mx-auto bg-white border border-slate-200 shadow-sm p-7">
                <SafetyDocumentPreview document={selected.snapshot} />
              </div>
            </div>
            <div className="flex justify-end gap-2 px-5 py-4 border-t border-gray-100">
              <span className="mr-auto flex items-center gap-2 text-xs text-green-700"><CheckCircle2 className="w-4 h-4" /> 생성 당시 원본 양식</span>
              <button onClick={() => setSelected(null)} className="px-4 py-2 border border-gray-200 rounded text-sm text-gray-600 hover:bg-gray-50">닫기</button>
              <button onClick={() => downloadReport(selected)} className="flex items-center gap-2 px-4 py-2 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#254d7a]">
                <Download className="w-4 h-4" /> 보고서 다운로드
              </button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
