import { useState } from 'react';
import { Mail, Lock } from 'lucide-react';

interface LoginPageProps {
  onLogin: (role: 'contractor' | 'subcontractor') => void;
  onNavigate: (page: string) => void;
}

export default function LoginPage({ onLogin, onNavigate }: LoginPageProps) {
  const [email, setEmail] = useState('demo@safemate.com');
  const [password, setPassword] = useState('demo1234');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const role = email === 'sub@safemate.com' ? 'subcontractor' : 'contractor';
    onLogin(role);
  };

  const inputStyle = {
    width: '100%', padding: '9px 12px 9px 36px', fontSize: 13,
    border: '1px solid #E5E7EB', borderRadius: 4, outline: 'none',
    background: 'white', color: '#0F172A', boxSizing: 'border-box' as const,
    fontFamily: "'Noto Sans KR', sans-serif",
  };

  return (
    <div style={{ minHeight: '100vh', background: '#F7F8FA', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24, fontFamily: "'Noto Sans KR', sans-serif" }}>
      <div style={{ width: '100%', maxWidth: 400 }}>
        {/* Logo */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 32, justifyContent: 'center' }}>
          <div style={{ width: 28, height: 28, background: '#F8FAFC', borderRadius: 4, display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' }}>
            <img src="/app/images/yeongyeol-gori-logo.png" alt="연결고리 로고" style={{ width: 26, height: 26, objectFit: 'contain' }} />
          </div>
          <span style={{ fontSize: 18, fontWeight: 700, color: '#0F172A', letterSpacing: '0' }}>연결고리</span>
        </div>

        {/* Card */}
        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 6, padding: '32px 36px' }}>
          <h2 style={{ fontSize: 18, fontWeight: 600, color: '#0F172A', marginBottom: 6, textAlign: 'center' }}>로그인</h2>
          <p style={{ fontSize: 12, color: '#9CA3AF', textAlign: 'center', marginBottom: 24 }}>건설현장 안전관리 플랫폼</p>

          {/* Demo accounts */}
          <div style={{ background: '#F9FAFB', border: '1px solid #E5E7EB', borderRadius: 4, padding: '12px 14px', marginBottom: 20 }}>
            <p style={{ fontSize: 11, color: '#6B7280', fontWeight: 500, marginBottom: 8 }}>테스트 계정</p>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
              <button type="button"
                onClick={() => { setEmail('demo@safemate.com'); setPassword('demo1234'); }}
                style={{
                  padding: '7px 12px', fontSize: 12, fontWeight: 500,
                  background: '#1A2E44', color: 'white', border: 'none',
                  borderRadius: 4, cursor: 'pointer',
                }}>
                원청 계정
              </button>
              <button type="button"
                onClick={() => { setEmail('sub@safemate.com'); setPassword('demo1234'); }}
                style={{
                  padding: '7px 12px', fontSize: 12, fontWeight: 500,
                  background: '#065F46', color: 'white', border: 'none',
                  borderRadius: 4, cursor: 'pointer',
                }}>
                하청 계정
              </button>
            </div>
          </div>

          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            <div>
              <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>이메일</label>
              <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                <Mail size={13} color="#9CA3AF" style={{ position: 'absolute', left: 12 }} />
                <input type="email" value={email} onChange={e => setEmail(e.target.value)}
                  placeholder="your@email.com" style={inputStyle} required />
              </div>
            </div>

            <div>
              <label style={{ fontSize: 12, color: '#374151', fontWeight: 500, display: 'block', marginBottom: 5 }}>비밀번호</label>
              <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                <Lock size={13} color="#9CA3AF" style={{ position: 'absolute', left: 12 }} />
                <input type="password" value={password} onChange={e => setPassword(e.target.value)}
                  placeholder="••••••••" style={inputStyle} required />
              </div>
            </div>

            <div className="flex items-center justify-between" style={{ fontSize: 12 }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer', color: '#6B7280' }}>
                <input type="checkbox" style={{ width: 14, height: 14 }} />
                로그인 유지
              </label>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <button type="button" onClick={() => onNavigate('find-id')} style={{ fontSize: 12, color: '#9CA3AF', background: 'none', border: 'none', cursor: 'pointer' }}>
                  아이디 찾기
                </button>
                <span style={{ color: '#E5E7EB' }}>|</span>
                <button type="button" onClick={() => onNavigate('find-password')} style={{ fontSize: 12, color: '#1A2E44', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 500 }}>
                  비밀번호 찾기
                </button>
              </div>
            </div>

            <button type="submit"
              style={{
                width: '100%', padding: '10px 0', fontSize: 13, fontWeight: 600,
                background: '#1A2E44', color: 'white', border: 'none',
                borderRadius: 4, cursor: 'pointer', marginTop: 4,
              }}>
              로그인
            </button>
          </form>

          <p style={{ textAlign: 'center', fontSize: 12, color: '#9CA3AF', marginTop: 20 }}>
            계정이 없으신가요?{' '}
            <button onClick={() => onNavigate('signup')} style={{ fontSize: 12, color: '#1A2E44', fontWeight: 600, background: 'none', border: 'none', cursor: 'pointer' }}>
              회원가입
            </button>
          </p>
        </div>

        <p style={{ textAlign: 'center', fontSize: 11, color: '#9CA3AF', marginTop: 20 }}>
          건설현장 안전관리 AI 플랫폼 · 연결고리
        </p>
      </div>
    </div>
  );
}
