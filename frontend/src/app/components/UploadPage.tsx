import { useState, useRef, useEffect } from 'react';
import Layout from './Layout';
import {
  MapPin, Upload, MessageSquare, CheckCircle2,
  X, Loader2, AlertTriangle, Building2,
  Plus, Trash2, ClipboardList,
  Calendar, User, ChevronLeft,
} from 'lucide-react';
import { toast } from 'sonner';
import type { AiAction } from '../App';

interface UploadPageProps {
  onNavigate: (page: string) => void;
  onCreateActions?: (actions: AiAction[], images?: string[]) => void;
}

interface UploadedFile {
  name: string;
  size: string;
  preview: string;
}

const SITES = [
  { id: 's1', name: '3동 건물 외벽',  zone: 'A구역', risk: 'high' },
  { id: 's2', name: '5동 옥상',        zone: 'B구역', risk: 'medium' },
  { id: 's3', name: '2동 전기실',      zone: 'C구역', risk: 'high' },
  { id: 's4', name: '4동 1층 로비',    zone: 'A구역', risk: 'low' },
  { id: 's5', name: '지하 주차장',     zone: 'D구역', risk: 'medium' },
  { id: 's6', name: '1동 출입구',      zone: 'A구역', risk: 'low' },
];

const QUESTION_PRESETS = [
  '안전난간이 제대로 설치되어 있나요?',
  '작업자들이 안전모를 착용하고 있나요?',
  '전기 배선이 안전하게 처리되어 있나요?',
  '소화기가 지정된 위치에 배치되어 있나요?',
  '비상구 및 대피로가 확보되어 있나요?',
  '추락 방지 장치가 적절히 설치되어 있나요?',
];

const STEPS = [
  { number: 1, label: '위치 선택' },
  { number: 2, label: '이미지 업로드' },
  { number: 3, label: '검사 항목' },
  { number: 4, label: '분석 실행' },
  { number: 5, label: '조치 등록' },
];

const CATEGORIES = ['추락 위험', '전기 위험', '화재 위험', '협착 위험', '붕괴 위험', '화학물질', '기타'];
const ASSIGNEES  = ['김현장', '박안전', '이관리'];
const RISK_OPTIONS = [
  { value: 'high',   label: '높음', color: '#991B1B', bg: '#FEF2F2', border: '#FCA5A5' },
  { value: 'medium', label: '중간', color: '#B45309', bg: '#FFFBEB', border: '#FCD34D' },
  { value: 'low',    label: '낮음', color: '#166534', bg: '#F0FDF4', border: '#86EFAC' },
];
const REGULATION_REFS = [
  '산업안전보건법 제38조 (추락 위험 방지)',
  '산업안전보건법 제24조 (보호구 착용)',
  '전기사업법 제67조 (전기설비 기술기준)',
  '소방시설법 제10조 (소화기 배치)',
  '건설기술진흥법 제62조',
];

const RISK_LABEL: Record<string, string> = { high: '높음', medium: '중간', low: '낮음' };
const RISK_COLOR: Record<string, string> = { high: '#991B1B', medium: '#B45309', low: '#166534' };
const RISK_BG:    Record<string, string> = { high: '#FEF2F2', medium: '#FFFBEB', low: '#F0FDF4' };

const UNSPLASH_BY_RISK: Record<string, string> = {
  high:   'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&h=240&fit=crop&auto=format',
  medium: 'https://images.unsplash.com/photo-1621294465978-6b4198a5f2f7?w=400&h=240&fit=crop&auto=format',
  low:    'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=400&h=240&fit=crop&auto=format',
};

interface RegForm {
  title: string; category: string; risk: 'high' | 'medium' | 'low' | '';
  assignee: string; discoveredDate: string; deadline: string;
  description: string; regulation: string; recommendation: string; note: string;
}

