import { useState, type ReactNode, type ElementType } from 'react';
import Layout from './Layout';
import {
  User, Mail, Phone, Building, Shield, Bell, Lock, LogOut,
  HardHat, MapPin, ChevronDown, CheckCircle2, Copy, RefreshCw,
  Loader2, AlertCircle, Link2, Link2Off, Search, Sparkles,
  Users, ExternalLink, Calendar, ClipboardList, Building2,
} from 'lucide-react';
import { toast } from 'sonner';

interface MyPageProps {
  onNavigate: (page: string) => void;
  userType?: 'contractor' | 'subcontractor' | null;
}

// ─── Mock data ────────────────────────────────────────────────────────────────

const MOCK_COMPANY = {
  name: '대한안전건설',
  bizNo: '123-45-67890',
  ceo: '김현장',
  address: '서울특별시 강남구 테헤란로 120',
};

const MOCK_SITES = [
  {
    id: 'site1',
    name: '강남 복합시설 신축공사',
    address: '서울특별시 강남구 역삼동 825',
    type: '건축공사',
    period: '2026.03.01 ~ 2026.12.31',
    contractor: '대한안전건설',
    kisconCode: 'KISCON-SITE-2026-001',
  },
  {
    id: 'site2',
    name: '인천 물류센터 증축공사',
    address: '인천광역시 서구 오류동 220',
    type: '건축공사',
    period: '2026.05.01 ~ 2027.03.31',
    contractor: '대한안전건설',
    kisconCode: 'KISCON-SITE-2026-002',
  },
  {
    id: 'site3',
    name: '판교 업무시설 리모델링',
    address: '경기도 성남시 분당구 대왕판교로 680',
    type: '리모델링공사',
    period: '2026.04.01 ~ 2026.11.30',
    contractor: '대한안전건설',
    kisconCode: 'KISCON-SITE-2026-003',
  },
];

const MOCK_SUBCONTRACTORS = [
  { name: '안전하도급', manager: '이조치', phone: '010-1234-5678', site: '강남 복합시설 신축공사', joinDate: '2026.08.09', status: '연결됨' },
  { name: '현장설비',   manager: '박설비', phone: '010-2222-3333', site: '강남 복합시설 신축공사', joinDate: '2026.08.09', status: '연결됨' },
  { name: '구조안전',   manager: '최구조', phone: '010-4444-5555', site: '강남 복합시설 신축공사', joinDate: '2026.08.08', status: '연결됨' },
];

const VALID_CODES: Record<string, typeof MOCK_SITES[0]> = {
  'SITE-8F3K2Q': MOCK_SITES[0],
};

const EXPIRED_CODES = ['SITE-EXPIRED'];

type SubCodeStatus = 'idle' | 'checking' | 'valid' | 'invalid' | 'expired' | 'connected';
type MenuId = 'profile' | 'account' | 'kiscon' | 'notifications' | 'security';

// ─── Sidebar nav items ────────────────────────────────────────────────────────

const MENU_ITEMS: { id: MenuId; label: string; icon: ElementType }[] = [
  { id: 'profile',       label: '내 정보',            icon: User },
  { id: 'account',       label: '계정 설정',           icon: Shield },
  { id: 'kiscon',        label: '건설사 및 현장 연동',  icon: Building2 },
  { id: 'notifications', label: '알림 설정',           icon: Bell },
  { id: 'security',      label: '보안 설정',           icon: Lock },
];

// ─── Main component ───────────────────────────────────────────────────────────

