import { useState } from 'react';
import Layout from './Layout';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { TrendingUp, TrendingDown, Download, BarChart3, AlertTriangle, CheckCircle2, Clock, ArrowUp, ArrowDown, Minus } from 'lucide-react';
import { toast } from 'sonner';
import { downloadCsv } from '../utils/demoFiles';

interface AnalyticsProps {
  onNavigate: (page: string) => void;
}

const monthlyData = {
  '1개월': [
    { month: '6/1', high: 3, medium: 7, low: 5, completed: 12 },
    { month: '6/7', high: 2, medium: 5, low: 8, completed: 15 },
    { month: '6/14', high: 4, medium: 6, low: 6, completed: 10 },
    { month: '6/21', high: 1, medium: 8, low: 9, completed: 18 },
    { month: '6/28', high: 2, medium: 4, low: 7, completed: 14 },
  ],
  '3개월': [
    { month: '4월', high: 12, medium: 18, low: 15, completed: 38 },
    { month: '5월', high: 8,  medium: 22, low: 19, completed: 52 },
    { month: '6월', high: 5,  medium: 24, low: 25, completed: 69 },
  ],
  '6개월': [
    { month: '1월', high: 18, medium: 22, low: 12, completed: 28 },
    { month: '2월', high: 15, medium: 25, low: 14, completed: 35 },
    { month: '3월', high: 14, medium: 20, low: 18, completed: 42 },
    { month: '4월', high: 12, medium: 18, low: 15, completed: 38 },
    { month: '5월', high: 8,  medium: 22, low: 19, completed: 52 },
    { month: '6월', high: 5,  medium: 24, low: 25, completed: 69 },
  ],
  '1년': [
    { month: '1월', high: 20, medium: 25, low: 10, completed: 22 },
    { month: '2월', high: 18, medium: 22, low: 12, completed: 28 },
    { month: '3월', high: 15, medium: 25, low: 14, completed: 35 },
    { month: '4월', high: 14, medium: 20, low: 18, completed: 42 },
    { month: '5월', high: 12, medium: 18, low: 15, completed: 38 },
    { month: '6월', high: 10, medium: 21, low: 17, completed: 46 },
    { month: '7월', high: 9,  medium: 23, low: 20, completed: 50 },
    { month: '8월', high: 8,  medium: 22, low: 22, completed: 55 },
    { month: '9월', high: 7,  medium: 24, low: 21, completed: 58 },
    { month: '10월', high: 6, medium: 23, low: 23, completed: 62 },
    { month: '11월', high: 5, medium: 24, low: 24, completed: 66 },
    { month: '12월', high: 5, medium: 24, low: 25, completed: 69 },
  ],
};

const siteStats = [
  { name: '1동', total: 45, pending: 4, inProgress: 8, verification: 3, completed: 30, rate: 67 },
  { name: '2동', total: 38, pending: 2, inProgress: 6, verification: 4, completed: 26, rate: 68 },
  { name: '3동', total: 58, pending: 7, inProgress: 12, verification: 5, completed: 34, rate: 59 },
  { name: '4동', total: 28, pending: 1, inProgress: 4, verification: 2, completed: 21, rate: 75 },
  { name: '5동', total: 41, pending: 3, inProgress: 7, verification: 3, completed: 28, rate: 68 },
  { name: '지하', total: 37, pending: 5, inProgress: 9, verification: 3, completed: 20, rate: 54 },
];

const statusData = [
  { name: '조치 전', value: 22, color: '#ef4444' },
  { name: '조치 중', value: 46, color: '#f97316' },
  { name: '검증 중', value: 18, color: '#3b82f6' },
  { name: '완료',   value: 161, color: '#22c55e' },
];

const riskData = [
  { name: '고위험', value: 22, color: '#ef4444' },
  { name: '중위험', value: 45, color: '#f97316' },
  { name: '저위험', value: 180, color: '#eab308' },
];

const managerStats = [
  { name: '이관리', assigned: 31, completed: 29, rate: 94, onTime: 97, trend: 'up'   as const },
  { name: '김현장', assigned: 42, completed: 36, rate: 86, onTime: 92, trend: 'same' as const },
  { name: '박안전', assigned: 38, completed: 32, rate: 84, onTime: 88, trend: 'down' as const },
];

const aiInsights = [
  { type: 'warn'  as const, text: '3동·지하 구역이 전체 미완료 조치의 62%를 차지합니다. 해당 구역 우선 대응이 필요합니다.' },
  { type: 'good'  as const, text: '고위험 감소율 42% 달성 — 전월 대비 12%p 개선. 안전난간 집중 관리 효과로 분석됩니다.' },
  { type: 'alert' as const, text: '대성철골(주)의 기한 초과 조치가 3건입니다. 담당자 재배정을 검토하세요.' },
  { type: 'info'  as const, text: '이관리 담당자 온타임율 97% 유지 중 — 우수 사례 공유를 권장합니다.' },
];

