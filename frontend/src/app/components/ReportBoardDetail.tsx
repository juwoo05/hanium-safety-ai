import { useState } from 'react';
import Layout from './Layout';
import {
  AlertTriangle, ArrowLeft, MapPin, Clock, Eye, EyeOff,
  CheckCircle2, MessageSquare, Send, HardHat,
  Package, Wind, Zap, MoreHorizontal, Flag
} from 'lucide-react';
import { toast } from 'sonner';

interface ReportBoardDetailProps {
  onNavigate: (page: string) => void;
}

const report = {
  id: 1,
  title: '3동 옥상 안전난간 파손 방치',
  category: '안전 위반' as const,
  location: '3동 옥상',
  date: '2026-06-01',
  status: '처리중' as const,
  anonymous: true,
  reporter: '익명',
  risk: 'high' as const,
  views: 42,
  description: `3동 옥상 남쪽 가장자리 안전난간이 파손된 채로 2주 이상 방치되고 있습니다.

현재 해당 구역에서 외벽 도색 작업이 진행 중인데, 파손된 난간 근처에서 작업자들이 안전장치 없이 작업하는 것을 여러 차례 목격했습니다.

추락 사고가 발생하기 전에 즉각적인 조치가 필요합니다. 최소한 해당 구역 출입을 통제하고 임시 안전장치라도 설치해야 합니다.`,
  images: [
    'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&h=400&fit=crop&auto=format',
    'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=600&h=400&fit=crop&auto=format',
  ],
};

const timeline = [
  { date: '2026-06-01 09:15', label: '신고 접수', desc: '신고가 안전 관리팀에 접수되었습니다.', done: true },
  { date: '2026-06-01 11:30', label: '담당자 배정', desc: '김현장 안전관리자가 담당자로 배정되었습니다.', done: true },
  { date: '2026-06-02 14:00', label: '현장 확인 중', desc: '담당자가 현장 실태를 확인하고 있습니다.', done: true },
  { date: '처리 예정',        label: '조치 완료',  desc: '안전난간 교체 작업 예정', done: false },
];

const initialComments = [
  {
    id: 1,
    author: '김현장',
    role: '안전관리자',
    date: '2026-06-01 14:20',
    text: '현장 확인 결과 신고 내용이 사실임을 확인했습니다. 오늘 오후 안전 테이프로 임시 통제하고, 내일 난간 교체 작업을 진행할 예정입니다.',
    official: true,
  },
  {
    id: 2,
    author: '익명',
    role: '신고자',
    date: '2026-06-01 16:05',
    text: '빠른 확인 감사합니다. 오늘 오후에도 작업자들이 해당 구역에 접근하고 있으니 빠른 조치 부탁드립니다.',
    official: false,
  },
];

const RISK_META = {
  high:   { label: '고위험', pill: 'bg-red-100 text-red-700 border-red-200' },
  medium: { label: '중위험', pill: 'bg-orange-100 text-orange-700 border-orange-200' },
  low:    { label: '저위험', pill: 'bg-yellow-100 text-yellow-700 border-yellow-200' },
};

const STATUS_META = {
  '접수':   { pill: 'bg-gray-100 text-gray-600', label: '접수' },
  '처리중': { pill: 'bg-blue-100 text-blue-700',  label: '처리중' },
  '완료':   { pill: 'bg-green-100 text-green-700', label: '완료' },
  '반려':   { pill: 'bg-red-100 text-red-600',    label: '반려' },
};