export default function MyPage({ onNavigate, userType }: MyPageProps) {
  const isContractor    = userType === 'contractor';
  const isSubcontractor = userType === 'subcontractor';

  const [activeMenu, setActiveMenu] = useState<MenuId>('kiscon');

  // ── Section 1: company info ──
  const [companyForm, setCompanyForm] = useState({ name: '', bizNo: '', ceo: '', address: '' });
  const [kisconLoading, setKisconLoading] = useState(false);
  const [kisconFetched, setKisconFetched] = useState(false);
  const [companySaved, setCompanySaved] = useState(false);

  const handleKisconSearch = () => {
    setKisconLoading(true);
    setTimeout(() => {
      setCompanyForm(MOCK_COMPANY);
      setKisconLoading(false);
      setKisconFetched(true);
      toast.success('KISCON에서 건설사 정보를 가져왔습니다.');
    }, 1600);
  };

  const handleCompanySave = () => {
    if (!companyForm.name) { toast.error('건설사 정보를 먼저 조회해주세요.'); return; }
    setCompanySaved(true);
    toast.success('건설사 정보가 저장되었습니다.');
  };

  // ── Section 2: site selection ──
  const [selectedSiteId, setSelectedSiteId] = useState('');
  const selectedSite = MOCK_SITES.find(s => s.id === selectedSiteId) ?? null;

  // ── Section 3: share code ──
  const [shareCode, setShareCode]         = useState('');
  const [codeGenerated, setCodeGenerated] = useState(false);
  const [codeLoading, setCodeLoading]     = useState(false);

  const handleGenerateCode = () => {
    if (!selectedSite) { toast.error('현장을 먼저 선택해주세요.'); return; }
    setCodeLoading(true);
    setTimeout(() => {
      setShareCode('SITE-8F3K2Q');
      setCodeGenerated(true);
      setCodeLoading(false);
      toast.success('공유 코드가 생성되었습니다.');
    }, 1200);
  };

  const handleCopyCode = () => {
    navigator.clipboard.writeText(shareCode).catch(() => {});
    toast.success('코드가 클립보드에 복사되었습니다.');
  };

  // ── Section 5: subcontractor code input ──
  const [subCodeInput, setSubCodeInput]   = useState('');
  const [subCodeStatus, setSubCodeStatus] = useState<SubCodeStatus>('idle');
  const [subCodeSite, setSubCodeSite]     = useState<typeof MOCK_SITES[0] | null>(null);
  const [subCheckLoading, setSubCheckLoading] = useState(false);

  const handleCheckCode = () => {
    if (!subCodeInput.trim()) { toast.error('공유 코드를 입력해주세요.'); return; }
    setSubCheckLoading(true);
    setTimeout(() => {
      setSubCheckLoading(false);
      if (VALID_CODES[subCodeInput.trim()]) {
        setSubCodeStatus('valid');
        setSubCodeSite(VALID_CODES[subCodeInput.trim()]);
      } else if (EXPIRED_CODES.includes(subCodeInput.trim())) {
        setSubCodeStatus('expired');
        setSubCodeSite(null);
      } else {
        setSubCodeStatus('invalid');
        setSubCodeSite(null);
      }
    }, 1400);
  };

  const handleConnectSite = () => {
    setSubCodeStatus('connected');
    toast.success('현장 연결이 완료되었습니다.');
  };

  return (
    <Layout currentPath="mypage" onNavigate={onNavigate} userType={userType}>
      <div className="flex gap-6 min-h-[calc(100vh-120px)]">

        {/* ── Left Sidebar ── */}
        <aside className="w-56 flex-shrink-0 hidden lg:block">
          <div className="bg-white rounded shadow-sm border border-gray-100 overflow-hidden sticky top-4">
            {/* User summary */}
            <div className="px-5 py-5 bg-gradient-to-br from-[#1A2E44] to-[#003b5c]">
              <div className={`w-11 h-11 rounded-full flex items-center justify-center mb-3 ${isSubcontractor ? 'bg-green-500' : 'bg-[#1A2E44]'}`}>
                <span className="text-white font-bold text-lg">{isSubcontractor ? '이' : '김'}</span>
              </div>
              <p className="text-white font-semibold text-sm">{isSubcontractor ? '이작업자' : '김현장'}</p>
              <span className={`inline-block mt-1 text-[10px] font-bold px-2 py-0.5 rounded-full ${isSubcontractor ? 'bg-green-500/30 text-green-200' : 'bg-[#1A2E44]/30 text-orange-200'}`}>
                {isSubcontractor ? '하청 사용자' : '원청 사용자'}
              </span>
            </div>

            {/* Nav */}
            <nav className="py-2">
              {MENU_ITEMS.map(item => {
                const active = activeMenu === item.id;
                const Icon   = item.icon;
                return (
                  <button
                    key={item.id}
                    onClick={() => setActiveMenu(item.id)}
                    className={`w-full flex items-center gap-3 px-5 py-3 text-sm font-medium transition-all text-left ${
                      active
                        ? 'bg-[#1A2E44]/8 text-[#1A2E44] border-r-2 border-[#1A2E44] font-semibold'
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    }`}
                  >
                    <Icon className={`w-4 h-4 flex-shrink-0 ${active ? 'text-[#1A2E44]' : 'text-gray-400'}`} />
                    {item.label}
                  </button>
                );
              })}
            </nav>

            {/* Logout */}
            <div className="border-t border-gray-100 p-3">
              <button onClick={() => onNavigate('landing')}
                className="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 rounded transition-colors font-medium">
                <LogOut className="w-4 h-4" /> 로그아웃
              </button>
            </div>
          </div>
        </aside>

        {/* ── Main Content ── */}
        <div className="flex-1 min-w-0 space-y-6">

          {/* Page title */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-1">마이페이지 › 설정</p>
              <h1 className="text-xl font-bold text-gray-900">{MENU_ITEMS.find(m => m.id === activeMenu)?.label}</h1>
            </div>
            {/* Mobile nav (simple select) */}
            <div className="lg:hidden">
              <select value={activeMenu} onChange={e => setActiveMenu(e.target.value as MenuId)}
                className="px-3 py-2 border border-gray-200 rounded text-sm outline-none bg-white">
                {MENU_ITEMS.map(m => <option key={m.id} value={m.id}>{m.label}</option>)}
              </select>
            </div>
          </div>

          {/* ════════════════════════════════════════════ */}
          {/* MENU: 내 정보                               */}
          {/* ════════════════════════════════════════════ */}
          {activeMenu === 'profile' && (
            <Section>
              <SectionHeader icon={User} title="내 정보" desc="이름, 이메일, 연락처 등 기본 정보를 수정합니다." />
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <Field label="이름" defaultValue={isSubcontractor ? '이작업자' : '김현장'} />
                <Field label="이메일" type="email" defaultValue={isSubcontractor ? 'sub@safemate.com' : 'kim@safemate.com'} />
                <Field label="전화번호" type="tel" defaultValue={isSubcontractor ? '010-9876-5432' : '010-1234-5678'} />
                <Field label="소속 회사" defaultValue={isSubcontractor ? '안전하도급' : '대한안전건설'} />
              </div>
              <div className="pt-2">
                <button onClick={() => toast.success('내 정보가 저장되었습니다.')}
                  className="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">
                  저장
                </button>
              </div>
            </Section>
          )}

          {/* ════════════════════════════════════════════ */}
          {/* MENU: 계정 설정                              */}
          {/* ════════════════════════════════════════════ */}
          {activeMenu === 'account' && (
            <Section>
              <SectionHeader icon={Shield} title="계정 설정" desc="비밀번호 변경 및 계정 관련 설정입니다." />
              <div className="space-y-4 max-w-md">
                <Field label="현재 비밀번호" type="password" defaultValue="••••••••" />
                <Field label="새 비밀번호" type="password" defaultValue="" placeholder="8자 이상 입력" />
                <Field label="비밀번호 확인" type="password" defaultValue="" placeholder="새 비밀번호 재입력" />
                <button onClick={() => toast.success('비밀번호가 변경되었습니다.')}
                  className="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">
                  비밀번호 변경
                </button>
              </div>
            </Section>
          )}

          {/* ════════════════════════════════════════════ */}
          {/* MENU: 건설사 및 현장 연동                     */}
          {/* ════════════════════════════════════════════ */}
          {activeMenu === 'kiscon' && (
            <>

              {/* 역할 안내 배너 */}
              <div className={`flex items-center gap-3 px-5 py-3 rounded border text-sm font-medium ${
                isSubcontractor
                  ? 'bg-green-50 border-green-200 text-green-800'
                  : 'bg-[#1A2E44]/5 border-[#1A2E44]/20 text-[#1A2E44]'
              }`}>
                <div className={`w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ${isSubcontractor ? 'bg-green-500' : 'bg-[#1A2E44]'}`}>
                  <span className="text-white text-[10px] font-bold">{isSubcontractor ? '하' : '원'}</span>
                </div>
                {isSubcontractor
                  ? '하청 사용자 — 원청에게 받은 공유 코드를 입력해 현장에 연결할 수 있습니다.'
                  : '원청 사용자 — 건설사 및 현장을 등록하고 하청 공유 코드를 생성할 수 있습니다.'}
              </div>

              {/* ══ 원청 전용 섹션 §1~§4 ══ */}
              {!isSubcontractor && <>

              {/* ── §1 내 건설사 정보 ── */}
              <Section>
                <SectionHeader
                  icon={Building2}
                  title="내 건설사 정보"
                  desc="KISCON 건설업체정보 기준으로 원청 건설사를 등록합니다."
                  badge="원청"
                  badgeColor="navy"
                />

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 mb-1.5">건설사명</label>
                    <input value={companyForm.name} onChange={e => setCompanyForm(f => ({ ...f, name: e.target.value }))} placeholder="KISCON 조회 후 자동 입력"
                      className={`w-full px-3 py-2.5 border rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all ${kisconFetched ? 'border-green-300 bg-green-50/50' : 'border-gray-200 bg-gray-50'}`} />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 mb-1.5">사업자등록번호</label>
                    <input value={companyForm.bizNo} onChange={e => setCompanyForm(f => ({ ...f, bizNo: e.target.value }))} placeholder="예) 123-45-67890"
                      className={`w-full px-3 py-2.5 border rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all ${kisconFetched ? 'border-green-300 bg-green-50/50' : 'border-gray-200 bg-gray-50'}`} />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 mb-1.5">대표자명</label>
                    <input value={companyForm.ceo} onChange={e => setCompanyForm(f => ({ ...f, ceo: e.target.value }))} placeholder="대표자명"
                      className={`w-full px-3 py-2.5 border rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all ${kisconFetched ? 'border-green-300 bg-green-50/50' : 'border-gray-200 bg-gray-50'}`} />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 mb-1.5">본사 주소</label>
                    <input value={companyForm.address} onChange={e => setCompanyForm(f => ({ ...f, address: e.target.value }))} placeholder="본사 주소"
                      className={`w-full px-3 py-2.5 border rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] transition-all ${kisconFetched ? 'border-green-300 bg-green-50/50' : 'border-gray-200 bg-gray-50'}`} />
                  </div>
                </div>

                {kisconFetched && (
                  <div className="flex items-center gap-2 px-4 py-2.5 bg-green-50 border border-green-200 rounded text-sm text-green-700 font-medium">
                    <CheckCircle2 className="w-4 h-4 text-green-500 flex-shrink-0" />
                    KISCON 가상 조회 완료 — 건설사 정보가 자동 입력되었습니다.
                  </div>
                )}

                <div className="flex flex-wrap gap-3 pt-1">
                  <button onClick={handleKisconSearch} disabled={kisconLoading}
                    className="flex items-center gap-2 px-5 py-2.5 border-2 border-[#1A2E44] text-[#1A2E44] rounded text-sm font-semibold hover:bg-[#1A2E44]/5 transition-colors disabled:opacity-60">
                    {kisconLoading ? <><Loader2 className="w-4 h-4 animate-spin" /> 조회 중...</> : <><Search className="w-4 h-4" /> KISCON 가상 조회</>}
                  </button>
                  <button onClick={handleCompanySave}
                    className={`flex items-center gap-2 px-5 py-2.5 rounded text-sm font-semibold transition-colors ${companySaved ? 'bg-green-600 text-white' : 'bg-[#1A2E44] text-white hover:bg-[#003b5c]'}`}>
                    {companySaved ? <><CheckCircle2 className="w-4 h-4" /> 저장 완료</> : '저장'}
                  </button>
                </div>
              </Section>

              {/* ── §2 현장 위치 선택 ── */}
              <Section>
                <SectionHeader
                  icon={MapPin}
                  title="현장 위치 선택"
                  desc="등록된 건설사 기준으로 KISCON에서 조회된 현장을 선택합니다."
                  badge="원청"
                  badgeColor="navy"
                />

                {/* Site dropdown */}
                <div className="relative max-w-sm">
                  <select
                    value={selectedSiteId}
                    onChange={e => setSelectedSiteId(e.target.value)}
                    className="w-full px-4 py-3 border-2 border-gray-200 rounded text-sm appearance-none outline-none focus:border-[#1A2E44] bg-white pr-10 transition-colors"
                  >
                    <option value="">현장을 선택하세요</option>
                    {MOCK_SITES.map(s => <option key={s.id} value={s.id}>{s.name}</option>)}
                  </select>
                  <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                </div>

                {/* Site detail card */}
                {!selectedSite && (
                  <div className="flex flex-col items-center justify-center py-10 text-gray-300 border-2 border-dashed border-gray-200 rounded">
                    <MapPin className="w-8 h-8 mb-2" />
                    <p className="text-sm text-gray-400">위에서 현장을 선택하면 상세 정보가 표시됩니다</p>
                  </div>
                )}

                {selectedSite && (
                  <div className="border-2 border-[#1A2E44]/20 rounded overflow-hidden">
                    {/* Card header */}
                    <div className="bg-[#1A2E44] px-5 py-4 flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-9 h-9 bg-white/10 rounded flex items-center justify-center">
                          <HardHat className="w-5 h-5 text-white" />
                        </div>
                        <div>
                          <p className="text-white font-bold">{selectedSite.name}</p>
                          <p className="text-white/60 text-xs">{selectedSite.kisconCode}</p>
                        </div>
                      </div>
                      <span className="px-2.5 py-1 bg-green-500/20 text-green-300 text-xs font-bold rounded-full border border-green-500/30">
                        연동 가능
                      </span>
                    </div>
                    {/* Card body */}
                    <div className="p-5 bg-white grid grid-cols-1 sm:grid-cols-2 gap-4">
                      {[
                        { label: '현장명',         value: selectedSite.name,        icon: ClipboardList },
                        { label: '현장 주소',       value: selectedSite.address,     icon: MapPin },
                        { label: '공사 구분',       value: selectedSite.type,        icon: Building },
                        { label: '공사 기간',       value: selectedSite.period,      icon: Calendar },
                        { label: '원청 건설사',     value: selectedSite.contractor,  icon: Building2 },
                        { label: 'KISCON 현장 코드', value: selectedSite.kisconCode,  icon: ExternalLink },
                      ].map((row, i) => (
                        <div key={i} className="flex items-start gap-3 p-3 bg-gray-50 rounded">
                          <row.icon className="w-4 h-4 text-[#1A2E44] flex-shrink-0 mt-0.5" />
                          <div>
                            <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wide">{row.label}</p>
                            <p className="text-sm font-semibold text-gray-900 mt-0.5">{row.value}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </Section>

              {/* ── §3 하청 공유 코드 ── */}
              <Section>
                <SectionHeader
                  icon={Link2}
                  title="하청 공유 코드"
                  desc="선택한 현장을 하청 업체에게 공유할 수 있는 코드를 생성합니다."
                  badge="원청"
                  badgeColor="navy"
                />

                {!codeGenerated ? (
                  <div className="flex flex-col items-center py-8 text-center gap-4">
                    <div className="w-16 h-16 bg-gray-100 rounded flex items-center justify-center">
                      <Link2Off className="w-7 h-7 text-gray-400" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-700">아직 공유 코드가 없습니다</p>
                      <p className="text-xs text-gray-400 mt-1">{selectedSite ? `${selectedSite.name} 현장 코드를 생성합니다` : '먼저 현장을 선택해주세요'}</p>
                    </div>
                    <button onClick={handleGenerateCode} disabled={!selectedSite || codeLoading}
                      className="flex items-center gap-2 px-6 py-3 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors disabled:opacity-50 shadow-lg shadow-[#1A2E44]/20">
                      {codeLoading ? <><Loader2 className="w-4 h-4 animate-spin" />생성 중...</> : <><Sparkles className="w-4 h-4" />공유 코드 생성</>}
                    </button>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {/* Code box */}
                    <div className="relative rounded overflow-hidden border-2 border-[#1A2E44]/20">
                      <div className="bg-[#1A2E44]/5 border-b border-[#1A2E44]/10 px-4 py-2.5 flex items-center gap-2">
                        <div className="w-2 h-2 rounded-full bg-green-400" />
                        <span className="text-xs font-semibold text-gray-600">현장 공유 코드</span>
                        {selectedSite && <span className="ml-auto text-xs text-gray-400">{selectedSite.name}</span>}
                      </div>
                      <div className="bg-white px-6 py-6 flex items-center justify-between">
                        <div>
                          <p className="text-3xl font-bold tracking-widest text-[#1A2E44] font-mono">{shareCode}</p>
                          <p className="text-xs text-gray-400 mt-1.5">하청 업체에 이 코드를 전달하세요</p>
                        </div>
                        <button onClick={handleCopyCode}
                          className="flex items-center gap-2 px-4 py-2.5 border-2 border-[#1A2E44] text-[#1A2E44] rounded text-sm font-semibold hover:bg-[#1A2E44]/5 transition-colors">
                          <Copy className="w-4 h-4" /> 복사
                        </button>
                      </div>
                    </div>

                    {/* Guide text */}
                    <div className="flex items-start gap-3 p-4 bg-blue-50 border border-blue-200 rounded">
                      <AlertCircle className="w-4 h-4 text-blue-500 flex-shrink-0 mt-0.5" />
                      <p className="text-xs text-blue-800 leading-relaxed">
                        이 코드를 하청 업체 담당자에게 전달하면 해당 현장과 원청 정보가 자동 연결됩니다.
                      </p>
                    </div>

                    {/* Code status */}
                    <div className="grid grid-cols-3 gap-3">
                      {[
                        { label: '상태',         value: '활성',           color: 'text-green-700', bg: 'bg-green-50', border: 'border-green-200' },
                        { label: '만료일',        value: '2026.09.30',    color: 'text-gray-700',  bg: 'bg-gray-50',  border: 'border-gray-200' },
                        { label: '연결된 하청 수', value: '3개 업체',      color: 'text-[#1A2E44]', bg: 'bg-[#1A2E44]/5', border: 'border-[#1A2E44]/20' },
                      ].map(s => (
                        <div key={s.label} className={`rounded border px-4 py-3 ${s.bg} ${s.border}`}>
                          <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wide">{s.label}</p>
                          <p className={`text-sm font-bold mt-0.5 ${s.color}`}>{s.value}</p>
                        </div>
                      ))}
                    </div>

                    {/* Regenerate */}
                    <button onClick={() => { setCodeGenerated(false); setShareCode(''); }}
                      className="flex items-center gap-2 text-xs text-gray-500 hover:text-gray-700 transition-colors">
                      <RefreshCw className="w-3.5 h-3.5" /> 새 코드 재생성
                    </button>
                  </div>
                )}
              </Section>

              {/* ── §4 연결된 하청 업체 ── */}
              <Section>
                <SectionHeader
                  icon={Users}
                  title="연결된 하청 업체"
                  desc="현재 현장에 연결된 하청 업체 목록입니다."
                  badge="원청"
                  badgeColor="navy"
                />

                <div className="overflow-x-auto rounded border border-gray-200">
                  <table className="w-full text-sm min-w-[640px]">
                    <thead className="bg-gray-50 border-b border-gray-200">
                      <tr>
                        {['하청 업체명', '담당자', '연락처', '연결 현장', '연결일', '상태'].map(h => (
                          <th key={h} className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">{h}</th>
                        ))}
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100 bg-white">
                      {MOCK_SUBCONTRACTORS.map((row, i) => (
                        <tr key={i} className="hover:bg-gray-50 transition-colors">
                          <td className="px-4 py-3.5">
                            <div className="flex items-center gap-2.5">
                              <div className="w-7 h-7 bg-[#1A2E44]/10 rounded-lg flex items-center justify-center flex-shrink-0">
                                <span className="text-[#1A2E44] font-bold text-xs">{row.name[0]}</span>
                              </div>
                              <span className="font-semibold text-gray-900">{row.name}</span>
                            </div>
                          </td>
                          <td className="px-4 py-3.5 text-gray-700">{row.manager}</td>
                          <td className="px-4 py-3.5 text-gray-500 font-mono text-xs">{row.phone}</td>
                          <td className="px-4 py-3.5">
                            <span className="text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-lg font-medium">{row.site}</span>
                          </td>
                          <td className="px-4 py-3.5 text-gray-500 text-xs whitespace-nowrap">{row.joinDate}</td>
                          <td className="px-4 py-3.5">
                            <span className="inline-flex items-center gap-1.5 px-2.5 py-1 bg-green-50 text-green-700 text-xs font-semibold rounded-full border border-green-200">
                              <span className="w-1.5 h-1.5 rounded-full bg-green-500" />
                              {row.status}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </Section>

              {/* ══ 원청 전용 섹션 끝 ══ */}
              </>}

              {/* ── §5 하청 전용: 코드 입력 ── */}
              {isSubcontractor && <Section highlight>
                <SectionHeader
                  icon={Link2}
                  title="원청 현장 연결"
                  desc="원청에게 받은 현장 공유 코드를 입력하면 원청 건설사와 현장이 자동 연결됩니다."
                  badge="하청"
                  badgeColor="green"
                />

                {/* Input + check */}
                <div className="flex gap-3 max-w-md">
                  <div className="flex-1 relative">
                    <input
                      value={subCodeInput}
                      onChange={e => { setSubCodeInput(e.target.value.toUpperCase()); setSubCodeStatus('idle'); }}
                      placeholder="예) SITE-8F3K2Q"
                      maxLength={12}
                      className={`w-full px-4 py-3 border-2 rounded text-sm font-mono tracking-widest outline-none transition-all ${
                        subCodeStatus === 'valid' || subCodeStatus === 'connected' ? 'border-green-400 bg-green-50 text-green-800' :
                        subCodeStatus === 'invalid' || subCodeStatus === 'expired' ? 'border-red-400 bg-red-50 text-red-800' :
                        'border-gray-200 focus:border-[#1A2E44]'
                      }`}
                    />
                  </div>
                  <button
                    onClick={handleCheckCode}
                    disabled={subCheckLoading || !subCodeInput.trim() || subCodeStatus === 'connected'}
                    className="px-5 py-3 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors disabled:opacity-50 whitespace-nowrap flex items-center gap-2"
                  >
                    {subCheckLoading ? <><Loader2 className="w-4 h-4 animate-spin" />확인 중</> : '코드 확인'}
                  </button>
                </div>

                {/* Error states */}
                {subCodeStatus === 'invalid' && (
                  <div className="flex items-center gap-2 px-4 py-3 bg-red-50 border border-red-200 rounded text-sm text-red-700">
                    <AlertCircle className="w-4 h-4 flex-shrink-0" />
                    잘못된 코드입니다. 원청에게 받은 코드를 다시 확인해주세요.
                  </div>
                )}
                {subCodeStatus === 'expired' && (
                  <div className="flex items-center gap-2 px-4 py-3 bg-red-50 border border-red-200 rounded text-sm text-red-700">
                    <AlertCircle className="w-4 h-4 flex-shrink-0" />
                    만료된 공유 코드입니다. 원청 담당자에게 새 코드를 요청해주세요.
                  </div>
                )}

                {/* Valid: show site info + connect button */}
                {(subCodeStatus === 'valid' || subCodeStatus === 'connected') && subCodeSite && (
                  <div className="space-y-4">
                    <div className="border-2 border-green-200 rounded overflow-hidden">
                      <div className={`px-5 py-3 flex items-center justify-between ${subCodeStatus === 'connected' ? 'bg-green-600' : 'bg-green-50 border-b border-green-200'}`}>
                        <div className="flex items-center gap-2">
                          <CheckCircle2 className={`w-4 h-4 ${subCodeStatus === 'connected' ? 'text-white' : 'text-green-600'}`} />
                          <span className={`text-sm font-semibold ${subCodeStatus === 'connected' ? 'text-white' : 'text-green-800'}`}>
                            {subCodeStatus === 'connected' ? '현장 연결 완료' : '코드 확인 완료 — 아래 정보를 확인 후 연결하세요'}
                          </span>
                        </div>
                        {subCodeStatus === 'connected' && (
                          <span className="px-3 py-1 bg-white/20 text-white text-xs font-bold rounded-full border border-white/30">연결 완료</span>
                        )}
                      </div>
                      <div className="p-5 bg-white grid grid-cols-1 sm:grid-cols-2 gap-3">
                        {[
                          { label: '원청 건설사',      value: subCodeSite.contractor },
                          { label: '현장명',           value: subCodeSite.name },
                          { label: '현장 주소',        value: subCodeSite.address },
                          { label: '공사 구분',        value: subCodeSite.type },
                          { label: 'KISCON 현장 코드', value: subCodeSite.kisconCode },
                        ].map((r, i) => (
                          <div key={i} className="p-3 bg-gray-50 rounded">
                            <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wide">{r.label}</p>
                            <p className="text-sm font-semibold text-gray-900 mt-0.5">{r.value}</p>
                          </div>
                        ))}
                      </div>
                    </div>

                    {subCodeStatus === 'valid' && (
                      <button onClick={handleConnectSite}
                        className="flex items-center gap-2 px-6 py-3 bg-green-600 text-white rounded text-sm font-bold hover:bg-green-700 transition-colors shadow-lg shadow-green-600/20">
                        <Link2 className="w-4 h-4" /> 현장 연결하기
                      </button>
                    )}
                    {subCodeStatus === 'connected' && (
                      <div className="flex items-center gap-2 text-sm text-green-700 font-semibold">
                        <CheckCircle2 className="w-5 h-5" />
                        원청 현장이 연결되었습니다. 이제 안전관리 데이터가 공유됩니다.
                      </div>
                    )}
                  </div>
                )}

                {/* Demo hint */}
                <p className="text-[11px] text-gray-400 flex items-center gap-1.5">
                  <Sparkles className="w-3 h-3" />
                  테스트 코드: <span className="font-mono font-semibold text-gray-600">SITE-8F3K2Q</span> (정상) / <span className="font-mono font-semibold text-gray-600">SITE-EXPIRED</span> (만료)
                </p>
              </Section>}

            </>
          )}

          {/* ════════════════════════════════════════════ */}
          {/* MENU: 알림 설정                              */}
          {/* ════════════════════════════════════════════ */}
          {activeMenu === 'notifications' && (
            <Section>
              <SectionHeader icon={Bell} title="알림 설정" desc="알림 수신 방법과 조건을 설정합니다." />
              <div className="divide-y divide-gray-100">
                {[
                  { label: '이메일 알림',    desc: '중요 알림을 이메일로 수신합니다',      checked: true },
                  { label: '조치 마감 알림', desc: '마감 1일 전 미리 알림을 받습니다',      checked: true },
                  { label: '댓글 알림',      desc: '새 댓글이 달리면 알림을 받습니다',      checked: true },
                  { label: '주간 리포트',    desc: '매주 월요일 주간 리포트를 받습니다',    checked: false },
                  { label: 'AI 분석 완료',   desc: 'AI 분석이 완료되면 알림을 받습니다',    checked: true },
                ].map((s, i) => (
                  <label key={i} className="flex items-center justify-between py-4 cursor-pointer">
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{s.label}</p>
                      <p className="text-xs text-gray-500 mt-0.5">{s.desc}</p>
                    </div>
                    <input type="checkbox" defaultChecked={s.checked}
                      className="w-5 h-5 rounded text-[#1A2E44] accent-[#1A2E44] flex-shrink-0" />
                  </label>
                ))}
              </div>
              <button onClick={() => toast.success('알림 설정이 저장되었습니다.')}
                className="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">
                저장
              </button>
            </Section>
          )}

          {/* ════════════════════════════════════════════ */}
          {/* MENU: 보안 설정                              */}
          {/* ════════════════════════════════════════════ */}
          {activeMenu === 'security' && (
            <Section>
              <SectionHeader icon={Lock} title="보안 설정" desc="2단계 인증 및 세션 관리를 설정합니다." />
              <div className="divide-y divide-gray-100">
                {[
                  { label: '2단계 인증 (OTP)', desc: '로그인 시 추가 인증을 요구합니다', checked: false },
                  { label: '새 기기 로그인 알림', desc: '새 기기에서 로그인 시 이메일로 알립니다', checked: true },
                  { label: '자동 로그아웃', desc: '30분 비활성 시 자동으로 로그아웃됩니다', checked: true },
                ].map((s, i) => (
                  <label key={i} className="flex items-center justify-between py-4 cursor-pointer">
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{s.label}</p>
                      <p className="text-xs text-gray-500 mt-0.5">{s.desc}</p>
                    </div>
                    <input type="checkbox" defaultChecked={s.checked}
                      className="w-5 h-5 rounded text-[#1A2E44] accent-[#1A2E44] flex-shrink-0" />
                  </label>
                ))}
              </div>
              <button onClick={() => toast.success('보안 설정이 저장되었습니다.')}
                className="px-6 py-2.5 bg-[#1A2E44] text-white rounded text-sm font-semibold hover:bg-[#003b5c] transition-colors">
                저장
              </button>
            </Section>
          )}

        </div>
      </div>
    </Layout>
  );
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function Section({ children, highlight }: { children: ReactNode; highlight?: boolean }) {
  return (
    <div className={`rounded shadow-sm border p-6 space-y-5 ${highlight ? 'bg-gradient-to-br from-green-50/80 to-white border-green-200' : 'bg-white border-gray-100'}`}>
      {children}
    </div>
  );
}

function SectionHeader({
  icon: Icon, title, desc, badge, badgeColor,
}: {
  icon: ElementType; title: string; desc: string;
  badge?: string; badgeColor?: 'navy' | 'green';
}) {
  return (
    <div className="flex items-start gap-3 pb-1">
      <div className={`w-9 h-9 rounded flex items-center justify-center flex-shrink-0 ${badgeColor === 'green' ? 'bg-green-100' : 'bg-[#1A2E44]/10'}`}>
        <Icon className={`w-5 h-5 ${badgeColor === 'green' ? 'text-green-700' : 'text-[#1A2E44]'}`} />
      </div>
      <div className="flex-1">
        <div className="flex items-center gap-2 flex-wrap">
          <h2 className="text-base font-bold text-gray-900">{title}</h2>
          {badge && (
            <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
              badgeColor === 'green' ? 'bg-green-100 text-green-700' : 'bg-[#1A2E44]/10 text-[#1A2E44]'
            }`}>{badge}</span>
          )}
        </div>
        <p className="text-xs text-gray-500 mt-0.5 leading-relaxed">{desc}</p>
      </div>
    </div>
  );
}

function Field({
  label, defaultValue = '', type = 'text', placeholder,
}: {
  label: string; defaultValue?: string; type?: string; placeholder?: string;
}) {
  return (
    <div>
      <label className="block text-xs font-semibold text-gray-500 mb-1.5">{label}</label>
      <input type={type} defaultValue={defaultValue} placeholder={placeholder}
        className="w-full px-3 py-2.5 border border-gray-200 rounded text-sm outline-none focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent transition-all" />
    </div>
  );
}
