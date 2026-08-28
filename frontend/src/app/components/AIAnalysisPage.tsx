import React, { useState, useRef, useCallback } from 'react';
import Layout from './Layout';
import {
  Upload, ArrowRight, CheckCircle2, AlertTriangle, Clock, Loader2,
  Sparkles, FileText, Download, RefreshCw, Edit3, Save, X, Plus,
  Shield, Scan, Camera, ChevronRight, ChevronLeft, Printer,
  BarChart2, Eye, AlertCircle, Check, Image as ImageIcon,
} from 'lucide-react';
import { toast } from 'sonner';

interface AIAnalysisPageProps {
  onNavigate: (page: string) => void;
}

type Phase = 'upload' | 'yolo_running' | 'yolo_done' | 'ai_running' | 'ai_done';
type AdminStatus = 'ok' | 'needs_review' | 'rejected';
type MainTab = 'analysis' | 'report';
type ReportStep = 1 | 2 | 3 | 4;

interface VerificationItem {
  id: number;
  label: string;
  location: string;
  confidence: number;
  risk: 'high' | 'medium' | 'low';
  beforeState: string;
  afterState: string;
  aiVerdict: 'ok' | 'needs_check';
  recommendation: string;
  adminSuitability: number;
  adminStatus: AdminStatus;
  weight: number;
  editOpen: boolean;
  adminNote: string;
  editSuitability: string;
  editStatus: AdminStatus;
}

interface DetectionBox {
  id: number;
  label: string;
  x: number; y: number; w: number; h: number;
  color: 'red' | 'green' | 'yellow';
  confidence: number;
}

interface ReportFormFile {
  id: string;
  name: string;
  size: string;
}

const DEMO_BEFORE = 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=520&h=320&fit=crop&auto=format';
const DEMO_AFTER  = 'https://images.unsplash.com/photo-1581094488379-6a10d571cc9d?w=520&h=320&fit=crop&auto=format';

const BEFORE_BOXES: DetectionBox[] = [
  { id: 1, label: '안전난간 미설치', x: 4,  y: 5,  w: 28, h: 44, color: 'red',    confidence: 94 },
  { id: 2, label: '개구부 방치',     x: 34, y: 58, w: 30, h: 22, color: 'red',    confidence: 91 },
  { id: 3, label: '안전모 미착용',   x: 66, y: 12, w: 26, h: 40, color: 'yellow', confidence: 88 },
];

const AFTER_BOXES: DetectionBox[] = [
  { id: 1, label: '안전난간 설치 ✓',     x: 4,  y: 5,  w: 28, h: 44, color: 'green',  confidence: 94 },
  { id: 2, label: '덮개 설치 (확인 필요)', x: 34, y: 58, w: 30, h: 22, color: 'yellow', confidence: 91 },
  { id: 3, label: '안전모 착용 ✓',       x: 66, y: 12, w: 26, h: 40, color: 'green',  confidence: 88 },
];

const INITIAL_ITEMS: VerificationItem[] = [
  {
    id: 1, label: '안전난간 미설치', location: '좌측 상단', confidence: 94, risk: 'high',
    beforeState: '난간 미설치로 추락 위험 있음', afterState: '임시 안전난간 설치 확인',
    aiVerdict: 'ok', recommendation: '난간 고정 상태 추가 확인',
    adminSuitability: 92, adminStatus: 'ok', weight: 40,
    editOpen: false, adminNote: '', editSuitability: '92', editStatus: 'ok',
  },
  {
    id: 2, label: '개구부 방치', location: '중앙 하단', confidence: 91, risk: 'high',
    beforeState: '개구부 덮개 없음', afterState: '덮개 설치 확인되나 고정 여부 불명확',
    aiVerdict: 'needs_check', recommendation: '덮개 고정 클램프 확인 사진 추가 필요',
    adminSuitability: 67, adminStatus: 'needs_review', weight: 35,
    editOpen: false, adminNote: '', editSuitability: '67', editStatus: 'needs_review',
  },
  {
    id: 3, label: '안전모 미착용', location: '우측 작업자', confidence: 88, risk: 'medium',
    beforeState: '작업자 1명 안전모 미착용', afterState: '작업자 안전모 착용 확인',
    aiVerdict: 'ok', recommendation: '지속 착용 교육 기록 첨부',
    adminSuitability: 88, adminStatus: 'ok', weight: 25,
    editOpen: false, adminNote: '', editSuitability: '88', editStatus: 'ok',
  },
];

const REPORT_TEMPLATES = [
  { id: 'inspection', name: '안전점검 결과보고서', desc: '현장 안전점검 결과를 정리한 표준 보고서 양식', icon: Shield },
  { id: 'tbm',        name: 'TBM 보고서',          desc: '작업 전 안전 회의 (Tool Box Meeting) 결과 보고서', icon: BarChart2 },
  { id: 'action',     name: '위험요소 조치결과 보고서', desc: '감지된 위험요소에 대한 조치 결과 기록 보고서', icon: AlertTriangle },
  { id: 'confirm',    name: '하청 조치확인서',       desc: '하청 업체의 조치 완료 확인 및 서명 문서', icon: CheckCircle2 },
];

function DetectionOverlay({ boxes, show }: { boxes: DetectionBox[]; show: boolean }) {
  if (!show) return null;
  const COLOR = {
    red:    { stroke: '#ef4444', fill: 'rgba(239,68,68,0.12)',    text: '#fff', bg: '#ef4444' },
    green:  { stroke: '#22c55e', fill: 'rgba(34,197,94,0.12)',    text: '#fff', bg: '#16a34a' },
    yellow: { stroke: '#f59e0b', fill: 'rgba(245,158,11,0.12)',   text: '#000', bg: '#f59e0b' },
  };
  return (
    <svg
      className="absolute inset-0 w-full h-full pointer-events-none"
      viewBox="0 0 100 100"
      preserveAspectRatio="none"
    >
      {boxes.map(b => {
        const c = COLOR[b.color];
        const labelW = Math.min(b.w - 1, 26);
        return (
          <g key={b.id}>
            <rect x={b.x} y={b.y} width={b.w} height={b.h} fill={c.fill} stroke={c.stroke} strokeWidth="0.6" />
            <rect x={b.x} y={b.y - 5} width={labelW} height={5} fill={c.bg} />
            <text x={b.x + 1} y={b.y - 0.8} fontSize="2.8" fill={c.text} fontFamily="sans-serif">{b.label.substring(0, 11)}</text>
          </g>
        );
      })}
    </svg>
  );
}

function CircularGauge({ value }: { value: number }) {
  const r = 52;
  const circ = 2 * Math.PI * r;
  const filled = Math.min(value / 100, 1) * circ;
  const color = value >= 100 ? '#22c55e' : value >= 90 ? '#3b82f6' : value >= 70 ? '#f59e0b' : '#ef4444';
  return (
    <svg viewBox="0 0 130 130" className="w-32 h-32">
      <circle cx="65" cy="65" r={r} fill="none" stroke="#e5e7eb" strokeWidth="11" />
      <circle
        cx="65" cy="65" r={r} fill="none"
        stroke={color} strokeWidth="11"
        strokeDasharray={`${filled} ${circ}`}
        strokeLinecap="round"
        transform="rotate(-90 65 65)"
        style={{ transition: 'stroke-dasharray 0.6s ease' }}
      />
      <text x="65" y="60" textAnchor="middle" dominantBaseline="middle" fontSize="20" fontWeight="bold" fill="#1f2937">{value}%</text>
      <text x="65" y="78" textAnchor="middle" fontSize="8" fill="#6b7280">완료율</text>
    </svg>
  );
}