export default function ReportBoardDetail({ onNavigate }: ReportBoardDetailProps) {
  const [comments, setComments] = useState(initialComments);
  const [newComment, setNewComment] = useState('');
  const [selectedImg, setSelectedImg] = useState(0);

  const handleComment = () => {
    if (!newComment.trim()) return;
    setComments(prev => [...prev, {
      id: prev.length + 1,
      author: '나',
      role: '작업자',
      date: new Date().toLocaleString('ko-KR'),
      text: newComment,
      official: false,
    }]);
    setNewComment('');
    toast.success('댓글이 등록되었습니다.');
  };

  return (
    <Layout currentPath="report-board" onNavigate={onNavigate}>
      <div className="max-w-4xl mx-auto space-y-5">

        {/* Back */}
        <button
          onClick={() => onNavigate('report-board')}
          className="flex items-center gap-2 text-sm text-gray-500 hover:text-gray-800 transition-colors"
        >
          <ArrowLeft className="w-4 h-4" /> 신고 게시판으로
        </button>

        {/* Header card */}
        <div className="bg-white rounded p-6 shadow-sm border border-gray-100">
          <div className="flex items-start justify-between gap-4 mb-4">
            <div className="flex items-start gap-3 flex-1">
              <div className="w-10 h-10 bg-red-50 rounded flex items-center justify-center flex-shrink-0 mt-0.5">
                <AlertTriangle className="w-5 h-5 text-red-600" />
              </div>
              <div>
                <div className="flex flex-wrap items-center gap-2 mb-2">
                  <span className={`text-xs font-semibold px-2.5 py-1 rounded-full border ${RISK_META[report.risk].pill}`}>
                    {RISK_META[report.risk].label}
                  </span>
                  <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${STATUS_META[report.status].pill}`}>
                    {STATUS_META[report.status].label}
                  </span>
                  <span className="text-xs text-gray-400 bg-gray-50 px-2 py-1 rounded-full">{report.category}</span>
                </div>
                <h1 className="text-xl font-bold text-gray-900">{report.title}</h1>
              </div>
            </div>
            <button
              onClick={() => toast.success('신고가 접수 처리되었습니다.')}
              className="flex items-center gap-1.5 px-3 py-2 border border-red-200 text-red-500 rounded-lg text-xs font-medium hover:bg-red-50 transition-colors flex-shrink-0"
            >
              <Flag className="w-3.5 h-3.5" /> 처리 요청
            </button>
          </div>

          <div className="flex flex-wrap items-center gap-4 text-xs text-gray-500 pt-4 border-t border-gray-100">
            <span className="flex items-center gap-1.5"><MapPin className="w-3.5 h-3.5" />{report.location}</span>
            <span className="flex items-center gap-1.5"><Clock className="w-3.5 h-3.5" />{report.date}</span>
            <span className="flex items-center gap-1.5"><Eye className="w-3.5 h-3.5" />{report.views}명 조회</span>
            <span className="flex items-center gap-1.5 ml-auto">
              {report.anonymous
                ? <><EyeOff className="w-3.5 h-3.5" /> 익명 신고</>
                : <><HardHat className="w-3.5 h-3.5" /> {report.reporter}</>
              }
            </span>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
          {/* Main content */}
          <div className="lg:col-span-2 space-y-5">

            {/* Description */}
            <div className="bg-white rounded p-6 shadow-sm border border-gray-100">
              <h2 className="text-base font-bold text-gray-900 mb-4">신고 내용</h2>
              <p className="text-sm text-gray-700 leading-relaxed whitespace-pre-line">{report.description}</p>
            </div>

            {/* Images */}
            {report.images.length > 0 && (
              <div className="bg-white rounded p-6 shadow-sm border border-gray-100">
                <h2 className="text-base font-bold text-gray-900 mb-4">첨부 사진 ({report.images.length})</h2>
                <div className="rounded overflow-hidden mb-3 bg-gray-100 aspect-video">
                  <img
                    src={report.images[selectedImg]}
                    alt="신고 사진"
                    className="w-full h-full object-cover"
                  />
                </div>
                <div className="flex gap-2">
                  {report.images.map((img, i) => (
                    <button
                      key={i}
                      onClick={() => setSelectedImg(i)}
                      className={`w-16 h-12 rounded-lg overflow-hidden border-2 transition-all ${selectedImg === i ? 'border-[#1A2E44] ring-2 ring-[#1A2E44]/20' : 'border-gray-200'}`}
                    >
                      <img src={img} alt="" className="w-full h-full object-cover" />
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Comments */}
            <div className="bg-white rounded p-6 shadow-sm border border-gray-100">
              <h2 className="text-base font-bold text-gray-900 mb-4 flex items-center gap-2">
                <MessageSquare className="w-4 h-4 text-[#1A2E44]" />
                댓글 ({comments.length})
              </h2>

              <div className="space-y-4 mb-5">
                {comments.map(c => (
                  <div key={c.id} className={`p-4 rounded border ${c.official ? 'bg-blue-50 border-blue-100' : 'bg-gray-50 border-gray-100'}`}>
                    <div className="flex items-center gap-2 mb-2">
                      <div className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold ${c.official ? 'bg-blue-600 text-white' : 'bg-gray-300 text-gray-700'}`}>
                        {c.author[0]}
                      </div>
                      <span className="text-sm font-semibold text-gray-900">{c.author}</span>
                      <span className={`text-[10px] px-2 py-0.5 rounded-full font-medium ${c.official ? 'bg-blue-100 text-blue-700' : 'bg-gray-200 text-gray-600'}`}>
                        {c.role}
                      </span>
                      {c.official && <CheckCircle2 className="w-3.5 h-3.5 text-blue-500" />}
                      <span className="text-xs text-gray-400 ml-auto">{c.date}</span>
                    </div>
                    <p className="text-sm text-gray-700 leading-relaxed">{c.text}</p>
                  </div>
                ))}
              </div>

              {/* Comment input */}
              <div className="flex gap-2">
                <input
                  type="text"
                  value={newComment}
                  onChange={e => setNewComment(e.target.value)}
                  onKeyDown={e => e.key === 'Enter' && handleComment()}
                  placeholder="댓글을 입력하세요..."
                  className="flex-1 px-3 py-2.5 border border-gray-200 rounded text-sm focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"
                />
                <button
                  onClick={handleComment}
                  className="px-4 py-2.5 bg-[#1A2E44] text-white rounded hover:bg-[#0F2233] transition-colors"
                >
                  <Send className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>

          {/* Right sidebar */}
          <div className="space-y-5">
            {/* Status timeline */}
            <div className="bg-white rounded p-5 shadow-sm border border-gray-100">
              <h2 className="text-sm font-bold text-gray-900 mb-4">처리 현황</h2>
              <div className="space-y-4">
                {timeline.map((step, i) => (
                  <div key={i} className="flex gap-3">
                    <div className="flex flex-col items-center">
                      <div className={`w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ${step.done ? 'bg-[#1A2E44] text-white' : 'bg-gray-100 border-2 border-gray-200'}`}>
                        {step.done
                          ? <CheckCircle2 className="w-3.5 h-3.5" />
                          : <div className="w-1.5 h-1.5 rounded-full bg-gray-400" />
                        }
                      </div>
                      {i < timeline.length - 1 && (
                        <div className={`w-0.5 flex-1 mt-1 min-h-[20px] ${step.done ? 'bg-[#1A2E44]/30' : 'bg-gray-100'}`} />
                      )}
                    </div>
                    <div className="pb-4">
                      <p className={`text-xs font-semibold mb-0.5 ${step.done ? 'text-gray-900' : 'text-gray-400'}`}>{step.label}</p>
                      <p className={`text-xs mb-0.5 ${step.done ? 'text-gray-600' : 'text-gray-400'}`}>{step.desc}</p>
                      <p className="text-[10px] text-gray-400">{step.date}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Info */}
            <div className="bg-white rounded p-5 shadow-sm border border-gray-100 space-y-3">
              <h2 className="text-sm font-bold text-gray-900">신고 정보</h2>
              {[
                { label: '신고 번호', value: `#${String(report.id).padStart(4, '0')}` },
                { label: '분류',     value: report.category },
                { label: '위치',     value: report.location },
                { label: '접수일',   value: report.date },
                { label: '신고자',   value: report.anonymous ? '익명' : report.reporter },
              ].map((item, i) => (
                <div key={i} className="flex items-center justify-between py-1 border-b border-gray-50 last:border-0">
                  <span className="text-xs text-gray-500">{item.label}</span>
                  <span className="text-xs font-semibold text-gray-800">{item.value}</span>
                </div>
              ))}
            </div>

            {/* Notice */}
            <div className="bg-blue-50 rounded p-4 border border-blue-100 text-xs text-blue-700">
              <p className="font-semibold mb-1">신고자 보호 안내</p>
              <p className="leading-relaxed text-blue-600">익명 신고자의 정보는 안전관리 담당자만 확인할 수 있으며, 외부에 공개되지 않습니다.</p>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