function DonutChart({ data, size = 120 }: { data: { name: string; value: number; color: string }[]; size?: number }) {
  const total = data.reduce((s, d) => s + d.value, 0);
  const r = size * 0.33;
  const cx = size / 2;
  const cy = size / 2;
  const strokeW = size * 0.16;
  const circ = 2 * Math.PI * r;
  let offset = 0;
  return (
    <div className="flex items-center gap-4">
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="flex-shrink-0">
        {data.map(d => {
          const pct = (d.value / total) * 100;
          const seg = (
            <circle
              key={d.name}
              cx={cx} cy={cy} r={r}
              fill="none"
              stroke={d.color}
              strokeWidth={strokeW}
              strokeDasharray={`${(pct / 100) * circ} ${circ}`}
              strokeDashoffset={-((offset / 100) * circ)}
              transform={`rotate(-90 ${cx} ${cy})`}
            />
          );
          offset += pct;
          return seg;
        })}
        <text x={cx} y={cy - 5} textAnchor="middle" fill="#111827" fontSize={size * 0.12} fontWeight="700">{total}</text>
        <text x={cx} y={cy + size * 0.1} textAnchor="middle" fill="#9CA3AF" fontSize={size * 0.08}>전체</text>
      </svg>
      <div className="space-y-2">
        {data.map(d => (
          <div key={d.name} className="flex items-center gap-2 text-sm">
            <span className="w-2.5 h-2.5 rounded-full flex-shrink-0" style={{ background: d.color }} />
            <span style={{ color: '#6B7280', width: 56, fontSize: 12 }}>{d.name}</span>
            <span style={{ fontWeight: 700, color: '#0F172A', fontSize: 12 }}>{d.value}</span>
            <span style={{ color: '#9CA3AF', fontSize: 11 }}>({Math.round(d.value / total * 100)}%)</span>
          </div>
        ))}
      </div>
    </div>
  );
}

