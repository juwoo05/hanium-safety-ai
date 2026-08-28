import { useState } from 'react';
import Layout from './Layout';
import Mascot from './Mascot';
import { Plus, FileText, Download, MessageSquare, Paperclip, Search, Filter, MoreVertical, Calendar, User, AlertTriangle, Clock, CheckCircle2, LayoutGrid, List, GanttChart } from 'lucide-react';
const actionImages: Record<number, string> = {
  1: 'https://images.unsplash.com/photo-1626885930974-4b69aa21bbf9?w=400&h=240&fit=crop&auto=format',
  2: 'https://images.unsplash.com/photo-1777262095520-9805f225fb63?w=400&h=240&fit=crop&auto=format',
  3: 'https://images.unsplash.com/photo-1621294465978-6b4198a5f2f7?w=400&h=240&fit=crop&auto=format',
  4: 'https://images.unsplash.com/photo-1625958936686-a9343dc35b5b?w=400&h=240&fit=crop&auto=format',
  5: 'https://images.unsplash.com/photo-1561715608-5659baeccfb4?w=400&h=240&fit=crop&auto=format',
  6: 'https://images.unsplash.com/photo-1567954970774-58d6aa6c50dc?w=400&h=240&fit=crop&auto=format',
};

interface ActionManagementProps {
  onNavigate: (page: string) => void;
}

