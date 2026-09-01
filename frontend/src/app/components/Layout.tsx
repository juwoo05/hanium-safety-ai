import { useState, type ReactNode } from 'react';
import {
  LayoutDashboard, Camera, ClipboardList, BarChart2,
  FileText, MessageSquare, Bell, LogOut, ChevronDown,
  Settings,
} from 'lucide-react';

interface LayoutProps {
  children: ReactNode;
  currentPath?: string;
  onNavigate: (page: string) => void;
  userType?: 'contractor' | 'subcontractor' | null;
}

const NAV_ITEMS = [
  { label: '대시보드',    path: 'dashboard',     icon: LayoutDashboard },
  { label: '사진 분석',   path: 'upload',         icon: Camera },
  { label: '조치관리',    path: 'actions',        icon: ClipboardList },
  { label: '분석 리포트', path: 'analytics',      icon: BarChart2 },
  { label: '안전 서류',   path: 'actions-detail', icon: FileText },
  { label: '신고 게시판', path: 'report-board',   icon: MessageSquare },
];

// 하청 계정에서 숨기는 메뉴: 조치 관리 / 분석 리포트.
// '안전 서류'는 TBM·교육일지·보호구 지급대장 등 하청이 직접 작성하는 서류가 많아 노출한다.
const SUB_HIDDEN_PATHS = new Set(['actions', 'analytics']);

const SIDEBAR_W = 220;

