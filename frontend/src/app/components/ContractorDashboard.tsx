import { useState } from 'react';
import Layout from './Layout';
import { ArrowUpRight, ArrowDownRight, Minus, ChevronRight, AlertTriangle } from 'lucide-react';

interface ContractorDashboardProps {
  onNavigate: (page: string) => void;
}

const KPI = [
  { label: '전체 현장', value: '5', unit: '개', delta: null },
  { label: '미조치 위험요소', value: '18', unit: '건', delta: { dir: 'down', val: '5', good: true } },
  { label: '진행중 조치', value: '42', unit: '건', delta: { dir: 'up', val: '8', good: false } },
  { label: '기한 초과', value: '7', unit: '건', delta: { dir: 'up', val: '3', good: false } },
  { label: '완료율', value: '74', unit: '%', delta: { dir: 'up', val: '4%p', good: true } },
];

type RiskLevel = 'high' | 'medium' | 'low';
type ActionStatus = 'pending' | 'inProgress' | 'completed';

interface Issue {
  id: string;
  grade: RiskLevel;
  location: string;
  type: string;
  company: string;
  status: ActionStatus;
  deadline: string;
  updated: string;
}

const ISSUES: Issue[] = [
  { id: 'SR-001', grade: 'high',   location: '3동 옥상',     type: '안전난간 미설치', company: '(주)한국건설', status: 'pending',    deadline: '2026-08-09', updated: '2시간 전' },
  { id: 'SR-002', grade: 'high',   location: '지하 1층',     type: '임시 배선 노출',  company: '대성철골(주)', status: 'inProgress', deadline: '2026-08-09', updated: '4시간 전' },
  { id: 'SR-003', grade: 'medium', location: '2동 전기실',   type: '전선 노출',       company: '미래전기설비', status: 'inProgress', deadline: '2026-08-12', updated: '1일 전' },
  { id: 'SR-004', grade: 'medium', location: '5동 옥상',     type: '안전난간 파손',   company: '(주)한국건설', status: 'pending',    deadline: '2026-08-14', updated: '2일 전' },
  { id: 'SR-005', grade: 'low',    location: '4동 1층',      type: '소화기 미배치',   company: '안전파트너스', status: 'inProgress', deadline: '2026-08-20', updated: '3일 전' },
  { id: 'SR-006', grade: 'medium', location: '1동 출입구',   type: '비상구 표시 미비', company: '미래전기설비', status: 'completed', deadline: '2026-08-05', updated: '5일 전' },
  { id: 'SR-007', grade: 'high',   location: '2동 3층',      type: '작업발판 불량',   company: '대성철골(주)', status: 'pending',    deadline: '2026-08-10', updated: '6시간 전' },
  { id: 'SR-008', grade: 'low',    location: '지하 주차장',  type: '환기시설 미작동', company: '안전파트너스', status: 'inProgress', deadline: '2026-08-18', updated: '1일 전' },
];

const SUBCONTRACTORS = [
  { name: '(주)한국건설', total: 45, pending: 8,  completion: 82 },
  { name: '대성철골(주)', total: 38, pending: 14, completion: 63 },
  { name: '미래전기설비', total: 29, pending: 3,  completion: 90 },
  { name: '안전파트너스', total: 22, pending: 7,  completion: 68 },
];

const RISK_LABEL: Record<RiskLevel, string>  = { high: '높음', medium: '중간', low: '낮음' };
const RISK_COLOR: Record<RiskLevel, string>  = { high: '#991B1B', medium: '#B45309', low: '#166534' };
const RISK_BG:    Record<RiskLevel, string>  = { high: '#FEF2F2', medium: '#FFFBEB', low: '#F0FDF4' };
const STATUS_LABEL: Record<ActionStatus, string> = { pending: '요청중', inProgress: '진행중', completed: '완료' };
const STATUS_COLOR: Record<ActionStatus, string> = { pending: '#B45309', inProgress: '#1D4ED8', completed: '#166534' };
const STATUS_BG:   Record<ActionStatus, string> = { pending: '#FFFBEB', inProgress: '#EFF6FF', completed: '#F0FDF4' };

const today = new Date();
const isOverdue = (d: string) => new Date(d) < today;

