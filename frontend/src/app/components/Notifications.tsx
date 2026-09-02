import { useState } from 'react';
import Layout from './Layout';
import { AlertTriangle, CheckCircle2, Info, Clock, Calendar, Bell, BellOff, ArrowRight, X } from 'lucide-react';
import { toast } from 'sonner';

interface NotificationsProps {
  onNavigate: (page: string) => void;
}

interface Notification {
  id: number;
  type: 'urgent' | 'success' | 'info' | 'warning';
  title: string;
  message: string;
  time: string;
  unread: boolean;
}

const typeStyles = {
  urgent:  { bg: 'bg-red-50',    text: 'text-red-600',    border: 'border-red-100',    dot: 'bg-red-500',    Icon: AlertTriangle },
  success: { bg: 'bg-green-50',  text: 'text-green-600',  border: 'border-green-100',  dot: 'bg-green-500',  Icon: CheckCircle2 },
  info:    { bg: 'bg-blue-50',   text: 'text-blue-600',   border: 'border-blue-100',   dot: 'bg-blue-500',   Icon: Info },
  warning: { bg: 'bg-orange-50', text: 'text-orange-600', border: 'border-orange-100', dot: 'bg-orange-500', Icon: Clock },
};

const priorityColors: Record<string, string> = { high: 'bg-red-500', medium: 'bg-orange-500', low: 'bg-yellow-400' };
const priorityLabels: Record<string, string> = { high: '고위험', medium: '중위험', low: '저위험' };

const deadlines = [
  { date: '2026-06-03 (오늘)', urgent: true, items: [
    { title: '화재안전 미조치', location: '3동 지하 1층', priority: 'high' },
    { title: '전선 노출', location: '2동 전기실', priority: 'high' },
  ]},
  { date: '2026-06-05', urgent: false, items: [
    { title: '안전 난간 파손', location: '5동 옥상', priority: 'medium' },
  ]},
  { date: '2026-06-07', urgent: false, items: [
    { title: '비상구 표시 미비', location: '1동 출입구', priority: 'low' },
    { title: '소화기 점검 필요', location: '4동 1층', priority: 'low' },
  ]},
];

const initialNotifications: Notification[] = [
  { id: 1, type: 'urgent',  title: '마감 임박 조치가 있습니다',    message: '화재안전 미조치 - 3동 지하 1층 (마감: 2026-06-03)', time: '10분 전',  unread: true },
  { id: 2, type: 'success', title: '조치가 완료되었습니다',        message: '안전모 착용 불량 조치가 완료 처리되었습니다.',        time: '1시간 전', unread: true },
  { id: 3, type: 'info',    title: '새로운 댓글이 등록되었습니다', message: '박안전님이 "전선 노출" 조치에 댓글을 남겼습니다.',    time: '2시간 전', unread: false },
  { id: 4, type: 'warning', title: '담당 조치 건이 있습니다',      message: '소화기 미배치 - 4동 1층 조치를 확인해주세요.',       time: '3시간 전', unread: false },
  { id: 5, type: 'urgent',  title: 'AI 분석 결과가 도착했습니다',  message: '지하 주차장 사진에서 3건의 위험 항목이 감지되었습니다.', time: '4시간 전', unread: false },
];

const olderNotifications: Notification[] = [
  { id: 101, type: 'success', title: '주간 안전점검이 완료되었습니다', message: '강남 복합시설 신축공사 주간 안전점검 결과가 저장되었습니다.', time: '어제', unread: false },
  { id: 102, type: 'info', title: 'TBM 일지가 등록되었습니다', message: '9월 1일 작업 전 TBM 일지가 안전서류에 등록되었습니다.', time: '어제', unread: false },
  { id: 103, type: 'warning', title: '보호구 재고 확인이 필요합니다', message: '안전대 재고가 기준 수량 이하로 내려갔습니다.', time: '2일 전', unread: false },
];

