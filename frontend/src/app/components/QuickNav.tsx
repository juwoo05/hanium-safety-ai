import { useState } from 'react';
import { Home, LogIn, LayoutDashboard, FileCheck2, Upload, FileText, BarChart3, Bell, User, ChevronDown, ChevronUp, Megaphone, FileSearch } from 'lucide-react';

interface QuickNavProps {
  onNavigate: (page: string) => void;
  currentPage: string;
}

export default function QuickNav({ onNavigate, currentPage }: QuickNavProps) {
  const [open, setOpen] = useState(true);

  const pages = [
    { id: 'landing',         label: '랜딩',      icon: Home },
    { id: 'login',           label: '로그인',    icon: LogIn },
    { id: 'dashboard',       label: '대시보드',  icon: LayoutDashboard },
    { id: 'upload',          label: '사진분석',  icon: Upload },
    { id: 'actions',         label: '조치관리',  icon: FileCheck2 },
    { id: 'actions-detail',  label: '보고서',    icon: FileText },
    { id: 'analytics',       label: '리포트',    icon: BarChart3 },
    { id: 'ai-analysis',     label: 'AI분석',    icon: FileSearch },
    { id: 'notifications',   label: '알림',      icon: Bell },
    { id: 'report-board',    label: '신고',      icon: Megaphone },
    { id: 'mypage',          label: '마이페이지', icon: User },
  ];

  return (
    <div className="fixed bottom-5 left-1/2 -translate-x-1/2 z-50 flex flex-col items-center gap-2">
      {open && (
        <div
          style={{
            background: 'rgba(15,23,42,0.92)',
            backdropFilter: 'blur(12px)',
            borderRadius: 8,
            border: '1px solid rgba(255,255,255,0.08)',
            boxShadow: '0 8px 32px rgba(0,0,0,0.3)',
            padding: '6px 8px',
          }}
        >
          <div className="flex items-center gap-0.5">
            {pages.map((page) => {
              const isActive = currentPage === page.id || (page.id !== 'landing' && currentPage.startsWith(page.id));
              return (
                <button
                  key={page.id}
                  onClick={() => onNavigate(page.id)}
                  title={page.label}
                  style={{
                    display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
                    padding: '5px 8px',
                    borderRadius: 4,
                    background: isActive ? 'rgba(74,144,217,0.18)' : 'transparent',
                    border: 'none',
                    cursor: 'pointer',
                    color: isActive ? '#5CA8E8' : '#6B7E94',
                    transition: 'background 0.1s, color 0.1s',
                  }}
                  onMouseEnter={e => {
                    if (!isActive) {
                      (e.currentTarget as HTMLElement).style.background = 'rgba(255,255,255,0.05)';
                      (e.currentTarget as HTMLElement).style.color = '#94A3B8';
                    }
                  }}
                  onMouseLeave={e => {
                    if (!isActive) {
                      (e.currentTarget as HTMLElement).style.background = 'transparent';
                      (e.currentTarget as HTMLElement).style.color = '#6B7E94';
                    }
                  }}
                >
                  <page.icon style={{ width: 14, height: 14 }} strokeWidth={isActive ? 2 : 1.5} />
                  <span style={{ fontSize: 9, fontWeight: isActive ? 600 : 400, whiteSpace: 'nowrap', letterSpacing: '0.01em' }}>
                    {page.label}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      )}

      <button
        onClick={() => setOpen(v => !v)}
        style={{
          background: 'rgba(15,23,42,0.85)',
          backdropFilter: 'blur(8px)',
          border: '1px solid rgba(255,255,255,0.08)',
          borderRadius: 20,
          padding: '4px 12px',
          display: 'flex', alignItems: 'center', gap: 4,
          fontSize: 10, fontWeight: 500, color: '#6B7E94',
          cursor: 'pointer',
          transition: 'color 0.1s',
        }}
        onMouseEnter={e => ((e.currentTarget as HTMLElement).style.color = '#94A3B8')}
        onMouseLeave={e => ((e.currentTarget as HTMLElement).style.color = '#6B7E94')}
      >
        {open ? <><ChevronDown style={{ width: 11, height: 11 }} /> 숨기기</> : <><ChevronUp style={{ width: 11, height: 11 }} /> 메뉴</>}
      </button>
    </div>
  );
}