export default function Layout({ children, currentPath = '', onNavigate, userType }: LayoutProps) {
  const [userMenuOpen, setUserMenuOpen] = useState(false);

  const navItems = userType === 'subcontractor'
    ? NAV_ITEMS.filter(item => !SUB_HIDDEN_PATHS.has(item.path))
    : NAV_ITEMS;

  const isActive = (path: string): boolean => {
    if (path === 'actions-detail') return currentPath === 'actions-detail';
    if (path === 'actions') return currentPath === 'actions' || currentPath === 'actions-new';
    if (path === 'report-board') return currentPath === 'report-board' || currentPath === 'report-board-detail';
    return currentPath === path;
  };

  const navBtn = (active: boolean): React.CSSProperties => ({
    width: '100%',
    display: 'flex',
    alignItems: 'center',
    gap: 9,
    padding: '7px 12px',
    marginBottom: 1,
    borderRadius: 4,
    border: 'none',
    cursor: 'pointer',
    background: active ? 'rgba(255,255,255,0.07)' : 'transparent',
    color: active ? '#E2E8F0' : '#7A8FA6',
    fontSize: 13,
    fontWeight: active ? 500 : 400,
    textAlign: 'left' as const,
    transition: 'background 0.1s, color 0.1s',
    boxShadow: active ? 'inset 2px 0 0 #4A90D9' : 'inset 2px 0 0 transparent',
    fontFamily: "'Noto Sans KR', sans-serif",
    letterSpacing: '-0.01em',
  });

  return (
    <div style={{ display: 'flex', minHeight: '100vh', fontFamily: "'Noto Sans KR', sans-serif" }}>

      {/* ── Sidebar ── */}
      <aside
        style={{
          width: SIDEBAR_W,
          flexShrink: 0,
          position: 'fixed',
          top: 0,
          left: 0,
          bottom: 0,
          background: '#0F172A',
          display: 'flex',
          flexDirection: 'column',
          zIndex: 40,
        }}
      >
        {/* Logo */}
        <div
          style={{
            height: 56,
            display: 'flex',
            alignItems: 'center',
            padding: '0 18px',
            borderBottom: '1px solid rgba(255,255,255,0.05)',
            flexShrink: 0,
          }}
        >
          <button
            onClick={() => onNavigate('dashboard')}
            style={{
              display: 'flex', alignItems: 'center', gap: 9,
              background: 'none', border: 'none', cursor: 'pointer', padding: 0,
            }}
          >
            <div
              style={{
                width: 28, height: 28, borderRadius: 6,
                background: 'rgba(74, 144, 217, 0.18)',
                border: '1px solid rgba(74, 144, 217, 0.25)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
              }}
            >
              <img src="/app/images/yeongyeol-gori-logo.png" alt="연결고리 로고" style={{ width: 24, height: 24, objectFit: 'contain' }} />
            </div>
            <span style={{ fontSize: 14, fontWeight: 600, color: '#E2E8F0', letterSpacing: '0' }}>
              안전고리
            </span>
          </button>
        </div>

        {/* Project context */}
        <div
          style={{
            padding: '10px 18px 8px',
            borderBottom: '1px solid rgba(255,255,255,0.05)',
            flexShrink: 0,
          }}
        >
          <p style={{ fontSize: 10, color: '#4B6280', fontWeight: 500, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 3 }}>현장</p>
          <p style={{ fontSize: 11, color: '#7A8FA6', fontWeight: 400, lineHeight: 1.4 }}>강남 복합시설 신축공사</p>
        </div>

        {/* Nav */}
        <nav style={{ flex: 1, padding: '10px 10px', overflowY: 'auto' }}>
          {navItems.map(item => {
            const active = isActive(item.path);
            return (
              <button
                key={item.path}
                onClick={() => onNavigate(item.path)}
                style={navBtn(active)}
                onMouseEnter={e => {
                  if (!active) {
                    const el = e.currentTarget as HTMLElement;
                    el.style.background = 'rgba(255,255,255,0.04)';
                    el.style.color = '#BDD0E2';
                  }
                }}
                onMouseLeave={e => {
                  if (!active) {
                    const el = e.currentTarget as HTMLElement;
                    el.style.background = 'transparent';
                    el.style.color = '#7A8FA6';
                  }
                }}
              >
                <item.icon
                  size={14}
                  strokeWidth={active ? 2 : 1.5}
                  color={active ? '#4A90D9' : '#5E7A94'}
                />
                {item.label}
              </button>
            );
          })}
        </nav>

        {/* Bottom */}
        <div style={{ borderTop: '1px solid rgba(255,255,255,0.05)', padding: '10px 10px 14px', flexShrink: 0 }}>
          {/* Notification */}
          <button
            onClick={() => onNavigate('notifications')}
            style={navBtn(false)}
            onMouseEnter={e => {
              const el = e.currentTarget as HTMLElement;
              el.style.background = 'rgba(255,255,255,0.04)';
              el.style.color = '#BDD0E2';
            }}
            onMouseLeave={e => {
              const el = e.currentTarget as HTMLElement;
              el.style.background = 'transparent';
              el.style.color = '#7A8FA6';
            }}
          >
            <Bell size={14} strokeWidth={1.5} color="#5E7A94" />
            알림
            <span
              style={{
                marginLeft: 'auto',
                minWidth: 17, height: 17, borderRadius: 9,
                background: '#B91C1C', fontSize: 9, fontWeight: 700,
                color: 'white', display: 'inline-flex', alignItems: 'center',
                justifyContent: 'center', padding: '0 4px',
              }}
            >
              3
            </span>
          </button>

          {/* Settings */}
          <button
            onClick={() => onNavigate('mypage')}
            style={navBtn(false)}
            onMouseEnter={e => {
              const el = e.currentTarget as HTMLElement;
              el.style.background = 'rgba(255,255,255,0.04)';
              el.style.color = '#BDD0E2';
            }}
            onMouseLeave={e => {
              const el = e.currentTarget as HTMLElement;
              el.style.background = 'transparent';
              el.style.color = '#7A8FA6';
            }}
          >
            <Settings size={14} strokeWidth={1.5} color="#5E7A94" />
            설정
          </button>

          {/* User */}
          <div style={{ height: 1, background: 'rgba(255,255,255,0.05)', margin: '8px 2px' }} />
          <div className="relative">
            <button
              onClick={() => setUserMenuOpen(v => !v)}
              style={{
                width: '100%',
                display: 'flex', alignItems: 'center', gap: 8,
                padding: '7px 10px',
                borderRadius: 4, border: 'none', cursor: 'pointer',
                background: 'transparent',
                fontFamily: "'Noto Sans KR', sans-serif",
              }}
              onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = 'rgba(255,255,255,0.04)')}
              onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'transparent')}
            >
              <div
                style={{
                  width: 26, height: 26, borderRadius: '50%',
                  background: userType === 'subcontractor' ? '#FF7A00' : '#086CF0',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: 10, fontWeight: 600, color: '#fff',
                  flexShrink: 0,
                }}
              >
                김
              </div>
              <div style={{ flex: 1, textAlign: 'left', minWidth: 0 }}>
                <p style={{ fontSize: 12, fontWeight: 500, color: '#CBD5E1', lineHeight: 1.3 }}>김현장</p>
                <p style={{ fontSize: 10, color: '#4B6280', lineHeight: 1.3, marginTop: 1 }}>
                  {userType === 'contractor' ? '원청 관리자' : userType === 'subcontractor' ? '하청 담당자' : '관리자'}
                </p>
              </div>
              <ChevronDown size={11} color="#4B6280" />
            </button>

            {userMenuOpen && (
              <>
                <div className="fixed inset-0 z-40" onClick={() => setUserMenuOpen(false)} />
                <div
                  style={{
                    position: 'absolute',
                    bottom: 46,
                    left: 8,
                    right: 8,
                    background: '#1E293B',
                    border: '1px solid rgba(255,255,255,0.07)',
                    borderRadius: 5,
                    boxShadow: '0 -8px 24px rgba(0,0,0,0.3)',
                    zIndex: 50,
                    overflow: 'hidden',
                  }}
                >
                  {[
                    { label: '내 정보', path: 'mypage' },
                    { label: '설정',    path: 'mypage' },
                  ].map(item => (
                    <button
                      key={item.label}
                      onClick={() => { onNavigate(item.path); setUserMenuOpen(false); }}
                      style={{
                        width: '100%', padding: '9px 14px', fontSize: 12,
                        color: '#94A3B8', background: 'none', border: 'none',
                        cursor: 'pointer', textAlign: 'left',
                        fontFamily: "'Noto Sans KR', sans-serif",
                        transition: 'background 0.1s',
                      }}
                      onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = 'rgba(255,255,255,0.05)')}
                      onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'none')}
                    >
                      {item.label}
                    </button>
                  ))}
                  <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)' }} />
                  <button
                    onClick={() => { onNavigate('landing'); setUserMenuOpen(false); }}
                    style={{
                      width: '100%', padding: '9px 14px', fontSize: 12,
                      color: '#F87171', background: 'none', border: 'none',
                      cursor: 'pointer', textAlign: 'left',
                      display: 'flex', alignItems: 'center', gap: 8,
                      fontFamily: "'Noto Sans KR', sans-serif",
                    }}
                    onMouseEnter={e => ((e.currentTarget as HTMLElement).style.background = 'rgba(248,113,113,0.06)')}
                    onMouseLeave={e => ((e.currentTarget as HTMLElement).style.background = 'none')}
                  >
                    <LogOut size={12} color="#F87171" />
                    로그아웃
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </aside>

      {/* ── Main content ── */}
      <main
        style={{
          marginLeft: SIDEBAR_W,
          flex: 1,
          minHeight: '100vh',
          background: '#F3F5F7',
        }}
      >
        <div style={{ padding: '28px 32px 56px', maxWidth: 1280 }}>
          {children}
        </div>
      </main>
    </div>
  );
}
