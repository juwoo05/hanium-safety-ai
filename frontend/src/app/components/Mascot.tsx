interface MascotProps {
  message?: string;
  className?: string;
  gesture?: 'thumbsup' | 'pointing' | 'greeting' | 'analyzing';
  size?: 'sm' | 'md' | 'lg';
}

import mascotImage from '../../imports/ChatGPT_Image_2026__6__1_____03_36_42.png';

export default function Mascot({ message, className = '', gesture = 'greeting', size = 'md' }: MascotProps) {
  const sizeClasses = {
    sm: 'w-16 h-16',
    md: 'w-24 h-24',
    lg: 'w-32 h-32'
  };

  return (
    <div className={`flex flex-col items-center gap-3 ${className}`}>
      <div className={`${sizeClasses[size]} relative`}>
        <img
          src={mascotImage}
          alt="연결고리 안전 도우미"
          className="w-full h-full object-contain"
          style={{ mixBlendMode: 'multiply' }}
        />
      </div>
      {message && (
        <div className="relative bg-white rounded-2xl shadow-lg px-4 py-3 max-w-xs">
          <div className="absolute -top-2 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-8 border-l-transparent border-r-transparent border-b-white"></div>
          <p className="text-sm text-gray-700">{message}</p>
        </div>
      )}
    </div>
  );
}