export default function Notifications({ onNavigate }: NotificationsProps) {
  const [notifications, setNotifications] = useState<Notification[]>(initialNotifications);
  const [olderLoaded, setOlderLoaded] = useState(false);
  const [settings, setSettings] = useState({
    deadline:  true,
    comment:   true,
    complete:  false,
    weekly:    true,
  });

  const unreadCount = notifications.filter(n => n.unread).length;

  const markRead = (id: number) => {
    setNotifications(prev => prev.map(n => n.id === id ? { ...n, unread: false } : n));
  };

  const markAllRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, unread: false })));
    toast.success('모든 알림을 읽음 처리했습니다');
  };

  const dismiss = (id: number) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
    toast.success('알림을 삭제했습니다');
  };

  const toggleSetting = (key: keyof typeof settings) => {
    setSettings(prev => {
      const next = { ...prev, [key]: !prev[key] };
      toast.success(`알림 설정이 변경되었습니다`);
      return next;
    });
  };

  return (
    <Layout currentPath="notifications" onNavigate={onNavigate}>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">알림</h1>
            <p className="text-sm text-gray-500 mt-0.5">
              {unreadCount > 0 ? (
                <span>읽지 않은 알림 <span className="text-[#1A2E44] font-semibold">{unreadCount}건</span></span>
              ) : '모든 알림을 읽었습니다'}
            </p>
          </div>
          {unreadCount > 0 && (
            <button onClick={markAllRead}
              className="flex items-center gap-2 px-4 py-2 border border-gray-200 rounded-lg text-sm font-medium text-gray-600 hover:bg-gray-50 transition-colors">
              <BellOff className="w-4 h-4" />
              모두 읽음 처리
            </button>
          )}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Notifications list */}
          <div className="lg:col-span-2 space-y-3">
            {notifications.length === 0 ? (
              <div className="bg-white rounded p-12 shadow-sm border border-gray-100 text-center">
                <Bell className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                <p className="text-gray-500 font-medium">알림이 없습니다</p>
                <p className="text-sm text-gray-400 mt-1">새로운 알림이 오면 여기에 표시됩니다</p>
              </div>
            ) : (
              notifications.map(n => {
                const style = typeStyles[n.type];
                const Icon = style.Icon;
                return (
                  <div key={n.id}
                    className={`relative group bg-white rounded border transition-all ${
                      n.unread ? 'border-[#1A2E44]/30 shadow-sm shadow-[#1A2E44]/10' : 'border-gray-100'
                    } hover:shadow-md cursor-pointer`}
                    onClick={() => markRead(n.id)}>
                    {n.unread && (
                      <div className="absolute left-0 top-0 bottom-0 w-1 rounded-l-xl bg-[#1A2E44]" />
                    )}
                    <div className="flex gap-4 p-4 pl-5">
                      <div className={`${style.bg} ${style.text} w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5`}>
                        <Icon className="w-4 h-4" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-2 mb-1">
                          <h3 className={`text-sm font-semibold ${n.unread ? 'text-gray-900' : 'text-gray-700'}`}>{n.title}</h3>
                          <div className="flex items-center gap-1 flex-shrink-0">
                            <span className="text-xs text-gray-400 whitespace-nowrap">{n.time}</span>
                            {n.unread && <div className="w-2 h-2 rounded-full bg-[#1A2E44] flex-shrink-0" />}
                          </div>
                        </div>
                        <p className="text-sm text-gray-600 leading-relaxed">{n.message}</p>
                      </div>
                    </div>
                    {/* dismiss */}
                    <button
                      onClick={e => { e.stopPropagation(); dismiss(n.id); }}
                      className="absolute top-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity p-1 rounded-md hover:bg-gray-100 text-gray-400 hover:text-gray-600">
                      <X className="w-3.5 h-3.5" />
                    </button>
                  </div>
                );
              })
            )}

            <button
              disabled={olderLoaded}
              onClick={() => {
                setNotifications(prev => [...prev, ...olderNotifications]);
                setOlderLoaded(true);
                toast.success('이전 알림 3건을 불러왔습니다.');
              }}
              className="w-full py-3 border border-gray-200 text-gray-600 text-sm font-medium rounded hover:bg-gray-50 disabled:bg-gray-50 disabled:text-gray-400 transition-colors"
            >
              {olderLoaded ? '모든 알림을 불러왔습니다' : '이전 알림 더 보기'}
            </button>
          </div>

          {/* Right sidebar */}
          <div className="space-y-5">
            {/* Mascot */}
            <div className="bg-gradient-to-br from-[#1A2E44] to-[#2C5282] rounded p-5">
            </div>

            {/* Deadlines */}
            <div className="bg-white rounded p-5 shadow-sm border border-gray-100">
              <h2 className="text-sm font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Calendar className="w-4 h-4 text-[#1A2E44]" /> 마감 일정
              </h2>
              <div className="space-y-5">
                {deadlines.map((group, i) => (
                  <div key={i}>
                    <div className="flex items-center gap-2 mb-2.5">
                      <div className={`w-2 h-2 rounded-full flex-shrink-0 ${group.urgent ? 'bg-red-500 animate-pulse' : 'bg-gray-300'}`} />
                      <span className={`text-xs font-semibold ${group.urgent ? 'text-red-600' : 'text-gray-600'}`}>{group.date}</span>
                    </div>
                    <div className="space-y-2 ml-4">
                      {group.items.map((item, j) => (
                        <div key={j} onClick={() => onNavigate('actions-detail')}
                          className="flex items-center gap-2.5 p-2.5 bg-gray-50 rounded-lg hover:bg-gray-100 cursor-pointer group transition-colors">
                          <div className={`w-2 h-2 rounded-full flex-shrink-0 ${priorityColors[item.priority]}`} />
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-medium text-gray-800 truncate">{item.title}</p>
                            <p className="text-[10px] text-gray-500">{item.location}</p>
                          </div>
                          <span className={`text-[10px] px-1.5 py-0.5 rounded font-medium flex-shrink-0 ${
                            item.priority === 'high' ? 'bg-red-100 text-red-700' :
                            item.priority === 'medium' ? 'bg-orange-100 text-orange-700' :
                            'bg-yellow-100 text-yellow-700'
                          }`}>{priorityLabels[item.priority]}</span>
                          <ArrowRight className="w-3 h-3 text-gray-300 group-hover:text-[#1A2E44] transition-colors flex-shrink-0" />
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
              <button onClick={() => onNavigate('actions')}
                className="w-full mt-4 py-2.5 bg-[#1A2E44] text-white rounded-lg text-sm font-semibold hover:bg-[#0F2233] transition-colors flex items-center justify-center gap-2">
                전체 조치 관리 <ArrowRight className="w-4 h-4" />
              </button>
            </div>

            {/* Notification Settings */}
            <div className="bg-white rounded p-5 shadow-sm border border-gray-100">
              <h2 className="text-sm font-semibold text-gray-900 mb-4">알림 설정</h2>
              <div className="space-y-3">
                {([
                  { key: 'deadline', label: '조치 마감 알림',  desc: '마감 1일 전 알림' },
                  { key: 'comment',  label: '댓글 알림',       desc: '새 댓글 등록 시' },
                  { key: 'complete', label: '조치 완료 알림',  desc: '완료 처리 시' },
                  { key: 'weekly',   label: '주간 리포트',     desc: '매주 월요일' },
                ] as { key: keyof typeof settings; label: string; desc: string }[]).map(s => (
                  <label key={s.key} className="flex items-center justify-between cursor-pointer group">
                    <div>
                      <p className="text-sm font-medium text-gray-800">{s.label}</p>
                      <p className="text-xs text-gray-400">{s.desc}</p>
                    </div>
                    <div onClick={() => toggleSetting(s.key)}
                      className={`relative w-10 h-5 rounded-full transition-colors flex-shrink-0 ${settings[s.key] ? 'bg-[#1A2E44]' : 'bg-gray-200'}`}>
                      <div className={`absolute top-0.5 w-4 h-4 bg-white rounded-full shadow-sm transition-transform ${settings[s.key] ? 'translate-x-5' : 'translate-x-0.5'}`} />
                    </div>
                  </label>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