export default function Analytics({ onNavigate }: AnalyticsProps) {
  const [period, setPeriod] = useState<keyof typeof monthlyData>('6개월');
  const [activeMetric, setActiveMetric] = useState<'risk' | 'completed'>('risk');

  const trend = monthlyData[period];

  const metrics = [
    { label: '월간 완료율',   value: '87%',    change: '+5%',   up: true,  icon: CheckCircle2 },
    { label: '평균 처리 기간', value: '2.3일',  change: '-0.5일', up: true,  icon: Clock },
    { label: '고위험 감소율',  value: '42%',    change: '+12%p', up: true,  icon: AlertTriangle },
    { label: '재발 조치',      value: '3건',    change: '-2건',  up: true,  icon: BarChart3 },
  ];

  const insightCfg = {
    warn:  { border: '#FED7AA', bg: '#FFFBEB', dot: '#D97706', text: '#92400E' },
    good:  { border: '#BBF7D0', bg: '#F0FDF4', dot: '#16A34A', text: '#14532D' },
    alert: { border: '#FECACA', bg: '#FEF2F2', dot: '#DC2626', text: '#7F1D1D' },
    info:  { border: '#BFDBFE', bg: '#EFF6FF', dot: '#2563EB', text: '#1E3A8A' },
  };

  return (
    <Layout currentPath="analytics" onNavigate={onNavigate}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>
              통계 현황
            </p>
            <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1 }}>분석 리포트</h1>
          </div>
          <div className="flex items-center gap-2">
            <div className="flex items-center" style={{ background: '#F3F4F6', borderRadius: 4, padding: 3, gap: 1 }}>
              {(Object.keys(monthlyData) as (keyof typeof monthlyData)[]).map(p => (
                <button
                  key={p}
                  onClick={() => setPeriod(p)}
                  style={{
                    padding: '4px 10px', fontSize: 12, fontWeight: period === p ? 600 : 400, borderRadius: 3,
                    background: period === p ? 'white' : 'transparent',
                    color: period === p ? '#0F172A' : '#9CA3AF',
                    border: 'none', cursor: 'pointer',
                    boxShadow: period === p ? '0 1px 3px rgba(0,0,0,0.1)' : 'none',
                  }}
                >
                  {p}
                </button>
              ))}
            </div>
            <button
              onClick={() => {
                downloadCsv(
                  `안전분석_${period}_${new Date().toISOString().slice(0, 10)}.csv`,
                  ['기간', '고위험', '중위험', '저위험', '완료'],
                  trend.map(item => [item.month, item.high, item.medium, item.low, item.completed])
                );
                toast.success(`${period} 분석 데이터를 CSV로 내보냈습니다.`);
              }}
              style={{
                display: 'flex', alignItems: 'center', gap: 6, padding: '7px 12px',
                background: 'white', color: '#374151', border: '1px solid #E5E7EB',
                borderRadius: 4, fontSize: 12, fontWeight: 500, cursor: 'pointer',
              }}
            >
              <Download size={13} /> 내보내기
            </button>
          </div>
        </div>

        {/* KPI */}
        <div className="grid grid-cols-4 gap-3">
          {metrics.map((m, i) => (
            <div key={i} style={{ background: 'white', border: '1px solid #E2E6EA', borderRadius: 4, padding: '16px 18px', boxShadow: '0 1px 3px rgba(0,0,0,0.03)' }}>
              <div className="flex items-center justify-between mb-3">
                <m.icon size={14} color="#C4CBD4" strokeWidth={1.5} />
                <span style={{ fontSize: 10, fontWeight: 600, color: m.up ? '#16A34A' : '#DC2626', display: 'flex', alignItems: 'center', gap: 2 }}>
                  {m.up ? <TrendingUp size={10} /> : <TrendingDown size={10} />}
                  {m.change}
                </span>
              </div>
              <p style={{ fontSize: 10, color: '#9CA3AF', marginBottom: 5, letterSpacing: '0.01em' }}>{m.label}</p>
              <p style={{ fontSize: 22, fontWeight: 700, color: '#0F172A', letterSpacing: '-0.03em' }}>{m.value}</p>
            </div>
          ))}
        </div>

        {/* AI Insights */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 20px' }}>
          <div className="flex items-center justify-between mb-3">
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>주요 지표 분석</h3>
            <span style={{ fontSize: 11, color: '#9CA3AF' }}>{period} 기준 자동 분석</span>
          </div>
          <div className="grid grid-cols-2 gap-2">
            {aiInsights.map((ins, i) => {
              const cfg = insightCfg[ins.type];
              return (
                <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: 8, padding: '10px 12px', background: cfg.bg, border: `1px solid ${cfg.border}`, borderRadius: 4 }}>
                  <span style={{ width: 6, height: 6, borderRadius: '50%', background: cfg.dot, flexShrink: 0, marginTop: 4 }} />
                  <p style={{ fontSize: 12, lineHeight: 1.5, color: cfg.text }}>{ins.text}</p>
                </div>
              );
            })}
          </div>
        </div>

        {/* Trend chart */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '18px 20px' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>월별 위험도 추이</h3>
            <div className="flex items-center" style={{ background: '#F3F4F6', borderRadius: 4, padding: 3, gap: 1 }}>
              {[['risk','위험도별'],['completed','완료 건수']].map(([k, l]) => (
                <button key={k}
                  onClick={() => setActiveMetric(k as 'risk' | 'completed')}
                  style={{
                    padding: '4px 10px', fontSize: 11, fontWeight: activeMetric === k ? 600 : 400, borderRadius: 3,
                    background: activeMetric === k ? 'white' : 'transparent',
                    color: activeMetric === k ? '#0F172A' : '#9CA3AF', border: 'none', cursor: 'pointer',
                    boxShadow: activeMetric === k ? '0 1px 3px rgba(0,0,0,0.1)' : 'none',
                  }}
                >
                  {l}
                </button>
              ))}
            </div>
          </div>
          <div style={{ height: 240 }}>
            <ResponsiveContainer width="100%" height="100%">
              {activeMetric === 'risk' ? (
                <LineChart key="risk-chart" data={trend} margin={{ top: 5, right: 20, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis dataKey="month" stroke="#9CA3AF" tick={{ fontSize: 11 }} />
                  <YAxis stroke="#9CA3AF" tick={{ fontSize: 11 }} />
                  <Tooltip contentStyle={{ borderRadius: 4, border: '1px solid #E5E7EB', fontSize: 12 }} />
                  <Legend iconType="circle" iconSize={7} wrapperStyle={{ fontSize: 11 }} />
                  <Line type="monotone" dataKey="high"   stroke="#ef4444" strokeWidth={2} dot={{ r: 3 }} name="고위험" />
                  <Line type="monotone" dataKey="medium" stroke="#f97316" strokeWidth={2} dot={{ r: 3 }} name="중위험" />
                  <Line type="monotone" dataKey="low"    stroke="#22c55e" strokeWidth={2} dot={{ r: 3 }} name="저위험" />
                </LineChart>
              ) : (
                <LineChart key="completed-chart" data={trend} margin={{ top: 5, right: 20, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis dataKey="month" stroke="#9CA3AF" tick={{ fontSize: 11 }} />
                  <YAxis stroke="#9CA3AF" tick={{ fontSize: 11 }} />
                  <Tooltip contentStyle={{ borderRadius: 4, border: '1px solid #E5E7EB', fontSize: 12 }} />
                  <Legend iconType="circle" iconSize={7} wrapperStyle={{ fontSize: 11 }} />
                  <Line type="monotone" dataKey="completed" stroke="#1A2E44" strokeWidth={2} dot={{ r: 3 }} name="완료 건수" />
                </LineChart>
              )}
            </ResponsiveContainer>
          </div>
        </div>

        {/* Row 2 */}
        <div className="grid grid-cols-2 gap-4">
          {/* Site bar chart */}
          <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '18px 20px' }}>
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A', marginBottom: 16 }}>현장별 조치 현황</h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {siteStats.map(site => (
                <div key={site.name}>
                  <div className="flex items-center justify-between" style={{ marginBottom: 4 }}>
                    <span style={{ fontSize: 12, fontWeight: 500, color: '#374151' }}>{site.name}</span>
                    <div className="flex items-center gap-3">
                      <span style={{ fontSize: 11, color: '#991B1B', fontWeight: 500 }}>미완료 {site.pending + site.inProgress + site.verification}건</span>
                      <span style={{ fontSize: 11, fontWeight: 700, color: site.rate >= 70 ? '#166534' : '#B45309' }}>{site.rate}%</span>
                    </div>
                  </div>
                  <div style={{ width: '100%', height: 6, background: '#F3F4F6', borderRadius: 3, overflow: 'hidden', display: 'flex' }}>
                    <div style={{ background: '#22c55e', height: '100%', width: `${(site.completed / site.total) * 100}%`, transition: 'width 0.3s' }} />
                    <div style={{ background: '#3b82f6', height: '100%', width: `${(site.verification / site.total) * 100}%` }} />
                    <div style={{ background: '#f97316', height: '100%', width: `${(site.inProgress / site.total) * 100}%` }} />
                    <div style={{ background: '#ef4444', height: '100%', width: `${(site.pending / site.total) * 100}%` }} />
                  </div>
                </div>
              ))}
              <div className="flex items-center gap-4" style={{ paddingTop: 8, borderTop: '1px solid #F3F4F6' }}>
                {[['#22c55e','완료'],['#3b82f6','검증중'],['#f97316','조치중'],['#ef4444','대기']].map(([c,l]) => (
                  <span key={l} className="flex items-center gap-1.5" style={{ fontSize: 11, color: '#6B7280' }}>
                    <span style={{ width: 8, height: 8, borderRadius: 2, background: c, display: 'inline-block' }} />{l}
                  </span>
                ))}
              </div>
            </div>
          </div>

          {/* Donut charts */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 20px', flex: 1 }}>
              <h3 style={{ fontSize: 13, fontWeight: 600, color: '#0F172A', marginBottom: 12 }}>조치 상태 분포</h3>
              <DonutChart data={statusData} size={100} />
            </div>
            <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '16px 20px', flex: 1 }}>
              <h3 style={{ fontSize: 13, fontWeight: 600, color: '#0F172A', marginBottom: 12 }}>위험도 분포</h3>
              <DonutChart data={riskData} size={100} />
            </div>
          </div>
        </div>

        {/* Manager table */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: '18px 20px' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>담당자별 처리 현황</h3>
            <span style={{ fontSize: 11, color: '#9CA3AF' }}>{period} 완료율 기준</span>
          </div>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
            <thead>
              <tr style={{ background: '#F9FAFB', borderBottom: '1px solid #F3F4F6' }}>
                {['순위','담당자','담당','완료','완료율','기한 준수','추이'].map(h => (
                  <th key={h} style={{ padding: '8px 14px', textAlign: 'left', fontSize: 11, fontWeight: 600, color: '#9CA3AF', letterSpacing: '0.04em' }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {managerStats.map((m, i) => {
                const TrendIcon = m.trend === 'up' ? ArrowUp : m.trend === 'down' ? ArrowDown : Minus;
                const trendColor = m.trend === 'up' ? '#166534' : m.trend === 'down' ? '#991B1B' : '#9CA3AF';
                return (
                  <tr key={m.name} style={{ borderBottom: '1px solid #F9FAFB' }}>
                    <td style={{ padding: '10px 14px' }}>
                      <span style={{
                        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                        width: 22, height: 22, borderRadius: '50%', fontSize: 11, fontWeight: 700,
                        background: i === 0 ? '#1A2E44' : '#F3F4F6', color: i === 0 ? 'white' : '#6B7280',
                      }}>{i + 1}</span>
                    </td>
                    <td style={{ padding: '10px 14px', fontWeight: 500, color: '#0F172A' }}>{m.name}</td>
                    <td style={{ padding: '10px 14px', color: '#6B7280' }}>{m.assigned}건</td>
                    <td style={{ padding: '10px 14px', color: '#6B7280' }}>{m.completed}건</td>
                    <td style={{ padding: '10px 14px' }}>
                      <div className="flex items-center gap-2">
                        <div style={{ width: 48, height: 4, background: '#F3F4F6', borderRadius: 2 }}>
                          <div style={{ width: `${m.rate}%`, height: '100%', background: '#1A2E44', borderRadius: 2 }} />
                        </div>
                        <span style={{ fontSize: 11, fontWeight: 700, color: '#0F172A' }}>{m.rate}%</span>
                      </div>
                    </td>
                    <td style={{ padding: '10px 14px' }}>
                      <div className="flex items-center gap-2">
                        <div style={{ width: 48, height: 4, background: '#F3F4F6', borderRadius: 2 }}>
                          <div style={{ width: `${m.onTime}%`, height: '100%', background: '#374151', borderRadius: 2 }} />
                        </div>
                        <span style={{ fontSize: 11, fontWeight: 700, color: '#0F172A' }}>{m.onTime}%</span>
                      </div>
                    </td>
                    <td style={{ padding: '10px 14px' }}>
                      <TrendIcon size={14} color={trendColor} />
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Detail table */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, overflow: 'hidden' }}>
          <div className="flex items-center justify-between" style={{ padding: '14px 20px', borderBottom: '1px solid #F3F4F6' }}>
            <h3 style={{ fontSize: 14, fontWeight: 600, color: '#0F172A' }}>현장별 상세 통계</h3>
            <span style={{ fontSize: 11, color: '#9CA3AF' }}>{period} 기준</span>
          </div>
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#F9FAFB', borderBottom: '1px solid #F3F4F6' }}>
                  {['현장','전체','조치 전','조치 중','검증 중','완료','완료율','추이'].map(h => (
                    <th key={h} style={{ padding: '9px 20px', textAlign: 'left', fontSize: 11, fontWeight: 600, color: '#9CA3AF', letterSpacing: '0.04em', whiteSpace: 'nowrap' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {siteStats.map((site, i) => {
                  const trends = [true, true, false, true, true, false];
                  const trendUp = trends[i];
                  const TrendIco = trendUp ? ArrowUp : ArrowDown;
                  return (
                    <tr key={site.name} style={{ borderBottom: '1px solid #F9FAFB' }}
                      onMouseEnter={e => (e.currentTarget as HTMLElement).style.background = '#FAFAFA'}
                      onMouseLeave={e => (e.currentTarget as HTMLElement).style.background = 'transparent'}
                    >
                      <td style={{ padding: '10px 20px', fontWeight: 600, color: '#0F172A' }}>{site.name}</td>
                      <td style={{ padding: '10px 20px', color: '#374151', fontWeight: 500 }}>{site.total}</td>
                      <td style={{ padding: '10px 20px' }}><span style={{ color: '#991B1B', fontWeight: 600 }}>{site.pending}</span></td>
                      <td style={{ padding: '10px 20px' }}><span style={{ color: '#B45309', fontWeight: 600 }}>{site.inProgress}</span></td>
                      <td style={{ padding: '10px 20px' }}><span style={{ color: '#1D4ED8', fontWeight: 600 }}>{site.verification}</span></td>
                      <td style={{ padding: '10px 20px' }}><span style={{ color: '#166534', fontWeight: 600 }}>{site.completed}</span></td>
                      <td style={{ padding: '10px 20px' }}>
                        <div className="flex items-center gap-2">
                          <div style={{ width: 48, height: 4, background: '#F3F4F6', borderRadius: 2 }}>
                            <div style={{ width: `${site.rate}%`, height: '100%', borderRadius: 2, background: site.rate >= 70 ? '#166534' : '#B45309' }} />
                          </div>
                          <span style={{ fontSize: 11, fontWeight: 700, color: site.rate >= 70 ? '#166534' : '#B45309' }}>{site.rate}%</span>
                        </div>
                      </td>
                      <td style={{ padding: '10px 20px' }}>
                        <TrendIco size={13} color={trendUp ? '#166534' : '#991B1B'} />
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layout>
  );
}
