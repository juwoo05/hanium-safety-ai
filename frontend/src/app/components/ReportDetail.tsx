import { useState, useRef, type ReactNode } from 'react';
import type { CompletedAction } from '../App';
import Layout from './Layout';
import ActionVerificationPanel from './ActionVerificationPanel';
import {
  ArrowLeft, MapPin, Calendar, User, Download, Share2, FileText,
  CheckCircle2, Bookmark, ExternalLink, ChevronRight, Camera,
  Sparkles, Loader2, Printer, Edit3, Save, ClipboardList,
  AlertTriangle, Upload, X, Eye, FileScan,
} from 'lucide-react';
import { toast } from 'sonner';

interface ReportDetailProps {
  onNavigate: (page: string) => void;
  beforeImages?: string[];
  onStartReport?: (actions: CompletedAction[]) => void;
}

// ─── Static data ────────────────────────────────────────────────────────────

const detectedIssues = [
  {
    title: '안전난간 미설치',
    risk: 'high',
    description: '3층 외벽 작업 구역에 추락 방지용 안전난간이 설치되지 않았습니다.',
    location: '감지 영역: 이미지 상단 좌측',
    recommendation: '즉시 안전난간 설치 및 작업자 출입 통제',
    regulation: '산업안전보건법 제38조',
    status: '조치 필요',
    confidence: 98,
  },
  {
    title: '임시 배선 노출',
    risk: 'high',
    description: '작업장 바닥에 전선이 노출되어 감전 및 화재 위험이 있습니다.',
    location: '감지 영역: 이미지 중앙 하단',
    recommendation: '배선 정리 및 전선 보호 커버 설치',
    regulation: '전기사업법 제67조',
    status: '조치 필요',
    confidence: 95,
  },
  {
    title: '안전모 미착용',
    risk: 'medium',
    description: '현장 작업자 중 1명이 안전모를 착용하지 않은 것으로 확인됩니다.',
    location: '감지 영역: 이미지 우측',
    recommendation: '안전모 착용 교육 및 관리 강화',
    regulation: '산업안전보건법 제24조',
    status: '완료',
    confidence: 92,
  },
];

const evidenceResources = {
  법규: [
    { title: '산업안전보건법 제38조 - 추락 위험 방지', summary: '사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간, 울, 수직형 추락방호망...', relevance: 98, source: '고용노동부' },
    { title: '전기사업법 제67조 - 전기설비 기술기준', summary: '전기사용장소의 시설은 감전, 화재 그 밖에 사람에게 위해를 주거나...', relevance: 95, source: '산업통상자원부' },
  ],
  사고사례: [
    { title: '건설현장 추락사고 사례 (2025.03)', summary: '안전난간 미설치로 인한 3층 높이 추락사고로 중상자 1명 발생', relevance: 92, source: '산업재해통계' },
    { title: '전기감전 사고 사례 (2025.01)', summary: '임시 전선 노출로 인한 감전사고, 작업 중단 및 안전점검 실시', relevance: 88, source: '안전보건공단' },
  ],
  지침: [
    { title: '건설현장 안전난간 설치 가이드', summary: '안전난간의 높이, 재질, 설치 방법에 대한 상세 지침', relevance: 96, source: '안전보건공단' },
    { title: '전기안전 작업수칙', summary: '전기 작업 시 안전수칙 및 점검사항', relevance: 90, source: '한국전기안전공사' },
  ],
};

const riskColors: Record<string, string> = { high: 'bg-red-500', medium: 'bg-orange-500', low: 'bg-yellow-500' };
const riskLabels: Record<string, string> = { high: '고위험', medium: '중위험', low: '저위험' };
const riskTextColors: Record<string, string> = { high: 'text-red-700', medium: 'text-orange-700', low: 'text-yellow-700' };
const riskBgColors: Record<string, string> = { high: 'bg-red-50 border-red-200', medium: 'bg-orange-50 border-orange-200', low: 'bg-yellow-50 border-yellow-200' };

// ─── Form Templates ──────────────────────────────────────────────────────────

const FORM_TEMPLATES = [
  { id: 'inspection', label: '안전점검일지', icon: ClipboardList, desc: '일상 현장 안전점검 결과 기록' },
  { id: 'risk',       label: '위험성평가서', icon: AlertTriangle,  desc: '위험요소 분류 및 개선대책 수립' },
  { id: 'action',     label: '조치결과보고서', icon: CheckCircle2, desc: '조치 완료 결과 및 재발방지 계획' },
  { id: 'work',       label: '작업허가서',    icon: FileText,      desc: '위험작업 사전 승인 및 조건 기록' },
];

interface UploadedFormFile {
  id: string;
  name: string;
  size: string;
  type: string;
  previewUrl?: string;
  parsedFields?: Partial<SafetyForm>;
  parseStatus: 'idle' | 'parsing' | 'done' | 'error';
}

interface SafetyForm {
  // 공통
  companyName: string;
  siteName: string;
  inspectionDate: string;
  inspector: string;
  supervisor: string;
  // 안전점검일지
  overallResult: string;
  weatherCondition: string;
  workerCount: string;
  items: { title: string; status: '양호' | '불량' | '해당없음'; note: string }[];
  // 위험성평가서
  assessmentPurpose: string;
  // 조치결과보고서
  actionSummary: string;
  preventionPlan: string;
  // 작업허가서
  workType: string;
  workScope: string;
  precautions: string;
  // 서명
  signaturePreparer: string;
  signatureReviewer: string;
  signatureApprover: string;
}

const EMPTY_FORM: SafetyForm = {
  companyName: '', siteName: '', inspectionDate: '', inspector: '', supervisor: '',
  overallResult: '양호', weatherCondition: '맑음', workerCount: '',
  items: [],
  assessmentPurpose: '', actionSummary: '', preventionPlan: '',
  workType: '', workScope: '', precautions: '',
  signaturePreparer: '', signatureReviewer: '', signatureApprover: '',
};

// ─── Main Component ──────────────────────────────────────────────────────────

