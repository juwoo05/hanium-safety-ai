import { useState } from 'react';
import { User, Mail, Lock, Building2, IdCard, CheckCircle2, ArrowLeft } from 'lucide-react';
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
      <div className="min-h-screen flex flex-col items-center justify-center px-5 py-10 bg-[#F7F8FA] text-[#0F172A]">

        <div className="text-center mb-6">
          <div className="flex items-center justify-center gap-2 mb-8">
            <img src="/app/images/yeongyeol-gori-logo.png" alt="연결고리 로고" className="w-7 h-7 object-contain" />
            <span className="text-[#0F172A] font-bold text-lg">연결고리</span>
          </div>
          <h1 className="text-lg font-semibold text-[#0F172A] mb-1.5">회원가입</h1>
          <p className="text-xs text-gray-400">계정 유형을 선택해주세요</p>
        </div>

        {/* Role cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full max-w-2xl">
          {[
            {
              role: 'contractor' as Role,
              number: 1,
              label: '원청',
              sublabel: '발주처 / 원도급사',
              desc: '현장 전체 안전 관리 및 하청 업체 감독',
              image: '/app/images/contractor-role-icon.svg',
              accent: '#086CF0',
              iconSize: 'w-16 h-16',
            },
            {
              role: 'subcontractor' as Role,
              number: 2,
              label: '하청',
              sublabel: '하도급사 / 협력업체',
              desc: '현장 작업 및 안전 조치 이행 보고',
              image: '/app/images/subcontractor-role-icon.svg',
              accent: '#FF7A00',
              iconSize: 'w-[74px] h-[74px]',
            },
          ].map(item => (
            <button
              key={item.role}
              onClick={() => setSelectedRole(item.role)}
              className="group bg-white rounded-md p-7 flex flex-col items-center gap-3 border border-gray-200 hover:shadow-sm relative overflow-hidden transition-all duration-200"
            >
              {/* Number badge */}
              <div
                className="absolute top-4 left-4 w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold"
                style={{ background: `${item.accent}14`, color: item.accent }}
              >
                {item.number}
              </div>

              {/* Icon */}
              <div
                className="w-20 h-20 rounded flex items-center justify-center mt-3"
                style={{ background: `${item.accent}0D` }}
              >
                <img
                  src={item.image}
                  alt={`${item.label} 아이콘`}
                className={`${item.iconSize} object-contain transition-transform group-hover:scale-105`}
                />
              </div>

              {/* Label */}
              <div className="text-center">
                <p className="text-lg font-semibold text-gray-900">{item.label}</p>
                <p className="text-xs text-gray-400 mt-1">{item.sublabel}</p>
              </div>

              {/* Desc */}
              <p className="text-xs text-gray-400 text-center leading-relaxed">{item.desc}</p>

              {/* Bottom accent line */}
              <div
                className="absolute bottom-0 left-0 right-0 h-1 opacity-0 group-hover:opacity-100 transition-opacity"
                style={{ background: item.accent }}
              />
            </button>
          ))}
        </div>

        <p className="mt-6 text-gray-400 text-xs">
          이미 계정이 있으신가요?{' '}
          <button onClick={() => onNavigate('login')} className="text-[#1A2E44] font-semibold hover:underline">
            로그인하기
          </button>
        </p>
      </div>
    );
  }

  // ── 회원가입 폼 ──
  const isContractor = selectedRole === 'contractor';
  const accent = isContractor ? '#086CF0' : '#FF7A00';
  const roleLabel = isContractor ? '원청' : '하청';
  const inputClass = 'w-full pl-9 pr-3 py-[9px] border rounded text-[13px] outline-none transition-colors focus:ring-1 focus:border-[#1A2E44] focus:ring-[#1A2E44]';
  const labelClass = 'block text-xs font-medium text-gray-700 mb-1.5';

  return (
    <div className="min-h-screen bg-[#F7F8FA] flex items-center justify-center px-6 py-10 text-[#0F172A]">
      <div className="bg-white rounded-md border border-gray-200 w-full max-w-[400px] overflow-hidden">
        {/* Header */}
        <div className="px-9 pt-7 pb-5 border-b border-gray-100 bg-white">
          <button
            onClick={() => setSelectedRole('')}
            className="flex items-center gap-1.5 text-gray-400 hover:text-[#1A2E44] transition-colors mb-4 text-xs"
          >
            <ArrowLeft className="w-4 h-4" /> 유형 선택으로
          </button>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded flex items-center justify-center" style={{ background: `${accent}0D` }}>
              <img
                src={isContractor ? '/app/images/contractor-role-icon.svg' : '/app/images/subcontractor-role-icon.svg'}
                alt={`${roleLabel} 아이콘`}
                className="w-9 h-9 object-contain"
              />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-lg font-semibold text-[#0F172A]">회원가입</h1>
                <span className="text-[11px] font-semibold px-2 py-0.5 rounded" style={{ background: `${accent}14`, color: accent }}>
                  {roleLabel}
                </span>
              </div>
              <p className="text-gray-400 text-xs mt-0.5">{isContractor ? '발주처 / 원도급사' : '하도급사 / 협력업체'}</p>
            </div>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="px-9 py-7 space-y-4">
          {/* 아이디 */}
          <div>
            <label className={labelClass}>아이디 <span className="text-red-500">*</span></label>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <IdCard className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
                <input
                  type="text"
                  value={form.userId}
                  onChange={e => handleChange('userId', e.target.value)}
                  placeholder="영문, 숫자 4~16자"
                  className={`${inputClass} ${idChecked ? 'border-green-400 bg-green-50' : errors.userId ? 'border-red-400' : 'border-gray-200'}`}
                  style={{ '--tw-ring-color': accent } as React.CSSProperties}
                />
              </div>
              <button type="button" onClick={handleIdCheck}
                className={`px-3 py-[9px] rounded text-xs font-semibold whitespace-nowrap transition-colors text-white ${idChecked ? 'bg-green-500' : ''}`}
                style={!idChecked ? { background: '#1A2E44' } : undefined}
              >
                {idChecked ? <span className="flex items-center gap-1"><CheckCircle2 className="w-4 h-4" />확인됨</span> : '중복확인'}
              </button>
            </div>
            {errors.userId && <p className="text-red-500 text-xs mt-1">{errors.userId}</p>}
          </div>

          {/* 이름 */}
          <div>
            <label className={labelClass}>이름 <span className="text-red-500">*</span></label>
            <div className="relative">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
              <input
                type="text"
                value={form.name}
                onChange={e => handleChange('name', e.target.value)}
                placeholder="실명 입력"
                className={`${inputClass} ${errors.name ? 'border-red-400' : 'border-gray-200'}`}
              />
            </div>
            {errors.name && <p className="text-red-500 text-xs mt-1">{errors.name}</p>}
          </div>

          {/* 이메일 */}
          <div>
            <label className={labelClass}>이메일 <span className="text-red-500">*</span></label>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
                <input
                  type="email"
                  value={form.email}
                  onChange={e => handleChange('email', e.target.value)}
                  placeholder="your@email.com"
                  className={`${inputClass} ${emailVerified ? 'border-green-400 bg-green-50' : errors.email ? 'border-red-400' : 'border-gray-200'}`}
                />
              </div>
              <button type="button" onClick={handleEmailVerify} disabled={emailVerified}
                className="px-3 py-[9px] rounded text-xs font-semibold whitespace-nowrap transition-colors text-white disabled:cursor-not-allowed"
                style={{ background: emailVerified ? '#22c55e' : '#1A2E44' }}
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
                  className="flex-1 px-3 py-[9px] border border-gray-200 rounded text-[13px] focus:ring-1 focus:ring-[#1A2E44] outline-none"
                />
                <button type="button" onClick={handleVerifyCode}
                  className="px-3 py-[9px] rounded text-xs font-semibold text-white"
                  style={{ background: '#1A2E44' }}
                >확인</button>
              </div>
            )}
          </div>

          {/* 비밀번호 */}
          <div>
            <label className={labelClass}>비밀번호 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
              <input type="password" value={form.password} onChange={e => handleChange('password', e.target.value)}
                placeholder="6자 이상"
                className={`${inputClass} ${errors.password ? 'border-red-400' : 'border-gray-200'}`}
              />
            </div>
            {errors.password && <p className="text-red-500 text-xs mt-1">{errors.password}</p>}
          </div>

          {/* 비밀번호 확인 */}
          <div>
            <label className={labelClass}>비밀번호 확인 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
              <input type="password" value={form.passwordConfirm} onChange={e => handleChange('passwordConfirm', e.target.value)}
                placeholder="비밀번호 재입력"
                className={`${inputClass} ${
                  form.passwordConfirm && form.password !== form.passwordConfirm ? 'border-red-400' :
                  form.passwordConfirm && form.password === form.passwordConfirm ? 'border-green-400 bg-green-50' :
                  'border-gray-200'}`}
              />
            </div>
            {errors.passwordConfirm && <p className="text-red-500 text-xs mt-1">{errors.passwordConfirm}</p>}
            {form.passwordConfirm && form.password === form.passwordConfirm && (
              <p className="text-green-600 text-xs mt-1 flex items-center gap-1"><CheckCircle2 className="w-3 h-3" />비밀번호가 일치합니다.</p>
            )}
          </div>

          {/* 회사명 */}
          <div>
            <label className={labelClass}>회사명 <span className="text-red-500">*</span></label>
            <div className="relative">
              <Building2 className="absolute left-3 top-1/2 -translate-y-1/2 w-[13px] h-[13px] text-gray-400" />
              <input type="text" value={form.company} onChange={e => handleChange('company', e.target.value)}
                placeholder="소속 회사명"
                className={`${inputClass} ${errors.company ? 'border-red-400' : 'border-gray-200'}`}
              />
            </div>
            {errors.company && <p className="text-red-500 text-xs mt-1">{errors.company}</p>}
          </div>

          <button type="submit"
            className="w-full py-2.5 text-white rounded font-semibold text-[13px] transition-colors mt-1"
            style={{ background: '#1A2E44' }}
          >
            {roleLabel} 계정 회원가입
          </button>

          <p className="text-center text-xs text-gray-400">
            이미 계정이 있으신가요?{' '}
            <button type="button" onClick={() => onNavigate('login')} className="font-semibold text-[#1A2E44] hover:underline">
              로그인하기
            </button>
          </p>
        </form>
      </div>
    </div>
  );
}
