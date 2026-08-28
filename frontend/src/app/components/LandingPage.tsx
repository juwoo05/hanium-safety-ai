import { Shield, BarChart3, Camera, FileCheck, AlertTriangle, Users } from 'lucide-react';


interface LandingPageProps {
  onNavigate: (page: string) => void;
}

export default function LandingPage({ onNavigate }: LandingPageProps) {

  const features = [
    { icon: Camera, title: 'AI 위험 분석', description: '사진을 업로드하면 AI가 자동으로 위험 요소를 분석합니다' },
    { icon: AlertTriangle, title: '실시간 모니터링', description: '현장의 안전 상황을 실시간으로 모니터링하고 대응합니다' },
    { icon: FileCheck, title: '스마트 리포팅', description: '조치 현황을 한눈에 파악하고 리포트를 자동 생성합니다' },
    { icon: BarChart3, title: '데이터 분석', description: '현장별, 기간별 안전 통계를 분석하여 인사이트를 제공합니다' },
    { icon: Users, title: '협업 관리', description: '담당자 지정, 알림, 댓글로 팀 협업을 강화합니다' },
    { icon: Shield, title: '규정 준수', description: '안전 규정 체크리스트와 감사 자료를 자동으로 관리합니다' },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#F5F7FA] to-white">
      {/* Header */}
      <header className="container mx-auto px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="w-10 h-10 bg-[#1A2E44] rounded-lg flex items-center justify-center">
            <Shield className="w-6 h-6 text-white" />
          </div>
          <span className="font-bold text-xl text-[#1A2E44]">SafeMate</span>
        </div>
        <div className="flex items-center gap-4">
          <button className="px-4 py-2 text-[#1A2E44] hover:text-[#1A2E44] transition-colors">
            제품 소개
          </button>
          <button className="px-4 py-2 text-[#1A2E44] hover:text-[#1A2E44] transition-colors">
            가격
          </button>
          <button
            onClick={() => onNavigate('login')}
            className="px-6 py-2 bg-[#1A2E44] text-white rounded-lg hover:bg-[#0F2233] transition-colors shadow-md"
          >
            시작하기
          </button>
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-6 py-16">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <div className="inline-block px-4 py-2 bg-[#1A2E44]/10 rounded-full mb-6">
              <span className="text-[#1A2E44] font-semibold text-sm">AI 기반 현장 안전 솔루션</span>
            </div>
            <h1 className="text-5xl lg:text-6xl font-bold text-[#1A2E44] mb-6 leading-tight">
              AI가 현장 위험을<br />분석하고 안전 조치까지<br />도와드립니다
            </h1>
            <p className="text-xl text-gray-600 mb-8 leading-relaxed">
              현장 사진 업로드부터 위험 탐지, 조치 등록, 리포트 관리까지<br />
              현장 안전 업무를 한 번에 관리할 수 있는 스마트 안전 플랫폼
            </p>
            <div className="flex items-center gap-4 mb-8">
              <button
                onClick={() => onNavigate('upload')}
                className="px-8 py-4 bg-[#1A2E44] text-white text-lg font-semibold rounded-xl hover:bg-[#0F2233] transition-all shadow-lg hover:shadow-xl transform hover:-translate-y-1"
              >
                현장 사진 분석하기
              </button>
              <button
                onClick={() => onNavigate('dashboard')}
                className="px-8 py-4 border-2 border-[#1A2E44] text-[#1A2E44] text-lg font-semibold rounded-xl hover:bg-[#1A2E44] hover:text-white transition-all"
              >
                대시보드 보기
              </button>
            </div>
            <div className="flex items-center gap-8 text-sm text-gray-600">
              <div className="flex items-center gap-2">
                <div className="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center">
                  <svg className="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
                <span>무료 체험</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center">
                  <svg className="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
                <span>설치 불필요</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center">
                  <svg className="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
                <span>24시간 지원</span>
              </div>
            </div>
          </div>
          <div className="relative">
            <div style={{ background: '#F0F4F8', borderRadius: 8, padding: 32 }}>
              <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: 4, padding: 20, marginBottom: 16 }}>
                <p style={{ fontSize: 11, color: '#9CA3AF', marginBottom: 8 }}>AI 위험요소 분석 결과 — SR-2026-001</p>
                <div style={{ display: 'flex', gap: 8 }}>
                  <span style={{ fontSize: 11, fontWeight: 600, padding: '2px 8px', background: '#FEF2F2', color: '#991B1B', borderRadius: 3 }}>안전난간 미설치</span>
                  <span style={{ fontSize: 11, fontWeight: 600, padding: '2px 8px', background: '#FEF2F2', color: '#991B1B', borderRadius: 3 }}>배선 노출</span>
                  <span style={{ fontSize: 11, fontWeight: 600, padding: '2px 8px', background: '#FFFBEB', color: '#B45309', borderRadius: 3 }}>안전모 미착용</span>
                </div>
              </div>
              <div className="bg-white rounded p-6 shadow-xl" style={{ border: '1px solid #E5E7EB' }}>
                <div className="flex items-center justify-between mb-4">
                  <span className="text-sm text-gray-600">분석 진행 중...</span>
                  <span className="text-sm font-semibold text-[#1A2E44]">87%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2 mb-4">
                  <div className="bg-[#1A2E44] h-2 rounded-full" style={{ width: '87%' }}></div>
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <span className="text-gray-700">고위험 항목 3건 감지</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-yellow-500 rounded-full"></div>
                    <span className="text-gray-700">중위험 항목 5건 감지</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="bg-gradient-to-r from-[#1A2E44] to-[#243E58] py-16">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center text-white">
            <div>
              <div className="text-4xl font-bold mb-2 text-white">24,500+</div>
              <div className="text-white/80">AI 분석 완료</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2 text-white">98.7%</div>
              <div className="text-white/80">AI 분석 정확도</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2 text-white">850+</div>
              <div className="text-white/80">도입 현장</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2 text-white">62%</div>
              <div className="text-white/80">사고 감소율</div>
            </div>
          </div>
        </div>
      </section>

      {/* Benefits Section */}
      <section className="container mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-[#1A2E44] mb-4">
            SafeMate를 선택해야 하는 이유
          </h2>
          <p className="text-xl text-gray-600">
            AI 기술로 현장 안전 관리가 달라집니다
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          {[
            {
              title: '시간 절약',
              description: '수작업 점검 대비 70% 이상 시간 단축',
              metric: '70%',
              color: 'bg-blue-500'
            },
            {
              title: '비용 절감',
              description: '사고 예방으로 평균 60% 비용 감소',
              metric: '60%',
              color: 'bg-green-500'
            },
            {
              title: '정확성 향상',
              description: '숙련 전문가 수준의 높은 정확도',
              metric: '98%',
              color: 'bg-[#1A2E44]'
            }
          ].map((benefit, index) => (
            <div key={index} className="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-center">
              <div className={`w-20 h-20 ${benefit.color} rounded-2xl flex items-center justify-center mx-auto mb-6`}>
                <span className="text-3xl font-bold text-white">{benefit.metric}</span>
              </div>
              <h3 className="text-2xl font-bold text-[#1A2E44] mb-3">{benefit.title}</h3>
              <p className="text-gray-600">{benefit.description}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Process Section */}
      <section className="bg-gradient-to-b from-[#F5F7FA] to-white py-20">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-[#1A2E44] mb-4">
              간단한 3단계로 시작하세요
            </h2>
            <p className="text-xl text-gray-600">
              복잡한 설정 없이 바로 사용 가능합니다
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            {[
              {
                step: '01',
                title: '현장 사진 업로드',
                description: '스마트폰으로 찍은 현장 사진을 드래그 앤 드롭으로 간편하게 업로드하세요'
              },
              {
                step: '02',
                title: 'AI 자동 분석',
                description: 'AI가 위험 요소를 자동으로 감지하고 위험도를 평가합니다'
              },
              {
                step: '03',
                title: '조치 및 리포트',
                description: '감지된 위험에 대한 조치를 등록하고 리포트를 생성합니다'
              }
            ].map((process, index) => (
              <div key={index} className="relative">
                <div className="bg-white rounded-2xl p-8 shadow-md hover:shadow-lg transition-shadow">
                  <div className="text-6xl font-bold text-[#1A2E44]/20 mb-4">{process.step}</div>
                  <h3 className="text-xl font-bold text-[#1A2E44] mb-3">{process.title}</h3>
                  <p className="text-gray-600 leading-relaxed">{process.description}</p>
                </div>
                {index < 2 && (
                  <div className="hidden md:block absolute top-1/2 -right-4 w-8 h-0.5 bg-[#1A2E44]/30"></div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="container mx-auto px-6 py-20">
        <h2 className="text-4xl font-bold text-[#1A2E44] text-center mb-4">
          SafeMate의 핵심 기능
        </h2>
        <p className="text-xl text-gray-600 text-center mb-12">
          현장 안전 관리에 필요한 모든 기능을 제공합니다
        </p>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((feature, index) => (
            <div key={index} className="bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-shadow">
              <div className="w-12 h-12 bg-[#1A2E44]/10 rounded-xl flex items-center justify-center mb-4">
                <feature.icon className="w-6 h-6 text-[#1A2E44]" />
              </div>
              <h3 className="text-lg font-semibold text-[#1A2E44] mb-2">{feature.title}</h3>
              <p className="text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Pricing */}
      <section className="container mx-auto px-6 py-20">
        <h2 className="text-3xl font-bold text-[#1A2E44] text-center mb-12">
          간편한 요금제
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
          {[
            { name: 'Basic', price: '₩99,000', features: ['현장 5개', '월 100건 조치', '기본 리포트', '이메일 지원'] },
            { name: 'Pro', price: '₩249,000', features: ['현장 20개', '월 500건 조치', '고급 분석', 'AI 위험 분석', '우선 지원'], popular: true },
            { name: 'Enterprise', price: '문의', features: ['무제한 현장', '무제한 조치', '맞춤형 리포트', 'API 연동', '전담 매니저'] },
          ].map((plan, index) => (
            <div
              key={index}
              className={`bg-white rounded-2xl p-8 shadow-md ${plan.popular ? 'ring-2 ring-[#1A2E44] relative' : ''}`}
            >
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-[#1A2E44] text-white px-4 py-1 rounded-full text-sm font-semibold">
                  인기
                </div>
              )}
              <h3 className="text-2xl font-bold text-[#1A2E44] mb-4">{plan.name}</h3>
              <div className="mb-6">
                <span className="text-3xl font-bold text-[#1A2E44]">{plan.price}</span>
                {plan.price !== '문의' && <span className="text-gray-600">/월</span>}
              </div>
              <ul className="space-y-3 mb-8">
                {plan.features.map((feature, i) => (
                  <li key={i} className="flex items-center gap-2 text-gray-600">
                    <div className="w-5 h-5 rounded-full bg-[#1A2E44]/10 flex items-center justify-center flex-shrink-0">
                      <div className="w-2 h-2 rounded-full bg-[#1A2E44]"></div>
                    </div>
                    {feature}
                  </li>
                ))}
              </ul>
              <button className={`w-full py-3 rounded-lg font-semibold transition-colors ${
                plan.popular
                  ? 'bg-[#1A2E44] text-white hover:bg-[#0F2233]'
                  : 'border-2 border-[#1A2E44] text-[#1A2E44] hover:bg-[#1A2E44] hover:text-white'
              }`}>
                {plan.price === '문의' ? '문의하기' : '시작하기'}
              </button>
            </div>
          ))}
        </div>
      </section>

      {/* Final CTA Section */}
      <section className="bg-gradient-to-r from-[#1A2E44] to-[#243E58] py-20">
        <div className="container mx-auto px-6 text-center">
          <h2 className="text-4xl font-bold text-white mb-6">
            지금 바로 SafeMate를 시작하세요
          </h2>
          <p className="text-xl text-white/90 mb-10 max-w-2xl mx-auto">
            14일 무료 체험으로 현장 안전 관리의 새로운 경험을 시작하세요.<br />
            신용카드 등록 없이 즉시 사용 가능합니다.
          </p>
          <div className="flex items-center justify-center gap-4">
            <button
              onClick={() => onNavigate('signup')}
              className="px-10 py-5 bg-[#1A2E44] text-white text-lg font-semibold rounded-xl hover:bg-[#0F2233] transition-all shadow-2xl hover:shadow-3xl transform hover:-translate-y-1"
            >
              무료로 시작하기
            </button>
            <button
              onClick={() => onNavigate('login')}
              className="px-10 py-5 bg-white text-[#1A2E44] text-lg font-semibold rounded-xl hover:bg-gray-100 transition-all shadow-xl"
            >
              영업팀 문의하기
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-[#1A2E44] text-white py-16 border-t border-white/10">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
            <div className="md:col-span-1">
              <div className="flex items-center gap-2 mb-4">
                <div className="w-10 h-10 bg-[#1A2E44] rounded-lg flex items-center justify-center">
                  <Shield className="w-6 h-6" />
                </div>
                <span className="font-bold text-xl">SafeMate</span>
              </div>
              <p className="text-gray-300 mb-4">
                AI가 지켜주는<br />현장 안전 관리 시스템
              </p>
              <p className="text-gray-400 text-sm">
                © 2026 SafeMate.<br />All rights reserved.
              </p>
            </div>

            <div>
              <h4 className="font-semibold mb-4">제품</h4>
              <ul className="space-y-2 text-gray-300">
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">기능 소개</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">가격 안내</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">고객 사례</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">업데이트</a></li>
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-4">지원</h4>
              <ul className="space-y-2 text-gray-300">
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">도움말 센터</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">사용 가이드</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">API 문서</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">문의하기</a></li>
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-4">회사</h4>
              <ul className="space-y-2 text-gray-300">
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">회사 소개</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">블로그</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">채용</a></li>
                <li><a href="#" className="hover:text-[#1A2E44] transition-colors">파트너십</a></li>
              </ul>
            </div>
          </div>

          <div className="border-t border-white/10 pt-8">
            <div className="flex flex-col md:flex-row justify-between items-center gap-4">
              <div className="flex items-center gap-6 text-sm text-gray-400">
                <a href="#" className="hover:text-white transition-colors">이용약관</a>
                <a href="#" className="hover:text-white transition-colors">개인정보처리방침</a>
                <a href="#" className="hover:text-white transition-colors">쿠키 정책</a>
              </div>
              <div className="flex items-center gap-4">
                <span className="text-gray-400 text-sm">고객센터: 1588-1234</span>
                <span className="text-gray-400 text-sm">|</span>
                <span className="text-gray-400 text-sm">support@safemate.com</span>
              </div>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
