import { useState, useRef } from 'react';
import svgPaths from '../../imports/action-verify-ai/svg-q58vvs8s1g';
import imgBefore from '../../imports/action-verify-ai/6a85f952a6db739f0fef08583301f6334815e83b.png';
import { toast } from 'sonner';
import { X, Loader2 } from 'lucide-react';

interface ActionVerificationPanelProps {
  issueTitle: string;
  issueCode: string;
  description: string;
  checklist: string[];
  beforeImage?: string;
  onClose: () => void;
}

function CameraIcon({ strokeColor = '#99A1AF' }: { strokeColor?: string }) {
  return (
    <svg className="w-16 h-16" fill="none" viewBox="0 0 64 64">
      <path d={svgPaths.p3e6de780} stroke={strokeColor} strokeLinecap="round" strokeLinejoin="round" strokeWidth="5.33333" />
      <path d={svgPaths.p394e8e00} stroke={strokeColor} strokeLinecap="round" strokeLinejoin="round" strokeWidth="5.33333" />
    </svg>
  );
}

function PhotoIcon({ strokeColor = '#1A2E44' }: { strokeColor?: string }) {
  return (
    <svg className="w-5 h-5" fill="none" viewBox="0 0 20 20">
      <path d={svgPaths.pf2880} stroke={strokeColor} strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
      <path d={svgPaths.p380a7500} stroke={strokeColor} strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
    </svg>
  );
}