export default function UploadPage({ onNavigate, onCreateActions }: UploadPageProps) {
  const [step, setStep] = useState(1);
  const [selectedSite, setSelectedSite] = useState<typeof SITES[0] | null>(null);
  const [files, setFiles] = useState<UploadedFile[]>([]);
  const [isDragging, setIsDragging] = useState(false);
  const [question, setQuestion] = useState('');
  const [analyzing, setAnalyzing] = useState(false);
  const [progress, setProgress] = useState(0);
  const [progressLabel, setProgressLabel] = useState('');
  const [results, setResults] = useState<{ title: string; risk: string; desc: string }[]>([]);
  const [aiScanVisible, setAiScanVisible] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const scanTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const [regForm, setRegForm] = useState<RegForm>({
    title: '', category: '', risk: '', assignee: '',
    discoveredDate: new Date().toISOString().slice(0, 10),
    deadline: '', description: '', regulation: '', recommendation: '', note: '',
  });
  const [regErrors, setRegErrors] = useState<Partial<Record<keyof RegForm, string>>>({});

  const setReg = (key: keyof RegForm, value: string) => {
    setRegForm(f => ({ ...f, [key]: value }));
    setRegErrors(e => ({ ...e, [key]: '' }));
  };

  useEffect(() => () => { if (scanTimerRef.current) clearTimeout(scanTimerRef.current); }, []);

  useEffect(() => {
    if (results.length === 0) return;
    const topResult = results[0];
    const highestRisk = results.find(r => r.risk === 'high') ?? results[0];
    setRegForm(f => ({
      ...f,
      title: topResult.title,
      risk: highestRisk.risk as 'high' | 'medium' | 'low',
      description: results.map((r, i) => `${i + 1}. ${r.title}: ${r.desc}`).join('\n'),
    }));
  }, [results]);

  const canNext =
    (step === 1 && selectedSite !== null) ||
    (step === 2 && files.length > 0) ||
    (step === 3 && question.trim().length > 0) ||
    step === 4;

  const processFiles = (raw: FileList | File[]) => {
    const imgs = Array.from(raw).filter(f => f.type.startsWith('image/'));
    if (!imgs.length) { toast.error('이미지 파일만 업로드 가능합니다'); return; }
    const next: UploadedFile[] = imgs.map(f => ({
      name: f.name, size: `${(f.size / 1024 / 1024).toFixed(2)} MB`,
      preview: URL.createObjectURL(f),
    }));
    setFiles(prev => [...prev, ...next]);
    toast.success(`${imgs.length}개 파일 업로드됨`);
  };

  const removeFile = (i: number) => {
    setFiles(prev => { URL.revokeObjectURL(prev[i].preview); return prev.filter((_, idx) => idx !== i); });
  };

  const analysisSteps = [
    '이미지 전처리 중...', '객체 감지 모델 실행 중...',
    '질문 기반 위험 요소 분석 중...', '법규 데이터베이스 대조 중...', '리포트 생성 중...',
  ];

  useEffect(() => {
    if (!analyzing || progress >= 100) return;
    const idx = Math.min(Math.floor((progress / 100) * analysisSteps.length), analysisSteps.length - 1);
    setProgressLabel(analysisSteps[idx]);
    const t = setTimeout(() => {
      setProgress(p => {
        const next = p + Math.random() * 14 + 4;
        if (next >= 100) {
          setResults([
            { title: '안전난간 미설치 감지', risk: 'high', desc: '2층 작업대 가장자리에 안전난간이 설치되지 않아 추락 위험이 높습니다.' },
            { title: '임시 배선 노출',       risk: 'high', desc: '작업장 바닥에 전선이 노출되어 감전 및 화재 위험이 있습니다.' },
            { title: '안전모 미착용 의심',   risk: 'medium', desc: '일부 작업자의 안전모 착용 여부가 불명확합니다.' },
          ]);
          setAnalyzing(false); setAiScanVisible(true);
          scanTimerRef.current = setTimeout(() => { setAiScanVisible(false); setStep(5); }, 2800);
          return 100;
        }
        return next;
      });
    }, 300);
    return () => clearTimeout(t);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [analyzing, progress]);

  const startAnalysis = () => {
    setAnalyzing(true); setProgress(0); setResults([]);
    toast.info('위험요소 분석을 시작합니다.');
  };

  const validateReg = () => {
    const e: Partial<Record<keyof RegForm, string>> = {};
    if (!regForm.title.trim())       e.title       = '제목을 입력하세요';
    if (!regForm.category)           e.category    = '위험 분류를 선택하세요';
    if (!regForm.risk)               e.risk        = '위험도를 선택하세요';
    if (!regForm.assignee)           e.assignee    = '담당자를 지정하세요';
    if (!regForm.deadline)           e.deadline    = '조치 기한을 설정하세요';
    if (!regForm.description.trim()) e.description = '상세 내용을 입력하세요';
    setRegErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleRegSubmit = () => {
    if (!validateReg()) return;
    if (onCreateActions) {
      const nextId = Date.now();
      const actions: AiAction[] = results.length > 0
        ? results.map((r, i) => ({
            id: nextId + i, title: i === 0 ? regForm.title : r.title,
            risk: r.risk as 'high' | 'medium' | 'low', desc: r.desc,
            site: selectedSite?.name ?? '현장 미지정',
            image: files[0]?.preview ?? UNSPLASH_BY_RISK[r.risk],
          }))
        : [{ id: nextId, title: regForm.title, risk: (regForm.risk || 'medium') as 'high' | 'medium' | 'low',
            desc: regForm.description, site: selectedSite?.name ?? '현장 미지정',
            image: files[0]?.preview ?? UNSPLASH_BY_RISK[regForm.risk || 'medium'] }];
      toast.success(`${actions.length}건이 조치관리에 등록되었습니다.`);
      onCreateActions(actions, files.map(f => f.preview));
    } else {
      toast.success('조치 사항이 등록되었습니다.');
      onNavigate('actions');
    }
  };

  const inputStyle = (err?: string) => ({
    width: '100%', padding: '8px 12px', fontSize: 13,
    border: `1px solid ${err ? '#FCA5A5' : '#E5E7EB'}`, borderRadius: 4,
    outline: 'none', background: '#F9FAFB', color: '#0F172A', boxSizing: 'border-box' as const,
  });

  return (
    <Layout currentPath="upload" onNavigate={onNavigate}>
      <div style={{ maxWidth: 720, margin: '0 auto' }}>
        {/* Page header */}
        <div className="flex items-center justify-between mb-5">
          <div>
            <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>사진 분석</p>
            <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1, marginBottom: 6 }}>위험요소 분석</h1>
            <p style={{ fontSize: 12, color: '#6B7280' }}>현장 사진을 업로드하여 위험요소를 분석하고 조치를 등록합니다</p>
          </div>
        </div>

        {/* Step indicator */}
        <div
          style={{
            background: 'white', border: '1px solid #E5E7EB', borderRadius: 4,
            padding: '14px 24px', marginBottom: 4, display: 'flex', alignItems: 'center',
          }}
        >
          {STEPS.map((s, i) => {
            const done = step > s.number;
            const active = step === s.number;
            return (
              <div key={s.number} className="flex items-center flex-1 last:flex-none" style={{ minWidth: 0 }}>
                <div className="flex flex-col items-center gap-1" style={{ flexShrink: 0 }}>
                  <div
                    style={{
                      width: 24, height: 24, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center',
                      background: done ? '#166534' : active ? '#1A2E44' : '#F3F4F6',
                      color: done || active ? 'white' : '#9CA3AF',
                      fontSize: 11, fontWeight: 600,
                    }}
                  >
                    {done ? <CheckCircle2 size={13} /> : s.number}
                  </div>
                  <span style={{ fontSize: 10, color: active ? '#0F172A' : done ? '#166534' : '#9CA3AF', fontWeight: active ? 600 : 400, whiteSpace: 'nowrap' }}>
                    {s.label}
                  </span>
                </div>
                {i < STEPS.length - 1 && (
                  <div style={{ flex: 1, height: 1, margin: '0 8px', marginBottom: 14, background: done ? '#86EFAC' : '#E5E7EB' }} />
                )}
              </div>
            );
          })}
        </div>

        {/* Step content */}
        <div
          style={{
            background: 'white', border: '1px solid #E5E7EB',
            borderRadius: 4, borderTopLeftRadius: 0, borderTopRightRadius: 0,
            borderTop: 'none', padding: 24, minHeight: 400,
          }}
        >
          {/* ── STEP 1: 위치 선택 ── */}
          {step === 1 && (
            <div>
              <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>검사 위치 선택</h2>
              <p style={{ fontSize: 12, color: '#9CA3AF', marginBottom: 16 }}>분석할 현장 구역을 선택하세요</p>
              <div className="grid grid-cols-2 gap-2">
                {SITES.map(site => {
                  const sel = selectedSite?.id === site.id;
                  return (
                    <button
                      key={site.id}
                      onClick={() => setSelectedSite(site)}
                      style={{
                        display: 'flex', alignItems: 'center', gap: 10,
                        padding: '12px 14px', textAlign: 'left',
                        border: `1px solid ${sel ? '#1A2E44' : '#E5E7EB'}`,
                        borderRadius: 4, background: sel ? '#F0F4F8' : 'white',
                        cursor: 'pointer', transition: 'border-color 0.1s',
                      }}
                    >
                      <Building2 size={15} color={sel ? '#1A2E44' : '#9CA3AF'} style={{ flexShrink: 0 }} />
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <p style={{ fontSize: 13, fontWeight: 500, color: '#0F172A' }}>{site.name}</p>
                        <p style={{ fontSize: 11, color: '#9CA3AF' }}>{site.zone}</p>
                      </div>
                      <span style={{
                        fontSize: 10, fontWeight: 600, padding: '1px 6px', borderRadius: 3,
                        background: RISK_BG[site.risk], color: RISK_COLOR[site.risk],
                      }}>
                        {RISK_LABEL[site.risk]}
                      </span>
                      {sel && <CheckCircle2 size={14} color="#166534" />}
                    </button>
                  );
                })}
              </div>
              {selectedSite && (
                <div
                  style={{
                    marginTop: 14, padding: '10px 14px', fontSize: 12,
                    background: '#F0F4F8', border: '1px solid #CBD5E1',
                    borderRadius: 4, display: 'flex', alignItems: 'center', gap: 8,
                  }}
                >
                  <MapPin size={13} color="#1A2E44" />
                  <span style={{ color: '#374151' }}>선택된 위치: <strong>{selectedSite.name}</strong> ({selectedSite.zone})</span>
                </div>
              )}
            </div>
          )}

          {/* ── STEP 2: 이미지 업로드 ── */}
          {step === 2 && (
            <div>
              <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>현장 이미지 업로드</h2>
              <p style={{ fontSize: 12, color: '#9CA3AF', marginBottom: 16 }}>
                <strong style={{ color: '#374151' }}>{selectedSite?.name}</strong> 구역의 현장 사진을 업로드하세요
              </p>
              <div
                onClick={() => fileInputRef.current?.click()}
                onDragOver={e => { e.preventDefault(); setIsDragging(true); }}
                onDragEnter={e => { e.preventDefault(); setIsDragging(true); }}
                onDragLeave={() => setIsDragging(false)}
                onDrop={e => { e.preventDefault(); setIsDragging(false); processFiles(e.dataTransfer.files); }}
                style={{
                  border: `1px dashed ${isDragging ? '#1A2E44' : '#D1D5DB'}`,
                  borderRadius: 4, padding: '32px 24px', textAlign: 'center',
                  cursor: 'pointer', marginBottom: 16, background: isDragging ? '#F0F4F8' : '#FAFAFA',
                  transition: 'all 0.15s',
                }}
              >
                <input ref={fileInputRef} type="file" multiple accept="image/*" className="hidden"
                  onChange={e => e.target.files && processFiles(e.target.files)} />
                <Upload size={20} color="#9CA3AF" style={{ margin: '0 auto 8px' }} />
                <p style={{ fontSize: 13, fontWeight: 500, color: '#374151' }}>
                  {isDragging ? '여기에 놓아주세요' : '파일을 드래그하거나 클릭하여 선택'}
                </p>
                <p style={{ fontSize: 11, color: '#9CA3AF', marginTop: 4 }}>JPG, PNG, HEIC · 최대 10MB</p>
              </div>

              {files.length > 0 && (
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <p style={{ fontSize: 12, color: '#374151', fontWeight: 500 }}>{files.length}개 선택됨</p>
                    <button onClick={() => setFiles([])} style={{ fontSize: 12, color: '#991B1B', background: 'none', border: 'none', cursor: 'pointer' }}>
                      전체 삭제
                    </button>
                  </div>
                  <div className="grid grid-cols-4 gap-2">
                    {files.map((f, i) => (
                      <div key={`${f.name}-${i}`} className="relative group" style={{ borderRadius: 3, overflow: 'hidden', border: '1px solid #E5E7EB', aspectRatio: '1', background: '#F3F4F6' }}>
                        <img src={f.preview} alt={f.name} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                        <button aria-label={`${f.name} 삭제`} onClick={() => removeFile(i)}
                          style={{ position: 'absolute', top: 4, right: 4, background: 'rgba(0,0,0,0.55)', color: 'white', border: 'none', borderRadius: '50%', width: 18, height: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' }}>
                          <X size={10} />
                        </button>
                      </div>
                    ))}
                    <button onClick={() => fileInputRef.current?.click()}
                      style={{ aspectRatio: '1', borderRadius: 3, border: '1px dashed #D1D5DB', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#FAFAFA', cursor: 'pointer' }}>
                      <Plus size={14} color="#9CA3AF" />
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* ── STEP 3: 검사 항목 ── */}
          {step === 3 && (
            <div>
              <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>검사 항목 입력</h2>
              <p style={{ fontSize: 12, color: '#9CA3AF', marginBottom: 16 }}>무엇을 확인할지 입력하거나 아래에서 선택하세요</p>
              <textarea
                value={question}
                onChange={e => setQuestion(e.target.value)}
                placeholder="예: 이 사진에서 안전난간이 제대로 설치되어 있나요? 추락 위험 요소가 있는지 확인해주세요."
                rows={4}
                style={{ ...inputStyle(), resize: 'none', marginBottom: 14, padding: '10px 12px' }}
              />
              <p style={{ fontSize: 11, color: '#6B7280', marginBottom: 8 }}>자주 쓰는 항목</p>
              <div className="flex flex-wrap gap-2">
                {QUESTION_PRESETS.map((q, i) => (
                  <button
                    key={i}
                    onClick={() => setQuestion(q)}
                    style={{
                      padding: '5px 12px', fontSize: 12, borderRadius: 3, cursor: 'pointer',
                      border: `1px solid ${question === q ? '#1A2E44' : '#E5E7EB'}`,
                      background: question === q ? '#1A2E44' : 'white',
                      color: question === q ? 'white' : '#6B7280',
                      transition: 'all 0.1s',
                    }}
                  >
                    {q}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* ── STEP 4: 분석 실행 ── */}
          {step === 4 && (
            <div>
              <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>분석 실행</h2>
              <p style={{ fontSize: 12, color: '#9CA3AF', marginBottom: 16 }}>입력 내용을 확인하고 위험요소 분석을 시작하세요</p>

              {!analyzing && results.length === 0 && (
                <div style={{ marginBottom: 20 }}>
                  {[
                    { label: '위치', value: `${selectedSite?.name} (${selectedSite?.zone})`, onClick: () => setStep(1) },
                    { label: '업로드 사진', value: `${files.length}장`, onClick: () => setStep(2) },
                    { label: '검사 항목', value: question, onClick: () => setStep(3) },
                  ].map((row, i) => (
                    <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '9px 14px', borderBottom: '1px solid #F9FAFB', background: '#FAFAFA' }}>
                      <span style={{ fontSize: 11, color: '#9CA3AF', width: 80 }}>{row.label}</span>
                      <span style={{ flex: 1, fontSize: 13, color: '#374151', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{row.value}</span>
                      <button onClick={row.onClick} style={{ fontSize: 11, color: '#1A2E44', background: 'none', border: 'none', cursor: 'pointer' }}>수정</button>
                    </div>
                  ))}
                </div>
              )}

              {analyzing && (
                <div style={{ background: '#F9FAFB', border: '1px solid #E5E7EB', borderRadius: 4, padding: 16, marginBottom: 16 }}>
                  <div className="flex items-center gap-2 mb-2">
                    <Loader2 size={14} color="#1A2E44" className="animate-spin" style={{ flexShrink: 0 }} />
                    <span style={{ fontSize: 12, color: '#374151', flex: 1 }}>{progressLabel}</span>
                    <span style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>{Math.round(progress)}%</span>
                  </div>
                  <div style={{ width: '100%', height: 4, background: '#E5E7EB', borderRadius: 2, overflow: 'hidden' }}>
                    <div style={{ width: `${progress}%`, height: '100%', background: '#1A2E44', transition: 'width 0.3s' }} />
                  </div>
                </div>
              )}

              {aiScanVisible && (
                <div>
                  <div className="flex items-center gap-2 mb-3">
                    <CheckCircle2 size={14} color="#166534" />
                    <p style={{ fontSize: 13, fontWeight: 600, color: '#166534' }}>분석 완료 — {results.length}건 위험요소 감지됨</p>
                  </div>
                  <div style={{ position: 'relative', borderRadius: 4, overflow: 'hidden', border: '1px solid #E5E7EB', marginBottom: 12 }}>
                    <img
                      src={files[0]?.preview ?? 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&h=280&fit=crop&auto=format'}
                      alt="분석 결과" style={{ width: '100%', maxHeight: 200, objectFit: 'cover', display: 'block' }}
                    />
                    <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', pointerEvents: 'none' }} viewBox="0 0 100 100" preserveAspectRatio="none">
                      {[
                        { x: 4,  y: 8,  w: 28, h: 44, label: '안전난간', color: '#ef4444' },
                        { x: 34, y: 58, w: 28, h: 22, label: '배선 노출', color: '#ef4444' },
                        { x: 66, y: 12, w: 26, h: 38, label: '안전모',   color: '#f59e0b' },
                      ].map((b, i) => (
                        <g key={i}>
                          <rect x={b.x} y={b.y} width={b.w} height={b.h} fill={`${b.color}20`} stroke={b.color} strokeWidth="0.6" />
                          <rect x={b.x} y={b.y - 4.5} width={20} height={4.5} fill={b.color} />
                          <text x={b.x + 0.8} y={b.y - 0.3} fontSize="2.6" fill="white" fontFamily="sans-serif">{b.label}</text>
                        </g>
                      ))}
                    </svg>
                    <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, background: 'rgba(0,0,0,0.6)', padding: '6px 12px', display: 'flex', alignItems: 'center', gap: 6 }}>
                      <Loader2 size={12} color="white" className="animate-spin" />
                      <p style={{ fontSize: 11, color: 'white' }}>결과 화면으로 이동 중...</p>
                    </div>
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                    {results.map((r, i) => (
                      <div key={i} style={{
                        display: 'flex', alignItems: 'center', gap: 10, padding: '8px 12px',
                        background: r.risk === 'high' ? '#FEF2F2' : '#FFFBEB',
                        border: `1px solid ${r.risk === 'high' ? '#FECACA' : '#FCD34D'}`,
                        borderRadius: 4,
                      }}>
                        <AlertTriangle size={13} color={r.risk === 'high' ? '#991B1B' : '#B45309'} style={{ flexShrink: 0 }} />
                        <span style={{ flex: 1, fontSize: 12, fontWeight: 500, color: '#0F172A' }}>{r.title}</span>
                        <span style={{ fontSize: 10, fontWeight: 600, padding: '1px 7px', borderRadius: 3, background: RISK_BG[r.risk], color: RISK_COLOR[r.risk] }}>
                          {RISK_LABEL[r.risk]}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {!analyzing && !aiScanVisible && results.length === 0 && (
                <button
                  onClick={startAnalysis}
                  style={{
                    width: '100%', padding: '10px 0', background: '#1A2E44', color: 'white',
                    border: 'none', borderRadius: 4, fontSize: 13, fontWeight: 600, cursor: 'pointer',
                    display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
                    marginTop: 8,
                  }}
                >
                  위험요소 분석 시작
                </button>
              )}
            </div>
          )}

          {/* ── STEP 5: 조치 등록 ── */}
          {step === 5 && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div>
                <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>조치 등록</h2>
                <p style={{ fontSize: 12, color: '#9CA3AF' }}>AI 분석 결과를 바탕으로 조치 사항을 등록합니다</p>
              </div>

              {results.length > 0 && (
                <div style={{ padding: '10px 14px', background: '#F9FAFB', border: '1px solid #E5E7EB', borderRadius: 4, display: 'flex', flexWrap: 'wrap', gap: 6, alignItems: 'center' }}>
                  <span style={{ fontSize: 11, color: '#6B7280' }}>감지 항목:</span>
                  {results.map((r, i) => (
                    <span key={i} style={{ fontSize: 10, fontWeight: 600, padding: '1px 7px', borderRadius: 3, background: RISK_BG[r.risk], color: RISK_COLOR[r.risk] }}>
                      {r.title}
                    </span>
                  ))}
                </div>
              )}

              {/* 제목 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>제목 <span style={{ color: '#991B1B' }}>*</span></label>
                <input type="text" value={regForm.title} onChange={e => setReg('title', e.target.value)}
                  placeholder="조치 사항을 간략히 입력하세요" style={inputStyle(regErrors.title)} />
                {regErrors.title && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.title}</p>}
              </div>

              {/* 위험 분류 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위험 분류 <span style={{ color: '#991B1B' }}>*</span></label>
                <div className="flex flex-wrap gap-2">
                  {CATEGORIES.map(c => (
                    <button key={c} onClick={() => setReg('category', c)}
                      style={{
                        padding: '5px 12px', fontSize: 12, borderRadius: 3, cursor: 'pointer',
                        border: `1px solid ${regForm.category === c ? '#1A2E44' : '#E5E7EB'}`,
                        background: regForm.category === c ? '#1A2E44' : 'white',
                        color: regForm.category === c ? 'white' : '#6B7280',
                      }}>
                      {c}
                    </button>
                  ))}
                </div>
                {regErrors.category && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.category}</p>}
              </div>

              {/* 위치 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위치</label>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '8px 12px', border: '1px solid #E5E7EB', borderRadius: 4, background: '#F9FAFB' }}>
                  <MapPin size={13} color="#9CA3AF" />
                  <span style={{ flex: 1, fontSize: 13, color: '#374151' }}>{selectedSite?.name ?? '위치 미선택'}{selectedSite && ` (${selectedSite.zone})`}</span>
                  <button onClick={() => setStep(1)} style={{ fontSize: 11, color: '#1A2E44', background: 'none', border: 'none', cursor: 'pointer' }}>변경</button>
                </div>
              </div>

              {/* 위험도 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위험도 <span style={{ color: '#991B1B' }}>*</span></label>
                <div className="grid grid-cols-3 gap-2">
                  {RISK_OPTIONS.map(r => (
                    <button key={r.value} onClick={() => setReg('risk', r.value)}
                      style={{
                        padding: '9px', borderRadius: 4, cursor: 'pointer', fontSize: 12, fontWeight: 600,
                        border: `1px solid ${regForm.risk === r.value ? r.border : '#E5E7EB'}`,
                        background: regForm.risk === r.value ? r.bg : 'white',
                        color: regForm.risk === r.value ? r.color : '#9CA3AF',
                        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
                      }}>
                      <span style={{ width: 10, height: 10, borderRadius: '50%', background: r.color, display: 'block' }} />
                      {r.label}
                    </button>
                  ))}
                </div>
                {regErrors.risk && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.risk}</p>}
              </div>

              {/* 담당자 + 발견일 + 기한 */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>담당자 <span style={{ color: '#991B1B' }}>*</span></label>
                  <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                    <User size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10 }} />
                    <select value={regForm.assignee} onChange={e => setReg('assignee', e.target.value)}
                      style={{ ...inputStyle(regErrors.assignee), paddingLeft: 28, appearance: 'none' }}>
                      <option value="">선택</option>
                      {ASSIGNEES.map(a => <option key={a}>{a}</option>)}
                    </select>
                  </div>
                  {regErrors.assignee && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.assignee}</p>}
                </div>
                <div>
                  <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>발견 일시</label>
                  <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                    <Calendar size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10, zIndex: 1, pointerEvents: 'none' }} />
                    <input type="date" value={regForm.discoveredDate} onChange={e => setReg('discoveredDate', e.target.value)}
                      style={{ ...inputStyle(), paddingLeft: 28 }} />
                  </div>
                </div>
                <div className="col-span-2">
                  <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>조치 기한 <span style={{ color: '#991B1B' }}>*</span></label>
                  <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                    <Calendar size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10, zIndex: 1, pointerEvents: 'none' }} />
                    <input type="date" value={regForm.deadline} onChange={e => setReg('deadline', e.target.value)}
                      style={{ ...inputStyle(regErrors.deadline), paddingLeft: 28 }} />
                  </div>
                  {regErrors.deadline && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.deadline}</p>}
                </div>
              </div>

              {/* 상황 설명 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위험 상황 설명 <span style={{ color: '#991B1B' }}>*</span></label>
                <textarea value={regForm.description} onChange={e => setReg('description', e.target.value)}
                  placeholder="발견된 위험 상황을 구체적으로 설명해주세요..." rows={4}
                  style={{ ...inputStyle(regErrors.description), resize: 'none', padding: '8px 12px' }} />
                {regErrors.description && <p style={{ color: '#991B1B', fontSize: 11, marginTop: 3 }}>{regErrors.description}</p>}
              </div>

              {/* 권장 조치 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>권장 조치 사항</label>
                <textarea value={regForm.recommendation} onChange={e => setReg('recommendation', e.target.value)}
                  placeholder="어떤 조치가 필요한지 설명해주세요..." rows={2}
                  style={{ ...inputStyle(), resize: 'none', padding: '8px 12px' }} />
              </div>

              {/* 관련 법규 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>관련 법규</label>
                <div className="flex flex-wrap gap-2 mb-2">
                  {REGULATION_REFS.map(r => (
                    <button key={r} onClick={() => setReg('regulation', r)}
                      style={{
                        padding: '4px 10px', fontSize: 11, borderRadius: 3, cursor: 'pointer',
                        border: `1px solid ${regForm.regulation === r ? '#1A2E44' : '#E5E7EB'}`,
                        background: regForm.regulation === r ? '#1A2E44' : 'white',
                        color: regForm.regulation === r ? 'white' : '#6B7280',
                      }}>
                      {r}
                    </button>
                  ))}
                </div>
                <input type="text" value={regForm.regulation} onChange={e => setReg('regulation', e.target.value)}
                  placeholder="직접 입력하거나 위에서 선택" style={inputStyle()} />
              </div>

              {/* 비고 */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>비고</label>
                <textarea value={regForm.note} onChange={e => setReg('note', e.target.value)}
                  placeholder="추가 메모사항" rows={2}
                  style={{ ...inputStyle(), resize: 'none', padding: '8px 12px' }} />
              </div>

              <div style={{ padding: '10px 14px', background: '#EFF6FF', border: '1px solid #BFDBFE', borderRadius: 4, fontSize: 12, color: '#1E40AF' }}>
                등록 후 담당자에게 알림이 발송됩니다.
              </div>

              <button onClick={handleRegSubmit}
                style={{
                  width: '100%', padding: '10px 0', background: '#1A2E44', color: 'white',
                  border: 'none', borderRadius: 4, fontSize: 13, fontWeight: 600, cursor: 'pointer',
                  display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
                }}>
                <ClipboardList size={14} /> 조치관리에 등록
              </button>
            </div>
          )}

          {/* Navigation buttons */}
          {!(step === 4 && (analyzing || aiScanVisible || results.length > 0)) && step !== 5 && (
            <div className="flex items-center justify-between mt-6 pt-5" style={{ borderTop: '1px solid #F3F4F6' }}>
              <button
                onClick={() => setStep(s => Math.max(1, s - 1))}
                disabled={step === 1}
                style={{
                  display: 'flex', alignItems: 'center', gap: 6, padding: '7px 14px',
                  fontSize: 12, background: 'white', color: step === 1 ? '#D1D5DB' : '#374151',
                  border: '1px solid #E5E7EB', borderRadius: 4, cursor: step === 1 ? 'not-allowed' : 'pointer',
                }}
              >
                <ChevronLeft size={14} /> 이전
              </button>
              <span style={{ fontSize: 11, color: '#9CA3AF' }}>{step} / {STEPS.length}</span>
              {step < 4 ? (
                <button
                  onClick={() => setStep(s => s + 1)}
                  disabled={!canNext}
                  style={{
                    padding: '7px 16px', fontSize: 12, fontWeight: 600,
                    background: canNext ? '#1A2E44' : '#E5E7EB',
                    color: canNext ? 'white' : '#9CA3AF',
                    border: 'none', borderRadius: 4, cursor: canNext ? 'pointer' : 'not-allowed',
                  }}
                >
                  다음
                </button>
              ) : <div style={{ width: 72 }} />}
            </div>
          )}

          {step === 5 && (
            <div style={{ paddingTop: 16, marginTop: 8, borderTop: '1px solid #F3F4F6' }}>
              <button onClick={() => setStep(4)}
                style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, color: '#6B7280', background: 'none', border: 'none', cursor: 'pointer' }}>
                <ChevronLeft size={13} /> AI 분석 결과로 돌아가기
              </button>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
