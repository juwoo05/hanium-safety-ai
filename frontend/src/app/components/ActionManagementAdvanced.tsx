import React, { useState, useMemo, useEffect } from 'react';
import type { AiAction } from '../App';
import Layout from './Layout';
import { Search, ChevronRight, Download, Plus, Pencil, Trash2, X, Save, AlertTriangle, ChevronDown } from 'lucide-react';
import { toast } from 'sonner';
import { downloadCsv } from '../utils/demoFiles';

type RiskLevel = 'high' | 'medium' | 'low';
type ActionStatus = 'pending' | 'inProgress' | 'verification' | 'completed';

interface Action {
  id: number;
  image: string;
  title: string;
  reportId: string;
  site: string;
  manager: string;
  deadline: string;
  risk: RiskLevel;
  comments: number;
  files: number;
  status: ActionStatus;
}

interface ActionManagementProps {
  onNavigate: (page: string) => void;
  incomingActions?: AiAction[];
  onIncomingConsumed?: () => void;
  userType?: 'contractor' | 'subcontractor' | null;
}

const RISK_LABEL: Record<RiskLevel, string>    = { high: '높음', medium: '중간', low: '낮음' };
const RISK_COLOR: Record<RiskLevel, string>    = { high: '#991B1B', medium: '#B45309', low: '#166534' };
const RISK_BG:    Record<RiskLevel, string>    = { high: '#FEF2F2', medium: '#FFFBEB', low: '#F0FDF4' };

const STATUS_LABEL: Record<ActionStatus, string> = {
  pending: '요청중', inProgress: '진행중', verification: '검증중', completed: '완료',
};
const STATUS_COLOR: Record<ActionStatus, string> = {
  pending: '#B45309', inProgress: '#1D4ED8', verification: '#6D28D9', completed: '#166534',
};
const STATUS_BG: Record<ActionStatus, string> = {
  pending: '#FFFBEB', inProgress: '#EFF6FF', verification: '#F5F3FF', completed: '#F0FDF4',
};

const ACTION_IMAGES: Record<number, string> = {
  1: 'https://images.unsplash.com/photo-1626885930974-4b69aa21bbf9?w=80&h=60&fit=crop&auto=format',
  2: 'https://images.unsplash.com/photo-1777262095520-9805f225fb63?w=80&h=60&fit=crop&auto=format',
  3: 'https://images.unsplash.com/photo-1621294465978-6b4198a5f2f7?w=80&h=60&fit=crop&auto=format',
  4: 'https://images.unsplash.com/photo-1625958936686-a9343dc35b5b?w=80&h=60&fit=crop&auto=format',
  5: 'https://images.unsplash.com/photo-1561715608-5659baeccfb4?w=80&h=60&fit=crop&auto=format',
  6: 'https://images.unsplash.com/photo-1567954970774-58d6aa6c50dc?w=80&h=60&fit=crop&auto=format',
  7: 'https://images.unsplash.com/photo-1713593930871-e21d7f9ef4a1?w=80&h=60&fit=crop&auto=format',
  8: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=80&h=60&fit=crop&auto=format',
};

const INITIAL_DATA: Action[] = [
  { id: 1, image: ACTION_IMAGES[1], title: '화재안전 미조치',   reportId: 'SR-2026-001', site: '3동 지하 1층', manager: '김현장', deadline: '2026-06-03', risk: 'high',   comments: 3, files: 2, status: 'pending' },
  { id: 2, image: ACTION_IMAGES[2], title: '안전 난간 파손',   reportId: 'SR-2026-002', site: '5동 옥상',    manager: '박안전', deadline: '2026-06-05', risk: 'medium', comments: 1, files: 1, status: 'pending' },
  { id: 3, image: ACTION_IMAGES[3], title: '전선 노출',         reportId: 'SR-2026-003', site: '2동 전기실',  manager: '김현장', deadline: '2026-06-04', risk: 'high',   comments: 5, files: 3, status: 'inProgress' },
  { id: 4, image: ACTION_IMAGES[4], title: '소화기 미배치',     reportId: 'SR-2026-004', site: '4동 1층',    manager: '이관리', deadline: '2026-06-10', risk: 'low',    comments: 2, files: 1, status: 'inProgress' },
  { id: 5, image: ACTION_IMAGES[5], title: '비상구 표시 미비',  reportId: 'SR-2026-005', site: '1동 출입구', manager: '박안전', deadline: '2026-06-07', risk: 'medium', comments: 4, files: 2, status: 'verification' },
  { id: 6, image: ACTION_IMAGES[6], title: '안전모 착용 불량',  reportId: 'SR-2026-006', site: '현장 전체',  manager: '김현장', deadline: '2026-06-01', risk: 'low',    comments: 8, files: 5, status: 'completed' },
  { id: 7, image: ACTION_IMAGES[7], title: '작업발판 불량',     reportId: 'SR-2026-007', site: '2동 3층',    manager: '이관리', deadline: '2026-06-08', risk: 'high',   comments: 2, files: 3, status: 'pending' },
  { id: 8, image: ACTION_IMAGES[8], title: '환기시설 미작동',   reportId: 'SR-2026-008', site: '지하 주차장', manager: '박안전', deadline: '2026-06-10', risk: 'medium', comments: 6, files: 4, status: 'inProgress' },
];