export default function ActionVerificationPanel({
  issueTitle,
  issueCode,
  description,
  checklist,
  beforeImage,
  onClose,
}: ActionVerificationPanelProps) {
  const [afterImage, setAfterImage] = useState<string | null>(null);
  const [checks, setChecks] = useState<boolean[]>(checklist.map(() => false));
  const [actionDesc, setActionDesc] = useState('');
  const [aiLoading, setAiLoading] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const toggleCheck = (i: number) => {
    setChecks(prev => prev.map((v, idx) => idx === i ? !v : v));
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setAfterImage(url);
    toast.success('사진이 업로드되었습니다.');
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setAfterImage(url);
    toast.success('사진이 업로드되었습니다.');
  };

  const handleAiRequest = () => {
    if (!afterImage) {
      toast.error('조치 후 사진을 먼저 업로드해주세요.');
      return;
    }
    setAiLoading(true);
    setTimeout(() => {
      setAiLoading(false);
      toast.success('AI 재평가가 완료되었습니다. 조치 항목이 95% 수준으로 이행되었습니다.');
    }, 2200);
  };

  return (
    <div className="bg-[#f5f7fa] rounded border-2 border-[#003b5c]/10 overflow-hidden">
      {/* Panel header */}
      <div className="bg-[#003b5c] px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 bg-[#1A2E44] rounded-lg flex items-center justify-center">
            <svg className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="white" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M4 5H20M4 12H20M4 19H20" />
            </svg>
          </div>
          <div>
            <p className="text-white font-bold text-base">조치 검증 업로드</p>
            <p className="text-white/60 text-xs">조치 항목: {issueTitle} ({issueCode})</p>
          </div>
        </div>
        <button onClick={onClose} className="p-1.5 hover:bg-white/10 rounded-lg transition-colors">
          <X className="w-5 h-5 text-white/70" />
        </button>
      </div>

      <div className="p-6 space-y-6">
        {/* Before / VS / After comparison */}
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_80px_1fr] gap-4 items-start">

          {/* 조치 전 panel */}
          <div className="bg-white rounded shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 px-6 pt-6 pb-4">
              <div className="w-3 h-3 rounded-full bg-[#fb2c36]" />
              <span className="font-bold text-[#003b5c] text-lg">조치 전</span>
            </div>

            {/* Before image */}
            <div className="relative mx-6 mb-4 rounded-[14px] overflow-hidden bg-[#f3f4f6]" style={{ height: '280px' }}>
              <img src={beforeImage ?? imgBefore} alt="조치 전 현장" className="w-full h-full object-cover" />
              {beforeImage && (
                <div className="absolute top-3 left-3 bg-[#003b5c]/80 text-white text-[10px] font-semibold px-2.5 py-1 rounded-full">
                  등록된 현장 사진
                </div>
              )}
              {/* Red hazard badge */}
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="relative">
                  <div className="w-14 h-14 bg-[#fb2c36] rounded-full flex items-center justify-center opacity-90 shadow-lg">
                    <span className="text-white font-bold text-2xl">!</span>
                  </div>
                  <div className="absolute -inset-7 bg-[#fb2c36] rounded-full opacity-[0.07]" />
                </div>
              </div>
            </div>

            {/* Risk description */}
            <div className="px-6 pb-4 space-y-3">
              <div>
                <p className="text-[#003b5c] font-bold text-sm mb-1">위험 내용</p>
                <p className="text-[#364153] text-sm leading-relaxed">{description}</p>
              </div>

              {/* Checklist */}
              <div>
                <p className="text-[#003b5c] font-bold text-sm mb-2">필수 조치 사항</p>
                <div className="space-y-2">
                  {checklist.map((item, i) => (
                    <label
                      key={i}
                      className="flex items-center gap-3 p-2.5 bg-[#f9fafb] rounded cursor-pointer hover:bg-gray-100 transition-colors"
                    >
                      <input
                        type="checkbox"
                        checked={checks[i]}
                        onChange={() => toggleCheck(i)}
                        className="w-4 h-4 rounded text-[#003b5c] accent-[#003b5c] flex-shrink-0"
                      />
                      <span className="text-[#364153] text-sm">{item}</span>
                    </label>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* VS badge (center) */}
          <div className="hidden lg:flex flex-col items-center justify-center gap-3 pt-24">
            <div className="w-16 h-16 rounded-full bg-gradient-to-b from-[#1A2E44] to-[#ffb81c] flex items-center justify-center shadow-lg flex-shrink-0">
              <span className="text-white font-bold text-lg">VS</span>
            </div>
            <div className="w-0.5 flex-1 bg-gradient-to-b from-[#1A2E44] to-[#2d5016] min-h-[120px]" />
          </div>

          {/* 조치 후 panel */}
          <div className="bg-white rounded shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 px-6 pt-6 pb-4">
              <div className="w-3 h-3 rounded-full bg-[#2d5016]" />
              <span className="font-bold text-[#003b5c] text-lg">조치 후</span>
            </div>

            {/* After upload area */}
            <div className="mx-6 mb-4">
              {afterImage ? (
                <div className="relative rounded-[14px] overflow-hidden bg-gray-100" style={{ height: '280px' }}>
                  <img src={afterImage} alt="조치 후 현장" className="w-full h-full object-cover" />
                  <button
                    onClick={() => setAfterImage(null)}
                    className="absolute top-3 right-3 bg-black/50 hover:bg-black/70 rounded-full p-1.5 transition-colors"
                  >
                    <X className="w-4 h-4 text-white" />
                  </button>
                  <div className="absolute bottom-3 left-3 bg-[#2d5016]/90 text-white text-xs px-3 py-1 rounded-full font-semibold">
                    ✓ 조치 완료 사진
                  </div>
                </div>
              ) : (
                <div
                  className="relative rounded-[14px] border-2 border-dashed border-[#d1d5dc] bg-gray-50 flex flex-col items-center justify-center cursor-pointer hover:border-[#1A2E44] hover:bg-orange-50 transition-all"
                  style={{ height: '280px' }}
                  onClick={() => fileInputRef.current?.click()}
                  onDrop={handleDrop}
                  onDragOver={e => e.preventDefault()}
                >
                  <CameraIcon />
                  <p className="text-[#364153] text-base font-medium mt-3">개선된 현장을 촬영해주세요</p>
                  <p className="text-[#6a7282] text-sm mt-1">클릭하거나 드래그하여 업로드</p>
                  <div className="mt-4 bg-[#eff6ff] border border-[#bedbff] rounded px-4 py-2.5">
                    <p className="text-[#193cb8] text-xs text-center">💡 동일 위치에서 촬영하면 더 정확해요</p>
                  </div>
                </div>
              )}
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                className="hidden"
                onChange={handleFileChange}
              />
            </div>

            {/* Shooting guide */}
            <div className="mx-6 mb-4 bg-[#fff5f2] border border-[#1A2E44] rounded-[14px] p-4 space-y-2">
              <div className="flex items-center gap-2">
                <PhotoIcon />
                <span className="text-[#1A2E44] font-bold text-sm">촬영 가이드</span>
              </div>
              <ul className="space-y-1.5">
                {[
                  '조치 전과 동일한 위치, 각도에서 촬영',
                  '개선 사항이 명확히 보이도록 촬영',
                  '충분한 조명 확보',
                  '여러 각도에서 촬영 권장',
                ].map((tip, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-[#364153]">
                    <span className="text-[#1A2E44] font-bold flex-shrink-0">•</span>
                    {tip}
                  </li>
                ))}
              </ul>
            </div>

            {/* Camera button */}
            <div className="mx-6 mb-6">
              <button
                onClick={() => fileInputRef.current?.click()}
                className="w-full flex items-center justify-center gap-2 h-[52px] rounded-[14px] border-2 border-[#2d5016] text-[#2d5016] font-medium hover:bg-[#2d5016]/5 transition-colors"
              >
                <PhotoIcon strokeColor="#2D5016" />
                카메라로 직접 촬영
              </button>
            </div>
          </div>
        </div>

        {/* Action description */}
        <div className="bg-white rounded shadow-sm p-6">
          <p className="text-[#003b5c] font-bold text-base mb-3">조치 내용 설명</p>
          <textarea
            value={actionDesc}
            onChange={e => setActionDesc(e.target.value)}
            placeholder="어떤 조치를 취했는지 상세히 설명해주세요..."
            rows={4}
            className="w-full px-4 py-3 border border-[#d1d5dc] rounded-[14px] text-sm text-gray-800 placeholder:text-gray-400 focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none resize-none"
          />
        </div>

        {/* Action buttons */}
        <div className="bg-white rounded shadow-sm p-6">
          <div className="flex gap-4">
            <button
              onClick={onClose}
              className="flex-1 h-14 rounded-[14px] border border-[#d1d5dc] text-[#364153] font-medium hover:bg-gray-50 transition-colors"
            >
              취소
            </button>
            <button
              onClick={handleAiRequest}
              disabled={aiLoading}
              className={`flex-1 h-14 rounded-[14px] font-bold text-base transition-colors flex items-center justify-center gap-2 ${
                afterImage
                  ? 'bg-[#003b5c] text-white hover:bg-[#002a44]'
                  : 'bg-[#d1d5dc] text-[#6a7282] cursor-not-allowed'
              }`}
            >
              {aiLoading ? (
                <>
                  <Loader2 className="w-5 h-5 animate-spin" />
                  AI 분석 중...
                </>
              ) : 'AI 재평가 요청'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