export default function ContractorDashboard({ onNavigate }: ContractorDashboardProps) {
  const [gradeFilter, setGradeFilter] = useState<'all' | RiskLevel>('all');
  const [statusFilter, setStatusFilter] = useState<'all' | ActionStatus>('all');

  const filtered = ISSUES.filter(i => {
    const g = gradeFilter === 'all' || i.grade === gradeFilter;
    const s = statusFilter === 'all' || i.status === statusFilter;
    return g && s;
  });

  return (
    <Layout currentPath="dashboard" onNavigate={onNavigate} userType="contractor">
      {/* Page header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>
            현황 개요
          </p>
          <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1 }}>대시보드</h1>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => onNavigate('upload')}
            style={{
              padding: '7px 14px', fontSize: 12, fontWeight: 500,
              background: 'white', color: '#374151', border: '1px solid #E2E6EA',
              borderRadius: 4, cursor: 'pointer',
              boxShadow: '0 1px 2px rgba(0,0,0,0.04)',
            }}
          >
            사진 등록
          </button>
          <button
            onClick={() => onNavigate('actions')}
            style={{
              padding: '7px 16px', fontSize: 12, fontWeight: 500,
              background: '#1A2E44', color: 'white', border: 'none',
              borderRadius: 4, cursor: 'pointer',
            }}
          >
            조치 등록
          </button>
        </div>
      </div>

      {/* ── KPI Row ── */}
      <div className="grid gap-3 mb-6" style={{ gridTemplateColumns: 'repeat(5, 1fr)' }}>
        {KPI.map(k => (
          <div
            key={k.label}
            style={{
              background: 'white', border: '1px solid #E2E6EA',
              borderRadius: 4, padding: '16px 18px',
              boxShadow: '0 1px 3px rgba(0,0,0,0.03)',
            }}
          >
            <p style={{ fontSize: 11, color: '#9CA3AF', marginBottom: 10, fontWeight: 400, letterSpacing: '0.01em' }}>{k.label}</p>
            <div className="flex items-end gap-1.5">
              <span style={{ fontSize: 26, fontWeight: 700, color: '#0F172A', lineHeight: 1, letterSpacing: '-0.03em' }}>
                {k.value}
              </span>
              <span style={{ fontSize: 12, color: '#CBD5E1', marginBottom: 2, fontWeight: 400 }}>{k.unit}</span>
            </div>
            {k.delta && (
              <div className="flex items-center gap-1 mt-2.5">
                {k.delta.dir === 'up' ? (
                  <ArrowUpRight size={11} color={k.delta.good ? '#16A34A' : '#DC2626'} />
                ) : (
                  <ArrowDownRight size={11} color={k.delta.good ? '#16A34A' : '#DC2626'} />
                )}
                <span style={{ fontSize: 10, color: k.delta.good ? '#16A34A' : '#DC2626', fontWeight: 500 }}>
                  {k.delta.val} 전주 대비
                </span>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* ── Main grid ── */}
      <div className="grid gap-5" style={{ gridTemplateColumns: '1fr 300px' }}>

        {/* Issues table */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4 }}>
          {/* Table toolbar */}
          <div
            className="flex items-center justify-between"
            style={{ padding: '14px 20px', borderBottom: '1px solid #F3F4F6' }}
          >
            <span style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>위험요소 현황</span>
            <div className="flex items-center gap-2">
              {/* Grade filter */}
              <div className="flex items-center gap-1">
                {(['all', 'high', 'medium', 'low'] as const).map(g => (
                  <button
                    key={g}
                    onClick={() => setGradeFilter(g)}
                    style={{
                      padding: '3px 10px', fontSize: 12, borderRadius: 3, cursor: 'pointer',
                      border: '1px solid',
                      borderColor: gradeFilter === g ? '#1A2E44' : '#E5E7EB',
                      background: gradeFilter === g ? '#1A2E44' : 'white',
                      color: gradeFilter === g ? 'white' : '#6B7280',
                      fontWeight: gradeFilter === g ? 500 : 400,
                    }}
                  >
                    {g === 'all' ? '전체' : RISK_LABEL[g]}
                  </button>
                ))}
              </div>
              <div style={{ width: 1, height: 16, background: '#E5E7EB' }} />
              {/* Status filter */}
              {(['all', 'pending', 'inProgress', 'completed'] as const).map(s => (
                <button
                  key={s}
                  onClick={() => setStatusFilter(s)}
                  style={{
                    padding: '3px 10px', fontSize: 12, borderRadius: 3, cursor: 'pointer',
                    border: '1px solid',
                    borderColor: statusFilter === s ? '#1A2E44' : '#E5E7EB',
                    background: statusFilter === s ? '#1A2E44' : 'white',
                    color: statusFilter === s ? 'white' : '#6B7280',
                    fontWeight: statusFilter === s ? 500 : 400,
                  }}
                >
                  {s === 'all' ? '전체' : STATUS_LABEL[s]}
                </button>
              ))}
            </div>
          </div>

          {/* Table */}
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#F9FAFB' }}>
                  {['위험등급', '위치', '위험유형', '담당업체', '조치상태', '마감기한', '최근 업데이트', ''].map(h => (
                    <th
                      key={h}
                      style={{
                        padding: '9px 16px', textAlign: 'left',
                        fontSize: 11, fontWeight: 600, color: '#9CA3AF',
                        letterSpacing: '0.04em', textTransform: 'uppercase',
                        borderBottom: '1px solid #F3F4F6', whiteSpace: 'nowrap',
                      }}
                    >
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {filtered.map((issue, idx) => {
                  const overdue = isOverdue(issue.deadline) && issue.status !== 'completed';
                  return (
                    <tr
                      key={issue.id}
                      onClick={() => onNavigate('actions-detail')}
                      style={{
                        borderBottom: idx < filtered.length - 1 ? '1px solid #F9FAFB' : 'none',
                        cursor: 'pointer', transition: 'background 0.1s',
                      }}
                      onMouseEnter={e => (e.currentTarget.style.background = '#FAFAFA')}
                      onMouseLeave={e => (e.currentTarget.style.background = 'transparent')}
                    >
                      <td style={{ padding: '11px 16px' }}>
                        <span
                          style={{
                            display: 'inline-flex', alignItems: 'center', gap: 4,
                            padding: '2px 8px', borderRadius: 3, fontSize: 11, fontWeight: 600,
                            background: RISK_BG[issue.grade], color: RISK_COLOR[issue.grade],
                          }}
                        >
                          {RISK_LABEL[issue.grade]}
                        </span>
                      </td>
                      <td style={{ padding: '11px 16px', color: '#374151', fontWeight: 500 }}>
                        {issue.location}
                      </td>
                      <td style={{ padding: '11px 16px', color: '#0F172A', fontWeight: 500 }}>
                        {issue.type}
                      </td>
                      <td style={{ padding: '11px 16px', color: '#6B7280' }}>
                        {issue.company}
                      </td>
                      <td style={{ padding: '11px 16px' }}>
                        <span
                          style={{
                            display: 'inline-block', padding: '2px 8px', borderRadius: 3,
                            fontSize: 11, fontWeight: 500,
                            background: STATUS_BG[issue.status], color: STATUS_COLOR[issue.status],
                          }}
                        >
                          {STATUS_LABEL[issue.status]}
                        </span>
                      </td>
                      <td style={{ padding: '11px 16px' }}>
                        <span style={{ color: overdue ? '#991B1B' : '#6B7280', fontWeight: overdue ? 600 : 400 }}>
                          {issue.deadline}
                          {overdue && (
                            <span
                              style={{
                                marginLeft: 4, fontSize: 10, padding: '1px 5px',
                                background: '#FEF2F2', color: '#991B1B', borderRadius: 3,
                              }}
                            >
                              초과
                            </span>
                          )}
                        </span>
                      </td>
                      <td style={{ padding: '11px 16px', color: '#9CA3AF', fontSize: 12 }}>
                        {issue.updated}
                      </td>
                      <td style={{ padding: '11px 16px' }}>
                        <ChevronRight size={14} color="#D1D5DB" />
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            {filtered.length === 0 && (
              <div style={{ padding: 48, textAlign: 'center', color: '#9CA3AF', fontSize: 13 }}>
                해당 조건의 위험요소가 없습니다.
              </div>
            )}
          </div>

          <div
            className="flex items-center justify-between"
            style={{ padding: '10px 20px', borderTop: '1px solid #F3F4F6' }}
          >
            <span style={{ fontSize: 12, color: '#9CA3AF' }}>
              {filtered.length}건 표시 / 전체 {ISSUES.length}건
            </span>
            <button
              onClick={() => onNavigate('actions')}
              className="flex items-center gap-1"
              style={{ fontSize: 12, color: '#1A2E44', fontWeight: 500, background: 'none', border: 'none', cursor: 'pointer' }}
            >
              전체 보기 <ChevronRight size={12} />
            </button>
          </div>
        </div>

        {/* Right sidebar */}
        <div className="flex flex-col gap-4">

          {/* Overdue alert */}
          {ISSUES.filter(i => isOverdue(i.deadline) && i.status !== 'completed').length > 0 && (
            <div
              style={{
                background: '#FEF2F2', border: '1px solid #FECACA',
                borderRadius: 4, padding: '14px 16px',
              }}
            >
              <div className="flex items-center gap-2 mb-2">
                <AlertTriangle size={13} color="#991B1B" />
                <span style={{ fontSize: 12, fontWeight: 600, color: '#991B1B' }}>
                  기한 초과 항목
                </span>
              </div>
              <div className="flex flex-col gap-2">
                {ISSUES.filter(i => isOverdue(i.deadline) && i.status !== 'completed').map(i => (
                  <div
                    key={i.id}
                    onClick={() => onNavigate('actions-detail')}
                    style={{ cursor: 'pointer' }}
                  >
                    <p style={{ fontSize: 12, fontWeight: 500, color: '#0F172A' }}>{i.type}</p>
                    <p style={{ fontSize: 11, color: '#9CA3AF', marginTop: 1 }}>{i.location} · {i.company}</p>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Subcontractor status */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4 }}>
            <div style={{ padding: '12px 16px', borderBottom: '1px solid #F3F4F6' }}>
              <span style={{ fontSize: 13, fontWeight: 600, color: '#0F172A' }}>협력사 조치 현황</span>
            </div>
            <div style={{ padding: '4px 0' }}>
              {SUBCONTRACTORS.map(sub => (
                <div
                  key={sub.name}
                  style={{
                    padding: '10px 16px',
                    borderBottom: '1px solid #F9FAFB',
                  }}
                >
                  <div className="flex items-center justify-between mb-1.5">
                    <span style={{ fontSize: 12, fontWeight: 500, color: '#0F172A' }}>{sub.name}</span>
                    <span
                      style={{
                        fontSize: 12, fontWeight: 600,
                        color: sub.completion >= 80 ? '#166534' : '#B45309',
                      }}
                    >
                      {sub.completion}%
                    </span>
                  </div>
                  <div
                    style={{
                      height: 4, background: '#F3F4F6', borderRadius: 2, overflow: 'hidden',
                    }}
                  >
                    <div
                      style={{
                        height: '100%', borderRadius: 2,
                        width: `${sub.completion}%`,
                        background: sub.completion >= 80 ? '#166534' : '#B45309',
                        transition: 'width 0.6s ease',
                      }}
                    />
                  </div>
                  <div className="flex items-center justify-between mt-1">
                    <span style={{ fontSize: 11, color: '#9CA3AF' }}>전체 {sub.total}건</span>
                    {sub.pending > 0 && (
                      <span style={{ fontSize: 11, color: '#991B1B' }}>미조치 {sub.pending}건</span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Quick links */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4 }}>
            <div style={{ padding: '12px 16px', borderBottom: '1px solid #F3F4F6' }}>
              <span style={{ fontSize: 13, fontWeight: 600, color: '#0F172A' }}>바로가기</span>
            </div>
            {[
              { label: '위험요소 사진 분석',  path: 'upload' },
              { label: '조치관리 전체 보기',  path: 'actions' },
              { label: '분석 리포트',         path: 'analytics' },
              { label: 'AI 결과보고서 생성',  path: 'ai-report' },
            ].map(link => (
              <button
                key={link.label}
                onClick={() => onNavigate(link.path)}
                className="w-full flex items-center justify-between"
                style={{
                  padding: '10px 16px', fontSize: 13, color: '#374151',
                  background: 'none', border: 'none', cursor: 'pointer',
                  borderBottom: '1px solid #F9FAFB', textAlign: 'left',
                }}
                onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = '#FAFAFA')}
                onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'none')}
              >
                {link.label}
                <ChevronRight size={13} color="#D1D5DB" />
              </button>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
}