export default function ReportDetail({ onNavigate, beforeImages = [], onStartReport }: ReportDetailProps) {
  const [mainTab, setMainTab]   = useState<'분석결과' | '안전양식' | '증거자료'>('분석결과');
  const [activeTab, setActiveTab] = useState('전체');
  const [evidenceTab, setEvidenceTab] = useState<'법규' | '사고사례' | '지침'>('법규');
  const [openVerification, setOpenVerification] = useState<number | null>(null);

  // Safety form state
  const [formTemplate, setFormTemplate] = useState<string>('inspection');
  const [safetyForm, setSafetyForm] = useState<SafetyForm>(EMPTY_FORM);
  const [aiLoading, setAiLoading] = useState(false);
  const [aiDone, setAiDone] = useState(false);
  const [editMode, setEditMode] = useState(true);

  // File upload state
  const [uploadedFiles, setUploadedFiles] = useState<UploadedFormFile[]>([]);
  const [uploadDragging, setUploadDragging] = useState(false);
  const [parsedFile, setParsedFile] = useState<UploadedFormFile | null>(null);
  const [parseLoading, setParseLoading] = useState(false);
  const fileUploadRef = useRef<HTMLInputElement>(null);

  const setField = (key: keyof SafetyForm, value: string) =>
    setSafetyForm(f => ({ ...f, [key]: value }));

  const setItemField = (i: number, key: 'status' | 'note', value: string) =>
    setSafetyForm(f => ({
      ...f,
      items: f.items.map((it, idx) =>
        idx === i ? { ...it, [key]: value as '양호' | '불량' | '해당없음' } : it
      ),
    }));

  const handleAiFill = () => {
    setAiLoading(true);
    setAiDone(false);
    setTimeout(() => {
      const today = new Date().toISOString().slice(0, 10);
      setSafetyForm({
        companyName: '(주)세이프메이트 건설',
        siteName: '3동 건물 외벽 공사현장',
        inspectionDate: today,
        inspector: '김현장',
        supervisor: '박안전',
        overallResult: '불량',
        weatherCondition: '맑음',
        workerCount: '24',
        items: detectedIssues.map(issue => ({
          title: issue.title,
          status: issue.status === '완료' ? '양호' : '불량',
          note: `${issue.description} — 권장조치: ${issue.recommendation}`,
        })),
        assessmentPurpose: `AI 자동 분석 결과 ${detectedIssues.length}건의 위험요소 감지됨. 고위험 항목 ${detectedIssues.filter(i => i.risk === 'high').length}건에 대한 즉각적인 조치가 필요합니다.`,
        actionSummary: detectedIssues
          .filter(i => i.status === '완료')
          .map(i => `• ${i.title}: ${i.recommendation}`)
          .join('\n') || '조치 진행 중',
        preventionPlan: '1. 정기 안전점검 주기 단축 (주 1회 → 주 2회)\n2. 신규 작업자 안전교육 의무화\n3. AI 모니터링 시스템 상시 가동',
        workType: '외벽 마감 및 전기 배선 작업',
        workScope: '3동 2~4층 외벽 구간, 전기실 임시 배선 정비',
        precautions: detectedIssues.map(i => `• ${i.regulation}: ${i.recommendation}`).join('\n'),
        signaturePreparer: '', signatureReviewer: '', signatureApprover: '',
      });
      setAiLoading(false);
      setAiDone(true);
      toast.success('AI가 조치관리 데이터를 기반으로 양식을 자동 작성했습니다.');
    }, 2400);
  };

  const handleSave = () => {
    setEditMode(false);
    toast.success('안전양식이 저장되었습니다.');
  };

  const handleDownload = () => {
    toast.success('PDF 다운로드가 시작됩니다.');
  };

  const handleFormFiles = (raw: FileList | File[]) => {
    const allowed = ['application/pdf', 'image/png', 'image/jpeg', 'image/jpg',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    const files = Array.from(raw).filter(f => allowed.some(t => f.type.startsWith('image/') || f.type === t));
    if (!files.length) { toast.error('PDF, 이미지, Excel, Word 파일만 가능합니다'); return; }
    const next: UploadedFormFile[] = files.map(f => ({
      id: `${Date.now()}-${f.name}`,
      name: f.name,
      size: f.size < 1024 * 1024 ? `${(f.size / 1024).toFixed(1)} KB` : `${(f.size / 1024 / 1024).toFixed(2)} MB`,
      type: f.type.startsWith('image/') ? 'image' : f.type.includes('pdf') ? 'pdf' : f.type.includes('sheet') || f.type.includes('excel') ? 'excel' : 'word',
      previewUrl: f.type.startsWith('image/') ? URL.createObjectURL(f) : undefined,
      parseStatus: 'idle',
    }));
    setUploadedFiles(prev => [...prev, ...next]);
    toast.success(`${files.length}개 파일이 추가되었습니다.`);
  };

  const handleParseFile = (file: UploadedFormFile) => {
    setParsedFile(file);
    setParseLoading(true);
    setUploadedFiles(prev => prev.map(f => f.id === file.id ? { ...f, parseStatus: 'parsing' } : f));
    const today = new Date().toISOString().slice(0, 10);
    setTimeout(() => {
      const parsed: Partial<SafetyForm> = {
        companyName: '(주)ABC 건설',
        siteName: '3동 건물 외벽 공사현장',
        inspectionDate: today,
        inspector: '이담당',
        supervisor: '최관리',
        overallResult: '불량',
        weatherCondition: '흐림',
        workerCount: '18',
        items: [
          { title: '추락방지 안전난간 설치 여부', status: '불량', note: '3층 외벽 구간 미설치 확인' },
          { title: '안전모 착용 현황', status: '불량', note: '작업자 2명 미착용' },
          { title: '소화기 배치 여부', status: '양호', note: '각 층 지정 위치 배치 완료' },
          { title: '전기배선 안전 처리', status: '불량', note: '임시 배선 노출 구간 존재' },
          { title: '비상구 확보', status: '양호', note: '전 구간 정상 확보' },
        ],
        assessmentPurpose: `${file.name} 양식에서 추출된 현장 안전점검 결과입니다.`,
      };
      setUploadedFiles(prev => prev.map(f => f.id === file.id ? { ...f, parseStatus: 'done', parsedFields: parsed } : f));
      setParsedFile({ ...file, parseStatus: 'done', parsedFields: parsed });
      setParseLoading(false);
      toast.success(`"${file.name}" 파일 분석 완료`);
    }, 2600);
  };

  const handleApplyParsed = (parsed: Partial<SafetyForm>) => {
    setSafetyForm(f => ({ ...f, ...parsed }));
    setAiDone(true);
    setEditMode(true);
    toast.success('파일에서 읽은 내용이 양식에 적용되었습니다.');
  };

  const removeFile = (id: string) => {
    setUploadedFiles(prev => {
      const f = prev.find(x => x.id === id);
      if (f?.previewUrl) URL.revokeObjectURL(f.previewUrl);
      return prev.filter(x => x.id !== id);
    });
    if (parsedFile?.id === id) setParsedFile(null);
  };

  return (
    <Layout currentPath="actions-detail" onNavigate={onNavigate}>
      <div className="space-y-5">

        {/* ── Page Header ── */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <div className="flex items-start justify-between mb-5">
            <div className="flex items-center gap-4">
              <button onClick={() => onNavigate('actions')} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                <ArrowLeft className="w-5 h-5" />
              </button>
              <div>
                <div className="flex items-center gap-3 mb-1.5">
                  <h1 className="text-xl font-bold text-gray-900">3동 건물 외벽 안전 분석 리포트</h1>
                  <span className="px-2.5 py-0.5 bg-blue-100 text-blue-700 text-xs font-semibold rounded-full">SR-2026-001</span>
                </div>
                <div className="flex flex-wrap items-center gap-3 text-sm text-gray-500">
                  <span className="flex items-center gap-1"><Calendar className="w-3.5 h-3.5" />2026-06-01 09:30</span>
                  <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" />3동 지하 1층</span>
                  <span className="flex items-center gap-1"><User className="w-3.5 h-3.5" />김현장</span>
                  <span className="px-2 py-0.5 bg-green-100 text-green-700 text-xs font-medium rounded-full">분석 완료</span>
                </div>
              </div>
            </div>
            <div className="flex items-center gap-2 flex-shrink-0">
              <button onClick={handleDownload} className="flex items-center gap-1.5 px-3 py-2 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium text-gray-700">
                <Download className="w-4 h-4" /> PDF
              </button>
              <button className="flex items-center gap-1.5 px-3 py-2 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium text-gray-700">
                <Share2 className="w-4 h-4" /> 공유
              </button>
            </div>
          </div>

          {/* Risk banner */}
          <div className="rounded p-4 border border-red-200 flex items-center gap-5" style={{ background: '#FEF2F2' }}>
            <div>
              <p className="text-xs text-gray-500 mb-0.5">종합 위험도</p>
              <div className="flex items-center gap-2">
                <span className="text-3xl font-bold text-red-600">8.5</span>
                <span className="text-gray-400">/ 10</span>
                <span className="px-2 py-0.5 bg-red-500 text-white text-xs font-semibold rounded-md">고위험</span>
              </div>
            </div>
            <div className="flex-1">
              <div className="w-full bg-gray-200 rounded-full h-2.5">
                <div className="bg-red-500 h-2.5 rounded-full" style={{ width: '85%' }} />
              </div>
            </div>
            <div className="text-right flex-shrink-0">
              <p className="text-xs text-gray-500">감지 항목</p>
              <p className="text-2xl font-bold text-gray-900">{detectedIssues.length}건</p>
            </div>
          </div>

          {/* Main Tab Nav */}
          <div className="flex gap-1 mt-5 border-b border-gray-100 pb-0">
            {(['분석결과', '안전양식', '증거자료'] as const).map(tab => (
              <button
                key={tab}
                onClick={() => setMainTab(tab)}
                className={`px-5 py-2.5 text-sm font-semibold transition-all border-b-2 -mb-px ${
                  mainTab === tab
                    ? 'border-gray-900 text-gray-900'
                    : 'border-transparent text-gray-500 hover:text-gray-700'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* ══════════════════════════════════════════ */}
        {/* TAB: 분석결과                               */}
        {/* ══════════════════════════════════════════ */}
        {mainTab === '분석결과' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
            <div className="lg:col-span-2 space-y-4">
              <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center justify-between mb-5">
                  <h3 className="text-base font-bold text-gray-900">감지된 위험 항목</h3>
                  <div className="flex items-center gap-1.5">
                    {['전체', '조치 필요', '완료'].map(tab => (
                      <button key={tab} onClick={() => setActiveTab(tab)}
                        className={`px-3 py-1 rounded-lg text-xs font-semibold transition-colors ${
                          activeTab === tab ? 'bg-[#1A2E44] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                        }`}>{tab}</button>
                    ))}
                  </div>
                </div>

                <div className="space-y-4">
                  {detectedIssues
                    .filter(i => activeTab === '전체' || i.status === activeTab)
                    .map((issue, index) => (
                      <div key={index} className={`rounded-xl border-2 p-5 transition-all ${riskBgColors[issue.risk]}`}>
                        <div className="flex items-start justify-between mb-3">
                          <div className="flex items-start gap-3 flex-1">
                            <div className={`w-2.5 h-2.5 rounded-full ${riskColors[issue.risk]} mt-2 flex-shrink-0`} />
                            <div>
                              <h4 className="font-bold text-gray-900 mb-1">{issue.title}</h4>
                              <div className="flex items-center gap-2">
                                <span className={`px-2 py-0.5 ${riskColors[issue.risk]} text-white text-[10px] font-bold rounded`}>{riskLabels[issue.risk]}</span>
                                <span className="text-xs text-gray-500">신뢰도 {issue.confidence}%</span>
                              </div>
                            </div>
                          </div>
                          <span className={`px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 ${issue.status === '조치 필요' ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}`}>
                            {issue.status}
                          </span>
                        </div>

                        <p className="text-sm text-gray-700 mb-3">{issue.description}</p>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-4">
                          <div className="bg-white/70 rounded-lg p-3">
                            <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wide mb-1">감지 위치</p>
                            <p className="text-xs text-gray-800">{issue.location}</p>
                          </div>
                          <div className="bg-white/70 rounded-lg p-3">
                            <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wide mb-1">관련 법규</p>
                            <p className="text-xs text-gray-800 font-medium">{issue.regulation}</p>
                          </div>
                        </div>

                        <div className="bg-white/80 rounded-lg p-3 mb-4 border border-orange-200">
                          <p className="text-xs font-bold text-orange-800 mb-1">권장 조치사항</p>
                          <p className="text-xs text-orange-700">{issue.recommendation}</p>
                        </div>

                        <div className="flex gap-2">
                          {issue.status === '조치 필요' && (
                            <button onClick={() => onNavigate('upload')}
                              className="flex-1 py-2.5 bg-[#1A2E44] text-white text-sm font-semibold rounded-lg hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-2">
                              <CheckCircle2 className="w-4 h-4" /> 조치 등록하기
                            </button>
                          )}
                          <button
                            onClick={() => setOpenVerification(openVerification === index ? null : index)}
                            className={`flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-sm font-semibold transition-colors border-2 ${
                              openVerification === index
                                ? 'bg-[#1A2E44] text-white border-[#1A2E44]'
                                : 'border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44]/5'
                            }`}
                          >
                            <Camera className="w-4 h-4" /> 현장 비교
                          </button>
                        </div>

                        {openVerification === index && (
                          <div className="mt-4">
                            <ActionVerificationPanel
                              issueTitle={issue.title}
                              issueCode={`A00${index + 1}`}
                              description={issue.description}
                              checklist={['안전난간 설치 (높이 1.2m 이상)', '중간난간 설치', '발끝막이판 설치', '작업발판 고정 확인']}
                              beforeImage={beforeImages[index] ?? beforeImages[0]}
                              onClose={() => setOpenVerification(null)}
                            />
                          </div>
                        )}
                      </div>
                    ))}
                </div>
              </div>
            </div>

            {/* Right: Action summary */}
            <div className="space-y-4">
              <div className="rounded p-5 border border-gray-200" style={{ background: '#F9FAFB' }}>
                <h3 className="font-bold text-gray-900 mb-4">조치 항목 요약</h3>
                <div className="space-y-2.5 mb-4">
                  {[
                    { label: '전체 항목',  value: detectedIssues.length, color: 'text-gray-900' },
                    { label: '조치 필요',  value: detectedIssues.filter(i => i.status === '조치 필요').length, color: 'text-red-600' },
                    { label: '완료',      value: detectedIssues.filter(i => i.status === '완료').length,      color: 'text-green-600' },
                  ].map(row => (
                    <div key={row.label} className="flex items-center justify-between bg-white rounded-lg px-3 py-2">
                      <span className="text-sm text-gray-600">{row.label}</span>
                      <span className={`text-sm font-bold ${row.color}`}>{row.value}건</span>
                    </div>
                  ))}
                </div>
                <button
                  onClick={() => {
                    const completed = detectedIssues
                      .filter(i => i.status === '완료')
                      .map(i => ({
                        title: i.title,
                        risk: i.risk as 'high' | 'medium' | 'low',
                        description: i.description,
                        location: i.location,
                        recommendation: i.recommendation,
                        regulation: i.regulation,
                        confidence: i.confidence,
                      }));
                    if (onStartReport) {
                      onStartReport(completed);
                    } else {
                      setMainTab('안전양식');
                    }
                  }}
                  className="w-full py-2.5 text-sm font-semibold rounded transition-colors flex items-center justify-center gap-2"
                  style={{ background: '#1A2E44', color: 'white', border: 'none' }}>
                  <FileText className="w-4 h-4" /> 안전양식 자동 작성
                </button>
                <button onClick={() => onNavigate('actions')}
                  className="w-full mt-2 py-2.5 border border-gray-200 text-gray-600 text-sm font-medium rounded-xl hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
                  조치 관리로 이동 <ChevronRight className="w-4 h-4" />
                </button>
              </div>

              <div className="rounded p-5 border border-gray-200" style={{ background: '#EFF6FF' }}>
                <p className="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wide">AI 종합 의견</p>
                <p className="text-xs text-gray-700 leading-relaxed">
                  고위험 항목 <span className="font-bold" style={{ color: '#991B1B' }}>2건</span>이 감지되었습니다. 특히 안전난간 미설치는 즉각적인 조치가 필요하며, 전선 노출은 화재 위험과 연결될 수 있습니다. 오늘 내로 담당자 배정을 권장합니다.
                </p>
              </div>
            </div>
          </div>
        )}

        {/* ══════════════════════════════════════════ */}
        {/* TAB: 안전양식                               */}
        {/* ══════════════════════════════════════════ */}
        {mainTab === '안전양식' && (
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-5">

            {/* Left: Template selector */}
            <div className="lg:col-span-1 space-y-4">
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
                <p className="text-sm font-bold text-gray-700 mb-3">양식 종류</p>
                <div className="space-y-2">
                  {FORM_TEMPLATES.map(tpl => {
                    const Icon = tpl.icon;
                    const active = formTemplate === tpl.id;
                    return (
                      <button key={tpl.id} onClick={() => { setFormTemplate(tpl.id); setAiDone(false); setSafetyForm(EMPTY_FORM); setEditMode(true); }}
                        className={`w-full text-left flex items-start gap-3 p-3 rounded-xl border-2 transition-all ${active ? 'border-[#1A2E44] bg-[#1A2E44]/5' : 'border-gray-100 hover:border-gray-200'}`}>
                        <div className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 ${active ? 'bg-[#1A2E44] text-white' : 'bg-gray-100 text-gray-500'}`}>
                          <Icon className="w-4 h-4" />
                        </div>
                        <div>
                          <p className={`text-sm font-semibold ${active ? 'text-[#1A2E44]' : 'text-gray-800'}`}>{tpl.label}</p>
                          <p className="text-[10px] text-gray-400 mt-0.5 leading-tight">{tpl.desc}</p>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* AI fill button */}
              <div className="rounded p-5" style={{ background: '#1A2E44', color: 'white' }}>
                <div className="flex items-center gap-2 mb-2">
                  <Sparkles size={15} color="#93C5FD" />
                  <p style={{ fontWeight: 600, fontSize: 13 }}>자동 작성</p>
                </div>
                <p style={{ fontSize: 11, color: 'rgba(255,255,255,0.65)', marginBottom: 14, lineHeight: 1.5 }}>
                  조치관리 데이터를 기반으로 AI가 양식을 자동 작성합니다.
                </p>
                <button
                  onClick={handleAiFill}
                  disabled={aiLoading}
                  style={{
                    width: '100%', padding: '8px 0', borderRadius: 4,
                    fontSize: 12, fontWeight: 600, border: 'none', cursor: aiLoading ? 'not-allowed' : 'pointer',
                    background: aiLoading ? 'rgba(255,255,255,0.15)' : 'rgba(255,255,255,0.15)',
                    color: aiLoading ? 'rgba(255,255,255,0.4)' : 'white',
                    display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                  }}
                >
                  {aiLoading ? <><Loader2 size={13} className="animate-spin" /> 작성 중...</> : <><Sparkles size={13} /> 자동 작성하기</>}
                </button>
                {aiDone && (
                  <p style={{ fontSize: 10, color: '#86EFAC', textAlign: 'center', marginTop: 8, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 4 }}>
                    <CheckCircle2 size={11} /> 자동 작성 완료 — 내용을 검토하세요
                  </p>
                )}
              </div>

              {/* ── 파일 업로드 섹션 ── */}
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
                <div className="flex items-center gap-2 mb-3">
                  <FileScan className="w-4 h-4 text-[#1A2E44]" />
                  <p className="text-sm font-bold text-gray-800">양식 파일 읽기</p>
                </div>
                <p className="text-[11px] text-gray-400 mb-3 leading-relaxed">
                  PDF · 이미지 · Excel · Word 형식의 안전양식을 업로드하면 AI가 내용을 읽어 자동 입력합니다.
                </p>

                {/* Drop zone */}
                <div
                  onClick={() => fileUploadRef.current?.click()}
                  onDragOver={e => { e.preventDefault(); setUploadDragging(true); }}
                  onDragLeave={() => setUploadDragging(false)}
                  onDrop={e => { e.preventDefault(); setUploadDragging(false); handleFormFiles(e.dataTransfer.files); }}
                  className={`border-2 border-dashed rounded-xl p-4 text-center cursor-pointer transition-all ${uploadDragging ? 'border-[#1A2E44] bg-[#1A2E44]/5' : 'border-gray-200 hover:border-[#1A2E44]/50 hover:bg-gray-50'}`}
                >
                  <input
                    ref={fileUploadRef}
                    type="file"
                    multiple
                    accept=".pdf,.png,.jpg,.jpeg,.xlsx,.xls,.docx,.doc"
                    className="hidden"
                    onChange={e => e.target.files && handleFormFiles(e.target.files)}
                  />
                  <Upload className={`w-6 h-6 mx-auto mb-1.5 ${uploadDragging ? 'text-[#1A2E44]' : 'text-gray-300'}`} />
                  <p className="text-xs text-gray-500 font-medium">파일을 드래그하거나 클릭</p>
                  <p className="text-[10px] text-gray-400 mt-0.5">PDF · 이미지 · Excel · Word</p>
                </div>

                {/* Uploaded file list */}
                {uploadedFiles.length > 0 && (
                  <div className="mt-3 space-y-2">
                    {uploadedFiles.map(file => (
                      <div key={file.id} className={`rounded-xl border p-3 transition-all ${parsedFile?.id === file.id ? 'border-[#1A2E44] bg-[#1A2E44]/5' : 'border-gray-100 bg-gray-50'}`}>
                        <div className="flex items-start gap-2">
                          {/* File icon / preview */}
                          <div className="w-9 h-9 rounded-lg overflow-hidden flex-shrink-0 bg-gray-100 flex items-center justify-center">
                            {file.previewUrl ? (
                              <img src={file.previewUrl} alt={file.name} className="w-full h-full object-cover" />
                            ) : (
                              <FileText className={`w-4 h-4 ${file.type === 'pdf' ? 'text-red-400' : file.type === 'excel' ? 'text-green-500' : 'text-blue-500'}`} />
                            )}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-semibold text-gray-800 truncate">{file.name}</p>
                            <p className="text-[10px] text-gray-400">{file.size}</p>
                            {file.parseStatus === 'done' && (
                              <p className="text-[10px] text-green-600 font-semibold mt-0.5 flex items-center gap-1">
                                <CheckCircle2 className="w-3 h-3" /> 분석 완료
                              </p>
                            )}
                          </div>
                          <button aria-label="파일 삭제" onClick={() => removeFile(file.id)} className="p-1 hover:bg-gray-200 rounded-lg transition-colors flex-shrink-0">
                            <X className="w-3 h-3 text-gray-400" />
                          </button>
                        </div>

                        <div className="flex gap-1.5 mt-2">
                          {file.parseStatus !== 'parsing' && file.parseStatus !== 'done' && (
                            <button
                              onClick={() => handleParseFile(file)}
                              className="flex-1 py-1.5 bg-[#1A2E44] text-white rounded-lg text-[11px] font-semibold hover:bg-[#1A2E44] transition-colors flex items-center justify-center gap-1"
                            >
                              <FileScan className="w-3 h-3" /> AI로 읽기
                            </button>
                          )}
                          {file.parseStatus === 'parsing' && (
                            <div className="flex-1 py-1.5 bg-gray-100 rounded-lg text-[11px] text-gray-500 flex items-center justify-center gap-1">
                              <Loader2 className="w-3 h-3 animate-spin" /> 분석 중...
                            </div>
                          )}
                          {file.parseStatus === 'done' && file.parsedFields && (
                            <>
                              <button
                                onClick={() => setParsedFile(file)}
                                className="flex-1 py-1.5 border border-[#1A2E44] text-[#1A2E44] rounded-lg text-[11px] font-semibold hover:bg-[#1A2E44]/5 transition-colors flex items-center justify-center gap-1"
                              >
                                <Eye className="w-3 h-3" /> 미리보기
                              </button>
                              <button
                                onClick={() => handleApplyParsed(file.parsedFields!)}
                                className="flex-1 py-1.5 bg-[#1A2E44] text-white rounded-lg text-[11px] font-semibold hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-1"
                              >
                                <Save className="w-3 h-3" /> 적용
                              </button>
                            </>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* ── 파싱 결과 미리보기 ── */}
              {parsedFile?.parseStatus === 'done' && parsedFile.parsedFields && (
                <div className="bg-white rounded-2xl p-5 shadow-sm border-2 border-[#1A2E44]/30">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-[#1A2E44]" />
                      <p className="text-sm font-bold text-gray-800">읽어온 내용</p>
                    </div>
                    <button aria-label="닫기" onClick={() => setParsedFile(null)} className="p-1 hover:bg-gray-100 rounded-lg">
                      <X className="w-3.5 h-3.5 text-gray-400" />
                    </button>
                  </div>
                  <div className="space-y-2 text-xs">
                    {parsedFile.parsedFields.companyName && <ParsedRow label="건설사" value={parsedFile.parsedFields.companyName} />}
                    {parsedFile.parsedFields.siteName && <ParsedRow label="현장명" value={parsedFile.parsedFields.siteName} />}
                    {parsedFile.parsedFields.inspector && <ParsedRow label="점검자" value={parsedFile.parsedFields.inspector} />}
                    {parsedFile.parsedFields.overallResult && <ParsedRow label="종합결과" value={parsedFile.parsedFields.overallResult} />}
                    {parsedFile.parsedFields.items && parsedFile.parsedFields.items.length > 0 && (
                      <div className="pt-1 border-t border-gray-100">
                        <p className="text-[10px] text-gray-400 font-semibold uppercase mb-1.5">점검 항목 {parsedFile.parsedFields.items.length}건</p>
                        {parsedFile.parsedFields.items.map((it, i) => (
                          <div key={i} className="flex items-center gap-2 py-1">
                            <span className={`w-1.5 h-1.5 rounded-full flex-shrink-0 ${it.status === '양호' ? 'bg-green-400' : 'bg-red-400'}`} />
                            <span className="text-gray-700 truncate">{it.title}</span>
                            <span className={`ml-auto text-[10px] font-bold flex-shrink-0 ${it.status === '양호' ? 'text-green-600' : 'text-red-600'}`}>{it.status}</span>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                  <button
                    onClick={() => handleApplyParsed(parsedFile.parsedFields!)}
                    className="mt-4 w-full py-2 bg-[#1A2E44] text-white rounded-xl text-xs font-bold hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-1.5"
                  >
                    <CheckCircle2 className="w-3.5 h-3.5" /> 양식에 적용하기
                  </button>
                </div>
              )}
            </div>

            {/* Right: Form */}
            <div className="lg:col-span-3">
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                {/* Form header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
                  <div>
                    <h2 className="font-bold text-gray-900">{FORM_TEMPLATES.find(t => t.id === formTemplate)?.label}</h2>
                    {aiDone && <p className="text-xs text-[#1A2E44] mt-0.5">AI가 조치관리 데이터를 기반으로 작성하였습니다</p>}
                  </div>
                  <div className="flex items-center gap-2">
                    {!editMode ? (
                      <button onClick={() => setEditMode(true)}
                        className="flex items-center gap-1.5 px-3 py-2 border border-gray-200 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors">
                        <Edit3 className="w-4 h-4" /> 편집
                      </button>
                    ) : (
                      <button onClick={handleSave}
                        className="flex items-center gap-1.5 px-3 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#1A2E44] transition-colors">
                        <Save className="w-4 h-4" /> 저장
                      </button>
                    )}
                    <button onClick={handleDownload}
                      className="flex items-center gap-1.5 px-3 py-2 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] transition-colors">
                      <Printer className="w-4 h-4" /> 출력·PDF
                    </button>
                  </div>
                </div>

                <div className="p-6 space-y-6">

                  {/* ── 공통: 개요 섹션 ── */}
                  <FormSection title="기본 정보">
                    <div className="grid grid-cols-2 gap-4">
                      <FormField label="건설사명" value={safetyForm.companyName} onChange={v => setField('companyName', v)} editable={editMode} placeholder="예) (주)세이프메이트 건설" />
                      <FormField label="현장명" value={safetyForm.siteName} onChange={v => setField('siteName', v)} editable={editMode} placeholder="예) 3동 건물 외벽 공사현장" />
                      <FormField label="점검일시" value={safetyForm.inspectionDate} onChange={v => setField('inspectionDate', v)} editable={editMode} type="date" />
                      <FormField label="점검자" value={safetyForm.inspector} onChange={v => setField('inspector', v)} editable={editMode} placeholder="예) 김현장" />
                      <FormField label="관리감독자" value={safetyForm.supervisor} onChange={v => setField('supervisor', v)} editable={editMode} placeholder="예) 박안전" />
                      {formTemplate === 'inspection' && (
                        <>
                          <FormField label="기상 상태" value={safetyForm.weatherCondition} onChange={v => setField('weatherCondition', v)} editable={editMode} placeholder="맑음 / 흐림 / 비" />
                          <FormField label="작업인원 수" value={safetyForm.workerCount} onChange={v => setField('workerCount', v)} editable={editMode} placeholder="명" />
                          <div>
                            <p className="text-xs font-semibold text-gray-600 mb-1.5">종합 점검 결과</p>
                            {editMode ? (
                              <div className="flex gap-2">
                                {['양호', '불량', '조치중'].map(opt => (
                                  <button key={opt} onClick={() => setField('overallResult', opt)}
                                    className={`flex-1 py-2 rounded-lg text-xs font-semibold border-2 transition-all ${safetyForm.overallResult === opt ? (opt === '양호' ? 'border-green-400 bg-green-50 text-green-700' : opt === '불량' ? 'border-red-400 bg-red-50 text-red-700' : 'border-orange-400 bg-orange-50 text-orange-700') : 'border-gray-200 text-gray-500'}`}>
                                    {opt}
                                  </button>
                                ))}
                              </div>
                            ) : (
                              <p className={`text-sm font-bold px-3 py-2 rounded-lg inline-block ${safetyForm.overallResult === '양호' ? 'bg-green-50 text-green-700' : safetyForm.overallResult === '불량' ? 'bg-red-50 text-red-700' : 'bg-orange-50 text-orange-700'}`}>
                                {safetyForm.overallResult || '—'}
                              </p>
                            )}
                          </div>
                        </>
                      )}
                      {formTemplate === 'work' && (
                        <>
                          <FormField label="작업 종류" value={safetyForm.workType} onChange={v => setField('workType', v)} editable={editMode} placeholder="예) 외벽 마감 작업" />
                          <FormField label="작업 범위" value={safetyForm.workScope} onChange={v => setField('workScope', v)} editable={editMode} placeholder="예) 3동 2~4층 외벽" />
                        </>
                      )}
                    </div>
                  </FormSection>

                  {/* ── 안전점검일지: 점검 항목표 ── */}
                  {formTemplate === 'inspection' && (
                    <FormSection title="점검 항목">
                      {safetyForm.items.length === 0 ? (
                        <div className="text-center py-10 text-gray-400">
                          <Sparkles className="w-8 h-8 mx-auto mb-2 opacity-30" />
                          <p className="text-sm">AI 자동 작성으로 점검 항목을 채워보세요</p>
                          <button onClick={handleAiFill} disabled={aiLoading}
                            className="mt-3 px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-xs font-semibold hover:bg-[#0F2233] transition-colors">
                            {aiLoading ? '작성 중...' : 'AI 자동 작성'}
                          </button>
                        </div>
                      ) : (
                        <div className="overflow-x-auto">
                          <table className="w-full text-sm">
                            <thead>
                              <tr className="bg-gray-50">
                                <th className="text-left px-3 py-2.5 text-xs font-semibold text-gray-500 w-6">No</th>
                                <th className="text-left px-3 py-2.5 text-xs font-semibold text-gray-500">점검 항목</th>
                                <th className="text-center px-3 py-2.5 text-xs font-semibold text-gray-500 w-28">결과</th>
                                <th className="text-left px-3 py-2.5 text-xs font-semibold text-gray-500">비고</th>
                              </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-100">
                              {safetyForm.items.map((item, i) => (
                                <tr key={i} className="hover:bg-gray-50">
                                  <td className="px-3 py-3 text-gray-400 text-xs">{i + 1}</td>
                                  <td className="px-3 py-3">
                                    <p className="text-sm font-medium text-gray-900">{item.title}</p>
                                  </td>
                                  <td className="px-3 py-3">
                                    {editMode ? (
                                      <select value={item.status} onChange={e => setItemField(i, 'status', e.target.value)}
                                        className={`w-full px-2 py-1.5 border rounded-lg text-xs font-semibold outline-none focus:ring-1 focus:ring-[#1A2E44] ${item.status === '양호' ? 'border-green-300 text-green-700 bg-green-50' : item.status === '불량' ? 'border-red-300 text-red-700 bg-red-50' : 'border-gray-200 text-gray-600'}`}>
                                        <option value="양호">양호</option>
                                        <option value="불량">불량</option>
                                        <option value="해당없음">해당없음</option>
                                      </select>
                                    ) : (
                                      <span className={`px-2 py-1 rounded-full text-xs font-semibold ${item.status === '양호' ? 'bg-green-100 text-green-700' : item.status === '불량' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-500'}`}>
                                        {item.status}
                                      </span>
                                    )}
                                  </td>
                                  <td className="px-3 py-3">
                                    {editMode ? (
                                      <input value={item.note} onChange={e => setItemField(i, 'note', e.target.value)}
                                        className="w-full px-2 py-1.5 border border-gray-200 rounded-lg text-xs focus:ring-1 focus:ring-[#1A2E44] outline-none" />
                                    ) : (
                                      <p className="text-xs text-gray-600 line-clamp-2">{item.note || '—'}</p>
                                    )}
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                          {editMode && (
                            <button
                              onClick={() => setSafetyForm(f => ({ ...f, items: [...f.items, { title: '', status: '양호', note: '' }] }))}
                              className="mt-3 flex items-center gap-1.5 text-xs text-[#1A2E44] hover:underline font-medium"
                            >
                              + 항목 추가
                            </button>
                          )}
                        </div>
                      )}
                    </FormSection>
                  )}

                  {/* ── 위험성평가서 ── */}
                  {formTemplate === 'risk' && (
                    <>
                      <FormSection title="평가 목적 및 개요">
                        <FormTextarea label="평가 목적" value={safetyForm.assessmentPurpose} onChange={v => setField('assessmentPurpose', v)} editable={editMode} rows={3} placeholder="AI 자동 작성을 사용해보세요" />
                      </FormSection>
                      <FormSection title="위험 요소 평가표">
                        {safetyForm.items.length === 0 ? (
                          <div className="text-center py-10 text-gray-400">
                            <Sparkles className="w-8 h-8 mx-auto mb-2 opacity-30" />
                            <p className="text-sm">AI 자동 작성으로 평가 항목을 채워보세요</p>
                          </div>
                        ) : (
                          <div className="space-y-3">
                            {safetyForm.items.map((item, i) => (
                              <div key={i} className={`rounded-xl border p-4 ${item.status === '불량' ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200'}`}>
                                <div className="flex items-center justify-between mb-2">
                                  <p className="text-sm font-bold text-gray-900">{item.title || `위험 요소 ${i + 1}`}</p>
                                  <span className={`px-2 py-0.5 text-xs font-bold rounded-full ${item.status === '불량' ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}`}>
                                    {item.status === '불량' ? '개선 필요' : '양호'}
                                  </span>
                                </div>
                                <p className="text-xs text-gray-600 leading-relaxed">{item.note}</p>
                              </div>
                            ))}
                          </div>
                        )}
                      </FormSection>
                    </>
                  )}

                  {/* ── 조치결과보고서 ── */}
                  {formTemplate === 'action' && (
                    <>
                      <FormSection title="조치 내용 요약">
                        <FormTextarea label="완료된 조치 사항" value={safetyForm.actionSummary} onChange={v => setField('actionSummary', v)} editable={editMode} rows={4} placeholder="어떤 조치를 취했는지 서술하세요" />
                      </FormSection>
                      <FormSection title="재발 방지 계획">
                        <FormTextarea label="재발 방지 대책" value={safetyForm.preventionPlan} onChange={v => setField('preventionPlan', v)} editable={editMode} rows={4} placeholder="향후 재발 방지를 위한 계획을 기술하세요" />
                      </FormSection>
                    </>
                  )}

                  {/* ── 작업허가서 ── */}
                  {formTemplate === 'work' && (
                    <>
                      <FormSection title="안전 주의사항">
                        <FormTextarea label="작업 전 안전 조치사항" value={safetyForm.precautions} onChange={v => setField('precautions', v)} editable={editMode} rows={5} placeholder="관련 법규 및 안전 주의사항을 기술하세요" />
                      </FormSection>
                    </>
                  )}

                  {/* ── 서명 섹션 (공통) ── */}
                  <FormSection title="서명">
                    <div className="grid grid-cols-3 gap-4">
                      {[
                        { label: '작성자', key: 'signaturePreparer' as const },
                        { label: '검토자', key: 'signatureReviewer' as const },
                        { label: '승인자', key: 'signatureApprover' as const },
                      ].map(sig => (
                        <div key={sig.key} className="border-2 border-dashed border-gray-200 rounded-xl p-4 text-center">
                          <p className="text-xs font-semibold text-gray-500 mb-3">{sig.label}</p>
                          {editMode ? (
                            <input value={safetyForm[sig.key]} onChange={e => setField(sig.key, e.target.value)}
                              placeholder="성명 입력"
                              className="w-full text-center px-2 py-1.5 border border-gray-200 rounded-lg text-sm focus:ring-1 focus:ring-[#1A2E44] outline-none" />
                          ) : (
                            <div className="h-10 flex items-end justify-center border-b border-gray-300">
                              <p className="text-sm font-medium text-gray-700 pb-1">{safetyForm[sig.key] || ''}</p>
                            </div>
                          )}
                          <p className="text-[10px] text-gray-400 mt-2">(서명 또는 인)</p>
                        </div>
                      ))}
                    </div>
                  </FormSection>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* ══════════════════════════════════════════ */}
        {/* TAB: 증거자료                               */}
        {/* ══════════════════════════════════════════ */}
        {mainTab === '증거자료' && (
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <div className="flex items-center gap-2 mb-5">
              {(['법규', '사고사례', '지침'] as const).map(tab => (
                <button key={tab} onClick={() => setEvidenceTab(tab)}
                  className={`px-4 py-2 rounded-xl text-sm font-semibold transition-colors ${evidenceTab === tab ? 'bg-[#1A2E44] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
                  {tab}
                </button>
              ))}
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {evidenceResources[evidenceTab].map((item, i) => (
                <div key={i} className="p-4 bg-gray-50 rounded-xl border border-gray-100 hover:border-[#1A2E44] transition-all">
                  <div className="flex items-start justify-between mb-2">
                    <p className="text-sm font-bold text-gray-900 flex-1 pr-2">{item.title}</p>
                    <button aria-label="북마크" className="p-0.5 hover:text-[#1A2E44] text-gray-400 transition-colors flex-shrink-0">
                      <Bookmark className="w-4 h-4" />
                    </button>
                  </div>
                  <p className="text-xs text-gray-600 mb-3 leading-relaxed">{item.summary}</p>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-xs text-gray-500">{item.source}</span>
                      <span className="px-2 py-0.5 bg-green-100 text-green-700 text-xs font-medium rounded-full">{item.relevance}% 관련</span>
                    </div>
                    <button className="text-xs text-[#1A2E44] hover:underline font-medium flex items-center gap-1">
                      보기 <ExternalLink className="w-3 h-3" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

      </div>
    </Layout>
  );
}

// ─── Sub-components ──────────────────────────────────────────────────────────

function FormSection({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div>
      <div className="flex items-center gap-2 mb-3">
        <div style={{ width: 3, height: 16, background: '#1A2E44', borderRadius: 2 }} />
        <h3 className="text-sm font-bold text-gray-800">{title}</h3>
      </div>
      {children}
    </div>
  );
}

function FormField({
  label, value, onChange, editable, placeholder, type = 'text',
}: {
  label: string; value: string; onChange: (v: string) => void;
  editable: boolean; placeholder?: string; type?: string;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-gray-500 mb-1.5">{label}</label>
      {editable ? (
        <input type={type} value={value} onChange={e => onChange(e.target.value)} placeholder={placeholder}
          className="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none" />
      ) : (
        <p className="px-3 py-2.5 bg-gray-50 rounded-xl text-sm text-gray-800 border border-gray-100 min-h-[40px]">{value || '—'}</p>
      )}
    </div>
  );
}

function FormTextarea({
  label, value, onChange, editable, rows, placeholder,
}: {
  label: string; value: string; onChange: (v: string) => void;
  editable: boolean; rows: number; placeholder?: string;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-gray-500 mb-1.5">{label}</label>
      {editable ? (
        <textarea value={value} onChange={e => onChange(e.target.value)} rows={rows} placeholder={placeholder}
          className="w-full px-3 py-2.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none" />
      ) : (
        <p className="px-3 py-2.5 bg-gray-50 rounded-xl text-sm text-gray-800 border border-gray-100 whitespace-pre-wrap leading-relaxed min-h-[80px]">{value || '—'}</p>
      )}
    </div>
  );
}

function ParsedRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center gap-2 py-1">
      <span className="text-[10px] font-semibold text-gray-400 w-14 flex-shrink-0">{label}</span>
      <span className="text-gray-800 truncate">{value}</span>
    </div>
  );
}
