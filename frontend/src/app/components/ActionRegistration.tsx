import { useState, useRef } from 'react';
import Layout from './Layout';
import { Upload, X, ChevronLeft, ChevronRight, CheckCircle2, AlertTriangle, Camera, Plus } from 'lucide-react';
import { toast } from 'sonner';

interface ActionRegistrationProps {
  onNavigate: (page: string) => void;
}

const STEPS = [
  { number: 1, title: '사진 업로드', icon: Camera },
  { number: 2, title: '상세 내용',   icon: AlertTriangle },
  { number: 3, title: '검토 및 제출', icon: CheckCircle2 },
];


export default function ActionRegistration({ onNavigate }: ActionRegistrationProps) {
  const [step, setStep] = useState(1);
  const [images, setImages] = useState<string[]>([]);
  const fileRef = useRef<HTMLInputElement>(null);
  const [form, setForm] = useState({
    actionTaken: '',
    note: '',
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  const set = (key: string, value: string) => {
    setForm(f => ({ ...f, [key]: value }));
    setErrors(e => ({ ...e, [key]: '' }));
  };

  const validateStep = (s: number) => {
    const e: Record<string, string> = {};
    if (s === 1 && images.length === 0) e.images = '현장 사진을 1장 이상 업로드하세요';
    if (s === 2 && !form.actionTaken.trim()) e.actionTaken = '조치 내용을 입력하세요';
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const next = () => {
    if (!validateStep(step)) return;
    setStep(s => s + 1);
  };

  const handleFiles = (files: FileList | null) => {
    if (!files) return;
    const urls = Array.from(files).filter(f => f.type.startsWith('image/')).map(f => URL.createObjectURL(f));
    setImages(prev => [...prev, ...urls]);
    setErrors(e => ({ ...e, images: '' }));
    toast.success(`${urls.length}장 업로드됨`);
  };

  const handleSubmit = () => {
    toast.success('조치 사항이 등록되었습니다!');
    setTimeout(() => onNavigate('actions'), 800);
  };

  return (
    <Layout currentPath="actions" onNavigate={onNavigate}>
      <div className="max-w-2xl mx-auto space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">조치 사항 등록</h1>
          <p className="text-sm text-gray-500 mt-1">새로운 안전 조치 사항을 단계별로 등록합니다</p>
        </div>

        {/* Step indicator */}
        <div className="bg-white rounded px-6 py-5 shadow-sm border border-gray-100">
          <div className="flex items-center">
            {STEPS.map((s, i) => {
              const done   = step > s.number;
              const active = step === s.number;
              return (
                <div key={s.number} className="flex items-center flex-1 last:flex-none">
                  <div className="flex flex-col items-center gap-1.5">
                    <div className={`w-9 h-9 rounded-full flex items-center justify-center transition-all ${
                      done   ? 'bg-green-500 text-white' :
                      active ? 'bg-[#1A2E44] text-white shadow-md shadow-[#1A2E44]/40 scale-110' :
                               'bg-gray-100 text-gray-400'
                    }`}>
                      {done ? <CheckCircle2 className="w-5 h-5" /> : <s.icon className="w-4 h-4" />}
                    </div>
                    <span className={`text-[10px] font-medium whitespace-nowrap ${active ? 'text-[#1A2E44]' : done ? 'text-green-600' : 'text-gray-400'}`}>
                      {s.title}
                    </span>
                  </div>
                  {i < STEPS.length - 1 && (
                    <div className={`flex-1 h-0.5 mx-2 mb-5 ${done ? 'bg-green-400' : 'bg-gray-200'}`} />
                  )}
                </div>
              );
            })}
          </div>
        </div>

        <div className="bg-white rounded p-6 shadow-sm border border-gray-100">

          {/* ── STEP 1: 사진 업로드 ── */}
          {step === 1 && (
            <div className="space-y-5">
              <div className="flex items-center gap-2 mb-1">
                <Camera className="w-5 h-5 text-blue-500" />
                <h2 className="text-base font-bold text-gray-900">현장 사진 업로드</h2>
              </div>

              <div
                onClick={() => fileRef.current?.click()}
                onDragOver={e => e.preventDefault()}
                onDrop={e => { e.preventDefault(); handleFiles(e.dataTransfer.files); }}
                className={`border-2 border-dashed rounded p-8 text-center cursor-pointer transition-all ${
                  errors.images ? 'border-red-400 bg-red-50' : 'border-gray-200 hover:border-blue-400 hover:bg-blue-50'
                }`}
              >
                <input ref={fileRef} type="file" multiple accept="image/*" className="hidden" onChange={e => handleFiles(e.target.files)} />
                <div className="flex flex-col items-center gap-3">
                  <div className="w-14 h-14 bg-blue-50 rounded flex items-center justify-center">
                    <Upload className="w-7 h-7 text-blue-500" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-800">사진을 드래그하거나 클릭하여 업로드</p>
                    <p className="text-xs text-gray-400 mt-1">JPG, PNG · 최대 10MB · 여러 장 가능</p>
                  </div>
                </div>
              </div>
              {errors.images && <p className="text-red-500 text-xs">{errors.images}</p>}

              {images.length > 0 && (
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <p className="text-sm font-semibold text-gray-700">{images.length}장 업로드됨</p>
                    <button onClick={() => setImages([])} className="text-xs text-red-400 hover:text-red-600">전체 삭제</button>
                  </div>
                  <div className="grid grid-cols-3 gap-2">
                    {images.map((img, i) => (
                      <div key={i} className="relative group aspect-video rounded overflow-hidden border border-gray-200">
                        <img src={img} alt="" className="w-full h-full object-cover" />
                        <button
                          onClick={() => setImages(prev => prev.filter((_, idx) => idx !== i))}
                          className="absolute top-1 right-1 bg-black/60 text-white rounded-full p-0.5 opacity-0 group-hover:opacity-100 transition-opacity hover:bg-red-500"
                        >
                          <X className="w-3 h-3" />
                        </button>
                      </div>
                    ))}
                    <button onClick={() => fileRef.current?.click()}
                      className="aspect-video rounded border-2 border-dashed border-gray-300 flex items-center justify-center hover:border-blue-400 transition-colors">
                      <Plus className="w-5 h-5 text-gray-400" />
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* ── STEP 2: 상세 내용 ── */}
          {step === 2 && (
            <div className="space-y-5">
              <div className="flex items-center gap-2 mb-1">
                <AlertTriangle className="w-5 h-5 text-orange-500" />
                <h2 className="text-base font-bold text-gray-900">상세 내용</h2>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">조치 내용 <span className="text-red-500">*</span></label>
                <textarea
                  value={form.actionTaken}
                  onChange={e => set('actionTaken', e.target.value)}
                  placeholder="실제로 어떤 조치를 취했는지 작성해주세요..."
                  rows={5}
                  className={`w-full px-4 py-3 border rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none ${errors.actionTaken ? 'border-red-400' : 'border-gray-200'}`}
                />
                {errors.actionTaken && <p className="text-red-500 text-xs mt-1">{errors.actionTaken}</p>}
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">비고</label>
                <textarea
                  value={form.note}
                  onChange={e => set('note', e.target.value)}
                  placeholder="추가 메모사항이 있으면 입력하세요"
                  rows={2}
                  className="w-full px-4 py-2.5 border border-gray-200 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none"
                />
              </div>
            </div>
          )}

          {/* ── STEP 3: 검토 및 제출 ── */}
          {step === 3 && (
            <div className="space-y-5">
              <div className="flex items-center gap-2 mb-1">
                <CheckCircle2 className="w-5 h-5 text-green-600" />
                <h2 className="text-base font-bold text-gray-900">검토 및 제출</h2>
              </div>

              <div className="space-y-3">
                {[
                  { label: '사진',      value: `${images.length}장`, step: 1 },
                  { label: '조치 내용', value: form.actionTaken || '-', step: 2 },
                ].map((item, i) => (
                  <div key={i} className="flex items-start justify-between gap-4 py-2.5 border-b border-gray-50 last:border-0">
                    <span className="text-xs text-gray-500 w-24 flex-shrink-0 pt-0.5">{item.label}</span>
                    <span className="text-sm font-medium text-gray-900 flex-1 text-right line-clamp-2">{item.value}</span>
                    <button onClick={() => setStep(item.step)} className="text-[10px] text-[#1A2E44] hover:underline flex-shrink-0 pt-0.5">수정</button>
                  </div>
                ))}
              </div>

              {images.length > 0 && (
                <div>
                  <p className="text-xs text-gray-500 mb-2">첨부 사진</p>
                  <div className="grid grid-cols-4 gap-2">
                    {images.map((img, i) => (
                      <img key={i} src={img} alt="" className="w-full aspect-video object-cover rounded-lg border border-gray-200" />
                    ))}
                  </div>
                </div>
              )}

              <div className="bg-blue-50 rounded p-3 border border-blue-100 text-xs text-blue-700">
                등록 후 담당자에게 즉시 알림이 발송됩니다.
              </div>

              <button
                onClick={handleSubmit}
                className="w-full py-4 bg-[#1A2E44] text-white rounded font-bold hover:bg-[#0F2233] transition-colors shadow-lg shadow-[#1A2E44]/30 flex items-center justify-center gap-2 text-base"
              >
                <CheckCircle2 className="w-5 h-5" /> 조치 사항 등록 완료
              </button>
            </div>
          )}

          {/* Navigation */}
          {step < 3 && (
            <div className="flex items-center justify-between mt-6 pt-5 border-t border-gray-100">
              <button
                onClick={() => setStep(s => Math.max(1, s - 1))}
                disabled={step === 1}
                className="flex items-center gap-2 px-5 py-2.5 border border-gray-200 rounded text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed transition-all"
              >
                <ChevronLeft className="w-4 h-4" /> 이전
              </button>
              <span className="text-xs text-gray-400">{step} / {STEPS.length}</span>
              <button onClick={next}
                className="flex items-center gap-2 px-5 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#0F2233] transition-colors shadow-sm">
                다음 <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
