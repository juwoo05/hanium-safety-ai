import { useState } from 'react';
import { Wind, Droplets, Eye, Thermometer, CloudRain, Sun, Cloud, CloudSnow, AlertTriangle } from 'lucide-react';

interface WeatherWidgetProps {
  compact?: boolean;
}

const weatherData = {
  location: '서울 강남구',
  temp: 28,
  feelsLike: 31,
  condition: '맑음',
  conditionType: 'sunny' as const,
  humidity: 62,
  wind: 3.2,
  windDir: '남서',
  visibility: 10,
  uvIndex: 7,
  safetyNote: '야외 작업 적합 — 자외선 지수 높음, 차광 필요',
  safetyLevel: 'caution' as 'good' | 'caution' | 'danger',
  hourly: [
    { time: '지금', temp: 28, type: 'sunny' },
    { time: '13시', temp: 30, type: 'sunny' },
    { time: '15시', temp: 31, type: 'cloudy' },
    { time: '17시', temp: 29, type: 'cloudy' },
    { time: '19시', temp: 26, type: 'cloudy' },
    { time: '21시', temp: 24, type: 'cloudy' },
  ],
  weekly: [
    { day: '오늘', high: 31, low: 22, type: 'sunny' },
    { day: '내일', high: 29, low: 21, type: 'cloudy' },
    { day: '수', high: 24, low: 19, type: 'rainy' },
    { day: '목', high: 22, low: 18, type: 'rainy' },
    { day: '금', high: 27, low: 20, type: 'sunny' },
  ],
};

function WeatherIcon({ type, className = '' }: { type: string; className?: string }) {
  const icons: Record<string, React.ReactNode> = {
    sunny: <Sun className={className} />,
    cloudy: <Cloud className={className} />,
    rainy: <CloudRain className={className} />,
    snowy: <CloudSnow className={className} />,
  };
  return <>{icons[type] || <Sun className={className} />}</>;
}

export default function WeatherWidget({ compact = false }: WeatherWidgetProps) {
  const [tab, setTab] = useState<'hourly' | 'weekly'>('hourly');
  const w = weatherData;

  const safetyColors = {
    good: 'bg-green-50 border-green-200 text-green-800',
    caution: 'bg-yellow-50 border-yellow-200 text-yellow-800',
    danger: 'bg-red-50 border-red-200 text-red-800',
  };

  if (compact) {
    return (
      <div className="bg-gradient-to-br from-sky-500 to-blue-600 rounded-2xl p-5 text-white shadow-md">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sky-200 text-xs font-medium mb-1">{w.location}</p>
            <div className="flex items-end gap-2">
              <span className="text-4xl font-bold">{w.temp}°</span>
              <span className="text-sky-200 text-sm mb-1">{w.condition}</span>
            </div>
          </div>
          <WeatherIcon type={w.conditionType} className="w-14 h-14 text-yellow-300" />
        </div>
        <div className="flex gap-4 mt-3 text-xs text-sky-200">
          <span className="flex items-center gap-1"><Droplets className="w-3 h-3" />{w.humidity}%</span>
          <span className="flex items-center gap-1"><Wind className="w-3 h-3" />{w.wind}m/s</span>
          <span className="flex items-center gap-1"><Thermometer className="w-3 h-3" />체감 {w.feelsLike}°</span>
        </div>
        <div className={`mt-3 px-3 py-2 rounded-lg border text-xs font-medium flex items-start gap-2 ${safetyColors[w.safetyLevel]}`}>
          <AlertTriangle className="w-3.5 h-3.5 flex-shrink-0 mt-0.5" />
          <span>{w.safetyNote}</span>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-2xl shadow-md overflow-hidden">
      {/* Header */}
      <div className="bg-gradient-to-br from-sky-500 to-blue-600 p-6 text-white">
        <div className="flex items-start justify-between">
          <div>
            <p className="text-sky-200 text-sm font-medium mb-1">{w.location} · 현재 날씨</p>
            <div className="flex items-end gap-3 mb-3">
              <span className="text-6xl font-bold">{w.temp}°C</span>
              <div className="mb-2">
                <p className="text-xl font-semibold">{w.condition}</p>
                <p className="text-sky-200 text-sm">체감 {w.feelsLike}°C</p>
              </div>
            </div>
            <div className="flex gap-5 text-sm text-sky-100">
              <span className="flex items-center gap-1.5"><Droplets className="w-4 h-4" />습도 {w.humidity}%</span>
              <span className="flex items-center gap-1.5"><Wind className="w-4 h-4" />{w.windDir} {w.wind}m/s</span>
              <span className="flex items-center gap-1.5"><Eye className="w-4 h-4" />가시거리 {w.visibility}km</span>
            </div>
          </div>
          <WeatherIcon type={w.conditionType} className="w-20 h-20 text-yellow-300 opacity-90" />
        </div>
      </div>

      {/* Safety notice */}
      <div className={`mx-4 mt-4 px-4 py-3 rounded-xl border-2 flex items-start gap-2 text-sm font-medium ${safetyColors[w.safetyLevel]}`}>
        <AlertTriangle className="w-4 h-4 flex-shrink-0 mt-0.5" />
        <span>현장 안전: {w.safetyNote}</span>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 mx-4 mt-4 bg-gray-100 rounded-xl p-1">
        {(['hourly', 'weekly'] as const).map(t => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`flex-1 py-2 rounded-lg text-sm font-medium transition-all ${
              tab === t ? 'bg-white shadow text-gray-900' : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            {t === 'hourly' ? '시간별' : '주간 예보'}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="p-4">
        {tab === 'hourly' ? (
          <div className="flex gap-2 overflow-x-auto pb-1">
            {w.hourly.map((h, i) => (
              <div key={i} className={`flex flex-col items-center gap-2 px-4 py-3 rounded-xl flex-shrink-0 min-w-[64px] ${
                i === 0 ? 'bg-sky-50 border-2 border-sky-200' : 'bg-gray-50'
              }`}>
                <span className="text-xs text-gray-500 font-medium">{h.time}</span>
                <WeatherIcon type={h.type} className={`w-6 h-6 ${h.type === 'sunny' ? 'text-yellow-500' : h.type === 'rainy' ? 'text-blue-500' : 'text-gray-400'}`} />
                <span className="text-sm font-bold text-gray-900">{h.temp}°</span>
              </div>
            ))}
          </div>
        ) : (
          <div className="space-y-2">
            {w.weekly.map((d, i) => (
              <div key={i} className={`flex items-center justify-between px-3 py-2.5 rounded-xl ${i === 0 ? 'bg-sky-50' : 'bg-gray-50'}`}>
                <span className={`text-sm font-medium w-10 ${i === 0 ? 'text-sky-700' : 'text-gray-700'}`}>{d.day}</span>
                <WeatherIcon type={d.type} className={`w-5 h-5 ${d.type === 'sunny' ? 'text-yellow-500' : d.type === 'rainy' ? 'text-blue-500' : 'text-gray-400'}`} />
                <div className="flex gap-3 text-sm">
                  <span className="text-red-500 font-semibold">{d.high}°</span>
                  <span className="text-blue-400 font-medium">{d.low}°</span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
