import React, { useState, useRef } from 'react';
import Layout from './Layout';
import {
  AlertTriangle, Plus, Search, ChevronRight,
  MapPin, Clock, Eye, EyeOff,
  Zap, Package, Wind, MoreHorizontal, X, Camera, Image as ImageIcon,
} from 'lucide-react';
import { toast } from 'sonner';

interface ReportBoardProps {
  onNavigate: (page: string) => void;
}

type ReportStatus = '접수' | '처리중' | '완료' | '반려';
type ReportCategory = '안전 위반' | '불량 자재' | '작업 환경' | '불법 하도급' | '기타';

interface Report {
  id: number;
  title: string;
  category: ReportCategory;
  location: string;
  date: string;
  status: ReportStatus;
  anonymous: boolean;
  reporter: string;
  risk: 'high' | 'medium' | 'low';
  views: number;
  description: string;
}

const CATEGORY_META: Record<ReportCategory, { icon: React.ComponentType<{size?: number; color?: string}> }> = {
  '안전 위반':   { icon: AlertTriangle },
  '불량 자재':   { icon: Package },
  '작업 환경':   { icon: Wind },
  '불법 하도급': { icon: Zap },
  '기타':        { icon: MoreHorizontal },
};

const STATUS_COLOR: Record<ReportStatus, string> = {
  '접수':   '#6B7280', '처리중': '#1D4ED8', '완료': '#166534', '반려': '#991B1B',
};
const STATUS_BG: Record<ReportStatus, string> = {
  '접수': '#F3F4F6', '처리중': '#EFF6FF', '완료': '#F0FDF4', '반려': '#FEF2F2',
};

const RISK_COLOR: Record<string, string> = { high: '#991B1B', medium: '#B45309', low: '#166534' };
const RISK_BG:    Record<string, string> = { high: '#FEF2F2', medium: '#FFFBEB', low: '#F0FDF4' };
const RISK_LABEL: Record<string, string> = { high: '고위험', medium: '중위험', low: '저위험' };

const initialReports: Report[] = [
  { id: 1, title: '3동 옥상 안전난간 파손 방치', category: '안전 위반', location: '3동 옥상', date: '2026-06-01', status: '처리중', anonymous: true, reporter: '익명', risk: 'high', views: 42, description: '3동 옥상 남쪽 가장자리 안전난간이 파손된 채로 2주 이상 방치되고 있습니다. 작업자들이 해당 구역에서 계속 작업 중이라 추락 사고 위험이 매우 높습니다.' },
  { id: 2, title: '철근 자재 불량 납품 의심', category: '불량 자재', location: '자재 창고', date: '2026-05-30', status: '접수', anonymous: false, reporter: '이관리', risk: 'high', views: 18, description: '최근 납품된 철근 자재 중 일부가 규격 미달로 의심됩니다. 검수 없이 현장 투입될 경우 구조 안전에 심각한 문제가 생길 수 있습니다.' },
  { id: 3, title: '지하 주차장 환기 불량으로 두통 호소', category: '작업 환경', location: '지하 주차장', date: '2026-05-28', status: '완료', anonymous: true, reporter: '익명', risk: 'medium', views: 31, description: '지하 주차장 환기팬 고장으로 유해가스가 축적되고 있습니다. 작업자 3명이 두통과 어지럼증을 호소했습니다.' },
  { id: 4, title: '무자격 하도급 업체 작업 목격', category: '불법 하도급', location: '2동 3층', date: '2026-05-27', status: '처리중', anonymous: true, reporter: '익명', risk: 'medium', views: 55, description: '2동 3층 전기 배선 작업을 면허 없는 업체가 진행하는 것을 목격했습니다. 관련 서류 확인이 필요합니다.' },
  { id: 5, title: '안전모 미착용 작업 반복 발생', category: '안전 위반', location: '5동 작업구역', date: '2026-05-25', status: '완료', anonymous: false, reporter: '박안전', risk: 'low', views: 24, description: '5동 작업구역에서 특정 팀 작업자들이 반복적으로 안전모를 착용하지 않고 작업하는 것이 목격되고 있습니다.' },
];

