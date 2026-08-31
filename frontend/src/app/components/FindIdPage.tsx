import { useState } from 'react';
import { User, Building2, ArrowLeft, CheckCircle2 } from 'lucide-react';
import { toast } from 'sonner';

interface FindIdPageProps {
  onNavigate: (page: string) => void;
}

export default function FindIdPage({ onNavigate }: FindIdPageProps) {
  const [name, setName] = useState('');
  const [company, setCompany] = useState('');
  const [result, setResult] = useState<string | null>(null);

  const handleFind = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim() || !company.trim()) {
      toast.error('이름과 회사명을 모두 입력해주세요.');
      return;
    }
    // Simulate finding ID
    setTimeout(() => {
      setResult('demo@safemate.com');
      toast.success('아이디를 찾았습니다!');
    }, 600);
  };

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

        <div className="flex items-center gap-2 mb-8">
          <div className="w-12 h-12 bg-[#1A2E44] rounded flex items-center justify-center">
            <img src="/app/images/yeongyeol-gori-logo.png" alt="연결고리 로고" className="w-11 h-11 object-contain" />
          </div>
          <div>
            <span className="font-bold text-2xl text-[#1A2E44]">아이디 찾기</span>
            <p className="text-xs text-gray-500">연결고리 계정 아이디를 찾아드립니다</p>
          </div>
        </div>

        {!result ? (
          <form onSubmit={handleFind} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">이름</label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  value={name}
                  onChange={e => setName(e.target.value)}
                  placeholder="가입 시 등록한 이름"
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">회사명</label>
              <div className="relative">
                <Building2 className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  value={company}
                  onChange={e => setCompany(e.target.value)}
                  placeholder="가입 시 등록한 회사명"
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none transition-all"
                />
              </div>
            </div>

            <button
              type="submit"
              className="w-full bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#2C5282] transition-colors shadow-lg"
            >
              아이디 찾기
            </button>
          </form>
        ) : (
          <div className="space-y-6">
            <div className="bg-green-50 border-2 border-green-200 rounded p-6 text-center">
              <CheckCircle2 className="w-12 h-12 text-green-500 mx-auto mb-3" />
              <p className="text-sm text-gray-600 mb-2">가입하신 아이디(이메일)는</p>
              <p className="text-xl font-bold text-[#1A2E44]">{result}</p>
              <p className="text-sm text-gray-500 mt-2">입니다.</p>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => onNavigate('login')}
                className="flex-1 bg-[#1A2E44] text-white py-3 rounded font-semibold hover:bg-[#0F2233] transition-colors"
              >
                로그인하기
              </button>
              <button
                onClick={() => onNavigate('find-password')}
                className="flex-1 border-2 border-[#1A2E44] text-[#1A2E44] py-3 rounded font-semibold hover:bg-[#1A2E44]/5 transition-colors"
              >
                비밀번호 찾기
              </button>
            </div>
          </div>
        )}

        <div className="mt-6 pt-6 border-t border-gray-100 flex justify-center gap-6 text-sm">
          <button
            onClick={() => onNavigate('find-password')}
            className="text-gray-500 hover:text-[#1A2E44] transition-colors"
          >
            비밀번호 찾기
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
