import { useState } from 'react';
import { Mail, Lock, ArrowLeft, CheckCircle2 } from 'lucide-react';
import { toast } from 'sonner';

interface FindPasswordPageProps {
  onNavigate: (page: string) => void;
}

type Step = 'email' | 'verify' | 'reset' | 'done';

export default function FindPasswordPage({ onNavigate }: FindPasswordPageProps) {
  const [step, setStep] = useState<Step>('email');
  const [email, setEmail] = useState('');
  const [code, setCode] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const handleSendCode = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !email.includes('@')) {
      toast.error('올바른 이메일을 입력해주세요.');
      return;
    }
    toast.success(`${email}로 인증 코드를 발송했습니다.`);
    setStep('verify');
  };

  const handleVerifyCode = (e: React.FormEvent) => {
    e.preventDefault();
    if (code === '123456' || code.length === 6) {
      toast.success('인증이 완료되었습니다.');
      setStep('reset');
    } else {
      toast.error('인증 코드가 올바르지 않습니다. (테스트: 123456)');
    }
  };

  const handleResetPassword = (e: React.FormEvent) => {
    e.preventDefault();
    if (newPassword.length < 6) {
      toast.error('비밀번호는 6자 이상이어야 합니다.');
      return;
    }
    if (newPassword !== confirmPassword) {
      toast.error('비밀번호가 일치하지 않습니다.');
      return;
    }
    toast.success('비밀번호가 성공적으로 변경되었습니다!');
    setStep('done');
  };

  const steps: Step[] = ['email', 'verify', 'reset', 'done'];
  const stepLabels = ['이메일 입력', '코드 인증', '비밀번호 재설정', '완료'];

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1A2E44] to-[#2C5282] flex items-center justify-center px-6">
      <div className="bg-white rounded shadow-2xl p-10 w-full max-w-md">
        <button
          onClick={() => onNavigate('login')}
          className="flex items-center gap-2 text-gray-500 hover:text-gray-700 transition-colors mb-6 text-sm"
        >
          <ArrowLeft className="w-4 h-4" />
          로그인으로 돌아가기
        </button>

        <div className="flex items-center gap-2 mb-6">
          <div className="w-12 h-12 bg-[#1A2E44] rounded flex items-center justify-center">
            <img src="/app/images/yeongyeol-gori-logo.png" alt="연결고리 로고" className="w-11 h-11 object-contain" />
          </div>
          <div>
            <span className="font-bold text-2xl text-[#1A2E44]">비밀번호 찾기</span>
            <p className="text-xs text-gray-500">이메일로 인증 후 재설정합니다</p>
          </div>
        </div>

        {/* Step indicator */}
        <div className="flex items-center justify-between mb-8">
          {steps.map((s, i) => (
            <div key={s} className="flex items-center flex-1">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold flex-shrink-0 transition-all ${
                steps.indexOf(step) > i
                  ? 'bg-green-500 text-white'
                  : steps.indexOf(step) === i
                  ? 'bg-[#1A2E44] text-white'
                  : 'bg-gray-100 text-gray-400'
              }`}>
                {steps.indexOf(step) > i ? <CheckCircle2 className="w-4 h-4" /> : i + 1}
              </div>
              {i < steps.length - 1 && (
                <div className={`flex-1 h-0.5 mx-1 transition-all ${
                  steps.indexOf(step) > i ? 'bg-green-500' : 'bg-gray-200'
                }`} />
              )}
            </div>
          ))}
        </div>
        <p className="text-center text-sm text-gray-500 -mt-4 mb-6">{stepLabels[steps.indexOf(step)]}</p>

        {/* Step: Email */}
        {step === 'email' && (
          <form onSubmit={handleSendCode} className="space-y-5">
            <p className="text-sm text-gray-600 bg-blue-50 rounded p-4 border border-blue-100">
              가입 시 등록한 이메일 주소를 입력하시면 인증 코드를 발송해드립니다.
            </p>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">이메일</label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="email"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  placeholder="가입 시 등록한 이메일"
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all"
                />
              </div>
            </div>
            <button
              type="submit"
              className="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors shadow-lg"
            >
              인증 코드 발송
            </button>
          </form>
        )}

        {/* Step: Verify */}
        {step === 'verify' && (
          <form onSubmit={handleVerifyCode} className="space-y-5">
            <p className="text-sm text-gray-600 bg-blue-50 rounded p-4 border border-blue-100">
              <strong>{email}</strong>로 발송된 6자리 인증 코드를 입력해주세요.<br />
              <span className="text-xs text-gray-500">(테스트용 코드: 123456)</span>
            </p>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">인증 코드</label>
              <input
                type="text"
                value={code}
                onChange={e => setCode(e.target.value)}
                placeholder="6자리 인증 코드"
                maxLength={6}
                className="w-full px-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all text-center text-2xl tracking-widest font-mono"
              />
            </div>
            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => setStep('email')}
                className="flex-1 border-2 border-gray-300 text-gray-700 py-3 rounded font-semibold hover:bg-gray-50 transition-colors"
              >
                이메일 재입력
              </button>
              <button
                type="submit"
                className="flex-1 bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors"
              >
                인증 확인
              </button>
            </div>
          </form>
        )}

        {/* Step: Reset */}
        {step === 'reset' && (
          <form onSubmit={handleResetPassword} className="space-y-5">
            <p className="text-sm text-gray-600 bg-green-50 rounded p-4 border border-green-100">
              새로운 비밀번호를 설정해주세요.
            </p>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">새 비밀번호</label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="password"
                  value={newPassword}
                  onChange={e => setNewPassword(e.target.value)}
                  placeholder="6자 이상"
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all"
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">새 비밀번호 확인</label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="password"
                  value={confirmPassword}
                  onChange={e => setConfirmPassword(e.target.value)}
                  placeholder="비밀번호 재입력"
                  className={`w-full pl-10 pr-4 py-3 border rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all ${
                    confirmPassword && newPassword !== confirmPassword ? 'border-red-400' : 'border-gray-300'
                  }`}
                />
              </div>
              {confirmPassword && newPassword !== confirmPassword && (
                <p className="text-red-500 text-xs mt-1">비밀번호가 일치하지 않습니다.</p>
              )}
            </div>
            <button
              type="submit"
              className="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors shadow-lg"
            >
              비밀번호 변경
            </button>
          </form>
        )}

        {/* Step: Done */}
        {step === 'done' && (
          <div className="space-y-6 text-center">
            <div className="bg-green-50 border-2 border-green-200 rounded p-8">
              <CheckCircle2 className="w-16 h-16 text-green-500 mx-auto mb-4" />
              <h3 className="text-xl font-bold text-gray-900 mb-2">비밀번호 변경 완료!</h3>
              <p className="text-sm text-gray-600">새로운 비밀번호로 로그인해주세요.</p>
            </div>
            <button
              onClick={() => onNavigate('login')}
              className="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors shadow-lg"
            >
              로그인하러 가기
            </button>
          </div>
        )}

        <div className="mt-6 pt-6 border-t border-gray-100 flex justify-center gap-6 text-sm">
          <button
            onClick={() => onNavigate('find-id')}
            className="text-gray-500 hover:text-[#1A2E44] transition-colors"
          >
            아이디 찾기
          </button>
          <span className="text-gray-300">|</span>
          <button
            onClick={() => onNavigate('signup')}
            className="text-gray-500 hover:text-[#1A2E44] transition-colors"
          >
            회원가입
          </button>
        </div>
      </div>
    </div>
  );
}