function ProgressBar({ pct, label }: { pct: number; label: string }) {
  return (
    <div className="space-y-1">
      <div className="flex justify-between text-xs text-gray-500">
        <span>{label}</span><span>{pct}%</span>
      </div>
      <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
        <div
          className="h-full bg-[#1A2E44] rounded-full transition-all duration-700"
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}

export default function AIAnalysisPage({ onNavigate }: AIAnalysisPageProps) {
  const [phase, setPhase] = useState<Phase>('upload');
  const [beforeImg, setBeforeImg] = useState<string | null>(null);
  const [afterImg,  setAfterImg]  = useState<string | null>(null);
  const beforeInputRef = useRef<HTMLInputElement>(null);
  const afterInputRef  = useRef<HTMLInputElement>(null);
  const [yoloPct, setYoloPct] = useState(0);
  const [aiPct,   setAiPct]   = useState(0);
  const [items, setItems] = useState<VerificationItem[]>(INITIAL_ITEMS);
  const [mainTab, setMainTab] = useState<MainTab>('analysis');
  const [finalDone, setFinalDone] = useState(false);

  // Report wizard
  const [reportStep, setReportStep] = useState<ReportStep>(1);
  const [reportFiles, setReportFiles] = useState<ReportFormFile[]>([]);
  const [selectedTemplate, setSelectedTemplate] = useState<string | null>(null);
  const [reportGenPct, setReportGenPct] = useState(0);
  const [reportGenDone, setReportGenDone] = useState(false);
  const [reportSaved, setReportSaved] = useState(false);
  const [pdfDone, setPdfDone] = useState(false);
  const reportFileRef = useRef<HTMLInputElement>(null);

  const completionRate = Math.round(
    items.reduce((sum, it) => sum + it.adminSuitability * it.weight, 0) / 100
  );

  // ── Upload helpers ────────────────────────────────────────────
  const handleImgFile = useCallback((file: File, side: 'before' | 'after') => {
    const url = URL.createObjectURL(file);
    if (side === 'before') setBeforeImg(url);
    else setAfterImg(url);
  }, []);

  const handleDrop = (e: React.DragEvent, side: 'before' | 'after') => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('image/')) handleImgFile(file, side);
    else toast.error('이미지 파일만 업로드할 수 있습니다.');
  };

  const loadDemoData = () => {
    setBeforeImg(DEMO_BEFORE);
    setAfterImg(DEMO_AFTER);
    toast.success('데모 데이터가 로드되었습니다.');
  };

  // ── YOLO simulation ───────────────────────────────────────────
  const startYolo = () => {
    setPhase('yolo_running');
    setYoloPct(0);
    let p = 0;
    const iv = setInterval(() => {
      p += Math.random() * 18 + 5;
      if (p >= 100) { p = 100; clearInterval(iv); setPhase('yolo_done'); }
      setYoloPct(Math.min(Math.round(p), 100));
    }, 120);
  };

  // ── AI simulation ─────────────────────────────────────────────
  const startAI = () => {
    setPhase('ai_running');
    setAiPct(0);
    let p = 0;
    const iv = setInterval(() => {
      p += Math.random() * 12 + 4;
      if (p >= 100) { p = 100; clearInterval(iv); setPhase('ai_done'); }
      setAiPct(Math.min(Math.round(p), 100));
    }, 150);
  };

  // ── Item edit helpers ─────────────────────────────────────────
  const openEdit  = (id: number) => setItems(prev => prev.map(it => it.id === id ? { ...it, editOpen: true, editSuitability: String(it.adminSuitability), editStatus: it.adminStatus } : it));
  const closeEdit = (id: number) => setItems(prev => prev.map(it => it.id === id ? { ...it, editOpen: false } : it));

  const saveEdit = (id: number) => {
    setItems(prev => prev.map(it => {
      if (it.id !== id) return it;
      const suitability = Math.max(0, Math.min(100, parseInt(it.editSuitability) || 0));
      return { ...it, adminSuitability: suitability, adminStatus: it.editStatus, editOpen: false };
    }));
    toast.success('수정 내용이 저장되었습니다.');
  };

  const approveAll = () => {
    setItems(prev => prev.map(it => ({ ...it, adminSuitability: 100, adminStatus: 'ok', editOpen: false })));
    toast.success('모든 항목이 최종 승인되었습니다.');
  };

  // ── Report wizard helpers ─────────────────────────────────────
  const handleReportFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const newFiles: ReportFormFile[] = files.map(f => ({
      id: Math.random().toString(36).slice(2),
      name: f.name,
      size: (f.size / 1024).toFixed(1) + ' KB',
    }));
    setReportFiles(prev => [...prev, ...newFiles]);
    toast.success(`${files.length}개 파일이 업로드되었습니다.`);
  };

  const startReportGen = () => {
    setReportGenPct(0);
    setReportGenDone(false);
    let p = 0;
    const tasks = [
      '현장 정보 삽입 중...',
      'Before / After 사진 처리 중...',
      'Roboflow 검증 결과 통합 중...',
      'AI 판독 결과 삽입 중...',
      '완료율 및 관리자 수정 내역 반영 중...',
      '최종 서식 적용 중...',
    ];
    let ti = 0;
    const iv = setInterval(() => {
      p += Math.random() * 10 + 6;
      if (p >= 100) {
        p = 100; clearInterval(iv);
        setReportGenPct(100);
        setTimeout(() => { setReportGenDone(true); setReportStep(4); }, 400);
      } else {
        setReportGenPct(Math.round(p));
        if (p > (ti + 1) * 16 && ti < tasks.length - 1) ti++;
      }
    }, 180);
  };

  // ── Risk/Status helpers ───────────────────────────────────────
  const RISK_LABEL = { high: '높음', medium: '중간', low: '낮음' };
  const RISK_PILL  = { high: 'bg-red-100 text-red-700', medium: 'bg-orange-100 text-orange-700', low: 'bg-yellow-100 text-yellow-700' };
  const STATUS_CFG: Record<AdminStatus, { label: string; pill: string }> = {
    ok:           { label: '완료 가능',      pill: 'bg-green-100 text-green-700' },
    needs_review: { label: '관리자 수정 필요', pill: 'bg-yellow-100 text-yellow-800' },
    rejected:     { label: '반려',           pill: 'bg-red-100 text-red-700' },
  };

  const canStartYolo = !!beforeImg && !!afterImg && phase === 'upload';

  // ─────────────────────────────────────────────────────────────
  return (
    <Layout currentPath="ai-analysis" onNavigate={onNavigate}>
      {/* Page header */}
      <div className="mb-6 flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-xl font-bold text-gray-800">AI 위험요소 분석 및 조치 검증</h1>
          <p className="text-sm text-gray-500 mt-0.5">Before / After 사진을 업로드하여 AI가 위험요소를 분석하고 조치 결과를 검증합니다.</p>
        </div>
        <button
          onClick={loadDemoData}
          className="flex items-center gap-2 px-4 py-2 border border-[#1A2E44] text-[#1A2E44] rounded-lg text-sm hover:bg-[#1A2E44] hover:text-white transition-colors"
        >
          <Sparkles className="w-4 h-4" />
          데모 데이터 로드
        </button>
      </div>

      {/* Site info bar */}
      <div className="bg-white rounded border border-gray-200 p-4 mb-6">
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
          {[
            { label: '현장명',      value: '강남 복합시설 신축공사' },
            { label: '원청 건설사', value: '대한안전건설' },
            { label: '하청 업체',   value: '안전하도급' },
            { label: '점검일',      value: '2026.08.09' },
            { label: '담당자',      value: '이조치' },
          ].map(f => (
            <div key={f.label}>
              <p className="text-xs text-gray-500 mb-0.5">{f.label}</p>
              <p className="text-sm font-medium text-gray-800">{f.value}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Main tabs */}
      <div className="flex gap-1 mb-6 bg-gray-100 p-1 rounded w-fit">
        {([
          { id: 'analysis' as MainTab, label: '분석 및 검증' },
          { id: 'report'   as MainTab, label: 'AI 결과보고서' },
        ]).map(t => (
          <button
            key={t.id}
            onClick={() => setMainTab(t.id)}
            className={`px-5 py-2 rounded-lg text-sm font-medium transition-colors ${
              mainTab === t.id ? 'bg-white text-[#1A2E44] shadow-sm' : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* ===== TAB: Analysis ===== */}
      {mainTab === 'analysis' && (
        <div className="space-y-6">

          {/* Section 1: Photo upload */}
          <div className="bg-white rounded border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Camera className="w-5 h-5 text-[#1A2E44]" />
                <h2 className="font-semibold text-gray-800">Before / After 사진 업로드</h2>
              </div>
              {phase !== 'upload' && (
                <span className="flex items-center gap-1.5 text-xs bg-green-50 text-green-700 px-3 py-1 rounded-full border border-green-200">
                  <Check className="w-3.5 h-3.5" /> 업로드 완료
                </span>
              )}
            </div>

            <div className="p-6">
              <div className="grid grid-cols-1 md:grid-cols-[1fr_auto_1fr] gap-4 items-center">
                {/* Before */}
                <DropZone
                  label="Before 사진"
                  sublabel="작업 전 (위험요소 있음)"
                  imgUrl={beforeImg}
                  boxes={BEFORE_BOXES}
                  showBoxes={phase !== 'upload'}
                  inputRef={beforeInputRef}
                  onFileChange={f => handleImgFile(f, 'before')}
                  onDrop={e => handleDrop(e, 'before')}
                  accentClass="border-red-200 hover:border-red-300"
                  badgeClass="bg-red-50 text-red-700 border-red-200"
                />

                {/* Arrow */}
                <div className="flex flex-col items-center gap-2 text-gray-400">
                  <ArrowRight className="w-8 h-8" />
                  <span className="text-xs font-medium">비교</span>
                </div>

                {/* After */}
                <DropZone
                  label="After 사진"
                  sublabel="작업 후 (조치 완료)"
                  imgUrl={afterImg}
                  boxes={AFTER_BOXES}
                  showBoxes={phase !== 'upload'}
                  inputRef={afterInputRef}
                  onFileChange={f => handleImgFile(f, 'after')}
                  onDrop={e => handleDrop(e, 'after')}
                  accentClass="border-green-200 hover:border-green-300"
                  badgeClass="bg-green-50 text-green-700 border-green-200"
                />
              </div>

              {canStartYolo && (
                <div className="mt-5 flex justify-center">
                  <button
                    onClick={startYolo}
                    className="flex items-center gap-2 px-6 py-3 bg-[#1A2E44] text-white rounded font-medium hover:bg-[#254d7a] transition-colors"
                  >
                    <Scan className="w-5 h-5" />
                    1차 검증 시작 (Roboflow 객체인식)
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              )}
            </div>
          </div>

          {/* Section 2: Roboflow 1st pass */}
          {phase !== 'upload' && (
            <div className="bg-white rounded border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Scan className="w-5 h-5 text-blue-600" />
                  <h2 className="font-semibold text-gray-800">1차 검증: Roboflow 객체인식</h2>
                </div>
                {phase === 'yolo_running' ? (
                  <span className="flex items-center gap-1.5 text-xs bg-blue-50 text-blue-700 px-3 py-1 rounded-full animate-pulse">
                    <Loader2 className="w-3.5 h-3.5 animate-spin" /> 분석 중...
                  </span>
                ) : (
                  <span className="flex items-center gap-1.5 text-xs bg-green-50 text-green-700 px-3 py-1 rounded-full border border-green-200">
                    <Check className="w-3.5 h-3.5" /> 완료
                  </span>
                )}
              </div>

              <div className="p-6">
                {phase === 'yolo_running' ? (
                  <div className="space-y-4">
                    <ProgressBar pct={yoloPct} label="Roboflow 모델 분석 중..." />
                    <p className="text-xs text-gray-400 text-center">YOLO v8 모델로 위험요소를 검출하고 있습니다</p>
                  </div>
                ) : (
                  <>
                    <div className="overflow-x-auto mb-5">
                      <table className="w-full text-sm">
                        <thead>
                          <tr className="bg-gray-50">
                            <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">감지 객체</th>
                            <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">위치</th>
                            <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">신뢰도</th>
                            <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">위험 등급</th>
                            <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">상태</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                          {INITIAL_ITEMS.map(it => (
                            <tr key={it.id} className="hover:bg-gray-50">
                              <td className="px-4 py-3 font-medium text-gray-800">{it.label}</td>
                              <td className="px-4 py-3 text-gray-600">{it.location}</td>
                              <td className="px-4 py-3">
                                <div className="flex items-center gap-2">
                                  <div className="w-16 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                    <div className="h-full bg-[#1A2E44] rounded-full" style={{ width: `${it.confidence}%` }} />
                                  </div>
                                  <span className="text-gray-700 font-mono text-xs">{it.confidence}%</span>
                                </div>
                              </td>
                              <td className="px-4 py-3">
                                <span className={`text-xs px-2.5 py-1 rounded-full font-medium ${RISK_PILL[it.risk]}`}>
                                  {RISK_LABEL[it.risk]}
                                </span>
                              </td>
                              <td className="px-4 py-3">
                                <span className="text-xs px-2.5 py-1 bg-red-50 text-red-700 rounded-full font-medium">조치 필요</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>

                    <div className="flex items-start gap-3 p-4 bg-blue-50 rounded-lg border border-blue-100 mb-4">
                      <Scan className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                      <p className="text-sm text-blue-800">
                        <strong>Roboflow 1차 결과:</strong> 총 3개 위험요소가 감지되었습니다.
                        고위험 2개(안전난간 미설치, 개구부 방치), 중위험 1개(안전모 미착용).
                        AI 2차 판독으로 상세 검증을 진행하세요.
                      </p>
                    </div>

                    {phase === 'yolo_done' && (
                      <div className="flex justify-end">
                        <button
                          onClick={startAI}
                          className="flex items-center gap-2 px-6 py-3 bg-[#1A2E44] text-white rounded font-medium hover:bg-[#e55f2a] transition-colors"
                        >
                          <Sparkles className="w-5 h-5" />
                          2차 AI 판독 시작
                          <ArrowRight className="w-4 h-4" />
                        </button>
                      </div>
                    )}
                  </>
                )}
              </div>
            </div>
          )}

          {/* Section 3: AI 2nd pass */}
          {(phase === 'ai_running' || phase === 'ai_done') && (
            <div className="bg-white rounded border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Sparkles className="w-5 h-5 text-purple-600" />
                  <h2 className="font-semibold text-gray-800">2차 검증: AI 판독 및 전후 비교</h2>
                </div>
                {phase === 'ai_running' ? (
                  <span className="flex items-center gap-1.5 text-xs bg-purple-50 text-purple-700 px-3 py-1 rounded-full animate-pulse">
                    <Loader2 className="w-3.5 h-3.5 animate-spin" /> AI 분석 중...
                  </span>
                ) : (
                  <span className="flex items-center gap-1.5 text-xs bg-green-50 text-green-700 px-3 py-1 rounded-full border border-green-200">
                    <Check className="w-3.5 h-3.5" /> 완료
                  </span>
                )}
              </div>

              <div className="p-6">
                {phase === 'ai_running' ? (
                  <div className="space-y-4">
                    <ProgressBar pct={aiPct} label="AI 모델이 전후 사진을 비교하고 있습니다..." />
                    <div className="grid grid-cols-3 gap-3 mt-2">
                      {['이미지 특징 추출', '전후 차이 분석', '조치 적합성 판단'].map((s, i) => (
                        <div key={i} className="flex items-center gap-2 text-xs text-gray-500">
                          {aiPct >= (i + 1) * 33 ? (
                            <Check className="w-4 h-4 text-green-500" />
                          ) : (
                            <Loader2 className="w-4 h-4 text-gray-300 animate-spin" />
                          )}
                          {s}
                        </div>
                      ))}
                    </div>
                  </div>
                ) : (
                  <>
                    {/* AI verification table */}
                    <div className="space-y-3 mb-6">
                      {items.map(it => (
                        <div
                          key={it.id}
                          className={`border rounded overflow-hidden ${
                            it.adminStatus === 'needs_review' ? 'border-yellow-200 bg-yellow-50/30' :
                            it.adminStatus === 'rejected'     ? 'border-red-200 bg-red-50/30' :
                            'border-gray-200 bg-white'
                          }`}
                        >
                          {/* Item header */}
                          <div className="flex items-center justify-between px-4 py-3 bg-gray-50/80 border-b border-gray-100">
                            <div className="flex items-center gap-3">
                              <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold text-white ${
                                it.aiVerdict === 'ok' ? 'bg-green-500' : 'bg-yellow-500'
                              }`}>{it.id}</span>
                              <span className="font-medium text-gray-800">{it.label}</span>
                              <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${RISK_PILL[it.risk]}`}>
                                {RISK_LABEL[it.risk]}
                              </span>
                              <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${STATUS_CFG[it.adminStatus].pill}`}>
                                {STATUS_CFG[it.adminStatus].label}
                              </span>
                            </div>
                            <div className="flex items-center gap-3">
                              <div className="text-right">
                                <span className="text-xs text-gray-500">적합도 </span>
                                <span className={`font-bold text-sm ${
                                  it.adminSuitability >= 80 ? 'text-green-600' :
                                  it.adminSuitability >= 60 ? 'text-yellow-600' : 'text-red-600'
                                }`}>{it.adminSuitability}%</span>
                              </div>
                              {!it.editOpen ? (
                                <button onClick={() => openEdit(it.id)} className="flex items-center gap-1 text-xs px-3 py-1.5 border border-gray-300 rounded-lg hover:bg-white transition-colors text-gray-600">
                                  <Edit3 className="w-3.5 h-3.5" /> 수정
                                </button>
                              ) : (
                                <button onClick={() => closeEdit(it.id)} className="text-xs px-3 py-1.5 border border-gray-300 rounded-lg hover:bg-white transition-colors text-gray-500">
                                  취소
                                </button>
                              )}
                            </div>
                          </div>

                          {/* Item body */}
                          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-0 divide-y md:divide-y-0 md:divide-x divide-gray-100">
                            <Cell label="Before 상태" value={it.beforeState} icon={<AlertCircle className="w-3.5 h-3.5 text-red-400" />} />
                            <Cell label="After 상태"   value={it.afterState}  icon={<CheckCircle2 className="w-3.5 h-3.5 text-green-500" />} />
                            <Cell
                              label="AI 판정"
                              value={it.aiVerdict === 'ok' ? '조치 적합' : '추가 확인 필요'}
                              icon={it.aiVerdict === 'ok' ? <Sparkles className="w-3.5 h-3.5 text-purple-500" /> : <AlertTriangle className="w-3.5 h-3.5 text-yellow-500" />}
                              valueClass={it.aiVerdict === 'ok' ? 'text-green-700' : 'text-yellow-700'}
                            />
                            <Cell label="권장 조치" value={it.recommendation} icon={<ArrowRight className="w-3.5 h-3.5 text-blue-400" />} />
                          </div>

                          {/* Admin edit panel */}
                          {it.editOpen && (
                            <div className="p-4 border-t border-gray-200 bg-blue-50/40">
                              <p className="text-xs font-semibold text-gray-600 mb-3">관리자 수정</p>
                              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <div>
                                  <label className="block text-xs text-gray-500 mb-1">조치 적합도 (%)</label>
                                  <input
                                    type="number" min="0" max="100"
                                    value={it.editSuitability}
                                    onChange={e => setItems(prev => prev.map(x => x.id === it.id ? { ...x, editSuitability: e.target.value } : x))}
                                    className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"
                                  />
                                </div>
                                <div>
                                  <label className="block text-xs text-gray-500 mb-1">관리자 판정</label>
                                  <select
                                    value={it.editStatus}
                                    onChange={e => setItems(prev => prev.map(x => x.id === it.id ? { ...x, editStatus: e.target.value as AdminStatus } : x))}
                                    className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-[#1A2E44] outline-none bg-white"
                                  >
                                    <option value="ok">완료</option>
                                    <option value="needs_review">추가 확인 필요</option>
                                    <option value="rejected">반려</option>
                                  </select>
                                </div>
                                <div>
                                  <label className="block text-xs text-gray-500 mb-1">관리자 메모</label>
                                  <input
                                    type="text"
                                    placeholder="수정 사유 또는 메모"
                                    value={it.adminNote}
                                    onChange={e => setItems(prev => prev.map(x => x.id === it.id ? { ...x, adminNote: e.target.value } : x))}
                                    className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"
                                  />
                                </div>
                              </div>
                              <div className="flex gap-2 mt-3">
                                <button onClick={() => saveEdit(it.id)} className="flex items-center gap-1.5 px-4 py-2 bg-[#1A2E44] text-white rounded-lg text-xs font-medium hover:bg-[#254d7a] transition-colors">
                                  <Save className="w-3.5 h-3.5" /> 저장
                                </button>
                                <button className="flex items-center gap-1.5 px-4 py-2 border border-gray-300 rounded-lg text-xs text-gray-600 hover:bg-white transition-colors">
                                  <Plus className="w-3.5 h-3.5" /> 보완 사진 추가
                                </button>
                                <button className="flex items-center gap-1.5 px-4 py-2 border border-gray-300 rounded-lg text-xs text-gray-600 hover:bg-white transition-colors">
                                  <RefreshCw className="w-3.5 h-3.5" /> 재검증 요청
                                </button>
                              </div>
                            </div>
                          )}
                        </div>
                      ))}
                    </div>

                    {/* AI summary */}
                    <div className="flex items-start gap-3 p-4 bg-purple-50 rounded-lg border border-purple-100">
                      <Sparkles className="w-5 h-5 text-purple-600 flex-shrink-0 mt-0.5" />
                      <p className="text-sm text-purple-800">
                        AI가 전후 사진을 비교한 결과, 3개 위험요소 중 <strong>2개는 조치 적합</strong>, <strong>1개는 추가 확인이 필요</strong>합니다.
                        완료율이 100%가 되어야 최종 완료 처리할 수 있습니다.
                      </p>
                    </div>
                  </>
                )}
              </div>
            </div>
          )}

          {/* Section 4: Completion gauge */}
          {phase === 'ai_done' && (
            <div className="bg-white rounded border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center gap-2">
                <BarChart2 className="w-5 h-5 text-[#1A2E44]" />
                <h2 className="font-semibold text-gray-800">조치 완료율</h2>
              </div>

              <div className="p-6">
                <div className="flex flex-col lg:flex-row gap-8 items-center lg:items-start">
                  {/* Gauge */}
                  <div className="flex flex-col items-center gap-3">
                    <CircularGauge value={completionRate} />
                    <div className="text-center">
                      <p className={`text-sm font-semibold ${completionRate >= 100 ? 'text-green-600' : 'text-yellow-600'}`}>
                        {completionRate >= 100 ? '최종 완료 가능' : '관리자 확인 필요'}
                      </p>
                      <p className="text-xs text-gray-400 mt-0.5">완료 기준: 100%</p>
                    </div>
                  </div>

                  {/* Per-item breakdown */}
                  <div className="flex-1 space-y-3 w-full">
                    {items.map(it => (
                      <div key={it.id} className="space-y-1.5">
                        <div className="flex justify-between items-center">
                          <div className="flex items-center gap-2">
                            <span className="text-sm text-gray-700">{it.label}</span>
                            <span className={`text-xs px-2 py-0.5 rounded-full ${STATUS_CFG[it.adminStatus].pill}`}>
                              {STATUS_CFG[it.adminStatus].label}
                            </span>
                          </div>
                          <span className={`text-sm font-bold ${
                            it.adminSuitability >= 80 ? 'text-green-600' :
                            it.adminSuitability >= 60 ? 'text-yellow-600' : 'text-red-600'
                          }`}>{it.adminSuitability}%</span>
                        </div>
                        <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                          <div
                            className={`h-full rounded-full transition-all duration-500 ${
                              it.adminSuitability >= 80 ? 'bg-green-500' :
                              it.adminSuitability >= 60 ? 'bg-yellow-500' : 'bg-red-500'
                            }`}
                            style={{ width: `${it.adminSuitability}%` }}
                          />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Actions */}
                <div className="mt-6 pt-5 border-t border-gray-100 flex flex-wrap gap-3 items-center justify-between">
                  <div className="flex gap-3">
                    <button
                      onClick={approveAll}
                      className="flex items-center gap-2 px-4 py-2 border border-[#1A2E44] text-[#1A2E44] rounded-lg text-sm hover:bg-[#1A2E44] hover:text-white transition-colors"
                    >
                      <Check className="w-4 h-4" />
                      모두 최종 승인 (100%)
                    </button>
                    <button className="flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-600 rounded-lg text-sm hover:bg-gray-50 transition-colors">
                      <RefreshCw className="w-4 h-4" />
                      재검증 요청
                    </button>
                  </div>
                  <button
                    disabled={completionRate < 100 || finalDone}
                    onClick={() => { setFinalDone(true); toast.success('최종 조치 완료 처리되었습니다!'); }}
                    className={`flex items-center gap-2 px-6 py-3 rounded font-semibold text-sm transition-colors ${
                      completionRate >= 100 && !finalDone
                        ? 'bg-green-600 text-white hover:bg-green-700'
                        : finalDone
                        ? 'bg-green-100 text-green-700 cursor-default'
                        : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    }`}
                  >
                    {finalDone ? <CheckCircle2 className="w-5 h-5" /> : <Shield className="w-5 h-5" />}
                    {finalDone ? '최종 조치 완료됨' : `최종 조치 완료 ${completionRate < 100 ? `(${completionRate}%)` : ''}`}
                  </button>
                </div>

                {completionRate < 100 && (
                  <p className="text-xs text-yellow-700 bg-yellow-50 border border-yellow-200 rounded-lg px-4 py-2 mt-3">
                    완료율이 {completionRate}%입니다. 관리자 수정 필요 항목을 확인하고 수정 후 저장하세요. 완료율 100% 달성 시 최종 조치 완료 처리됩니다.
                  </p>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      {/* ===== TAB: Report Wizard ===== */}
      {mainTab === 'report' && (
        <div className="bg-white rounded border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100 flex items-center gap-2">
            <FileText className="w-5 h-5 text-[#1A2E44]" />
            <h2 className="font-semibold text-gray-800">AI 결과보고서 생성</h2>
          </div>

          {/* Wizard step bar */}
          <div className="px-6 py-4 border-b border-gray-100">
            <div className="flex items-center gap-0">
              {[
                { n: 1, label: '양식 파일 넣기' },
                { n: 2, label: '양식 선택' },
                { n: 3, label: 'AI 양식 생성' },
                { n: 4, label: '저장 및 PDF' },
              ].map((s, i) => (
                <div key={s.n} className="flex items-center flex-1 last:flex-none">
                  <div className="flex flex-col items-center gap-1">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold transition-colors ${
                      reportStep > s.n ? 'bg-green-500 text-white' :
                      reportStep === s.n ? 'bg-[#1A2E44] text-white' :
                      'bg-gray-200 text-gray-500'
                    }`}>
                      {reportStep > s.n ? <Check className="w-4 h-4" /> : s.n}
                    </div>
                    <span className={`text-xs font-medium whitespace-nowrap ${reportStep === s.n ? 'text-[#1A2E44]' : 'text-gray-400'}`}>
                      {s.label}
                    </span>
                  </div>
                  {i < 3 && <div className={`flex-1 h-px mx-2 mb-4 ${reportStep > s.n ? 'bg-green-400' : 'bg-gray-200'}`} />}
                </div>
              ))}
            </div>
          </div>

          <div className="p-6">

            {/* Step 1: Upload form file */}
            {reportStep === 1 && (
              <div className="space-y-5">
                <div>
                  <h3 className="font-semibold text-gray-800 mb-1">보고서 양식 파일 업로드</h3>
                  <p className="text-sm text-gray-500">업로드한 양식 파일을 기반으로 AI가 현장 점검 결과보고서를 자동 생성합니다.</p>
                </div>

                <div
                  className="border-2 border-dashed border-gray-300 rounded p-10 text-center hover:border-[#1A2E44] transition-colors cursor-pointer group"
                  onClick={() => reportFileRef.current?.click()}
                >
                  <Upload className="w-10 h-10 text-gray-300 mx-auto mb-3 group-hover:text-[#1A2E44] transition-colors" />
                  <p className="font-medium text-gray-600 mb-1">파일을 드래그하거나 클릭하여 업로드</p>
                  <p className="text-xs text-gray-400">지원 형식: DOCX, HWP, PDF, XLSX</p>
                  <input ref={reportFileRef} type="file" className="hidden" multiple accept=".docx,.hwp,.pdf,.xlsx" onChange={handleReportFileInput} />
                </div>

                {reportFiles.length > 0 && (
                  <div className="space-y-2">
                    {reportFiles.map(f => (
                      <div key={f.id} className="flex items-center justify-between px-4 py-3 bg-blue-50 border border-blue-200 rounded-lg">
                        <div className="flex items-center gap-3">
                          <FileText className="w-5 h-5 text-blue-600" />
                          <div>
                            <p className="text-sm font-medium text-gray-800">{f.name}</p>
                            <p className="text-xs text-gray-500">{f.size}</p>
                          </div>
                        </div>
                        <button onClick={() => setReportFiles(prev => prev.filter(x => x.id !== f.id))} className="text-gray-400 hover:text-red-500 transition-colors">
                          <X className="w-4 h-4" />
                        </button>
                      </div>
                    ))}
                  </div>
                )}

                <div className="flex justify-between items-center pt-2">
                  <p className="text-xs text-gray-400">
                    {reportFiles.length === 0 ? '파일을 업로드하거나 기본 제공 양식을 사용하세요.' : `${reportFiles.length}개 파일 업로드됨`}
                  </p>
                  <button
                    onClick={() => setReportStep(2)}
                    className="flex items-center gap-2 px-5 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-medium hover:bg-[#254d7a] transition-colors"
                  >
                    다음 단계 <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            )}

            {/* Step 2: Select template */}
            {reportStep === 2 && (
              <div className="space-y-5">
                <div>
                  <h3 className="font-semibold text-gray-800 mb-1">양식 선택</h3>
                  <p className="text-sm text-gray-500">생성할 보고서 양식을 선택하세요.</p>
                </div>

                {reportFiles.length > 0 && (
                  <div>
                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">업로드한 양식</p>
                    {reportFiles.map(f => (
                      <button
                        key={f.id}
                        onClick={() => setSelectedTemplate(f.id)}
                        className={`w-full flex items-center gap-3 p-4 rounded border-2 mb-2 transition-colors ${
                          selectedTemplate === f.id ? 'border-[#1A2E44] bg-blue-50' : 'border-gray-200 hover:border-gray-300'
                        }`}
                      >
                        <FileText className="w-6 h-6 text-blue-600" />
                        <div className="text-left">
                          <p className="font-medium text-gray-800">{f.name}</p>
                          <p className="text-xs text-gray-500">업로드된 양식 · {f.size}</p>
                        </div>
                        {selectedTemplate === f.id && <CheckCircle2 className="w-5 h-5 text-[#1A2E44] ml-auto" />}
                      </button>
                    ))}
                  </div>
                )}

                <div>
                  <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">기본 제공 양식</p>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {REPORT_TEMPLATES.map(t => (
                      <button
                        key={t.id}
                        onClick={() => setSelectedTemplate(t.id)}
                        className={`flex items-start gap-3 p-4 rounded border-2 text-left transition-colors ${
                          selectedTemplate === t.id ? 'border-[#1A2E44] bg-blue-50' : 'border-gray-200 hover:border-gray-300'
                        }`}
                      >
                        <t.icon className={`w-6 h-6 flex-shrink-0 mt-0.5 ${selectedTemplate === t.id ? 'text-[#1A2E44]' : 'text-gray-400'}`} />
                        <div>
                          <p className="font-medium text-gray-800">{t.name}</p>
                          <p className="text-xs text-gray-500 mt-0.5">{t.desc}</p>
                        </div>
                        {selectedTemplate === t.id && <CheckCircle2 className="w-5 h-5 text-[#1A2E44] ml-auto flex-shrink-0" />}
                      </button>
                    ))}
                  </div>
                </div>

                <div className="flex justify-between pt-2">
                  <button onClick={() => setReportStep(1)} className="flex items-center gap-1.5 px-4 py-2.5 border border-gray-300 text-gray-600 rounded text-sm hover:bg-gray-50 transition-colors">
                    <ChevronLeft className="w-4 h-4" /> 이전
                  </button>
                  <button
                    disabled={!selectedTemplate}
                    onClick={() => { setReportStep(3); startReportGen(); }}
                    className={`flex items-center gap-2 px-5 py-2.5 rounded text-sm font-medium transition-colors ${
                      selectedTemplate ? 'bg-[#1A2E44] text-white hover:bg-[#254d7a]' : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    }`}
                  >
                    {!selectedTemplate ? '양식을 선택하세요' : 'AI 보고서 생성'} <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            )}

            {/* Step 3: AI generation — split view with live doc preview */}
            {reportStep === 3 && (
              <div className="space-y-4">
                <div>
                  <h3 className="font-semibold text-gray-800 mb-1">AI 양식 파일 생성</h3>
                  <p className="text-sm text-gray-500">선택한 양식에 맞춰 AI가 현장 점검 결과를 자동으로 삽입하고 있습니다.</p>
                </div>

                <ProgressBar pct={reportGenPct} label={`AI 보고서 생성 중... ${reportGenPct}%`} />

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-5 mt-2">
                  {/* Left: task checklist */}
                  <div className="space-y-2">
                    {[
                      { label: '현장 기본정보 삽입',        threshold: 0  },
                      { label: 'Before / After 사진 처리', threshold: 20 },
                      { label: 'Roboflow 1차 검증 결과 통합', threshold: 40 },
                      { label: 'AI 2차 판독 결과 삽입',     threshold: 60 },
                      { label: '조치 완료율 및 관리자 내역', threshold: 75 },
                      { label: '종합 의견 자동 생성',        threshold: 85 },
                      { label: '서명란 및 서식 최종 적용',   threshold: 95 },
                    ].map(t => {
                      const done    = reportGenPct > t.threshold + 14;
                      const running = !done && reportGenPct >= t.threshold;
                      return (
                        <div key={t.label} className={`flex items-center gap-3 text-sm px-3 py-2.5 rounded-lg transition-colors ${
                          done ? 'bg-green-50' : running ? 'bg-blue-50' : 'bg-gray-50'
                        }`}>
                          {done ? (
                            <CheckCircle2 className="w-4 h-4 text-green-500 flex-shrink-0" />
                          ) : running ? (
                            <Loader2 className="w-4 h-4 text-blue-500 animate-spin flex-shrink-0" />
                          ) : (
                            <Clock className="w-4 h-4 text-gray-300 flex-shrink-0" />
                          )}
                          <span className={done ? 'text-green-800 font-medium' : running ? 'text-blue-700 font-medium' : 'text-gray-400'}>
                            {t.label}
                          </span>
                          {done && <span className="ml-auto text-xs text-green-500 font-semibold">완료</span>}
                          {running && <span className="ml-auto text-xs text-blue-500 animate-pulse">처리중...</span>}
                        </div>
                      );
                    })}
                  </div>

                  {/* Right: live document preview */}
                  <div className="border border-gray-200 rounded overflow-hidden text-xs">
                    <div className="bg-[#1A2E44] px-3 py-2 flex items-center gap-2">
                      <Eye className="w-3.5 h-3.5 text-white/70" />
                      <span className="text-white/90 font-medium text-xs">실시간 문서 미리보기</span>
                    </div>
                    <div className="p-4 space-y-3 max-h-72 overflow-y-auto">
                      {/* Title */}
                      <div className="text-center font-bold text-sm text-gray-800 border-b border-gray-200 pb-2">
                        {REPORT_TEMPLATES.find(t => t.id === selectedTemplate)?.name ?? '안전점검 결과보고서'}
                      </div>

                      {/* Site info — fills at pct >= 0 */}
                      <div className={`transition-opacity duration-500 ${reportGenPct >= 5 ? 'opacity-100' : 'opacity-30'}`}>
                        <table className="w-full border border-gray-300 text-xs">
                          <tbody>
                            <tr>
                              <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300 w-16">현장명</td>
                              <td className="px-2 py-1 border border-gray-300">
                                {reportGenPct >= 5 ? '강남 복합시설 신축공사' : <span className="text-gray-300">▓▓▓▓▓▓▓▓▓</span>}
                              </td>
                              <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300 w-12">점검일</td>
                              <td className="px-2 py-1 border border-gray-300">
                                {reportGenPct >= 8 ? '2026.08.09' : <span className="text-gray-300">▓▓▓▓▓</span>}
                              </td>
                            </tr>
                            <tr>
                              <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300">원청</td>
                              <td className="px-2 py-1 border border-gray-300">
                                {reportGenPct >= 10 ? '대한안전건설' : <span className="text-gray-300">▓▓▓▓▓▓</span>}
                              </td>
                              <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300">하청</td>
                              <td className="px-2 py-1 border border-gray-300">
                                {reportGenPct >= 12 ? '안전하도급' : <span className="text-gray-300">▓▓▓▓▓</span>}
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>

                      {/* Roboflow — fills at pct >= 40 */}
                      <div className={`transition-opacity duration-500 ${reportGenPct >= 40 ? 'opacity-100' : 'opacity-20'}`}>
                        <p className="text-xs font-semibold text-gray-600 mb-1">■ Roboflow 1차 검증 결과</p>
                        <table className="w-full border border-gray-300 text-xs">
                          <thead className="bg-gray-100">
                            <tr>
                              <th className="px-2 py-1 border border-gray-300 text-left">감지 항목</th>
                              <th className="px-2 py-1 border border-gray-300">신뢰도</th>
                              <th className="px-2 py-1 border border-gray-300">위험</th>
                            </tr>
                          </thead>
                          <tbody>
                            {INITIAL_ITEMS.map(it => (
                              <tr key={it.id}>
                                <td className="px-2 py-1 border border-gray-300">
                                  {reportGenPct >= 45 ? it.label : <span className="text-gray-300">▓▓▓▓▓▓▓</span>}
                                </td>
                                <td className="px-2 py-1 border border-gray-300 text-center">
                                  {reportGenPct >= 48 ? `${it.confidence}%` : <span className="text-gray-300">▓▓▓</span>}
                                </td>
                                <td className="px-2 py-1 border border-gray-300 text-center">
                                  {reportGenPct >= 50 ? RISK_LABEL[it.risk] : <span className="text-gray-300">▓▓</span>}
                                </td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>

                      {/* AI results — fills at pct >= 60 */}
                      <div className={`transition-opacity duration-500 ${reportGenPct >= 60 ? 'opacity-100' : 'opacity-20'}`}>
                        <p className="text-xs font-semibold text-gray-600 mb-1">■ AI 2차 판독 결과</p>
                        {reportGenPct >= 65 ? (
                          <div className="space-y-1">
                            {items.map(it => (
                              <div key={it.id} className="flex items-center gap-2 px-2 py-1 border border-gray-200 rounded">
                                <span className={`w-1.5 h-1.5 rounded-full ${it.aiVerdict === 'ok' ? 'bg-green-500' : 'bg-yellow-500'}`} />
                                <span className="text-gray-700 flex-1">{it.label}</span>
                                <span className={`font-semibold ${it.adminSuitability >= 80 ? 'text-green-600' : 'text-yellow-600'}`}>{it.adminSuitability}%</span>
                              </div>
                            ))}
                          </div>
                        ) : (
                          <div className="space-y-1">
                            {[1,2,3].map(i => <div key={i} className="h-5 bg-gray-100 rounded animate-pulse" />)}
                          </div>
                        )}
                      </div>

                      {/* Opinion — fills at pct >= 85 */}
                      <div className={`transition-opacity duration-500 ${reportGenPct >= 85 ? 'opacity-100' : 'opacity-20'}`}>
                        <p className="text-xs font-semibold text-gray-600 mb-1">■ 종합 의견</p>
                        <div className="text-gray-700 leading-relaxed border border-gray-200 rounded p-2">
                          {reportGenPct >= 88
                            ? '금번 점검 결과, 3건의 위험요소 중 2건(안전난간, 안전모)은 AI 판독 기준 조치 적합 판정을 받았습니다. 1건(개구부)은 추가 확인이 필요합니다. 조치 완료율은 현재 82%이며, 관리자 보완 조치 후 최종 완료 처리를 권장합니다.'
                            : <span className="text-gray-300 text-xs">▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓</span>
                          }
                        </div>
                      </div>

                      {/* Signature — fills at pct >= 95 */}
                      <div className={`transition-opacity duration-500 ${reportGenPct >= 95 ? 'opacity-100' : 'opacity-20'}`}>
                        <table className="w-full border border-gray-300 text-xs mt-1">
                          <thead className="bg-gray-100">
                            <tr>
                              <th className="px-2 py-1 border border-gray-300">작성자</th>
                              <th className="px-2 py-1 border border-gray-300">검토자</th>
                              <th className="px-2 py-1 border border-gray-300">승인자</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr>
                              <td className="px-2 py-4 border border-gray-300 text-center text-gray-400">(서명)</td>
                              <td className="px-2 py-4 border border-gray-300 text-center text-gray-400">(서명)</td>
                              <td className="px-2 py-4 border border-gray-300 text-center text-gray-400">(서명)</td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Step 4: Full document + Save */}
            {reportStep === 4 && (
              <div className="space-y-5">
                <div className="flex items-center gap-3 p-4 bg-green-50 border border-green-200 rounded">
                  <CheckCircle2 className="w-6 h-6 text-green-600 flex-shrink-0" />
                  <div>
                    <p className="font-semibold text-green-800">AI 보고서 생성 완료</p>
                    <p className="text-sm text-green-700">
                      {REPORT_TEMPLATES.find(t => t.id === selectedTemplate)?.name ?? selectedTemplate}을(를) 기반으로 결과보고서가 자동 작성되었습니다.
                    </p>
                  </div>
                </div>

                {/* A4-style document */}
                <div className="border border-gray-300 rounded overflow-hidden shadow-sm">
                  {/* Toolbar */}
                  <div className="bg-gray-100 border-b border-gray-300 px-4 py-2.5 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <FileText className="w-4 h-4 text-gray-500" />
                      <span className="text-sm font-medium text-gray-700">보고서 미리보기</span>
                      {pdfDone && (
                        <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full border border-green-200 font-medium">PDF 완료</span>
                      )}
                    </div>
                    <span className="text-xs text-gray-400">강남복합시설_안전점검_AI결과보고서_20260809.pdf</span>
                  </div>

                  {/* Document body */}
                  <div className="bg-white p-6 sm:p-8 space-y-5 text-sm">
                    {/* Document header */}
                    <div className="text-center space-y-1 pb-4 border-b-2 border-gray-800">
                      <div className="flex items-center justify-between text-xs text-gray-500 mb-2">
                        <span>문서번호: SM-2026-0809-001</span>
                        <span className="flex items-center gap-1">
                          <Sparkles className="w-3.5 h-3.5 text-purple-500" /> AI 자동생성
                        </span>
                      </div>
                      <h2 className="text-xl font-bold text-gray-900">
                        {REPORT_TEMPLATES.find(t => t.id === selectedTemplate)?.name ?? '안전점검 결과보고서'}
                      </h2>
                      <p className="text-xs text-gray-500">건설현장 안전관리 플랫폼 SafeMate · 2026년 08월 09일</p>
                    </div>

                    {/* Site info table */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-[#1A2E44] rounded-full inline-block" /> 현장 기본정보
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <tbody>
                          <tr>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 w-24 text-center">현  장  명</td>
                            <td className="px-3 py-2 border border-gray-400" colSpan={3}>강남 복합시설 신축공사</td>
                          </tr>
                          <tr>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center">원청 건설사</td>
                            <td className="px-3 py-2 border border-gray-400">대한안전건설</td>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center w-20">하청 업체</td>
                            <td className="px-3 py-2 border border-gray-400">안전하도급</td>
                          </tr>
                          <tr>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center">점  검  일</td>
                            <td className="px-3 py-2 border border-gray-400">2026년 08월 09일</td>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center">담  당  자</td>
                            <td className="px-3 py-2 border border-gray-400">이조치</td>
                          </tr>
                          <tr>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center">조치 완료율</td>
                            <td className="px-3 py-2 border border-gray-400" colSpan={3}>
                              <div className="flex items-center gap-3">
                                <div className="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
                                  <div className={`h-full rounded-full ${completionRate >= 100 ? 'bg-green-500' : 'bg-yellow-500'}`} style={{ width: `${completionRate}%` }} />
                                </div>
                                <span className={`font-bold ${completionRate >= 100 ? 'text-green-600' : 'text-yellow-600'}`}>{completionRate}%</span>
                                <span className={`text-xs px-2 py-0.5 rounded-full ${completionRate >= 100 ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                                  {completionRate >= 100 ? '최종 완료' : '관리자 확인 필요'}
                                </span>
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    {/* Section 1: Roboflow results */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-blue-600 rounded-full inline-block" /> 1. Roboflow 1차 객체인식 결과
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <thead>
                          <tr className="bg-gray-100">
                            <th className="px-3 py-2 border border-gray-400 text-center">No.</th>
                            <th className="px-3 py-2 border border-gray-400 text-left">감지 위험요소</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">위치</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">신뢰도</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">위험 등급</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">상태</th>
                          </tr>
                        </thead>
                        <tbody>
                          {INITIAL_ITEMS.map(it => (
                            <tr key={it.id} className="hover:bg-gray-50">
                              <td className="px-3 py-2 border border-gray-400 text-center">{it.id}</td>
                              <td className="px-3 py-2 border border-gray-400 font-medium">{it.label}</td>
                              <td className="px-3 py-2 border border-gray-400 text-center text-gray-600">{it.location}</td>
                              <td className="px-3 py-2 border border-gray-400 text-center font-mono">{it.confidence}%</td>
                              <td className="px-3 py-2 border border-gray-400 text-center">
                                <span className={`px-2 py-0.5 rounded-full font-medium ${RISK_PILL[it.risk]}`}>{RISK_LABEL[it.risk]}</span>
                              </td>
                              <td className="px-3 py-2 border border-gray-400 text-center">
                                <span className="px-2 py-0.5 rounded-full bg-red-100 text-red-700 font-medium">조치 필요</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>

                    {/* Section 2: AI 2nd pass */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-purple-600 rounded-full inline-block" /> 2. AI 2차 판독 및 전후 비교 검증
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <thead>
                          <tr className="bg-gray-100">
                            <th className="px-2 py-2 border border-gray-400 text-left w-24">위험요소</th>
                            <th className="px-2 py-2 border border-gray-400 text-left">Before 상태</th>
                            <th className="px-2 py-2 border border-gray-400 text-left">After 상태</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-20">AI 판정</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-14">적합도</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-20">확인 상태</th>
                          </tr>
                        </thead>
                        <tbody>
                          {items.map(it => (
                            <tr key={it.id} className={it.adminStatus === 'needs_review' ? 'bg-yellow-50' : ''}>
                              <td className="px-2 py-2 border border-gray-400 font-medium">{it.label}</td>
                              <td className="px-2 py-2 border border-gray-400 text-gray-600">{it.beforeState}</td>
                              <td className="px-2 py-2 border border-gray-400 text-gray-600">{it.afterState}</td>
                              <td className="px-2 py-2 border border-gray-400 text-center">
                                <span className={it.aiVerdict === 'ok' ? 'text-green-700 font-semibold' : 'text-yellow-700 font-semibold'}>
                                  {it.aiVerdict === 'ok' ? '조치 적합' : '추가 확인'}
                                </span>
                              </td>
                              <td className="px-2 py-2 border border-gray-400 text-center font-bold font-mono">
                                <span className={it.adminSuitability >= 80 ? 'text-green-600' : 'text-yellow-600'}>{it.adminSuitability}%</span>
                              </td>
                              <td className="px-2 py-2 border border-gray-400 text-center">
                                <span className={`px-1.5 py-0.5 rounded-full text-xs font-medium ${STATUS_CFG[it.adminStatus].pill}`}>
                                  {STATUS_CFG[it.adminStatus].label}
                                </span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>

                    {/* Section 3: Photos */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-orange-500 rounded-full inline-block" /> 3. 첨부 사진 (Before / After)
                      </p>
                      <div className="grid grid-cols-2 gap-4 border border-gray-300 rounded p-3 bg-gray-50">
                        {[
                          { label: 'Before', sublabel: '조치 이전', src: beforeImg ?? DEMO_BEFORE, border: 'border-red-200' },
                          { label: 'After',  sublabel: '조치 이후', src: afterImg  ?? DEMO_AFTER,  border: 'border-green-200' },
                        ].map(p => (
                          <div key={p.label}>
                            <p className={`text-xs font-semibold mb-1 text-center border-b ${p.border} pb-1`}>{p.label} — {p.sublabel}</p>
                            <img src={p.src} alt={p.label} className="w-full rounded object-cover" style={{ height: 120 }} />
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Section 4: Overall opinion */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-gray-700 rounded-full inline-block" /> 4. 종합 의견 (AI 자동 생성)
                      </p>
                      <div className="border border-gray-300 rounded p-3 bg-gray-50 text-xs text-gray-700 leading-5">
                        금번 강남 복합시설 신축공사 현장에 대한 AI 안전점검 결과, 총 <strong>3건</strong>의 위험요소가 감지되었습니다.
                        <br />• <strong>안전난간 미설치</strong>(적합도 {items[0].adminSuitability}%): 임시 안전난간 설치가 확인되었으나, 고정 상태 추가 확인이 권장됩니다.
                        <br />• <strong>개구부 방치</strong>(적합도 {items[1].adminSuitability}%): 덮개 설치는 확인되었으나 고정 여부가 불명확하여 관리자 보완 조치가 필요합니다.
                        <br />• <strong>안전모 미착용</strong>(적합도 {items[2].adminSuitability}%): 착용이 확인되었으며, 지속 착용 교육 기록 첨부를 권장합니다.
                        <br /><br />현재 조치 완료율은 <strong>{completionRate}%</strong>이며,
                        {completionRate < 100
                          ? ' 잔여 미흡 항목에 대한 관리자 검토 및 보완 조치 후 최종 완료 처리를 권장합니다.'
                          : ' 모든 항목의 조치가 완료되어 최종 완료 처리가 가능합니다.'}
                      </div>
                    </div>

                    {/* Section 5: Recommendation */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-red-500 rounded-full inline-block" /> 5. 권장 조치 사항
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <tbody>
                          {items.map((it, i) => (
                            <tr key={it.id} className={i % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                              <td className="bg-gray-100 px-3 py-2 border border-gray-400 font-semibold w-32 text-center">{it.label}</td>
                              <td className="px-3 py-2 border border-gray-400 text-gray-700">{it.recommendation}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>

                    {/* Section 6: Signatures */}
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-gray-500 rounded-full inline-block" /> 6. 담당자 확인란
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <thead>
                          <tr className="bg-gray-100">
                            <th className="px-3 py-2 border border-gray-400 text-center">작 성 자</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">검 토 자</th>
                            <th className="px-3 py-2 border border-gray-400 text-center">승 인 자</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-lg">(인)</td>
                            <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-lg">(인)</td>
                            <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-lg">(인)</td>
                          </tr>
                          <tr>
                            <td className="px-3 py-2 border border-gray-400 text-center text-gray-500">이조치</td>
                            <td className="px-3 py-2 border border-gray-400 text-center text-gray-400"></td>
                            <td className="px-3 py-2 border border-gray-400 text-center text-gray-400"></td>
                          </tr>
                        </tbody>
                      </table>
                      <p className="text-right text-xs text-gray-400 mt-2">
                        상기 내용은 AI 분석 결과를 바탕으로 자동 생성된 보고서입니다. · SafeMate v2.0
                      </p>
                    </div>
                  </div>
                </div>

                {/* Save actions */}
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <button
                    onClick={() => { setReportSaved(true); toast.success('보고서가 저장되었습니다.'); }}
                    className={`flex items-center justify-center gap-2 px-4 py-3 rounded font-medium text-sm transition-colors ${
                      reportSaved ? 'bg-green-100 text-green-700' : 'bg-[#1A2E44] text-white hover:bg-[#254d7a]'
                    }`}
                  >
                    {reportSaved ? <CheckCircle2 className="w-4 h-4" /> : <Save className="w-4 h-4" />}
                    {reportSaved ? '저장 완료' : '보고서 저장'}
                  </button>
                  <button
                    onClick={() => { setPdfDone(true); toast.success('PDF가 생성되었습니다.'); }}
                    className={`flex items-center justify-center gap-2 px-4 py-3 rounded font-medium text-sm transition-colors ${
                      pdfDone ? 'bg-green-100 text-green-700' : 'bg-[#1A2E44] text-white hover:bg-[#e55f2a]'
                    }`}
                  >
                    {pdfDone ? <CheckCircle2 className="w-4 h-4" /> : <Printer className="w-4 h-4" />}
                    {pdfDone ? 'PDF 생성 완료' : 'PDF 생성'}
                  </button>
                  <button
                    onClick={() => toast.success('다운로드가 시작됩니다.')}
                    className="flex items-center justify-center gap-2 px-4 py-3 border border-gray-300 text-gray-700 rounded font-medium text-sm hover:bg-gray-50 transition-colors"
                  >
                    <Download className="w-4 h-4" /> 다운로드
                  </button>
                </div>

                {(reportSaved || pdfDone) && (
                  <div className="text-xs text-gray-500 bg-gray-50 border border-gray-200 rounded-lg px-4 py-2.5">
                    <span className="font-medium">저장 위치:</span> /reports/강남복합시설_안전점검_AI결과보고서_20260809.pdf
                    {pdfDone && <span className="ml-3 text-green-600 font-medium">· PDF 생성 완료</span>}
                  </div>
                )}

                <div className="flex justify-between pt-2">
                  <button
                    onClick={() => { setReportStep(1); setSelectedTemplate(null); setReportGenPct(0); setReportGenDone(false); setReportSaved(false); setPdfDone(false); }}
                    className="flex items-center gap-1.5 px-4 py-2.5 border border-gray-300 text-gray-600 rounded text-sm hover:bg-gray-50 transition-colors"
                  >
                    <RefreshCw className="w-4 h-4" /> 새 보고서 생성
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </Layout>
  );
}

// ── DropZone sub-component ──────────────────────────────────────
function DropZone({
  label, sublabel, imgUrl, boxes, showBoxes,
  inputRef, onFileChange, onDrop, accentClass, badgeClass,
}: {
  label: string; sublabel: string;
  imgUrl: string | null;
  boxes: DetectionBox[]; showBoxes: boolean;
  inputRef: React.RefObject<HTMLInputElement>;
  onFileChange: (f: File) => void;
  onDrop: (e: React.DragEvent) => void;
  accentClass: string; badgeClass: string;
}) {
  const [dragging, setDragging] = useState(false);
  return (
    <div className="flex-1">
      <div className="flex items-center justify-between mb-2">
        <span className="text-sm font-semibold text-gray-700">{label}</span>
        <span className={`text-xs px-2.5 py-1 rounded-full border font-medium ${badgeClass}`}>{sublabel}</span>
      </div>
      <div
        className={`relative border-2 rounded overflow-hidden transition-colors ${
          dragging ? 'border-[#1A2E44] bg-blue-50' : imgUrl ? 'border-gray-200' : `border-dashed ${accentClass}`
        }`}
        style={{ minHeight: 200 }}
        onDragOver={e => { e.preventDefault(); setDragging(true); }}
        onDragLeave={() => setDragging(false)}
        onDrop={e => { setDragging(false); onDrop(e); }}
      >
        {imgUrl ? (
          <>
            <img src={imgUrl} alt={label} className="w-full object-cover" style={{ maxHeight: 260 }} />
            <DetectionOverlay boxes={boxes} show={showBoxes} />
            <button
              onClick={() => inputRef.current?.click()}
              className="absolute bottom-2 right-2 bg-white/90 rounded-lg px-3 py-1.5 text-xs text-gray-600 flex items-center gap-1 shadow hover:bg-white transition-colors"
            >
              <Upload className="w-3.5 h-3.5" /> 교체
            </button>
          </>
        ) : (
          <div className="flex flex-col items-center justify-center gap-3 p-10 cursor-pointer" onClick={() => inputRef.current?.click()}>
            <ImageIcon className="w-12 h-12 text-gray-300" />
            <div className="text-center">
              <p className="text-sm font-medium text-gray-500">클릭 또는 드래그하여 업로드</p>
              <p className="text-xs text-gray-400 mt-1">JPG, PNG, WEBP 지원</p>
            </div>
          </div>
        )}
        <input
          ref={inputRef} type="file" className="hidden" accept="image/*"
          onChange={e => { const f = e.target.files?.[0]; if (f) onFileChange(f); }}
        />
      </div>
    </div>
  );
}

// ── Cell sub-component ─────────────────────────────────────────
function Cell({ label, value, icon, valueClass = 'text-gray-700' }: { label: string; value: string; icon: React.ReactNode; valueClass?: string }) {
  return (
    <div className="px-4 py-3">
      <div className="flex items-center gap-1.5 mb-1">
        {icon}
        <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">{label}</span>
      </div>
      <p className={`text-sm ${valueClass}`}>{value}</p>
    </div>
  );
}
