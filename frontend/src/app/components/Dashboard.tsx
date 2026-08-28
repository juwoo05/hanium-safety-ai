import Layout from './Layout';
import { AlertTriangle, CheckCircle2, Clock, TrendingUp, Upload, FileSearch, FileText, Eye, Calendar as CalendarIcon, User as UserIcon, ArrowRight } from 'lucide-react';

interface DashboardProps {
  onNavigate: (page: string) => void;
}

export default function Dashboard({ onNavigate }: DashboardProps) {
  const kpiData = [
    { label: '전체 리포트 수', value: '247', icon: FileText, color: 'bg-blue-500', trend: '+23', period: '이번 달' },
    { label: '고위험 항목 수', value: '18', icon: AlertTriangle, color: 'bg-red-500', trend: '-5', period: '지난주 대비' },
    { label: '조치 진행 중', value: '42', icon: Clock, color: 'bg-orange-500', trend: '+8', period: '진행 중' },
    { label: '오늘 마감 일정', value: '7', icon: CalendarIcon, color: 'bg-yellow-500', trend: '긴급', period: '확인 필요' },
  ];

  const weeklyData = [
    { id: 'mon', day: '월', value: 12 },
    { id: 'tue', day: '화', value: 19 },
    { id: 'wed', day: '수', value: 15 },
    { id: 'thu', day: '목', value: 25 },
    { id: 'fri', day: '금', value: 22 },
    { id: 'sat', day: '토', value: 8 },
    { id: 'sun', day: '일', value: 5 },
  ];

  const recentReports = [
    { id: 1, site: '3동 건물 외벽', risk: 'high', issues: 5, status: '분석 완료', time: '10분 전', image: '🏗️' },
    { id: 2, site: '지하 주차장', risk: 'medium', issues: 3, status: '조치 대기', time: '1시간 전', image: '🅿️' },
    { id: 3, site: '5층 철골 작업장', risk: 'high', issues: 7, status: '긴급 조치', time: '2시간 전', image: '⚙️' },
  ];

  const urgentActions = [
    { title: '안전 난간 미설치', location: '3동 옥상', deadline: '오늘', risk: 'high' },
    { title: '임시 배선 노출', location: '지하 1층', deadline: '오늘', risk: 'high' },
    { title: '소화기 점검 필요', location: '4동 1층', deadline: '내일', risk: 'medium' },
  ];

  const recentUploads = [
    { name: '현장전경_0601.jpg', time: '15분 전', status: '분석 완료' },
    { name: '작업장_안전점검.jpg', time: '45분 전', status: '분석 중' },
    { name: '철골구조_확인.jpg', time: '1시간 전', status: '대기 중' },
  ];

  const staffProgress = [
    { name: '김현장', total: 24, completed: 18, rate: 75 },
    { name: '박안전', total: 31, completed: 28, rate: 90 },
    { name: '이관리', total: 19, completed: 15, rate: 79 },
  ];

  const riskColors: Record<string, string> = {
    high: 'bg-red-500',
    medium: 'bg-orange-500',
    low: 'bg-yellow-500',
  };

  return (
    <Layout currentPath="dashboard" onNavigate={onNavigate}>
      <div className="space-y-6">
        {/* Welcome Banner */}
        <div className="bg-gradient-to-r from-[#1A2E44] to-[#2C5282] rounded p-8 text-white">
          <div className="flex items-center justify-between">
            <div className="flex-1">
              <h1 className="text-3xl font-bold mb-2">안녕하세요, 김현장님! 👋</h1>
              <p className="text-white/80 text-lg">오늘의 현장 안전 현황을 확인하세요</p>
              <div className="flex items-center gap-6 mt-4">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-green-400 rounded-full"></div>
                  <span className="text-sm">전체 현장: 5개</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-yellow-400 rounded-full"></div>
                  <span className="text-sm">긴급 조치: 7건</span>
                </div>
              </div>
            </div>
            <div className="hidden lg:block">
            </div>
          </div>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {kpiData.map((kpi, index) => (
            <div key={index} className="bg-white rounded p-6 shadow-md hover:shadow-lg transition-all cursor-pointer border-2 border-transparent hover:border-[#1A2E44]">
              <div className="flex items-start justify-between mb-4">
                <div className={`${kpi.color} w-14 h-14 rounded flex items-center justify-center shadow-lg`}>
                  <kpi.icon className="w-7 h-7 text-white" />
                </div>
                <div className="text-right">
                  <span className="text-xs text-gray-500">{kpi.period}</span>
                  <div className="text-sm font-semibold text-green-600">{kpi.trend}</div>
                </div>
              </div>
              <p className="text-gray-600 text-sm mb-2">{kpi.label}</p>
              <p className="text-4xl font-bold text-gray-900">{kpi.value}</p>
            </div>
          ))}
        </div>

        {/* Mascot Helper Widget */}
        <div className="bg-gradient-to-r from-[#1A2E44]/10 to-[#1A2E44]/5 rounded p-6 border-2 border-[#1A2E44]/20">
          <div className="flex items-start gap-4">
            <div className="flex-shrink-0">
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-[#1A2E44] mb-2">💡 오늘의 안전 팁</h3>
              <p className="text-gray-700 mb-3">
                긴급 조치가 필요한 항목을 우선 정리해드릴게요. 고위험 항목 3건이 오늘 마감이니 먼저 확인해주세요!
              </p>
              <button
                onClick={() => onNavigate('actions')}
                className="px-4 py-2 bg-[#1A2E44] text-white rounded-lg hover:bg-[#0F2233] transition-colors text-sm font-medium"
              >
                긴급 조치 확인하기
              </button>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Main Content - 2 columns */}
          <div className="lg:col-span-2 space-y-6">
            {/* Quick Actions */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">빠른 실행</h3>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {[
                  { icon: Upload, label: '사진 업로드', color: 'bg-blue-500', page: 'upload' },
                  { icon: FileSearch, label: '위험 분석 시작', color: 'bg-[#1A2E44]', page: 'upload' },
                  { icon: FileText, label: '조치 등록', color: 'bg-green-500', page: 'actions-new' },
                  { icon: Eye, label: '리포트 보기', color: 'bg-purple-500', page: 'actions-detail' },
                ].map((action, index) => (
                  <button
                    key={index}
                    onClick={() => onNavigate(action.page)}
                    className="flex flex-col items-center gap-3 p-4 bg-gray-50 rounded hover:bg-gray-100 transition-colors group"
                  >
                    <div className={`${action.color} w-12 h-12 rounded flex items-center justify-center group-hover:scale-110 transition-transform`}>
                      <action.icon className="w-6 h-6 text-white" />
                    </div>
                    <span className="text-sm font-medium text-gray-700">{action.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Recent Reports */}
            <div className="bg-white rounded p-6 shadow-md">
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-lg font-semibold text-gray-900">최근 분석 리포트</h3>
                <button
                  onClick={() => onNavigate('actions')}
                  className="text-[#1A2E44] hover:text-[#0F2233] font-medium text-sm flex items-center gap-1"
                >
                  전체 보기 <ArrowRight className="w-4 h-4" />
                </button>
              </div>
              <div className="space-y-3">
                {recentReports.map((report) => (
                  <div
                    key={report.id}
                    className="flex items-center gap-4 p-4 border-2 border-gray-100 rounded hover:border-[#1A2E44] transition-colors cursor-pointer"
                    onClick={() => onNavigate('actions-detail')}
                  >
                    <div className="w-16 h-16 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg flex items-center justify-center text-3xl flex-shrink-0">
                      {report.image}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <div className={`w-2 h-2 rounded-full ${riskColors[report.risk]}`}></div>
                        <p className="font-semibold text-gray-900">{report.site}</p>
                      </div>
                      <p className="text-sm text-gray-600">위험 항목 {report.issues}건 감지</p>
                    </div>
                    <div className="text-right flex-shrink-0">
                      <span className="inline-block px-3 py-1 bg-blue-100 text-blue-700 text-xs font-medium rounded-full mb-1">
                        {report.status}
                      </span>
                      <p className="text-xs text-gray-500">{report.time}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Weekly Chart — custom CSS bars */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">주간 분석 현황</h3>
              <div className="flex items-end justify-between gap-2 px-2" style={{ height: '180px' }}>
                {weeklyData.map((d) => {
                  const max = Math.max(...weeklyData.map(x => x.value));
                  const pct = max > 0 ? (d.value / max) * 100 : 0;
                  return (
                    <div key={d.id} className="flex-1 flex flex-col items-center gap-1 group">
                      <span className="text-xs font-semibold text-gray-400 opacity-0 group-hover:opacity-100 transition-opacity">{d.value}</span>
                      <div className="w-full flex items-end" style={{ height: '140px' }}>
                        <div
                          className="w-full bg-[#1A2E44] rounded-t-lg hover:bg-[#0F2233] transition-colors"
                          style={{ height: `${pct}%`, minHeight: '4px' }}
                        />
                      </div>
                      <span className="text-xs text-gray-500 font-medium">{d.day}</span>
                    </div>
                  );
                })}
              </div>
              <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
                <div className="w-3 h-3 rounded-sm bg-[#1A2E44]" />
                <span className="text-xs text-gray-500">분석 건수</span>
              </div>
            </div>

            {/* Staff Progress */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">담당자별 진행 현황</h3>
              <div className="space-y-4">
                {staffProgress.map((staff, index) => (
                  <div key={index}>
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-[#1A2E44]/10 rounded-full flex items-center justify-center">
                          <UserIcon className="w-5 h-5 text-[#1A2E44]" />
                        </div>
                        <div>
                          <p className="font-semibold text-gray-900">{staff.name}</p>
                          <p className="text-xs text-gray-500">{staff.completed} / {staff.total} 완료</p>
                        </div>
                      </div>
                      <span className="text-lg font-bold text-[#1A2E44]">{staff.rate}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div
                        className="bg-[#1A2E44] h-2 rounded-full transition-all"
                        style={{ width: `${staff.rate}%` }}
                      ></div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Right Sidebar */}
          <div className="space-y-6">
            {/* Urgent Actions */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-red-500" />
                긴급 조치 필요
              </h3>
              <div className="space-y-3">
                {urgentActions.map((action, index) => (
                  <div
                    key={index}
                    className="p-4 bg-red-50 rounded border border-red-100 hover:border-red-200 transition-colors cursor-pointer"
                    onClick={() => onNavigate('actions-detail')}
                  >
                    <div className="flex items-start gap-2 mb-2">
                      <div className={`w-2 h-2 rounded-full ${riskColors[action.risk]} mt-1.5`}></div>
                      <p className="text-sm font-semibold text-gray-900 flex-1">{action.title}</p>
                    </div>
                    <p className="text-xs text-gray-600 mb-2">{action.location}</p>
                    <div className="flex items-center justify-between">
                      <span className="text-xs text-red-600 font-medium">마감: {action.deadline}</span>
                      <ArrowRight className="w-4 h-4 text-red-500" />
                    </div>
                  </div>
                ))}
              </div>
              <button
                onClick={() => onNavigate('actions')}
                className="w-full mt-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium"
              >
                전체 긴급 조치 보기
              </button>
            </div>

            {/* Recent Uploads */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">최근 업로드 현장 사진</h3>
              <div className="space-y-3">
                {recentUploads.map((upload, index) => (
                  <div key={index} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                    <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                      <FileText className="w-5 h-5 text-blue-600" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-gray-900 truncate">{upload.name}</p>
                      <p className="text-xs text-gray-500">{upload.time}</p>
                    </div>
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      upload.status === '분석 완료' ? 'bg-green-100 text-green-700' :
                      upload.status === '분석 중' ? 'bg-yellow-100 text-yellow-700' :
                      'bg-gray-100 text-gray-700'
                    }`}>
                      {upload.status}
                    </span>
                  </div>
                ))}
              </div>
            </div>

            {/* Today's Safety Alert */}
            <div className="bg-gradient-to-br from-yellow-50 to-orange-50 rounded p-6 border-2 border-yellow-200">
              <h3 className="text-lg font-semibold text-gray-900 mb-3 flex items-center gap-2">
                <CalendarIcon className="w-5 h-5 text-orange-500" />
                오늘의 안전 알림
              </h3>
              <ul className="space-y-2 text-sm text-gray-700">
                <li className="flex items-start gap-2">
                  <span className="text-orange-500 mt-0.5">•</span>
                  <span>3동 건물 외벽 작업 시 안전난간 필수 착용</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-orange-500 mt-0.5">•</span>
                  <span>지하 주차장 환기 작업 진행 중 (14:00~17:00)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-orange-500 mt-0.5">•</span>
                  <span>내일 오전 안전 교육 실시 예정</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