interface NewReportForm {
  title: string; category: ReportCategory; location: string;
  risk: 'high' | 'medium' | 'low'; description: string; anonymous: boolean;
}

interface AttachedPhoto {
  id: string; file: File; previewUrl: string; caption: string;
}

const defaultForm: NewReportForm = { title: '', category: '안전 위반', location: '', risk: 'high', description: '', anonymous: true };

export default function ReportBoard({ onNavigate }: ReportBoardProps) {
  const [reports, setReports] = useState<Report[]>(initialReports);
  const [statusFilter, setStatusFilter] = useState<string>('전체');
  const [searchQuery, setSearchQuery] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState<NewReportForm>(defaultForm);
  const [attachedPhotos, setAttachedPhotos] = useState<AttachedPhoto[]>([]);
  const photoInputRef = useRef<HTMLInputElement>(null);

  const filters = ['전체', '처리중', '접수', '완료'];

  const filtered = reports.filter(r => {
    const matchStatus = statusFilter === '전체' || r.status === statusFilter;
    const matchSearch = !searchQuery || r.title.includes(searchQuery) || r.location.includes(searchQuery) || r.category.includes(searchQuery);
    return matchStatus && matchSearch;
  });

  const handlePhotoAdd = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const ALLOWED = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    const valid = files.filter(f => ALLOWED.includes(f.type));
    const invalid = files.filter(f => !ALLOWED.includes(f.type));
    if (invalid.length) toast.error(`${invalid.length}개 파일은 지원하지 않는 형식입니다.`);
    const newPhotos: AttachedPhoto[] = valid.map(f => ({
      id: Math.random().toString(36).slice(2), file: f, previewUrl: URL.createObjectURL(f), caption: '',
    }));
    setAttachedPhotos(prev => [...prev, ...newPhotos]);
    e.target.value = '';
  };

  const removePhoto = (id: string) => {
    setAttachedPhotos(prev => { const p = prev.find(x => x.id === id); if (p) URL.revokeObjectURL(p.previewUrl); return prev.filter(x => x.id !== id); });
  };

  const updateCaption = (id: string, caption: string) => {
    setAttachedPhotos(prev => prev.map(p => p.id === id ? { ...p, caption } : p));
  };

  const handleSubmit = () => {
    if (!form.title.trim() || !form.location.trim() || !form.description.trim()) {
      toast.error('제목, 위치, 내용을 모두 입력해주세요'); return;
    }
    const newReport: Report = {
      id: reports.length + 1, title: form.title, category: form.category, location: form.location,
      date: new Date().toISOString().slice(0, 10), status: '접수', anonymous: form.anonymous,
      reporter: form.anonymous ? '익명' : '나', risk: form.risk, views: 0, description: form.description,
    };
    setReports(prev => [newReport, ...prev]);
    setForm(defaultForm); setAttachedPhotos([]); setShowForm(false);
    toast.success(`신고가 접수되었습니다.${attachedPhotos.length ? ` (사진 ${attachedPhotos.length}장 포함)` : ''}`);
  };

  const inputStyle = {
    width: '100%', padding: '8px 12px', fontSize: 13,
    border: '1px solid #E5E7EB', borderRadius: 4, outline: 'none',
    background: '#F9FAFB', color: '#0F172A', boxSizing: 'border-box' as const,
  };

  return (
    <Layout currentPath="report-board" onNavigate={onNavigate}>
      {/* Header */}
      <div className="flex items-center justify-between mb-5">
        <div>
          <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>신고 접수</p>
          <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1 }}>신고 게시판</h1>
        </div>
        <button
          onClick={() => setShowForm(true)}
          style={{
            display: 'flex', alignItems: 'center', gap: 6, padding: '7px 14px',
            background: '#1A2E44', color: 'white', border: 'none',
            borderRadius: 4, fontSize: 13, fontWeight: 500, cursor: 'pointer',
          }}
        >
          <Plus size={13} /> 신고하기
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-4 gap-3 mb-5">
        {[
          { label: '전체 신고', value: reports.length, color: '#0F172A', bg: '#F9FAFB' },
          { label: '처리중',   value: reports.filter(r => r.status === '처리중').length, color: '#1D4ED8', bg: '#EFF6FF' },
          { label: '완료',     value: reports.filter(r => r.status === '완료').length,   color: '#166534', bg: '#F0FDF4' },
          { label: '고위험',   value: reports.filter(r => r.risk === 'high').length,     color: '#991B1B', bg: '#FEF2F2' },
        ].map((s, i) => (
          <div key={i} style={{ background: s.bg, border: '1px solid #E5E7EB', borderRadius: 4, padding: '14px 18px' }}>
            <p style={{ fontSize: 11, color: '#9CA3AF', marginBottom: 4 }}>{s.label}</p>
            <p style={{ fontSize: 22, fontWeight: 700, color: s.color }}>{s.value}</p>
          </div>
        ))}
      </div>

      {/* Filters + search */}
      <div
        style={{
          background: 'white', border: '1px solid #E5E7EB',
          borderRadius: 4, borderBottomLeftRadius: 0, borderBottomRightRadius: 0,
          borderBottom: 'none', padding: '0 20px',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}
      >
        <div className="flex items-center">
          {filters.map(f => {
            const active = statusFilter === f;
            return (
              <button key={f} onClick={() => setStatusFilter(f)}
                style={{
                  padding: '11px 14px', fontSize: 13, fontWeight: active ? 600 : 400,
                  color: active ? '#0F172A' : '#9CA3AF', background: 'none', border: 'none', cursor: 'pointer',
                  borderBottom: active ? '2px solid #0F172A' : '2px solid transparent', marginBottom: -1,
                }}>
                {f}
              </button>
            );
          })}
        </div>
        <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
          <Search size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10 }} />
          <input
            type="text" placeholder="제목, 위치, 분류 검색" value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            style={{
              paddingLeft: 30, paddingRight: searchQuery ? 28 : 10, paddingTop: 6, paddingBottom: 6,
              fontSize: 12, border: '1px solid #E5E7EB', borderRadius: 4,
              outline: 'none', background: '#F9FAFB', color: '#374151', width: 220,
            }}
          />
          {searchQuery && (
            <button onClick={() => setSearchQuery('')} style={{ position: 'absolute', right: 8, background: 'none', border: 'none', cursor: 'pointer', display: 'flex' }}>
              <X size={12} color="#9CA3AF" />
            </button>
          )}
        </div>
      </div>

      {/* Report table */}
      <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, borderTopLeftRadius: 0, borderTopRightRadius: 0, overflow: 'hidden' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ background: '#F9FAFB', borderBottom: '1px solid #F3F4F6' }}>
              {['분류','제목','위치','신고일','위험','상태','조회','신고자',''].map(h => (
                <th key={h} style={{ padding: '9px 16px', textAlign: 'left', fontSize: 11, fontWeight: 600, color: '#9CA3AF', letterSpacing: '0.04em', whiteSpace: 'nowrap' }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {filtered.length === 0 ? (
              <tr><td colSpan={9} style={{ padding: 48, textAlign: 'center', color: '#9CA3AF', fontSize: 13 }}>검색 결과가 없습니다.</td></tr>
            ) : filtered.map(report => {
              const CatIcon = CATEGORY_META[report.category].icon;
              return (
                <tr
                  key={report.id}
                  style={{ borderBottom: '1px solid #F9FAFB', cursor: 'pointer' }}
                  onClick={() => onNavigate('report-board-detail')}
                  onMouseEnter={e => (e.currentTarget as HTMLElement).style.background = '#FAFAFA'}
                  onMouseLeave={e => (e.currentTarget as HTMLElement).style.background = 'transparent'}
                >
                  <td style={{ padding: '10px 16px' }}>
                    <CatIcon size={14} color="#9CA3AF" />
                  </td>
                  <td style={{ padding: '10px 16px', maxWidth: 280 }}>
                    <p style={{ fontWeight: 500, color: '#0F172A', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{report.title}</p>
                    <p style={{ fontSize: 11, color: '#9CA3AF', marginTop: 1 }}>{report.category}</p>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <span style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 12, color: '#6B7280' }}>
                      <MapPin size={11} color="#9CA3AF" /> {report.location}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px', fontSize: 12, color: '#6B7280' }}>
                    <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                      <Clock size={11} color="#9CA3AF" /> {report.date}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <span style={{ fontSize: 10, fontWeight: 600, padding: '1px 7px', borderRadius: 3, background: RISK_BG[report.risk], color: RISK_COLOR[report.risk] }}>
                      {RISK_LABEL[report.risk]}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <span style={{ fontSize: 11, fontWeight: 500, padding: '2px 8px', borderRadius: 3, background: STATUS_BG[report.status], color: STATUS_COLOR[report.status] }}>
                      {report.status}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <span style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 12, color: '#9CA3AF' }}>
                      <Eye size={11} /> {report.views}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <span style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 12, color: '#6B7280' }}>
                      {report.anonymous ? <><EyeOff size={11} color="#9CA3AF" /> 익명</> : report.reporter}
                    </span>
                  </td>
                  <td style={{ padding: '10px 16px' }}>
                    <ChevronRight size={14} color="#D1D5DB" />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
        <div style={{ padding: '10px 20px', borderTop: '1px solid #F3F4F6' }}>
          <span style={{ fontSize: 12, color: '#9CA3AF' }}>{filtered.length}건 표시 / 전체 {reports.length}건</span>
        </div>
      </div>

      {/* New report modal */}
      {showForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center" style={{ background: 'rgba(0,0,0,0.35)' }}>
          <div style={{ background: 'white', borderRadius: 6, width: '100%', maxWidth: 480, maxHeight: '88vh', overflow: 'hidden', display: 'flex', flexDirection: 'column', boxShadow: '0 8px 32px rgba(0,0,0,0.12)' }}>
            {/* Modal header */}
            <div style={{ padding: '16px 24px', borderBottom: '1px solid #F3F4F6', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <h2 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A' }}>신고하기</h2>
              <button aria-label="닫기" onClick={() => setShowForm(false)} style={{ background: 'none', border: 'none', cursor: 'pointer' }}>
                <X size={16} color="#9CA3AF" />
              </button>
            </div>

            <div style={{ padding: '20px 24px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 14 }}>
              {/* Anonymous toggle */}
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 14px', background: '#F9FAFB', border: '1px solid #E5E7EB', borderRadius: 4 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  {form.anonymous ? <EyeOff size={14} color="#9CA3AF" /> : <Eye size={14} color="#1A2E44" />}
                  <div>
                    <p style={{ fontSize: 13, fontWeight: 500, color: '#374151' }}>{form.anonymous ? '익명 신고' : '실명 신고'}</p>
                    <p style={{ fontSize: 11, color: '#9CA3AF' }}>신고자 정보는 관리자만 확인 가능</p>
                  </div>
                </div>
                <button
                  onClick={() => setForm(f => ({ ...f, anonymous: !f.anonymous }))}
                  style={{
                    width: 40, height: 22, borderRadius: 11, border: 'none', cursor: 'pointer',
                    background: form.anonymous ? '#1A2E44' : '#D1D5DB', position: 'relative', flexShrink: 0,
                  }}
                >
                  <div style={{
                    position: 'absolute', top: 2, width: 18, height: 18, background: 'white', borderRadius: '50%',
                    transition: 'left 0.15s', left: form.anonymous ? 20 : 2,
                  }} />
                </button>
              </div>

              {/* Title */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>제목 <span style={{ color: '#991B1B' }}>*</span></label>
                <input type="text" value={form.title} onChange={e => setForm(f => ({ ...f, title: e.target.value }))}
                  placeholder="신고 내용을 간략히 입력하세요" style={inputStyle} />
              </div>

              {/* Category + Risk */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>분류</label>
                  <select value={form.category} onChange={e => setForm(f => ({ ...f, category: e.target.value as ReportCategory }))}
                    style={{ ...inputStyle, appearance: 'none' }}>
                    {Object.keys(CATEGORY_META).map(c => <option key={c}>{c}</option>)}
                  </select>
                </div>
                <div>
                  <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위험도</label>
                  <select value={form.risk} onChange={e => setForm(f => ({ ...f, risk: e.target.value as 'high'|'medium'|'low' }))}
                    style={{ ...inputStyle, appearance: 'none' }}>
                    <option value="high">높음</option>
                    <option value="medium">중간</option>
                    <option value="low">낮음</option>
                  </select>
                </div>
              </div>

              {/* Location */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>위치 <span style={{ color: '#991B1B' }}>*</span></label>
                <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                  <MapPin size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10 }} />
                  <input type="text" value={form.location} onChange={e => setForm(f => ({ ...f, location: e.target.value }))}
                    placeholder="예: 3동 옥상, 지하 주차장" style={{ ...inputStyle, paddingLeft: 28 }} />
                </div>
              </div>

              {/* Description */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>상세 내용 <span style={{ color: '#991B1B' }}>*</span></label>
                <textarea value={form.description} onChange={e => setForm(f => ({ ...f, description: e.target.value }))}
                  placeholder="발견한 위험 상황이나 안전 위반 사항을 구체적으로 설명해주세요."
                  rows={4} style={{ ...inputStyle, resize: 'none', padding: '8px 12px' }} />
              </div>

              {/* Photo attachment */}
              <div>
                <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, marginBottom: 8, display: 'flex', alignItems: 'center', gap: 5 } as React.CSSProperties}>
                  <Camera size={13} color="#6B7280" /> 사진 첨부
                </label>
                <div
                  style={{ border: '1px dashed #D1D5DB', borderRadius: 4, padding: '20px', textAlign: 'center', cursor: 'pointer', background: '#FAFAFA' }}
                  onClick={() => photoInputRef.current?.click()}
                >
                  <ImageIcon size={20} color="#D1D5DB" style={{ margin: '0 auto 8px' }} />
                  <p style={{ fontSize: 12, color: '#6B7280', fontWeight: 500 }}>클릭하여 사진 추가</p>
                  <p style={{ fontSize: 11, color: '#9CA3AF', marginTop: 2 }}>JPG, PNG, WEBP · 여러 장 선택 가능</p>
                  <input ref={photoInputRef} type="file" multiple accept="image/jpeg,image/png,image/webp,image/gif"
                    className="hidden" onChange={handlePhotoAdd} />
                </div>
                {attachedPhotos.length > 0 && (
                  <div className="grid grid-cols-2 gap-2 mt-2">
                    {attachedPhotos.map(p => (
                      <div key={p.id} style={{ border: '1px solid #E5E7EB', borderRadius: 4, overflow: 'hidden' }}>
                        <img src={p.previewUrl} alt="첨부" style={{ width: '100%', height: 80, objectFit: 'cover', display: 'block' }} />
                        <div style={{ padding: '6px 8px', display: 'flex', gap: 6 }}>
                          <input type="text" placeholder="설명 (선택)" value={p.caption} onChange={e => updateCaption(p.id, e.target.value)}
                            style={{ flex: 1, fontSize: 11, border: '1px solid #E5E7EB', borderRadius: 3, padding: '3px 6px', outline: 'none' }} />
                          <button onClick={() => removePhoto(p.id)} style={{ background: 'none', border: 'none', cursor: 'pointer' }}>
                            <X size={12} color="#9CA3AF" />
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              <div style={{ padding: '10px 14px', background: '#EFF6FF', border: '1px solid #BFDBFE', borderRadius: 4, fontSize: 12, color: '#1E40AF' }}>
                신고 내용은 현장 안전 관리자 및 담당 부서에 전달됩니다. 익명 신고 시 신고자 정보는 보호됩니다.
              </div>

              <div className="flex gap-2">
                <button onClick={() => setShowForm(false)}
                  style={{ flex: 1, padding: '9px', fontSize: 13, background: 'white', color: '#374151', border: '1px solid #E5E7EB', borderRadius: 4, cursor: 'pointer' }}>
                  취소
                </button>
                <button onClick={handleSubmit}
                  style={{ flex: 1, padding: '9px', fontSize: 13, fontWeight: 600, background: '#1A2E44', color: 'white', border: 'none', borderRadius: 4, cursor: 'pointer' }}>
                  신고 접수
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