let _cache: Action[] | null = null;

const today = new Date(); today.setHours(0,0,0,0);
const isOverdue = (d: string) => new Date(d) < today;

const NEXT_STATUS: Partial<Record<ActionStatus, ActionStatus>> = {
  pending: 'inProgress', inProgress: 'verification', verification: 'completed',
};

export default function ActionManagementAdvanced({ onNavigate, incomingActions, onIncomingConsumed, userType }: ActionManagementProps) {
  const isContractor = userType === 'contractor';
  const [actions, setActionsRaw] = useState<Action[]>(_cache ?? INITIAL_DATA);
  const [statusTab, setStatusTab] = useState<'all' | ActionStatus>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [riskFilter, setRiskFilter] = useState<'all' | RiskLevel>('all');
  const [siteFilter, setSiteFilter] = useState('전체 현장');
  const [editingAction, setEditingAction] = useState<Action | null>(null);
  const [deleteConfirm, setDeleteConfirm] = useState<number | null>(null);
  const [newBanner, setNewBanner] = useState(0);
  const [expandedId, setExpandedId] = useState<number | null>(null);

  const setActions = (u: Action[] | ((p: Action[]) => Action[])) => {
    setActionsRaw(prev => {
      const next = typeof u === 'function' ? u(prev) : u;
      _cache = next; return next;
    });
  };

  useEffect(() => {
    if (!incomingActions?.length) return;
    const todayStr = new Date().toISOString().slice(0,10);
    const items: Action[] = incomingActions.map(a => ({
      id: a.id, image: a.image, title: a.title, reportId: `AI-${a.id}`,
      site: a.site, manager: '미배정', deadline: todayStr,
      risk: a.risk, comments: 0, files: 0, status: 'pending' as ActionStatus,
    }));
    setActions(prev => [...items, ...prev]);
    setNewBanner(items.length);
    onIncomingConsumed?.();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [incomingActions]);

  const filteredActions = useMemo(() => actions.filter(a => {
    const matchStatus = statusTab === 'all' || a.status === statusTab;
    const matchSearch = !searchQuery ||
      a.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      a.site.toLowerCase().includes(searchQuery.toLowerCase()) ||
      a.manager.toLowerCase().includes(searchQuery.toLowerCase()) ||
      a.reportId.toLowerCase().includes(searchQuery.toLowerCase());
    const matchRisk = riskFilter === 'all' || a.risk === riskFilter;
    const matchSite = siteFilter === '전체 현장' || a.site.includes(siteFilter.replace('동','')) || a.site.includes(siteFilter);
    return matchStatus && matchSearch && matchRisk && matchSite;
  }), [actions, statusTab, searchQuery, riskFilter, siteFilter]);

  const counts = useMemo(() => ({
    all: actions.length,
    pending: actions.filter(a => a.status === 'pending').length,
    inProgress: actions.filter(a => a.status === 'inProgress').length,
    verification: actions.filter(a => a.status === 'verification').length,
    completed: actions.filter(a => a.status === 'completed').length,
  }), [actions]);

  const overdueCount = actions.filter(a => isOverdue(a.deadline) && a.status !== 'completed').length;
  const completionRate = Math.round((counts.completed / counts.all) * 100);

  const advanceStatus = (id: number, current: ActionStatus) => {
    const next = NEXT_STATUS[current];
    if (!next) return;
    setActions(prev => prev.map(a => a.id === id ? {...a, status: next} : a));
    toast.success(`"${actions.find(a => a.id === id)?.title}" → ${STATUS_LABEL[next]}`);
  };

  const handleSaveEdit = () => {
    if (!editingAction?.title.trim()) { toast.error('제목을 입력하세요'); return; }
    setActions(prev => prev.map(a => a.id === editingAction.id ? editingAction : a));
    setEditingAction(null);
    toast.success('수정되었습니다.');
  };

  const handleDelete = (id: number) => {
    setActions(prev => prev.filter(a => a.id !== id));
    setDeleteConfirm(null);
    toast.success('삭제되었습니다.');
  };

  const TAB_LIST = [
    { key: 'all', label: '전체', count: counts.all },
    { key: 'pending', label: '요청중', count: counts.pending },
    { key: 'inProgress', label: '진행중', count: counts.inProgress },
    { key: 'verification', label: '검증중', count: counts.verification },
    { key: 'completed', label: '완료', count: counts.completed },
  ] as const;

  return (
    <Layout currentPath="actions" onNavigate={onNavigate} userType={userType ?? undefined}>
      {/* New-action banner */}
      {newBanner > 0 && (
        <div
          className="flex items-center justify-between mb-5"
          style={{
            background: '#EFF6FF', border: '1px solid #BFDBFE',
            borderRadius: 4, padding: '10px 16px',
          }}
        >
          <span style={{ fontSize: 13, color: '#1E40AF' }}>
            AI 분석 결과 <strong>{newBanner}건</strong>이 요청중으로 등록되었습니다.
          </span>
          <button
            aria-label="닫기"
            onClick={() => setNewBanner(0)}
            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#93C5FD' }}
          >
            <X size={14} />
          </button>
        </div>
      )}

      {/* Page header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <p style={{ fontSize: 11, color: '#9CA3AF', letterSpacing: '0.06em', textTransform: 'uppercase', fontWeight: 500, marginBottom: 5 }}>조치 관리</p>
          <h1 style={{ fontSize: 22, fontWeight: 600, color: '#0F172A', letterSpacing: '-0.02em', lineHeight: 1, marginBottom: 6 }}>조치관리</h1>
          <p style={{ fontSize: 12, color: '#6B7280' }}>
            전체 {counts.all}건 · 완료율 {completionRate}%
            {overdueCount > 0 && (
              <span style={{ marginLeft: 8, color: '#991B1B', fontWeight: 500 }}>
                기한 초과 {overdueCount}건
              </span>
            )}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => {
              downloadCsv(
                `조치관리_${new Date().toISOString().slice(0, 10)}.csv`,
                ['리포트 ID', '위험요소', '현장', '담당자', '위험등급', '상태', '기한'],
                filteredActions.map(action => [
                  action.reportId,
                  action.title,
                  action.site,
                  action.manager,
                  RISK_LABEL[action.risk],
                  STATUS_LABEL[action.status],
                  action.deadline,
                ])
              );
              toast.success(`${filteredActions.length}건을 CSV로 내보냈습니다.`);
            }}
            style={{
              display: 'flex', alignItems: 'center', gap: 6,
              padding: '7px 12px', fontSize: 12, fontWeight: 500,
              background: 'white', color: '#374151', border: '1px solid #E5E7EB',
              borderRadius: 4, cursor: 'pointer',
            }}
          >
            <Download size={13} /> 내보내기
          </button>
          <button
            onClick={() => onNavigate('upload')}
            style={{
              display: 'flex', alignItems: 'center', gap: 6,
              padding: '7px 14px', fontSize: 13, fontWeight: 500,
              background: '#1A2E44', color: 'white', border: 'none',
              borderRadius: 4, cursor: 'pointer',
            }}
          >
            <Plus size={13} /> 조치 등록
          </button>
        </div>
      </div>

      {/* Status tabs + filters */}
      <div
        style={{
          background: 'white', border: '1px solid #E5E7EB',
          borderRadius: 4, marginBottom: 0,
          borderBottomLeftRadius: 0, borderBottomRightRadius: 0,
          borderBottom: 'none',
        }}
      >
        <div
          className="flex items-center justify-between"
          style={{ padding: '0 20px', borderBottom: '1px solid #E5E7EB' }}
        >
          {/* Tabs */}
          <div className="flex items-center" style={{ gap: 0 }}>
            {TAB_LIST.map(tab => {
              const active = statusTab === tab.key;
              return (
                <button
                  key={tab.key}
                  onClick={() => setStatusTab(tab.key)}
                  style={{
                    padding: '12px 16px', fontSize: 13, fontWeight: active ? 600 : 400,
                    color: active ? '#0F172A' : '#9CA3AF',
                    background: 'none', border: 'none', cursor: 'pointer',
                    borderBottom: active ? '2px solid #0F172A' : '2px solid transparent',
                    display: 'flex', alignItems: 'center', gap: 6,
                    marginBottom: -1,
                  }}
                >
                  {tab.label}
                  <span
                    style={{
                      fontSize: 11, padding: '1px 6px', borderRadius: 10, fontWeight: 600,
                      background: active ? '#0F172A' : '#F3F4F6',
                      color: active ? 'white' : '#9CA3AF',
                    }}
                  >
                    {tab.count}
                  </span>
                </button>
              );
            })}
          </div>

          {/* Filters */}
          <div className="flex items-center gap-2">
            <div className="relative" style={{ display: 'flex', alignItems: 'center' }}>
              <Search size={13} color="#9CA3AF" style={{ position: 'absolute', left: 10 }} />
              <input
                value={searchQuery}
                onChange={e => setSearchQuery(e.target.value)}
                placeholder="항목, 현장, 담당자 검색"
                style={{
                  paddingLeft: 32, paddingRight: 10, paddingTop: 6, paddingBottom: 6,
                  fontSize: 12, border: '1px solid #E5E7EB', borderRadius: 4,
                  outline: 'none', background: '#F9FAFB', color: '#374151', width: 200,
                }}
              />
            </div>
            <select
              value={riskFilter}
              onChange={e => setRiskFilter(e.target.value as any)}
              style={{
                padding: '6px 10px', fontSize: 12, border: '1px solid #E5E7EB',
                borderRadius: 4, background: '#F9FAFB', color: '#374151', outline: 'none', cursor: 'pointer',
              }}
            >
              {(['all','high','medium','low'] as const).map(v => (
                <option key={v} value={v}>{v === 'all' ? '위험도 전체' : RISK_LABEL[v]}</option>
              ))}
            </select>
            <select
              value={siteFilter}
              onChange={e => setSiteFilter(e.target.value)}
              style={{
                padding: '6px 10px', fontSize: 12, border: '1px solid #E5E7EB',
                borderRadius: 4, background: '#F9FAFB', color: '#374151', outline: 'none', cursor: 'pointer',
              }}
            >
              {['전체 현장','1동','2동','3동','4동','5동','지하 주차장'].map(v => (
                <option key={v}>{v}</option>
              ))}
            </select>
            {(searchQuery || riskFilter !== 'all' || siteFilter !== '전체 현장') && (
              <button
                onClick={() => { setSearchQuery(''); setRiskFilter('all'); setSiteFilter('전체 현장'); }}
                style={{
                  padding: '6px 10px', fontSize: 12, color: '#991B1B',
                  background: '#FEF2F2', border: '1px solid #FECACA',
                  borderRadius: 4, cursor: 'pointer',
                }}
              >
                초기화
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Table */}
      <div
        style={{
          background: 'white', border: '1px solid #E5E7EB',
          borderTopLeftRadius: 0, borderTopRightRadius: 0,
          borderRadius: 4, overflow: 'hidden',
        }}
      >
        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
            <thead>
              <tr style={{ background: '#F9FAFB', borderBottom: '1px solid #F3F4F6' }}>
                {['', '리포트 ID', '위험유형', '현장', '담당자', '위험등급', '마감일', '상태', '조치'].map(h => (
                  <th
                    key={h}
                    style={{
                      padding: '9px 14px', textAlign: 'left',
                      fontSize: 11, fontWeight: 600, color: '#9CA3AF',
                      letterSpacing: '0.04em', textTransform: 'uppercase',
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filteredActions.map((action, idx) => {
                const overdue = isOverdue(action.deadline) && action.status !== 'completed';
                const isExpanded = expandedId === action.id;
                const next = NEXT_STATUS[action.status];
                return (
                  <React.Fragment key={action.id}>
                    <tr
                      style={{
                        borderBottom: '1px solid #F9FAFB', cursor: 'pointer',
                        transition: 'background 0.1s',
                        background: isExpanded ? '#FAFAFA' : 'transparent',
                      }}
                      onMouseEnter={e => { if (!isExpanded) e.currentTarget.style.background = '#FAFAFA'; }}
                      onMouseLeave={e => { if (!isExpanded) e.currentTarget.style.background = 'transparent'; }}
                    >
                      {/* Thumbnail */}
                      <td style={{ padding: '10px 14px', width: 72 }}>
                        <div
                          style={{
                            width: 56, height: 40, borderRadius: 3, overflow: 'hidden',
                            background: '#F3F4F6', flexShrink: 0,
                          }}
                          onClick={() => onNavigate('actions-detail')}
                        >
                          <img src={action.image} alt={action.title} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                        </div>
                      </td>
                      <td
                        style={{ padding: '10px 14px', color: '#9CA3AF', fontFamily: 'monospace', fontSize: 12 }}
                        onClick={() => onNavigate('actions-detail')}
                      >
                        {action.reportId}
                      </td>
                      <td style={{ padding: '10px 14px' }} onClick={() => onNavigate('actions-detail')}>
                        <span style={{ fontWeight: 500, color: '#0F172A' }}>{action.title}</span>
                      </td>
                      <td style={{ padding: '10px 14px', color: '#6B7280' }} onClick={() => onNavigate('actions-detail')}>
                        {action.site}
                      </td>
                      <td style={{ padding: '10px 14px', color: '#6B7280' }} onClick={() => onNavigate('actions-detail')}>
                        {action.manager}
                      </td>
                      <td style={{ padding: '10px 14px' }} onClick={() => onNavigate('actions-detail')}>
                        <span
                          style={{
                            display: 'inline-block', padding: '2px 8px', borderRadius: 3,
                            fontSize: 11, fontWeight: 600,
                            background: RISK_BG[action.risk], color: RISK_COLOR[action.risk],
                          }}
                        >
                          {RISK_LABEL[action.risk]}
                        </span>
                      </td>
                      <td style={{ padding: '10px 14px' }} onClick={() => onNavigate('actions-detail')}>
                        <span style={{ color: overdue ? '#991B1B' : '#6B7280', fontWeight: overdue ? 600 : 400, fontSize: 12 }}>
                          {action.deadline}
                          {overdue && (
                            <span style={{ marginLeft: 4, fontSize: 10, padding: '1px 5px', background: '#FEF2F2', color: '#991B1B', borderRadius: 3 }}>
                              초과
                            </span>
                          )}
                        </span>
                      </td>
                      <td style={{ padding: '10px 14px' }} onClick={() => onNavigate('actions-detail')}>
                        <span
                          style={{
                            display: 'inline-block', padding: '2px 8px', borderRadius: 3,
                            fontSize: 11, fontWeight: 500,
                            background: STATUS_BG[action.status], color: STATUS_COLOR[action.status],
                          }}
                        >
                          {STATUS_LABEL[action.status]}
                        </span>
                      </td>
                      {/* Actions column */}
                      <td style={{ padding: '10px 14px' }}>
                        <div className="flex items-center gap-1">
                          {next && (
                            <button
                              onClick={() => advanceStatus(action.id, action.status)}
                              style={{
                                padding: '3px 10px', fontSize: 11, fontWeight: 500,
                                background: '#1A2E44', color: 'white', border: 'none',
                                borderRadius: 3, cursor: 'pointer', whiteSpace: 'nowrap',
                              }}
                            >
                              {STATUS_LABEL[next]}
                            </button>
                          )}
                          {isContractor && (
                            <>
                              <button
                                aria-label="수정"
                                onClick={() => setEditingAction({...action})}
                                style={{
                                  width: 28, height: 28, display: 'flex', alignItems: 'center', justifyContent: 'center',
                                  background: 'none', border: '1px solid #E5E7EB', borderRadius: 3, cursor: 'pointer',
                                }}
                                onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = '#F9FAFB')}
                                onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'none')}
                              >
                                <Pencil size={12} color="#9CA3AF" />
                              </button>
                              <button
                                aria-label="삭제"
                                onClick={() => setDeleteConfirm(action.id)}
                                style={{
                                  width: 28, height: 28, display: 'flex', alignItems: 'center', justifyContent: 'center',
                                  background: 'none', border: '1px solid #E5E7EB', borderRadius: 3, cursor: 'pointer',
                                }}
                                onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = '#FEF2F2')}
                                onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'none')}
                              >
                                <Trash2 size={12} color="#9CA3AF" />
                              </button>
                            </>
                          )}
                          <button
                            aria-label="상세 보기"
                            onClick={() => setExpandedId(isExpanded ? null : action.id)}
                            style={{
                              width: 28, height: 28, display: 'flex', alignItems: 'center', justifyContent: 'center',
                              background: 'none', border: '1px solid #E5E7EB', borderRadius: 3, cursor: 'pointer',
                              transform: isExpanded ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s',
                            }}
                          >
                            <ChevronDown size={12} color="#9CA3AF" />
                          </button>
                        </div>
                      </td>
                    </tr>
                    {isExpanded && (
                      <tr key={`${action.id}-exp`} style={{ background: '#FAFAFA', borderBottom: '1px solid #F3F4F6' }}>
                        <td colSpan={9} style={{ padding: '12px 14px 14px 82px' }}>
                          <div className="grid gap-4" style={{ gridTemplateColumns: '1fr 1fr 1fr', fontSize: 12 }}>
                            <div>
                              <p style={{ color: '#9CA3AF', marginBottom: 4 }}>담당자</p>
                              <p style={{ color: '#374151', fontWeight: 500 }}>{action.manager}</p>
                            </div>
                            <div>
                              <p style={{ color: '#9CA3AF', marginBottom: 4 }}>증빙 파일</p>
                              <p style={{ color: '#374151', fontWeight: 500 }}>{action.files}개 첨부</p>
                            </div>
                            <div>
                              <p style={{ color: '#9CA3AF', marginBottom: 4 }}>댓글</p>
                              <p style={{ color: '#374151', fontWeight: 500 }}>{action.comments}건</p>
                            </div>
                          </div>
                          <div className="flex items-center gap-2 mt-3">
                            <button
                              onClick={() => onNavigate('actions-detail')}
                              style={{
                                padding: '5px 12px', fontSize: 12, fontWeight: 500,
                                background: 'white', color: '#374151', border: '1px solid #E5E7EB',
                                borderRadius: 3, cursor: 'pointer',
                              }}
                            >
                              상세 보기
                            </button>
                            <button
                              onClick={() => onNavigate('actions-detail')}
                              disabled={action.status !== 'completed'}
                              title={action.status === 'completed' ? '완료 조치로 안전서류 작성' : '조치 완료 후 작성할 수 있습니다'}
                              style={{
                                padding: '5px 12px', fontSize: 12, fontWeight: 500,
                                background: 'white',
                                color: action.status === 'completed' ? '#1D4ED8' : '#9CA3AF',
                                border: `1px solid ${action.status === 'completed' ? '#BFDBFE' : '#E5E7EB'}`,
                                borderRadius: 3,
                                cursor: action.status === 'completed' ? 'pointer' : 'not-allowed',
                                opacity: action.status === 'completed' ? 1 : 0.65,
                              }}
                            >
                              안전서류 작성
                            </button>
                          </div>
                        </td>
                      </tr>
                    )}
                  </React.Fragment>
                );
              })}
            </tbody>
          </table>
          {filteredActions.length === 0 && (
            <div style={{ padding: 64, textAlign: 'center', color: '#9CA3AF', fontSize: 13 }}>
              해당 조건의 조치 항목이 없습니다.
            </div>
          )}
        </div>

        <div
          className="flex items-center justify-between"
          style={{ padding: '10px 20px', borderTop: '1px solid #F3F4F6' }}
        >
          <span style={{ fontSize: 12, color: '#9CA3AF' }}>
            {filteredActions.length}건 표시 / 전체 {counts.all}건
          </span>
        </div>
      </div>

      {/* Edit Modal */}
      {editingAction && (
        <div className="fixed inset-0 z-50 flex items-center justify-center" style={{ background: 'rgba(0,0,0,0.35)' }}>
          <div
            style={{
              background: 'white', borderRadius: 6, padding: 28,
              width: 480, boxShadow: '0 8px 32px rgba(0,0,0,0.12)',
            }}
          >
            <div className="flex items-center justify-between mb-5">
              <h3 style={{ fontSize: 15, fontWeight: 600, color: '#0F172A' }}>조치 항목 수정</h3>
              <button aria-label="닫기" onClick={() => setEditingAction(null)} style={{ background: 'none', border: 'none', cursor: 'pointer' }}>
                <X size={16} color="#9CA3AF" />
              </button>
            </div>
            {[
              { label: '제목', key: 'title' as keyof Action },
              { label: '현장', key: 'site' as keyof Action },
              { label: '담당자', key: 'manager' as keyof Action },
              { label: '마감일', key: 'deadline' as keyof Action },
            ].map(f => (
              <div key={f.key} style={{ marginBottom: 14 }}>
                <label style={{ fontSize: 12, color: '#6B7280', display: 'block', marginBottom: 4 }}>{f.label}</label>
                <input
                  value={editingAction[f.key] as string}
                  onChange={e => setEditingAction(prev => ({ ...prev!, [f.key]: e.target.value }))}
                  style={{
                    width: '100%', padding: '8px 10px', fontSize: 13,
                    border: '1px solid #E5E7EB', borderRadius: 4, outline: 'none',
                    background: '#F9FAFB', color: '#0F172A', boxSizing: 'border-box',
                  }}
                />
              </div>
            ))}
            <div style={{ marginBottom: 14 }}>
              <label style={{ fontSize: 12, color: '#6B7280', display: 'block', marginBottom: 4 }}>상태</label>
              <select
                value={editingAction.status}
                onChange={e => setEditingAction(prev => ({ ...prev!, status: e.target.value as ActionStatus }))}
                style={{
                  width: '100%', padding: '8px 10px', fontSize: 13,
                  border: '1px solid #E5E7EB', borderRadius: 4, outline: 'none',
                  background: '#F9FAFB', color: '#0F172A',
                }}
              >
                {(Object.keys(STATUS_LABEL) as ActionStatus[]).map(s => (
                  <option key={s} value={s}>{STATUS_LABEL[s]}</option>
                ))}
              </select>
            </div>
            <div className="flex items-center justify-end gap-2 mt-6">
              <button
                onClick={() => setEditingAction(null)}
                style={{
                  padding: '7px 16px', fontSize: 13, background: 'white',
                  color: '#374151', border: '1px solid #E5E7EB', borderRadius: 4, cursor: 'pointer',
                }}
              >
                취소
              </button>
              <button
                onClick={handleSaveEdit}
                style={{
                  padding: '7px 16px', fontSize: 13, background: '#1A2E44',
                  color: 'white', border: 'none', borderRadius: 4, cursor: 'pointer',
                  display: 'flex', alignItems: 'center', gap: 6,
                }}
              >
                <Save size={13} /> 저장
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete confirm */}
      {deleteConfirm !== null && (
        <div className="fixed inset-0 z-50 flex items-center justify-center" style={{ background: 'rgba(0,0,0,0.35)' }}>
          <div
            style={{
              background: 'white', borderRadius: 6, padding: 28, width: 360,
              boxShadow: '0 8px 32px rgba(0,0,0,0.12)',
            }}
          >
            <div className="flex items-start gap-3 mb-5">
              <AlertTriangle size={18} color="#991B1B" style={{ flexShrink: 0, marginTop: 1 }} />
              <div>
                <p style={{ fontSize: 14, fontWeight: 600, color: '#0F172A', marginBottom: 4 }}>항목 삭제</p>
                <p style={{ fontSize: 13, color: '#6B7280' }}>이 조치 항목을 삭제하면 복구할 수 없습니다.</p>
              </div>
            </div>
            <div className="flex items-center justify-end gap-2">
              <button
                onClick={() => setDeleteConfirm(null)}
                style={{
                  padding: '7px 16px', fontSize: 13, background: 'white',
                  color: '#374151', border: '1px solid #E5E7EB', borderRadius: 4, cursor: 'pointer',
                }}
              >
                취소
              </button>
              <button
                onClick={() => handleDelete(deleteConfirm)}
                style={{
                  padding: '7px 16px', fontSize: 13, background: '#991B1B',
                  color: 'white', border: 'none', borderRadius: 4, cursor: 'pointer',
                }}
              >
                삭제
              </button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
