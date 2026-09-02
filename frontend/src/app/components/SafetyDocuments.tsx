import { BookOpenCheck, BriefcaseBusiness, GraduationCap, HardHat, ReceiptText, ShieldCheck } from 'lucide-react';
import Layout from './Layout';

interface SafetyDocumentsProps {
  onNavigate: (page: string) => void;
  onCreate: (templateId: string) => void;
}

const OPERATING_DOCUMENTS = [
  { id: 'tbm', title: 'TBM 일지', description: '작업 전 안전 회의와 참석자 기록', icon: BookOpenCheck, color: '#1D4ED8', background: '#EFF6FF' },
  { id: 'edu', title: '안전보건교육일지', description: '교육 내용과 참석자 서명부', icon: GraduationCap, color: '#047857', background: '#ECFDF5' },
  { id: 'ppe', title: '보호구 지급대장', description: '보호구 품목·수량·수령자 기록', icon: HardHat, color: '#B45309', background: '#FFFBEB' },
];

const APPROVAL_DOCUMENTS = [
  { id: 'work', title: '안전작업허가서', description: '위험작업의 사전 안전조치와 승인 확인', icon: BriefcaseBusiness, color: '#6D28D9', background: '#F5F3FF' },
  { id: 'expense', title: '산업안전보건관리비 사용내역서', description: '집행 항목·금액·증빙과 누계 관리', icon: ReceiptText, color: '#BE123C', background: '#FFF1F2' },
];

export default function SafetyDocuments({ onNavigate, onCreate }: SafetyDocumentsProps) {
  const renderSection = (title: string, description: string, documents: typeof OPERATING_DOCUMENTS) => (
    <section className="mb-7">
      <div className="flex items-end justify-between mb-3">
        <div><h2 className="text-sm font-bold text-slate-800">{title}</h2><p className="text-xs text-slate-400 mt-1">{description}</p></div>
        <span className="text-xs text-slate-400">{documents.length}개 서류</span>
      </div>
      <div className={`grid grid-cols-1 ${documents.length === 3 ? 'md:grid-cols-3' : 'md:grid-cols-2'} gap-3`}>
        {documents.map(document => {
          const Icon = document.icon;
          return (
            <button key={document.id} onClick={() => onCreate(document.id)} className="text-left bg-white border border-slate-200 rounded p-4 hover:border-[#4A90D9] hover:shadow-sm transition-all">
              <span className="w-9 h-9 rounded flex items-center justify-center mb-4" style={{ color: document.color, background: document.background }}><Icon className="w-5 h-5" /></span>
              <span className="block font-semibold text-slate-900">{document.title}</span>
              <span className="block text-xs text-slate-500 mt-1">{document.description}</span>
            </button>
          );
        })}
      </div>
    </section>
  );

  return (
    <Layout currentPath="documents" onNavigate={onNavigate}>
      <div className="flex items-start justify-between gap-4 mb-7">
        <div><p className="text-xs font-semibold text-gray-400 mb-2">현장 문서 관리</p><h1 className="text-[22px] font-semibold text-slate-900 leading-none mb-2">안전 서류</h1><p className="text-sm text-slate-500">조치와 무관한 현장 운영·승인·증빙 서류를 작성합니다.</p></div>
        <button onClick={() => onNavigate('saved-reports')} className="px-4 py-2.5 border border-slate-200 bg-white rounded text-sm font-semibold text-slate-700 hover:bg-slate-50">완료된 보고서 보기</button>
      </div>
      {renderSection('현장 운영 기록', '작업 전 회의, 교육 및 지급 내역', OPERATING_DOCUMENTS)}
      {renderSection('승인·증빙 서류', '위험작업 승인과 안전관리비 집행 증빙', APPROVAL_DOCUMENTS)}
      <section className="border-t border-slate-200 pt-6">
        <div className="flex items-center justify-between mb-3"><h2 className="text-sm font-bold text-slate-800">조치 연계 보고서</h2><span className="text-xs text-slate-400">조치관리에서 작성</span></div>
        <div className="flex items-center justify-between gap-4 bg-slate-50 border border-slate-200 rounded px-5 py-4">
          <div className="flex items-start gap-3"><ShieldCheck className="w-5 h-5 text-slate-500 mt-0.5" /><div><p className="text-sm font-semibold text-slate-800">조치결과보고서 · 위험성평가서 · 안전점검일지</p><p className="text-xs text-slate-500 mt-1">완료 조치와 위험요소 데이터를 사용하므로 조치관리에서 작성합니다.</p></div></div>
          <button onClick={() => onNavigate('actions')} className="flex-shrink-0 px-4 py-2 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#254d7a]">조치관리로 이동</button>
        </div>
      </section>
    </Layout>
  );
}
