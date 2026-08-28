import { useState } from 'react';
import { Shield, User, Mail, Lock, Building2, IdCard, CheckCircle2, ArrowLeft, HardHat, Building } from 'lucide-react';
import { toast } from 'sonner';

interface SignupPageProps {
  onNavigate: (page: string) => void;
}

type Role = 'contractor' | 'subcontractor' | '';

export default function SignupPage({ onNavigate }: SignupPageProps) {
  const [selectedRole, setSelectedRole] = useState<Role>('');
  const [form, setForm] = useState({
    userId: '',
    name: '',
    email: '',
    password: '',
    passwordConfirm: '',
    company: '',
  });

  const [idChecked, setIdChecked] = useState(false);
  const [emailVerified, setEmailVerified] = useState(false);
  const [emailCodeSent, setEmailCodeSent] = useState(false);
  const [verifyCode, setVerifyCode] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleChange = (field: string, value: string) => {
    setForm(prev => ({ ...prev, [field]: value }));
    if (field === 'userId') setIdChecked(false);
    setErrors(prev => ({ ...prev, [field]: '' }));
  };

  const handleIdCheck = () => {
    if (!form.userId.trim()) { setErrors(p => ({ ...p, userId: '아이디를 입력해주세요.' })); return; }
    if (form.userId.length < 4) { setErrors(p => ({ ...p, userId: '4자 이상이어야 합니다.' })); return; }
    setIdChecked(true);
    toast.success('사용 가능한 아이디입니다.');
  };

  const handleEmailVerify = () => {
    if (!form.email.includes('@')) { setErrors(p => ({ ...p, email: '올바른 이메일을 입력해주세요.' })); return; }
    setEmailCodeSent(true);
    toast.success(`${form.email}로 인증 코드를 발송했습니다.`);
  };

  const handleVerifyCode = () => {
    if (verifyCode === '123456' || verifyCode.length === 6) {
      setEmailVerified(true);
      toast.success('이메일 인증이 완료되었습니다!');
    } else {
      toast.error('인증 코드가 올바르지 않습니다. (테스트: 123456)');
    }
  };

  const validate = () => {
    const e: Record<string, string> = {};
    if (!form.userId.trim() || !idChecked) e.userId = '아이디 중복확인을 해주세요.';
    if (!form.name.trim()) e.name = '이름을 입력해주세요.';
    if (!emailVerified) e.email = '이메일 인증을 완료해주세요.';
    if (form.password.length < 6) e.password = '6자 이상이어야 합니다.';
    if (form.password !== form.passwordConfirm) e.passwordConfirm = '비밀번호가 일치하지 않습니다.';
    if (!form.company.trim()) e.company = '회사명을 입력해주세요.';
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    toast.success('회원가입이 완료되었습니다! 로그인해주세요.');
    onNavigate('login');
  };

  // ── 역할 선택 화면 ──
  if (!selectedRole) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-8 py-16 bg-gradient-to-br from-[#1A2E44] to-[#2C5282]">

        <div className="text-center mb-14">
          <div className="flex items-center justify-center gap-3 mb-5">
            <div className="w-14 h-14 bg-[#1A2E44] rounded flex items-center justify-center shadow-lg">
              <Shield className="w-8 h-8 text-white" />
            </div>
            <span className="text-white font-bold text-3xl">SafeMate</span>
          </div>
          <h1 className="text-4xl font-bold text-white mb-3">회원가입</h1>
          <p className="text-white/60 text-lg">계정 유형을 선택해주세요</p>
        </div>

        {/* Role cards */}
        <div className="grid grid-cols-2 gap-8 w-full max-w-2xl">
          {[
            {
              role: 'contractor' as Role,
              number: 1,
              label: '원청',
              sublabel: '발주처 / 원도급사',
              desc: '현장 전체 안전 관리 및 하청 업체 감독',
              Icon: Building,
              accent: '#1A2E44',
            },
            {
              role: 'subcontractor' as Role,
              number: 2,
              label: '하청',
              sublabel: '하도급사 / 협력업체',
              desc: '현장 작업 및 안전 조치 이행 보고',
              Icon: HardHat,
              accent: '#22c55e',
            },
          ].map(item => (
            <button
              key={item.role}
              onClick={() => setSelectedRole(item.role)}
              className="group bg-white rounded p-10 flex flex-col items-center gap-5 shadow-2xl hover:scale-[1.04] transition-all duration-200 hover:shadow-[0_24px_64px_rgba(0,0,0,0.35)] relative overflow-hidden"
            >
              {/* Number badge */}
              <div
                className="absolute top-5 left-5 w-9 h-9 rounded-full border-2 flex items-center justify-center text-base font-bold"
                style={{ borderColor: item.accent, color: item.accent }}
              >
                {item.number}
              </div>

              {/* Icon */}
              <div
                className="w-28 h-28 rounded-full flex items-center justify-center mt-6"
                style={{ background: `${item.accent}15` }}
              >
                <item.Icon
                  className="w-14 h-14 transition-transform group-hover:scale-110"
                  style={{ color: item.accent }}
                />
              </div>

              {/* Label */}
              <div className="text-center">
                <p className="text-2xl font-bold text-gray-900">{item.label}</p>
                <p className="text-sm text-gray-500 mt-1.5">{item.sublabel}</p>
              </div>

              {/* Desc */}
              <p className="text-sm text-gray-400 text-center leading-relaxed">{item.desc}</p>

              {/* Bottom accent line */}
              <div
                className="absolute bottom-0 left-0 right-0 h-1 rounded-b-2xl opacity-0 group-hover:opacity-100 transition-opacity"
                style={{ background: item.accent }}
              />
            </button>
          ))}
        </div>

        <p className="mt-10 text-white/50 text-base">
          이미 계정이 있으신가요?{' '}
          <button onClick={() => onNavigate('login')} className="text-[#1A2E44] hover:underline">
            로그인하기
          </button>
        </p>
      </div>
    );
  }

  // ── 회원가입 폼 ──
  const isContractor = selectedRole === 'contractor';
  const accent = isContractor ? '#1A2E44' : '#22c55e';
  const roleLabel = isContractor ? '원청' : '하청';

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1A2E44] to-[#2C5282] flex items-center justify-center px-4 py-10">
      <div className="bg-white rounded shadow-2xl w-full max-w-lg overflow-hidden">
        {/* Header */}
        <div className="p-8 text-white" style={{ background: `linear-gradient(135deg, #1A2E44, #2C5282)` }}>
          <button
            onClick={() => setSelectedRole('')}
            className="flex items-center gap-2 text-white/60 hover:text-white transition-colors mb-5 text-sm"
          >
            <ArrowLeft className="w-4 h-4" /> 유형 선택으로
          </button>
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded flex items-center justify-center shadow-lg" style={{ background: accent }}>
              {isContractor ? <Building className="w-6 h-6 text-white" /> : <HardHat className="w-6 h-6 text-white" />}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-bold text-white">회원가입</h1>
                <span className="text-xs font-bold px-2.5 py-1 rounded-full" style={{ background: `${accent}30`, color: accent }}>
                  {roleLabel}
                </span>
              </div>
              <p className="text-white/60 text-sm">{isContractor ? '발주처 / 원도급사' : '하도급사 / 협력업체'}</p>
            </div>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-8 space-y-4">
          {/* 아이디 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">아이디 <span className="text-red-500">*</span></label>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <IdCard className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  value={form.userId}
                  onChange={e => handleChange('userId', e.target.value)}
                  placeholder="영문, 숫자 4~16자"
                  className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none transition-all ${idChecked ? 'border-green-400 bg-green-50' : errors.userId ? 'border-red-400' : 'border-gray-300'}`}
                  style={{ '--tw-ring-color': accent } as React.CSSProperties}
                />
              </div>
              <button type="button" onClick={handleIdCheck}
                className={`px-4 py-2.5 rounded text-sm font-semibold whitespace-nowrap transition-colors text-white ${idChecked ? 'bg-green-500' : ''}`}
                style={!idChecked ? { background: '#1A2E44' } : undefined}
              >
                {idChecked ? <span className="flex items-center gap-1"><CheckCircle2 className="w-4 h-4" />확인됨</span> : '중복확인'}
              </button>
            </div>
            {errors.userId && <p className="text-red-500 text-xs mt-1">{errors.userId}</p>}
          </div>

          {/* 이름 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">이름 <span className="text-red-500">*</span></label>
            <div className="relative">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                value={form.name}
                onChange={e => handleChange('name', e.target.value)}
                placeholder="실명 입력"
                className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none ${errors.name ? 'border-red-400' : 'border-gray-300'}`}
              />
            </div>
            {errors.name && <p className="text-red-500 text-xs mt-1">{errors.name}</p>}
          </div>

          {/* 이메일 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">이메일 <span className="text-red-500">*</span></label>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="email"
                  value={form.email}
                  onChange={e => handleChange('email', e.target.value)}
                  placeholder="your@email.com"
                  className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none ${emailVerified ? 'border-green-400 bg-green-50' : errors.email ? 'border-red-400' : 'border-gray-300'}`}
                />
              </div>
              <button type="button" onClick={handleEmailVerify} disabled={emailVerified}
                className="px-4 py-2.5 rounded text-sm font-semibold whitespace-nowrap transition-colors text-white disabled:cursor-not-allowed"
                style={{ background: emailVerified ? '#22c55e' : accent }}
              >
                {emailVerified ? <span className="flex items-center gap-1"><CheckCircle2 className="w-4 h-4" />인증완료</span> : '이메일 인증'}
              </button>
            </div>
            {errors.email && <p className="text-red-500 text-xs mt-1">{errors.email}</p>}
            {emailCodeSent && !emailVerified && (
              <div className="flex gap-2 mt-2">
                <input
                  type="text"
                  value={verifyCode}
                  onChange={e => setVerifyCode(e.target.value)}
                  placeholder="6자리 인증코드 입력 (테스트: 123456)"
                  maxLength={6}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 outline-none"
                />
                <button type="button" onClick={handleVerifyCode}
                  className="px-4 py-2 rounded text-sm font-semibold text-white"
                  style={{ background: '#1A2E44' }}
                >확인</button>
              </div>
            )}
          </div>

          {/* 비밀번호 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input type="password" value={form.password} onChange={e => handleChange('password', e.target.value)}
                placeholder="6자 이상"
                className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none ${errors.password ? 'border-red-400' : 'border-gray-300'}`}
              />
            </div>
            {errors.password && <p className="text-red-500 text-xs mt-1">{errors.password}</p>}
          </div>

          {/* 비밀번호 확인 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">비밀번호 확인 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input type="password" value={form.passwordConfirm} onChange={e => handleChange('passwordConfirm', e.target.value)}
                placeholder="비밀번호 재입력"
                className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none ${
                  form.passwordConfirm && form.password !== form.passwordConfirm ? 'border-red-400' :
                  form.passwordConfirm && form.password === form.passwordConfirm ? 'border-green-400 bg-green-50' :
                  'border-gray-300'}`}
              />
            </div>
            {errors.passwordConfirm && <p className="text-red-500 text-xs mt-1">{errors.passwordConfirm}</p>}
            {form.passwordConfirm && form.password === form.passwordConfirm && (
              <p className="text-green-600 text-xs mt-1 flex items-center gap-1"><CheckCircle2 className="w-3 h-3" />비밀번호가 일치합니다.</p>
            )}
          </div>

          {/* 회사명 */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">회사명 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Building2 className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input type="text" value={form.company} onChange={e => handleChange('company', e.target.value)}
                placeholder="소속 회사명"
                className={`w-full pl-9 pr-4 py-2.5 border rounded text-sm focus:ring-2 outline-none ${errors.company ? 'border-red-400' : 'border-gray-300'}`}
              />
            </div>
            {errors.company && <p className="text-red-500 text-xs mt-1">{errors.company}</p>}
          </div>

          <button type="submit"
            className="w-full py-4 text-white rounded font-bold text-base transition-all shadow-lg mt-2"
            style={{ background: accent }}
          >
            {roleLabel} 계정 회원가입
          </button>

          <p className="text-center text-sm text-gray-500">
            이미 계정이 있으신가요?{' '}
            <button type="button" onClick={() => onNavigate('login')} className="font-semibold hover:underline" style={{ color: accent }}>
              로그인하기
            </button>
          </p>
        </form>
      </div>
    </div>
  );
}
