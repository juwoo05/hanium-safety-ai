import React, { useState, useRef, useEffect } from 'react';
import Layout from './Layout';
import type { CompletedAction } from '../App';
import {
  FileText, Upload, CheckCircle2, Loader2, Clock, ChevronRight, ChevronLeft,
  Save, Printer, Download, RefreshCw, AlertTriangle, Shield, BarChart2,
  Sparkles, Eye, X, Check, CheckSquare,
} from 'lucide-react';
import { toast } from 'sonner';

interface AIReportPageProps {
  onNavigate: (page: string) => void;
  completedActions?: CompletedAction[];
  onConsumeActions?: () => void;
}

type ReportStep = 1 | 2 | 3 | 4;

interface FormFile {
  id: string;
  name: string;
  size: string;
}

const STEPS_WITH_ACTIONS = [
  { number: 1, label: '완료 조치 선택',  icon: CheckSquare },
  { number: 2, label: '양식 선택',       icon: FileText },
  { number: 3, label: 'AI 양식 생성',    icon: Sparkles },
  { number: 4, label: '저장 및 PDF',     icon: Save },
];

const STEPS_UPLOAD = [
  { number: 1, label: '양식 파일 넣기', icon: Upload },
  { number: 2, label: '양식 선택',      icon: FileText },
  { number: 3, label: 'AI 양식 생성',   icon: Sparkles },
  { number: 4, label: '저장 및 PDF',    icon: Save },
];

const TEMPLATES = [
  { id: 'action',     name: '조치결과보고서',          desc: '완료된 조치 결과 및 재발방지 계획 기록',       icon: CheckCircle2 },
  { id: 'inspection', name: '안전점검 결과보고서',      desc: '현장 안전점검 결과를 정리한 표준 보고서',       icon: Shield },
  { id: 'tbm',        name: 'TBM 보고서',              desc: '작업 전 안전 회의 (Tool Box Meeting) 기록',     icon: BarChart2 },
  { id: 'confirm',    name: '하청 조치확인서',          desc: '하청 업체의 조치 완료 확인 및 서명 문서',       icon: AlertTriangle },
];

const RISK_PILL: Record<string, string> = {
  high: 'bg-red-100 text-red-700 border-red-200',
  medium: 'bg-orange-100 text-orange-700 border-orange-200',
  low: 'bg-yellow-100 text-yellow-700 border-yellow-200',
};
const RISK_LABEL: Record<string, string> = { high: '고위험', medium: '중위험', low: '저위험' };

const DEMO_BEFORE = 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=500&h=280&fit=crop&auto=format';
const DEMO_AFTER  = 'https://images.unsplash.com/photo-1581094488379-6a10d571cc9d?w=500&h=280&fit=crop&auto=format';

function ProgressBar({ pct }: { pct: number }) {
  return (
    <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
      <div className="h-full bg-[#1A2E44] rounded-full transition-all duration-300" style={{ width: `${pct}%` }} />
    </div>
  );
}