export default function ActionManagement({ onNavigate }: ActionManagementProps) {
  const [activeTab, setActiveTab] = useState('전체');
  const [viewMode, setViewMode] = useState<'kanban' | 'list' | 'gantt'>('kanban');

  const tabs = ['전체', '사진', '도면', '기타'];

  const columns = [
    { id: 'pending', title: '조치 대기', badge: 'red', count: 8 },
    { id: 'inProgress', title: '조치 중', badge: 'orange', count: 12 },
    { id: 'verification', title: '검증 대기', badge: 'yellow', count: 5 },
    { id: 'completed', title: '완료', badge: 'green', count: 24 },
  ];

  const actions = {
    pending: [
      {
        id: 1,
        image: actionImages[1],
        title: '화재안전 미조치',
        reportId: 'SR-2026-001',
        site: '3동 지하 1층',
        manager: '김현장',
        deadline: '2026-06-03',
        risk: 'high',
        comments: 3,
        files: 2,
      },
      {
        id: 2,
        image: actionImages[2],
        title: '안전 난간 파손',
        reportId: 'SR-2026-002',
        site: '5동 옥상',
        manager: '박안전',
        deadline: '2026-06-05',
        risk: 'medium',
        comments: 1,
        files: 1,
      },
    ],
    inProgress: [
      {
        id: 3,
        image: actionImages[3],
        title: '전선 노출',
        reportId: 'SR-2026-003',
        site: '2동 전기실',
        manager: '김현장',
        deadline: '2026-06-04',
        risk: 'high',
        comments: 5,
        files: 3,
      },
      {
        id: 4,
        image: actionImages[4],
        title: '소화기 미배치',
        reportId: 'SR-2026-004',
        site: '4동 1층',
        manager: '이관리',
        deadline: '2026-06-06',
        risk: 'low',
        comments: 2,
        files: 1,
      },
    ],
    verification: [
      {
        id: 5,
        image: actionImages[5],
        title: '비상구 표시 미비',
        reportId: 'SR-2026-005',
        site: '1동 출입구',
        manager: '박안전',
        deadline: '2026-06-07',
        risk: 'medium',
        comments: 4,
        files: 2,
      },
    ],
    completed: [
      {
        id: 6,
        image: actionImages[6],
        title: '안전모 착용 불량',
        reportId: 'SR-2026-006',
        site: '현장 전체',
        manager: '김현장',
        deadline: '2026-05-27',
        risk: 'low',
        comments: 8,
        files: 5,
      },
    ],
  };

  const urgentItems = [
    { title: '화재안전 미조치', site: '3동 지하 1층', deadline: '오늘', risk: 'high' },
    { title: '전선 노출', site: '2동 전기실', deadline: '내일', risk: 'high' },
  ];

  const upcomingDeadlines = [
    { title: '안전 난간 파손', deadline: '2026-06-05', manager: '박안전' },
    { title: '소화기 미배치', deadline: '2026-06-06', manager: '이관리' },
    { title: '비상구 표시 미비', deadline: '2026-06-07', manager: '박안전' },
  ];

  const managerSummary = [
    { name: '김현장', total: 15, completed: 12, pending: 3 },
    { name: '박안전', total: 18, completed: 15, pending: 3 },
    { name: '이관리', total: 10, completed: 8, pending: 2 },
  ];

  const delayedItems = [
    { title: '임시 가설물 점검', days: 3 },
    { title: '안전표지판 설치', days: 1 },
  ];

  const badgeColors: Record<string, string> = {
    red: 'bg-red-500',
    orange: 'bg-orange-500',
    yellow: 'bg-yellow-500',
    green: 'bg-green-500',
  };

  const riskColors: Record<string, string> = {
    high: 'bg-red-500',
    medium: 'bg-orange-500',
    low: 'bg-yellow-500',
  };

  const riskLabels: Record<string, string> = {
    high: '고위험',
    medium: '중위험',
    low: '저위험',
  };

  return (
    <Layout currentPath="actions" onNavigate={onNavigate}>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 mb-1">조치 관리 대시보드</h1>
            <p className="text-gray-600">현장 안전 조치 사항을 관리하고 추적합니다</p>
          </div>
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 px-4 py-2 border-2 border-gray-300 rounded hover:bg-gray-50 transition-colors">
              <FileText className="w-4 h-4" />
              <span className="font-medium">Excel</span>
            </button>
            <button className="flex items-center gap-2 px-4 py-2 border-2 border-gray-300 rounded hover:bg-gray-50 transition-colors">
              <Download className="w-4 h-4" />
              <span className="font-medium">PDF</span>
            </button>
            <button
              onClick={() => onNavigate('actions-new')}
              className="flex items-center gap-2 px-6 py-2 bg-[#1A2E44] text-white rounded hover:bg-[#0F2233] transition-colors shadow-md font-semibold"
            >
              <Plus className="w-5 h-5" />
              <span>새 조치 등록</span>
            </button>
          </div>
        </div>

        {/* Toolbar */}
        <div className="bg-white rounded p-4 shadow-md">
          <div className="flex flex-col lg:flex-row gap-4">
            {/* Search */}
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  placeholder="제목, 담당자, 현장명으로 검색..."
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none"
                />
              </div>
            </div>

            {/* Filters */}
            <div className="flex flex-wrap items-center gap-3">
              <select className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                <option>전체 기간</option>
                <option>오늘</option>
                <option>이번 주</option>
                <option>이번 달</option>
              </select>
              <select className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                <option>전체 현장</option>
                <option>1동</option>
                <option>2동</option>
                <option>3동</option>
              </select>
              <select className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                <option>전체 담당자</option>
                <option>김현장</option>
                <option>박안전</option>
                <option>이관리</option>
              </select>
              <select className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1A2E44] focus:border-transparent outline-none">
                <option>전체 위험도</option>
                <option>고위험</option>
                <option>중위험</option>
                <option>저위험</option>
              </select>
              <button className="p-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                <Filter className="w-5 h-5 text-gray-600" />
              </button>
            </div>

            {/* View Toggle */}
            <div className="flex items-center gap-1 bg-gray-100 rounded-lg p-1">
              <button
                onClick={() => setViewMode('kanban')}
                className={`p-2 rounded-lg transition-colors ${
                  viewMode === 'kanban' ? 'bg-white shadow-sm' : 'hover:bg-gray-200'
                }`}
              >
                <LayoutGrid className="w-5 h-5" />
              </button>
              <button
                onClick={() => setViewMode('list')}
                className={`p-2 rounded-lg transition-colors ${
                  viewMode === 'list' ? 'bg-white shadow-sm' : 'hover:bg-gray-200'
                }`}
              >
                <List className="w-5 h-5" />
              </button>
              <button
                onClick={() => setViewMode('gantt')}
                className={`p-2 rounded-lg transition-colors ${
                  viewMode === 'gantt' ? 'bg-white shadow-sm' : 'hover:bg-gray-200'
                }`}
              >
                <GanttChart className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex items-center gap-2 border-b-2 border-gray-200 overflow-x-auto">
          {tabs.map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-6 py-3 font-semibold transition-colors relative whitespace-nowrap ${
                activeTab === tab
                  ? 'text-[#1A2E44]'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              {tab}
              {activeTab === tab && (
                <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-[#1A2E44]"></div>
              )}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Kanban Board - 3 columns */}
          <div className="lg:col-span-3">
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
              {columns.map((column) => (
                <div key={column.id} className="bg-gray-50 rounded p-4 min-h-[600px]">
                  <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center gap-2">
                      <div className={`w-3 h-3 rounded-full ${badgeColors[column.badge]}`}></div>
                      <h3 className="font-semibold text-gray-900">{column.title}</h3>
                    </div>
                    <span className="px-2 py-1 bg-white rounded-full text-sm font-medium text-gray-700 shadow-sm">
                      {column.count}
                    </span>
                  </div>

                  <div className="space-y-3">
                    {actions[column.id as keyof typeof actions].map((action) => (
                      <div
                        key={action.id}
                        onClick={() => onNavigate('actions-detail')}
                        className="bg-white rounded p-4 shadow-sm hover:shadow-md transition-all cursor-pointer border-2 border-transparent hover:border-[#1A2E44]"
                      >
                        {/* Image */}
                        <div className="aspect-video bg-gray-200 rounded-lg mb-3 overflow-hidden">
                          <img
                            src={action.image}
                            alt={action.title}
                            className="w-full h-full object-cover"
                          />
                        </div>

                        {/* Risk Badge */}
                        <div className="flex items-center gap-2 mb-2">
                          <span className={`px-2 py-1 ${riskColors[action.risk]} text-white text-xs font-semibold rounded`}>
                            {riskLabels[action.risk]}
                          </span>
                          <span className="text-xs text-gray-500">{action.reportId}</span>
                        </div>

                        {/* Title */}
                        <h4 className="font-bold text-gray-900 mb-2 line-clamp-2">{action.title}</h4>

                        {/* Site */}
                        <p className="text-sm text-gray-600 mb-3">{action.site}</p>

                        {/* Manager */}
                        <div className="flex items-center gap-2 mb-3 text-sm text-gray-600">
                          <User className="w-4 h-4" />
                          <span>{action.manager}</span>
                        </div>

                        {/* Deadline */}
                        <div className="flex items-center gap-2 mb-4 text-sm">
                          <Calendar className="w-4 h-4 text-gray-400" />
                          <span className={`${
                            new Date(action.deadline) <= new Date() ? 'text-red-600 font-semibold' : 'text-gray-600'
                          }`}>
                            {action.deadline}
                          </span>
                        </div>

                        {/* Bottom Actions */}
                        <div className="flex items-center justify-between pt-3 border-t border-gray-100">
                          <div className="flex items-center gap-3 text-gray-500">
                            <div className="flex items-center gap-1">
                              <MessageSquare className="w-4 h-4" />
                              <span className="text-xs">{action.comments}</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <Paperclip className="w-4 h-4" />
                              <span className="text-xs">{action.files}</span>
                            </div>
                          </div>
                          <button className="p-1 hover:bg-gray-100 rounded transition-colors">
                            <MoreVertical className="w-4 h-4 text-gray-400" />
                          </button>
                        </div>

                        {/* Action Button */}
                        <button className="w-full mt-3 px-4 py-2 bg-[#1A2E44] text-white text-sm font-semibold rounded-lg hover:bg-[#0F2233] transition-colors">
                          조치하기
                        </button>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right Panel - 1 column */}
          <div className="space-y-6">
            {/* Mascot Guidance */}
            <div className="bg-gradient-to-br from-[#1A2E44]/10 to-[#1A2E44]/5 rounded p-6 border-2 border-[#1A2E44]/20">
              <Mascot
                size="sm"
                message="지연된 항목부터 우선 처리해보세요 ⚡"
                className="mb-4"
              />
            </div>

            {/* Urgent Actions */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-red-500" />
                긴급 조치 필요
              </h3>
              <div className="space-y-3">
                {urgentItems.map((item, index) => (
                  <div
                    key={index}
                    className="p-4 bg-red-50 rounded border border-red-100 hover:border-red-200 transition-colors cursor-pointer"
                    onClick={() => onNavigate('actions-detail')}
                  >
                    <div className="flex items-start gap-2 mb-2">
                      <div className={`w-2 h-2 rounded-full ${riskColors[item.risk]} mt-1.5`}></div>
                      <p className="text-sm font-semibold text-gray-900 flex-1">{item.title}</p>
                    </div>
                    <p className="text-xs text-gray-600 mb-2">{item.site}</p>
                    <span className="text-xs text-red-600 font-medium">마감: {item.deadline}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Upcoming Deadlines */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Clock className="w-5 h-5 text-orange-500" />
                다가오는 마감 일정
              </h3>
              <div className="space-y-3">
                {upcomingDeadlines.map((item, index) => (
                  <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <div className="flex-1">
                      <p className="text-sm font-medium text-gray-900 mb-1">{item.title}</p>
                      <p className="text-xs text-gray-500">{item.manager}</p>
                    </div>
                    <span className="text-xs text-gray-600">{item.deadline}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Manager Summary */}
            <div className="bg-white rounded p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">담당자별 작업 요약</h3>
              <div className="space-y-3">
                {managerSummary.map((manager, index) => (
                  <div key={index} className="p-3 bg-gray-50 rounded-lg">
                    <div className="flex items-center justify-between mb-2">
                      <span className="font-medium text-gray-900">{manager.name}</span>
                      <span className="text-sm text-gray-600">{manager.completed}/{manager.total}</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div
                        className="bg-[#1A2E44] h-2 rounded-full"
                        style={{ width: `${(manager.completed / manager.total) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Delayed Items */}
            <div className="bg-yellow-50 rounded p-6 border-2 border-yellow-200">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">지연 항목</h3>
              <div className="space-y-2">
                {delayedItems.map((item, index) => (
                  <div key={index} className="flex items-center justify-between p-3 bg-white rounded-lg">
                    <p className="text-sm font-medium text-gray-900">{item.title}</p>
                    <span className="text-xs text-red-600 font-semibold">{item.days}일 지연</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
