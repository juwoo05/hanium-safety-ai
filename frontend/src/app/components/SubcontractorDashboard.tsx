import Layout from './Layout';
import {
  AlertTriangle, Clock, FileText, Upload, FileSearch, Eye, CheckCircle2,
  ArrowRight, TrendingUp, TrendingDown, ArrowUpRight,
} from 'lucide-react';

interface SubcontractorDashboardProps {
  onNavigate: (page: string) => void;
}

const today = new Date().toLocaleDateString('ko-KR', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'short' });

export default function SubcontractorDashboard({ onNavigate }: SubcontractorDashboardProps) {
  const kpiData = [
    { label: '내 리포트 수', value: '45',   sub: '+8 이번 달', up: true,  icon: FileText },
    { label: '고위험 항목', value: '3',    sub: '-2 감소',    up: false, icon: AlertTriangle },
    { label: '진행 중 조치', value: '11',   sub: '+3 증가',   up: true,  icon: Clock },
    { label: '완료율',      value: '87%',  sub: '+5%p',       up: true,  icon: CheckCircle2 },
  ];

  const myTasks = [
    { title: '5층 외벽 안전망 점검', deadline: '오늘 18:00', priority: 'high',   status: '미완료' },
    { title: '작업자 안전장비 확인', deadline: '오늘 15:00', priority: 'high',   status: '진행 중' },
    { title: '전기 배선 임시 조치',  deadline: '내일',       priority: 'medium', status: '미완료' },
    { title: '소화기 위치 재배치',   deadline: '이번 주',    priority: 'low',    status: '완료' },
  ];

  const safetyScore = 87;

  const statusColor: Record<string, string> = {
    '완료':  '#166534', '진행 중': '#1D4ED8', '미완료': '#991B1B',
  };
  const statusBg: Record<string, string> = {
    '완료': '#F0FDF4', '진행 중': '#EFF6FF', '미완료': '#FEF2F2',
  };
  const priorityColor: Record<string, string> = { high: '#991B1B', medium: '#B45309', low: '#166534' };

  return (
    <Layout currentPath="dashboard" onNavigate={onNavigate} userType="subcontractor">
      {/* Page header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>현황 개요</p>
          <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1 }}>대시보드</h1>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => onNavigate('upload')}
            style={{
              display: 'flex', alignItems: 'center', gap: 6, padding: '7px 14px',
              background: '#1A2E44', color: 'white', border: 'none',
              borderRadius: 4, fontSize: 13, fontWeight: 500, cursor: 'pointer',
            }}
          >
            <Upload size={13} /> 사진 업로드
          </button>
        </div>
      </div>

      {/* KPI row */}
      <div className="grid grid-cols-4 gap-4 mb-5">
        {kpiData.map((kpi, i) => (
          <div key={i} style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 18px' }}>
            <div className="flex items-center justify-between mb-3">
              <kpi.icon size={15} color="#9CA3AF" />
              <span style={{ display: 'flex', alignItems: 'center', gap: 3, fontSize: 11, fontWeight: 500, color: kpi.up ? '#166534' : '#991B1B' }}>
                {kpi.up ? <TrendingUp size={11} /> : <TrendingDown size={11} />}
                {kpi.sub}
              </span>
            </div>
            <p style={{ fontSize: 11, color: '#9CA3AF', marginBottom: 3 }}>{kpi.label}</p>
            <p style={{ fontSize: 22, fontWeight: 700, color: '#0F172A' }}>{kpi.value}</p>
          </div>
        ))}
      </div>

      {/* Two-column layout */}
      <div className="grid gap-5" style={{ gridTemplateColumns: '1fr 300px' }}>
        {/* Left column */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
          {/* Safety score */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 20px' }}>
            <div className="flex items-center justify-between mb-3">
              <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>안전 점수</h3>
              <span style={{ fontSize: 20, fontWeight: 700, color: safetyScore >= 80 ? '#166534' : '#B45309' }}>{safetyScore}점</span>
            </div>
            <div style={{ width: '100%', height: 6, background: '#F3F4F6', borderRadius: 3, marginBottom: 6, overflow: 'hidden' }}>
              <div style={{ width: `${safetyScore}%`, height: '100%', background: safetyScore >= 80 ? '#166534' : '#B45309', borderRadius: 3, transition: 'width 0.4s' }} />
            </div>
            <div className="flex justify-between" style={{ fontSize: 11, color: '#9CA3AF' }}>
              <span>0</span>
              <span style={{ color: safetyScore >= 80 ? '#166534' : '#B45309', fontWeight: 500 }}>
                {safetyScore >= 90 ? '최우수' : safetyScore >= 80 ? '우수' : safetyScore >= 70 ? '양호' : '개선 필요'} ({safetyScore}/100)
              </span>
              <span>100</span>
            </div>
          </div>

          {/* My tasks */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, overflow: 'hidden' }}>
            <div className="flex items-center justify-between" style={{ padding: '14px 20px', borderBottom: '1px solid #F3F4F6' }}>
              <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>내 조치 목록</h3>
              <button onClick={() => onNavigate('actions')}
                style={{ fontSize: 12, color: '#1A2E44', background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4, fontWeight: 500 }}>
                전체 보기 <ArrowRight size={12} />
              </button>
            </div>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#F9FAFB', borderBottom: '1px solid #F3F4F6' }}>
                  {['','조치 항목','마감','상태'].map(h => (
                    <th key={h} style={{ padding: '8px 16px', textAlign: 'left', fontSize: 11, fontWeight: 600, color: '#9CA3AF', letterSpacing: '0.04em' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {myTasks.map((task, i) => (
                  <tr key={i} style={{ borderBottom: '1px solid #F9FAFB', cursor: 'pointer' }}
                    onClick={() => onNavigate('actions-detail')}
                    onMouseEnter={e => (e.currentTarget as HTMLElement).style.background = '#FAFAFA'}
                    onMouseLeave={e => (e.currentTarget as HTMLElement).style.background = 'transparent'}
                  >
                    <td style={{ padding: '10px 16px', width: 12 }}>
                      <span style={{ display: 'block', width: 8, height: 8, borderRadius: '50%', background: priorityColor[task.priority] }} />
                    </td>
                    <td style={{ padding: '10px 16px' }}>
                      <span style={{ fontWeight: 500, color: task.status === '완료' ? '#9CA3AF' : '#0F172A', textDecoration: task.status === '완료' ? 'line-through' : 'none' }}>
                        {task.title}
                      </span>
                    </td>
                    <td style={{ padding: '10px 16px', fontSize: 12, color: '#6B7280' }}>{task.deadline}</td>
                    <td style={{ padding: '10px 16px' }}>
                      <span style={{ fontSize: 11, fontWeight: 500, padding: '2px 8px', borderRadius: 3, background: statusBg[task.status], color: statusColor[task.status] }}>
                        {task.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Weekly chart */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 20px' }}>
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A', marginBottom: 16 }}>주간 위험 감지 현황</h3>
            <div style={{ display: 'flex', alignItems: 'flex-end', gap: 8, height: 100 }}>
              {[
                { id: 'mon', day: '월', value: 5 },
                { id: 'tue', day: '화', value: 9 },
                { id: 'wed', day: '수', value: 7 },
                { id: 'thu', day: '목', value: 12 },
                { id: 'fri', day: '금', value: 10 },
                { id: 'sat', day: '토', value: 3 },
                { id: 'sun', day: '일', value: 2 },
              ].map(d => {
                const max = 12;
                const pct = (d.value / max) * 100;
                return (
                  <div key={d.id} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                    <span style={{ fontSize: 10, color: '#9CA3AF' }}>{d.value}</span>
                    <div style={{ width: '100%', height: 72, display: 'flex', alignItems: 'flex-end' }}>
                      <div style={{ width: '100%', height: `${pct}%`, minHeight: 3, background: '#1A2E44', borderRadius: '2px 2px 0 0' }} />
                    </div>
                    <span style={{ fontSize: 10, color: '#9CA3AF' }}>{d.day}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Right column */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          {/* Quick actions */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 18px' }}>
            <h3 style={{ fontSize: 13, fontWeight: 600, color: '#0F172A', marginBottom: 12 }}>빠른 실행</h3>
            <div className="grid grid-cols-2 gap-2">
              {[
                { icon: Upload, label: '사진 업로드', page: 'upload' },
                { icon: FileSearch, label: '위험 분석', page: 'upload' },
                { icon: FileText, label: '조치 목록', page: 'actions' },
                { icon: Eye, label: '보고서 확인', page: 'actions-detail' },
              ].map((a, i) => (
                <button key={i} onClick={() => onNavigate(a.page)}
                  style={{
                    display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
                    padding: '12px 8px', background: '#F9FAFB', border: '1px solid #E5E7EB',
                    borderRadius: 4, cursor: 'pointer', fontSize: 11, color: '#374151', fontWeight: 500,
                  }}
                  onMouseEnter={e => (e.currentTarget as HTMLElement).style.background = '#F3F4F6'}
                  onMouseLeave={e => (e.currentTarget as HTMLElement).style.background = '#F9FAFB'}
                >
                  <a.icon size={16} color="#1A2E44" />
                  {a.label}
                </button>
              ))}
            </div>
          </div>

          {/* Urgent tasks */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 18px' }}>
            <h3 style={{ fontSize: 13, fontWeight: 600, color: '#0F172A', marginBottom: 10, display: 'flex', alignItems: 'center', gap: 6 }}>
              <AlertTriangle size={13} color="#991B1B" /> 긴급 조치 필요
            </h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {myTasks.filter(t => t.priority === 'high' && t.status !== '완료').map((t, i) => (
                <div key={i}
                  onClick={() => onNavigate('actions-detail')}
                  style={{ padding: '10px 12px', background: '#FEF2F2', border: '1px solid #FECACA', borderRadius: 4, cursor: 'pointer' }}
                  onMouseEnter={e => (e.currentTarget as HTMLElement).style.borderColor = '#FCA5A5'}
                  onMouseLeave={e => (e.currentTarget as HTMLElement).style.borderColor = '#FECACA'}
                >
                  <p style={{ fontSize: 12, fontWeight: 500, color: '#0F172A', marginBottom: 4 }}>{t.title}</p>
                  <div className="flex items-center justify-between">
                    <span style={{ fontSize: 11, color: '#991B1B' }}>마감: {t.deadline}</span>
                    <ArrowUpRight size={12} color="#991B1B" />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Performance */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 18px' }}>
            <h3 style={{ fontSize: 13, fontWeight: 600, color: '#0F172A', marginBottom: 12 }}>이번 달 성과</h3>
            {[
              { label: '리포트 제출', value: 45, max: 50, pct: 90 },
              { label: '조치 완료율', value: 87, max: 100, pct: 87 },
              { label: '기한 준수율', value: 92, max: 100, pct: 92 },
            ].map((item, i) => (
              <div key={i} style={{ marginBottom: i < 2 ? 12 : 0 }}>
                <div className="flex justify-between" style={{ marginBottom: 4 }}>
                  <span style={{ fontSize: 12, color: '#374151', fontWeight: 500 }}>{item.label}</span>
                  <span style={{ fontSize: 12, fontWeight: 700, color: '#0F172A' }}>{item.value}{item.max === 100 ? '%' : `/${item.max}`}</span>
                </div>
                <div style={{ width: '100%', height: 4, background: '#F3F4F6', borderRadius: 2 }}>
                  <div style={{ width: `${item.pct}%`, height: '100%', background: '#1A2E44', borderRadius: 2, transition: 'width 0.4s' }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
}