export default function AIReportPage({ onNavigate, completedActions, onConsumeActions }: AIReportPageProps) {
  const fromReport = Boolean(completedActions?.length);
  const STEPS = fromReport ? STEPS_WITH_ACTIONS : STEPS_UPLOAD;

  const [step, setStep] = useState<ReportStep>(1);
  const [selectedIds, setSelectedIds] = useState<Set<number>>(
    () => new Set(completedActions?.map((_, i) => i) ?? [])
  );
  const [formFiles, setFormFiles] = useState<FormFile[]>([]);
  const [selectedTemplate, setSelectedTemplate] = useState<string | null>(fromReport ? 'action' : null);
  const [genPct, setGenPct] = useState(0);
  const [genDone, setGenDone] = useState(false);
  const [saved, setSaved] = useState(false);
  const [pdfDone, setPdfDone] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);
  const genIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const genTimeoutRef  = useRef<ReturnType<typeof setTimeout>  | null>(null);

  useEffect(() => {
    const consume = onConsumeActions;
    return () => {
      consume?.();
      if (genIntervalRef.current) clearInterval(genIntervalRef.current);
      if (genTimeoutRef.current)  clearTimeout(genTimeoutRef.current);
    };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const selectedActions = completedActions?.filter((_, i) => selectedIds.has(i)) ?? [];

  const templateName = TEMPLATES.find(t => t.id === selectedTemplate)?.name
    ?? (formFiles.find(f => f.id === selectedTemplate)?.name ?? '조치결과보고서');

  const toggleId = (i: number) => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      next.has(i) ? next.delete(i) : next.add(i);
      return next;
    });
  };

  const handleFiles = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const valid = files.filter(f => /\.(docx|hwp|pdf|xlsx)$/i.test(f.name));
    const invalid = files.filter(f => !/\.(docx|hwp|pdf|xlsx)$/i.test(f.name));
    if (invalid.length) toast.error(`${invalid.length}개 파일은 지원하지 않는 형식입니다.`);
    const next: FormFile[] = valid.map(f => ({
      id: Math.random().toString(36).slice(2),
      name: f.name,
      size: (f.size / 1024).toFixed(1) + ' KB',
    }));
    setFormFiles(prev => [...prev, ...next]);
    if (valid.length) toast.success(`${valid.length}개 파일이 업로드되었습니다.`);
    e.target.value = '';
  };

  const startGenerate = () => {
    setGenPct(0);
    setGenDone(false);
    let p = 0;
    if (genIntervalRef.current) clearInterval(genIntervalRef.current);
    genIntervalRef.current = setInterval(() => {
      p += Math.random() * 10 + 5;
      if (p >= 100) {
        clearInterval(genIntervalRef.current!);
        genIntervalRef.current = null;
        setGenPct(100);
        genTimeoutRef.current = setTimeout(() => { setGenDone(true); setStep(4); }, 500);
      } else {
        setGenPct(Math.round(p));
      }
    }, 180);
  };

  const resetAll = () => {
    setStep(1);
    setFormFiles([]);
    setSelectedTemplate(fromReport ? 'action' : null);
    setSelectedIds(new Set(completedActions?.map((_, i) => i) ?? []));
    setGenPct(0);
    setGenDone(false);
    setSaved(false);
    setPdfDone(false);
  };

  return (
    <Layout currentPath="ai-report" onNavigate={onNavigate}>
      <div className="mb-6">
        <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>결과보고서</p>
        <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1, marginBottom: 6 }}>AI 결과보고서 생성</h1>
        <p style={{ fontSize: 12, color: '#6B7280' }}>
          {fromReport
            ? '완료된 조치 항목을 선택하여 안전양식을 자동으로 작성합니다.'
            : '업로드한 양식 파일을 기반으로 현장 점검 결과보고서를 자동 생성합니다.'}
        </p>
      </div>

      <div className="bg-white rounded shadow-sm border border-gray-100 overflow-hidden">

        {/* ── Step indicator ── */}
        <div className="px-6 pt-6 pb-4 border-b border-gray-100">
          <div className="flex items-center">
            {STEPS.map((s, i) => {
              const done    = step > s.number;
              const current = step === s.number;
              return (
                <React.Fragment key={s.number}>
                  <div className="flex flex-col items-center gap-1.5">
                    <div className={`w-9 h-9 rounded-full flex items-center justify-center transition-colors ${
                      done    ? 'bg-green-500 text-white' :
                      current ? 'bg-[#1A2E44] text-white' :
                                'bg-gray-100 text-gray-400'
                    }`}>
                      {done ? <Check className="w-4 h-4" /> : <s.icon className="w-4 h-4" />}
                    </div>
                    <span className={`text-[11px] font-medium whitespace-nowrap ${
                      current ? 'text-[#1A2E44]' : done ? 'text-green-600' : 'text-gray-400'
                    }`}>{s.label}</span>
                  </div>
                  {i < STEPS.length - 1 && (
                    <div className={`flex-1 h-0.5 mx-1 mb-5 transition-colors ${done ? 'bg-green-400' : 'bg-gray-200'}`} />
                  )}
                </React.Fragment>
              );
            })}
          </div>
        </div>

        <div className="p-6">

          {/* ══════════════════════════════════════════════
              STEP 1-A: Completed action selector (from ReportDetail)
          ══════════════════════════════════════════════ */}
          {step === 1 && fromReport && (
            <div className="space-y-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-green-50 rounded flex items-center justify-center">
                  <CheckSquare className="w-5 h-5 text-green-600" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-gray-900">완료된 조치 선택</h2>
                  <p className="text-sm text-gray-500">보고서에 포함할 완료 조치를 선택하세요. 선택된 항목만 양식에 작성됩니다.</p>
                </div>
              </div>

              {/* Select all toggle */}
              <div className="flex items-center justify-between px-4 py-2.5 bg-gray-50 rounded border border-gray-200">
                <span className="text-sm text-gray-600 font-medium">
                  <span className="text-green-700 font-bold">{selectedIds.size}</span>/{completedActions!.length}개 선택됨
                </span>
                <button
                  onClick={() => {
                    if (selectedIds.size === completedActions!.length) {
                      setSelectedIds(new Set());
                    } else {
                      setSelectedIds(new Set(completedActions!.map((_, i) => i)));
                    }
                  }}
                  className="text-xs font-semibold text-[#1A2E44] hover:text-[#0F2233] transition-colors"
                >
                  {selectedIds.size === completedActions!.length ? '전체 해제' : '전체 선택'}
                </button>
              </div>

              {/* Action cards */}
              <div className="space-y-3">
                {completedActions!.map((action, i) => {
                  const selected = selectedIds.has(i);
                  return (
                    <button
                      key={`${action.title}-${i}`}
                      onClick={() => toggleId(i)}
                      className={`w-full text-left rounded border-2 p-4 transition-all ${
                        selected
                          ? 'border-[#1A2E44] bg-[#1A2E44]/5 shadow-sm'
                          : 'border-gray-200 bg-white hover:border-gray-300'
                      }`}
                    >
                      <div className="flex items-start gap-3">
                        {/* Checkbox */}
                        <div className={`mt-0.5 flex-shrink-0 w-5 h-5 rounded flex items-center justify-center transition-colors ${
                          selected ? 'bg-[#1A2E44] border-[#1A2E44]' : 'border-2 border-gray-300'
                        }`}>
                          {selected && <Check className="w-3 h-3 text-white" />}
                        </div>

                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap mb-1">
                            <span className="font-bold text-gray-900">{action.title}</span>
                            <span className={`text-xs px-2 py-0.5 rounded-full border font-medium ${RISK_PILL[action.risk]}`}>
                              {RISK_LABEL[action.risk]}
                            </span>
                            <span className="text-xs px-2 py-0.5 rounded-full bg-green-100 text-green-700 border border-green-200 font-medium">
                              조치 완료
                            </span>
                            <span className="ml-auto text-xs text-gray-400 font-mono">신뢰도 {action.confidence}%</span>
                          </div>
                          <p className="text-xs text-gray-600 mb-2">{action.description}</p>
                          <div className="grid grid-cols-1 sm:grid-cols-2 gap-1.5 text-xs">
                            <div className="flex items-start gap-1.5 text-gray-500">
                              <span className="font-semibold text-gray-700 flex-shrink-0">위치:</span>
                              <span>{action.location}</span>
                            </div>
                            <div className="flex items-start gap-1.5 text-gray-500">
                              <span className="font-semibold text-gray-700 flex-shrink-0">권장조치:</span>
                              <span>{action.recommendation}</span>
                            </div>
                            <div className="flex items-start gap-1.5 text-gray-500 sm:col-span-2">
                              <span className="font-semibold text-gray-700 flex-shrink-0">관련법규:</span>
                              <span>{action.regulation}</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </button>
                  );
                })}
              </div>

              {selectedIds.size === 0 && (
                <div className="flex items-center gap-2 px-4 py-3 bg-yellow-50 border border-yellow-200 rounded text-sm text-yellow-800">
                  <AlertTriangle className="w-4 h-4 flex-shrink-0" />
                  최소 1개 이상의 완료 조치를 선택해야 합니다.
                </div>
              )}

              <div className="flex justify-end pt-2">
                <button
                  disabled={selectedIds.size === 0}
                  onClick={() => setStep(2)}
                  className={`flex items-center gap-2 px-6 py-3 rounded font-bold transition-colors ${
                    selectedIds.size > 0
                      ? 'bg-[#1A2E44] text-white hover:bg-[#0F2233] shadow-md shadow-[#1A2E44]/30'
                      : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  }`}
                >
                  다음 단계 <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* ══════════════════════════════════════════════
              STEP 1-B: File upload (standalone nav)
          ══════════════════════════════════════════════ */}
          {step === 1 && !fromReport && (
            <div className="space-y-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-blue-50 rounded flex items-center justify-center">
                  <Upload className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-gray-900">양식 파일 넣기</h2>
                  <p className="text-sm text-gray-500">보고서 양식 파일을 업로드하거나 기본 제공 양식을 사용하세요.</p>
                </div>
              </div>

              <div
                className="border-2 border-dashed border-gray-300 rounded p-10 text-center hover:border-[#1A2E44] hover:bg-[#1A2E44]/5 transition-colors cursor-pointer group"
                onClick={() => fileRef.current?.click()}
              >
                <div className="w-14 h-14 bg-gray-100 rounded flex items-center justify-center mx-auto mb-3 group-hover:bg-[#1A2E44]/10 transition-colors">
                  <Upload className="w-7 h-7 text-gray-400 group-hover:text-[#1A2E44] transition-colors" />
                </div>
                <p className="font-semibold text-gray-700 mb-1 group-hover:text-gray-900">파일을 드래그하거나 클릭하여 업로드</p>
                <p className="text-sm text-gray-400">지원 형식: <span className="font-medium text-gray-600">DOCX · HWP · PDF · XLSX</span></p>
                <input ref={fileRef} type="file" className="hidden" multiple accept=".docx,.hwp,.pdf,.xlsx" onChange={handleFiles} />
              </div>

              {formFiles.length > 0 && (
                <div className="space-y-2">
                  <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">업로드된 파일</p>
                  {formFiles.map(f => (
                    <div key={f.id} className="flex items-center gap-3 px-4 py-3 bg-blue-50 border border-blue-200 rounded">
                      <FileText className="w-5 h-5 text-blue-600 flex-shrink-0" />
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-gray-800 truncate">{f.name}</p>
                        <p className="text-xs text-gray-500">{f.size}</p>
                      </div>
                      <button aria-label={`${f.name} 삭제`} onClick={() => setFormFiles(p => p.filter(x => x.id !== f.id))} className="text-gray-400 hover:text-red-500 transition-colors">
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                  ))}
                </div>
              )}

              {formFiles.length === 0 && (
                <div className="flex items-start gap-3 p-4 bg-gray-50 rounded border border-gray-200">
                  <FileText className="w-5 h-5 text-gray-400 flex-shrink-0 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-gray-700">파일 없이 진행해도 됩니다</p>
                    <p className="text-xs text-gray-500 mt-0.5">다음 단계에서 기본 제공 양식 중 선택할 수 있습니다.</p>
                  </div>
                </div>
              )}

              <div className="flex justify-end pt-2">
                <button
                  onClick={() => setStep(2)}
                  className="flex items-center gap-2 px-6 py-3 bg-[#1A2E44] text-white rounded font-bold hover:bg-[#0F2233] transition-colors shadow-md shadow-[#1A2E44]/30"
                >
                  다음 단계 <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* ══════════════════════════════════════════════
              STEP 2: Template selection
          ══════════════════════════════════════════════ */}
          {step === 2 && (
            <div className="space-y-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-purple-50 rounded flex items-center justify-center">
                  <FileText className="w-5 h-5 text-purple-600" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-gray-900">양식 선택</h2>
                  <p className="text-sm text-gray-500">생성할 보고서 양식을 선택하세요.</p>
                </div>
              </div>

              {formFiles.length > 0 && (
                <div>
                  <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">업로드한 양식</p>
                  {formFiles.map(f => (
                    <button
                      key={f.id}
                      onClick={() => setSelectedTemplate(f.id)}
                      className={`w-full flex items-center gap-3 p-4 rounded border-2 mb-2 text-left transition-colors ${
                        selectedTemplate === f.id ? 'border-[#1A2E44] bg-[#1A2E44]/5' : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <FileText className={`w-6 h-6 flex-shrink-0 ${selectedTemplate === f.id ? 'text-[#1A2E44]' : 'text-blue-500'}`} />
                      <div className="flex-1">
                        <p className="font-medium text-gray-800">{f.name}</p>
                        <p className="text-xs text-gray-500">업로드된 양식 · {f.size}</p>
                      </div>
                      {selectedTemplate === f.id && <CheckCircle2 className="w-5 h-5 text-[#1A2E44] flex-shrink-0" />}
                    </button>
                  ))}
                </div>
              )}

              <div>
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">기본 제공 양식</p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {TEMPLATES.map(t => (
                    <button
                      key={t.id}
                      onClick={() => setSelectedTemplate(t.id)}
                      className={`flex items-start gap-3 p-4 rounded border-2 text-left transition-colors ${
                        selectedTemplate === t.id ? 'border-[#1A2E44] bg-[#1A2E44]/5' : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <t.icon className={`w-6 h-6 flex-shrink-0 mt-0.5 ${selectedTemplate === t.id ? 'text-[#1A2E44]' : 'text-gray-400'}`} />
                      <div className="flex-1">
                        <p className="font-medium text-gray-800">{t.name}</p>
                        <p className="text-xs text-gray-500 mt-0.5">{t.desc}</p>
                      </div>
                      {selectedTemplate === t.id && <CheckCircle2 className="w-5 h-5 text-[#1A2E44] flex-shrink-0" />}
                    </button>
                  ))}
                </div>
              </div>

              <div className="flex justify-between pt-2">
                <button onClick={() => setStep(1)} className="flex items-center gap-1.5 px-4 py-2.5 border border-gray-200 text-gray-600 rounded text-sm hover:bg-gray-50 transition-colors">
                  <ChevronLeft className="w-4 h-4" /> 이전
                </button>
                <button
                  disabled={!selectedTemplate}
                  onClick={() => { setStep(3); startGenerate(); }}
                  className={`flex items-center gap-2 px-6 py-3 rounded font-bold transition-colors ${
                    selectedTemplate
                      ? 'bg-[#1A2E44] text-white hover:bg-[#0F2233] shadow-md shadow-[#1A2E44]/30'
                      : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  }`}
                >
                  {selectedTemplate ? 'AI 보고서 생성' : '양식을 선택하세요'}
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* ══════════════════════════════════════════════
              STEP 3: AI generation
          ══════════════════════════════════════════════ */}
          {step === 3 && (
            <div className="space-y-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-[#1A2E44]/10 rounded flex items-center justify-center">
                  <Sparkles className="w-5 h-5 text-[#1A2E44]" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-gray-900">AI 양식 파일 생성</h2>
                  <p className="text-sm text-gray-500">
                    「{templateName}」에 맞춰 AI가{fromReport ? ` 선택된 ${selectedActions.length}건의 완료 조치를 기반으로` : ''} 자동 작성 중입니다.
                  </p>
                </div>
              </div>

              <div className="bg-gradient-to-br from-[#1A2E44]/5 to-[#1A2E44]/5 rounded p-5 border border-[#1A2E44]/20">
                <div className="flex items-center gap-3 mb-3">
                  <Loader2 className="w-5 h-5 text-[#1A2E44] animate-spin flex-shrink-0" />
                  <p className="text-sm font-semibold text-gray-800 flex-1">AI 보고서 생성 중...</p>
                  <span className="text-lg font-bold text-[#1A2E44]">{genPct}%</span>
                </div>
                <ProgressBar pct={genPct} />
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
                {/* Task list */}
                <div className="space-y-2">
                  {[
                    { label: '현장 기본정보 삽입',                    threshold: 0  },
                    { label: fromReport ? '완료 조치 항목 파싱' : 'Before / After 사진 처리', threshold: 18 },
                    { label: 'AI 2차 판독 결과 통합',                  threshold: 35 },
                    { label: fromReport ? '조치 상세 내용 작성' : '위험요소 분류표 작성', threshold: 50 },
                    { label: '조치 완료율 및 개선사항 삽입',            threshold: 65 },
                    { label: '종합 의견 자동 생성',                    threshold: 80 },
                    { label: '서명란 및 서식 최종 적용',                threshold: 92 },
                  ].map(t => {
                    const done    = genPct > t.threshold + 14;
                    const running = !done && genPct >= t.threshold;
                    return (
                      <div key={t.label} className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-colors ${
                        done ? 'bg-green-50' : running ? 'bg-blue-50' : 'bg-gray-50'
                      }`}>
                        {done    ? <CheckCircle2 className="w-4 h-4 text-green-500 flex-shrink-0" />
                         : running ? <Loader2 className="w-4 h-4 text-blue-500 animate-spin flex-shrink-0" />
                         :           <Clock className="w-4 h-4 text-gray-300 flex-shrink-0" />}
                        <span className={done ? 'text-green-800 font-medium' : running ? 'text-blue-700 font-medium' : 'text-gray-400'}>
                          {t.label}
                        </span>
                        {done    && <span className="ml-auto text-xs text-green-500 font-semibold">완료</span>}
                        {running && <span className="ml-auto text-xs text-blue-500 animate-pulse">처리중...</span>}
                      </div>
                    );
                  })}
                </div>

                {/* Live preview */}
                <div className="border border-gray-200 rounded overflow-hidden">
                  <div className="bg-[#1A2E44] px-3 py-2 flex items-center gap-2">
                    <Eye className="w-3.5 h-3.5 text-white/70" />
                    <span className="text-white/90 text-xs font-medium">실시간 문서 미리보기</span>
                  </div>
                  <div className="p-4 space-y-3 max-h-80 overflow-y-auto bg-white text-xs">
                    <div className="text-center font-bold text-gray-800 border-b border-gray-200 pb-2">{templateName}</div>

                    {/* Site info */}
                    <div className={`transition-opacity duration-500 ${genPct >= 5 ? 'opacity-100' : 'opacity-20'}`}>
                      <table className="w-full border-collapse border border-gray-300">
                        <tbody>
                          <tr>
                            <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300 w-16 text-center">현장명</td>
                            <td className="px-2 py-1 border border-gray-300" colSpan={3}>
                              {genPct >= 5 ? '강남 복합시설 신축공사' : <span className="text-gray-200">▓▓▓▓▓▓▓▓</span>}
                            </td>
                          </tr>
                          <tr>
                            <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300 text-center">점검일</td>
                            <td className="px-2 py-1 border border-gray-300">
                              {genPct >= 8 ? '2026.08.09' : <span className="text-gray-200">▓▓▓▓▓</span>}
                            </td>
                            <td className="bg-gray-100 px-2 py-1 font-semibold border border-gray-300 text-center w-14">담당자</td>
                            <td className="px-2 py-1 border border-gray-300">
                              {genPct >= 10 ? '이조치' : <span className="text-gray-200">▓▓▓</span>}
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    {/* Selected actions preview */}
                    {fromReport && (
                      <div className={`transition-opacity duration-500 ${genPct >= 35 ? 'opacity-100' : 'opacity-20'}`}>
                        <p className="font-semibold text-gray-600 mb-1">■ 완료 조치 항목</p>
                        {genPct >= 40 ? (
                          <div className="space-y-1">
                            {selectedActions.map((a, i) => (
                              <div key={i} className="flex items-center gap-2 px-2 py-1 border border-gray-200 rounded">
                                <CheckCircle2 className="w-3 h-3 text-green-500 flex-shrink-0" />
                                <span className="flex-1 text-gray-700">{a.title}</span>
                                <span className={`text-xs px-1.5 py-0.5 rounded-full border font-medium ${RISK_PILL[a.risk]}`}>{RISK_LABEL[a.risk]}</span>
                              </div>
                            ))}
                          </div>
                        ) : <div className="space-y-1">{selectedActions.map((_, i) => <div key={i} className="h-5 bg-gray-100 rounded animate-pulse" />)}</div>}
                      </div>
                    )}

                    {/* Opinion */}
                    <div className={`transition-opacity duration-500 ${genPct >= 80 ? 'opacity-100' : 'opacity-20'}`}>
                      <p className="font-semibold text-gray-600 mb-1">■ 종합 의견</p>
                      {genPct >= 85 ? (
                        <div className="border border-gray-200 rounded p-2 text-gray-600 leading-relaxed">
                          {fromReport
                            ? `총 ${selectedActions.length}건의 완료 조치를 확인했습니다. ${selectedActions.map(a => a.title).join(', ')} 항목이 적합하게 처리되었습니다.`
                            : '현장 점검 결과 감지된 위험요소에 대한 조치가 완료되었습니다.'}
                        </div>
                      ) : <div className="h-10 bg-gray-100 rounded animate-pulse" />}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ══════════════════════════════════════════════
              STEP 4: Save & PDF
          ══════════════════════════════════════════════ */}
          {step === 4 && (
            <div className="space-y-5">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-green-50 rounded flex items-center justify-center">
                  <CheckCircle2 className="w-5 h-5 text-green-600" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-gray-900">저장하기 및 PDF 생성</h2>
                  <p className="text-sm text-gray-500">보고서를 저장하고 PDF로 출력하세요.</p>
                </div>
              </div>

              <div className="flex items-center gap-3 p-4 bg-green-50 border border-green-200 rounded">
                <CheckCircle2 className="w-6 h-6 text-green-600 flex-shrink-0" />
                <div>
                  <p className="font-semibold text-green-800">AI 보고서 생성 완료</p>
                  <p className="text-sm text-green-700">
                    「{templateName}」 기반
                    {fromReport ? ` — ${selectedActions.length}건 완료 조치 반영` : ''} 결과보고서가 자동 작성되었습니다.
                  </p>
                </div>
                <div className="ml-auto flex flex-wrap gap-2">
                  {saved   && <span className="text-xs bg-blue-100 text-blue-700 border border-blue-200 px-2 py-1 rounded-full font-semibold">저장 완료</span>}
                  {pdfDone && <span className="text-xs bg-purple-100 text-purple-700 border border-purple-200 px-2 py-1 rounded-full font-semibold">PDF 완료</span>}
                </div>
              </div>

              {/* Full document */}
              <div className="border border-gray-300 rounded overflow-hidden shadow-sm">
                <div className="bg-gray-100 border-b border-gray-300 px-4 py-2.5 flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <FileText className="w-4 h-4 text-gray-500" />
                    <span className="text-sm font-medium text-gray-700">보고서 미리보기</span>
                  </div>
                  <span className="text-xs text-gray-400">강남복합시설_{templateName}_20260809.pdf</span>
                </div>
                <div className="bg-white p-6 space-y-5 text-sm max-h-[680px] overflow-y-auto">
                  {/* Header */}
                  <div className="text-center space-y-1 pb-4 border-b-2 border-gray-800">
                    <div className="flex items-center justify-between text-xs text-gray-400 mb-2">
                      <span>문서번호: SM-2026-0809-001</span>
                      <span className="flex items-center gap-1"><Sparkles className="w-3 h-3 text-purple-500" /> AI 자동생성</span>
                    </div>
                    <h3 className="text-xl font-bold text-gray-900">{templateName}</h3>
                    <p className="text-xs text-gray-500">건설현장 안전관리 플랫폼 연결고리 · 2026년 08월 09일</p>
                  </div>

                  {/* Site info */}
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
                        {fromReport && (
                          <tr>
                            <td className="bg-gray-100 px-3 py-2 font-semibold border border-gray-400 text-center">완료 조치 수</td>
                            <td className="px-3 py-2 border border-gray-400" colSpan={3}>
                              <span className="font-bold text-green-700">{selectedActions.length}건</span> 완료 조치 포함
                            </td>
                          </tr>
                        )}
                      </tbody>
                    </table>
                  </div>

                  {/* Completed actions table (only when from report) */}
                  {fromReport && selectedActions.length > 0 && (
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-green-600 rounded-full inline-block" /> 1. 완료된 조치 항목 목록
                      </p>
                      <table className="w-full border-collapse border border-gray-400 text-xs">
                        <thead>
                          <tr className="bg-gray-100">
                            <th className="px-2 py-2 border border-gray-400 text-center w-8">No.</th>
                            <th className="px-2 py-2 border border-gray-400 text-left">항목명</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-16">위험등급</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-16">신뢰도</th>
                            <th className="px-2 py-2 border border-gray-400 text-center w-20">조치 상태</th>
                          </tr>
                        </thead>
                        <tbody>
                          {selectedActions.map((a, i) => (
                            <tr key={i}>
                              <td className="px-2 py-2 border border-gray-400 text-center">{i + 1}</td>
                              <td className="px-2 py-2 border border-gray-400 font-medium">{a.title}</td>
                              <td className="px-2 py-2 border border-gray-400 text-center">
                                <span className={`px-1.5 py-0.5 rounded-full text-xs font-medium border ${RISK_PILL[a.risk]}`}>{RISK_LABEL[a.risk]}</span>
                              </td>
                              <td className="px-2 py-2 border border-gray-400 text-center font-mono">{a.confidence}%</td>
                              <td className="px-2 py-2 border border-gray-400 text-center">
                                <span className="px-1.5 py-0.5 rounded-full bg-green-100 text-green-700 border border-green-200 font-medium">조치 완료</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}

                  {/* Action details */}
                  {fromReport && selectedActions.length > 0 && (
                    <div>
                      <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                        <span className="w-1 h-3.5 bg-blue-600 rounded-full inline-block" /> 2. 조치 상세 내용
                      </p>
                      {selectedActions.map((a, i) => (
                        <div key={i} className="border border-gray-300 rounded mb-3 overflow-hidden">
                          <div className="bg-gray-100 px-3 py-1.5 flex items-center gap-2 border-b border-gray-300">
                            <CheckCircle2 className="w-3.5 h-3.5 text-green-600" />
                            <span className="font-semibold text-gray-800">{i + 1}. {a.title}</span>
                            <span className={`ml-auto text-xs px-1.5 py-0.5 rounded-full border ${RISK_PILL[a.risk]}`}>{RISK_LABEL[a.risk]}</span>
                          </div>
                          <div className="px-3 py-2 space-y-1.5 text-xs">
                            <div className="grid grid-cols-3 gap-x-4">
                              <div><span className="font-semibold text-gray-600">위치:</span> <span className="text-gray-700">{a.location}</span></div>
                              <div><span className="font-semibold text-gray-600">신뢰도:</span> <span className="font-mono text-gray-700">{a.confidence}%</span></div>
                              <div><span className="font-semibold text-gray-600">관련법규:</span> <span className="text-gray-700">{a.regulation}</span></div>
                            </div>
                            <div><span className="font-semibold text-gray-600">조치 내용:</span> <span className="text-gray-700">{a.description}</span></div>
                            <div><span className="font-semibold text-gray-600">권장 후속조치:</span> <span className="text-gray-700">{a.recommendation}</span></div>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}

                  {/* Photos */}
                  <div>
                    <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                      <span className="w-1 h-3.5 bg-orange-500 rounded-full inline-block" /> {fromReport ? '3' : '1'}. 첨부 사진 (Before / After)
                    </p>
                    <div className="grid grid-cols-2 gap-4 border border-gray-300 rounded p-3 bg-gray-50">
                      {[
                        { label: 'Before', src: DEMO_BEFORE },
                        { label: 'After',  src: DEMO_AFTER  },
                      ].map(p => (
                        <div key={p.label}>
                          <p className="text-xs font-semibold mb-1 text-center border-b pb-1">{p.label}</p>
                          <img src={p.src} alt={p.label} className="w-full rounded object-cover" style={{ height: 100 }} />
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Opinion */}
                  <div>
                    <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                      <span className="w-1 h-3.5 bg-gray-700 rounded-full inline-block" /> {fromReport ? '4' : '2'}. 종합 의견 (AI 자동 생성)
                    </p>
                    <div className="border border-gray-300 rounded p-3 bg-gray-50 text-xs text-gray-700 leading-5">
                      {fromReport
                        ? `금번 강남 복합시설 신축공사 현장 AI 안전점검 결과, 총 ${selectedActions.length}건의 완료 조치를 확인하였습니다. ${selectedActions.map(a => a.title).join(', ')} 항목 모두 조치가 적합하게 완료되었습니다. 지속적인 안전 관리 및 정기 점검을 권장합니다.`
                        : '현장 점검 결과 감지된 위험요소에 대한 조치가 완료되었습니다. 지속적인 안전 관리 및 정기 점검을 권장합니다.'}
                    </div>
                  </div>

                  {/* Signature */}
                  <div>
                    <p className="text-xs font-bold text-gray-700 mb-2 flex items-center gap-1">
                      <span className="w-1 h-3.5 bg-gray-500 rounded-full inline-block" /> {fromReport ? '5' : '3'}. 담당자 확인란
                    </p>
                    <table className="w-full border-collapse border border-gray-400 text-xs">
                      <thead><tr className="bg-gray-100">
                        <th className="px-3 py-2 border border-gray-400 text-center">작 성 자</th>
                        <th className="px-3 py-2 border border-gray-400 text-center">검 토 자</th>
                        <th className="px-3 py-2 border border-gray-400 text-center">승 인 자</th>
                      </tr></thead>
                      <tbody>
                        <tr>
                          <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-xl">(인)</td>
                          <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-xl">(인)</td>
                          <td className="px-3 py-6 border border-gray-400 text-center text-gray-300 text-xl">(인)</td>
                        </tr>
                        <tr>
                          <td className="px-3 py-2 border border-gray-400 text-center text-gray-600 font-medium">이조치</td>
                          <td className="px-3 py-2 border border-gray-400 text-center text-gray-400"></td>
                          <td className="px-3 py-2 border border-gray-400 text-center text-gray-400"></td>
                        </tr>
                      </tbody>
                    </table>
                    <p className="text-right text-xs text-gray-400 mt-2">연결고리 AI 자동생성 보고서 · 2026.08.09</p>
                  </div>
                </div>
              </div>

              {/* Action buttons */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <button
                  onClick={() => { setSaved(true); toast.success('보고서가 저장되었습니다.'); }}
                  className={`flex items-center justify-center gap-2 px-4 py-3 rounded font-bold text-sm transition-colors ${
                    saved ? 'bg-green-100 text-green-700 border border-green-300' : 'bg-[#1A2E44] text-white hover:bg-[#254d7a] shadow-md'
                  }`}
                >
                  {saved ? <CheckCircle2 className="w-4 h-4" /> : <Save className="w-4 h-4" />}
                  {saved ? '저장 완료' : '보고서 저장'}
                </button>
                <button
                  onClick={() => { setPdfDone(true); toast.success('PDF가 생성되었습니다.'); }}
                  className={`flex items-center justify-center gap-2 px-4 py-3 rounded font-bold text-sm transition-colors ${
                    pdfDone ? 'bg-green-100 text-green-700 border border-green-300' : 'bg-[#1A2E44] text-white hover:bg-[#0F2233] shadow-md shadow-[#1A2E44]/30'
                  }`}
                >
                  {pdfDone ? <CheckCircle2 className="w-4 h-4" /> : <Printer className="w-4 h-4" />}
                  {pdfDone ? 'PDF 완료' : 'PDF 생성'}
                </button>
                <button
                  onClick={() => toast.success('다운로드가 시작됩니다.')}
                  className="flex items-center justify-center gap-2 px-4 py-3 border border-gray-200 text-gray-700 rounded font-bold text-sm hover:bg-gray-50 transition-colors"
                >
                  <Download className="w-4 h-4" /> 다운로드
                </button>
              </div>

              {(saved || pdfDone) && (
                <div className="flex items-center gap-2 text-xs text-gray-500 bg-gray-50 border border-gray-200 rounded-lg px-4 py-2.5">
                  <FileText className="w-4 h-4 text-gray-400 flex-shrink-0" />
                  <span><span className="font-medium">저장 위치:</span> /reports/강남복합시설_{templateName}_20260809.pdf</span>
                </div>
              )}

              <div className="flex justify-between pt-2">
                <button
                  onClick={resetAll}
                  className="flex items-center gap-1.5 px-4 py-2.5 border border-gray-200 text-gray-600 rounded text-sm hover:bg-gray-50 transition-colors"
                >
                  <RefreshCw className="w-4 h-4" /> 새 보고서 생성
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
