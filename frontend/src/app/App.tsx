import { useEffect, useState } from 'react';
import { Toaster } from 'sonner';
import LandingPage from './components/LandingPage';
import LoginPage from './components/LoginPage';
import SignupPage from './components/SignupPage';
import FindIdPage from './components/FindIdPage';
import FindPasswordPage from './components/FindPasswordPage';
import ContractorDashboard from './components/ContractorDashboard';
import SubcontractorDashboard from './components/SubcontractorDashboard';
import ActionManagementAdvanced from './components/ActionManagementAdvanced';
import ActionRegistration from './components/ActionRegistration';
import UploadPage from './components/UploadPage';
import ReportDetail from './components/ReportDetail';
import Analytics from './components/Analytics';
import Notifications from './components/Notifications';
import MyPage from './components/MyPage';
import ReportBoard from './components/ReportBoard';
import ReportBoardDetail from './components/ReportBoardDetail';
import QuickNav from './components/QuickNav';
import AIAnalysisPage from './components/AIAnalysisPage';
import AIReportPage from './components/AIReportPage';
import SavedReports from './components/SavedReports';
import SafetyDocuments from './components/SafetyDocuments';
import { createSafetyDocumentSnapshot, type SafetyDocumentSnapshot } from './components/SafetyDocumentTemplate';

type UserType = 'contractor' | 'subcontractor' | null;

export interface AiAction {
  id: number;
  title: string;
  risk: 'high' | 'medium' | 'low';
  desc: string;
  site: string;
  image: string;
}

export interface CompletedAction {
  title: string;
  risk: 'high' | 'medium' | 'low';
  description: string;
  location: string;
  recommendation: string;
  regulation: string;
  confidence: number;
}

export interface SavedReport {
  id: string;
  title: string;
  site: string;
  author: string;
  createdAt: string;
  actionCount: number;
  aiGenerated: boolean;
  snapshot: SafetyDocumentSnapshot;
}

const INITIAL_SAVED_REPORTS: SavedReport[] = [
  { id: 'SR-2026-006', title: '조치결과보고서', site: '강남 복합시설 신축공사', author: '김현장', createdAt: '2026.08.28', actionCount: 4, aiGenerated: true, snapshot: createSafetyDocumentSnapshot({ templateId: 'action', siteName: '강남 복합시설 신축공사', documentDate: '2026-08-28', writer: '김현장', documentNumber: 'SR-2026-006' }) },
  { id: 'SR-2026-005', title: '안전점검일지', site: '강남 복합시설 신축공사', author: '박안전', createdAt: '2026.08.25', actionCount: 7, aiGenerated: true, snapshot: createSafetyDocumentSnapshot({ templateId: 'inspection', siteName: '강남 복합시설 신축공사', documentDate: '2026-08-25', writer: '박안전', documentNumber: 'SR-2026-005' }) },
  { id: 'SR-2026-004', title: 'TBM 일지', site: '강남 복합시설 신축공사', author: '이관리', createdAt: '2026.08.21', actionCount: 3, aiGenerated: true, snapshot: createSafetyDocumentSnapshot({ templateId: 'tbm', siteName: '강남 복합시설 신축공사', documentDate: '2026-08-21', writer: '이관리', documentNumber: 'SR-2026-004' }) },
];

const SAVED_REPORTS_KEY = 'safety-link-saved-reports-v2';

export default function App() {
  const [currentPage, setCurrentPage] = useState<string>('landing');
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userType, setUserType] = useState<UserType>(null);
  const [aiActions, setAiActions] = useState<AiAction[]>([]);
  const [registeredImages, setRegisteredImages] = useState<string[]>([]);
  const [pendingReportActions, setPendingReportActions] = useState<CompletedAction[]>([]);
  const [savedReports, setSavedReports] = useState<SavedReport[]>(() => {
    try {
      const stored = localStorage.getItem(SAVED_REPORTS_KEY);
      const parsed = stored ? JSON.parse(stored) as SavedReport[] : null;
      return parsed?.every(report => report.snapshot) ? parsed : INITIAL_SAVED_REPORTS;
    } catch {
      return INITIAL_SAVED_REPORTS;
    }
  });
  const [standaloneTemplate, setStandaloneTemplate] = useState<string | null>(null);

  useEffect(() => {
    localStorage.setItem(SAVED_REPORTS_KEY, JSON.stringify(savedReports));
  }, [savedReports]);

  const publicPages = new Set(['landing', 'login', 'signup', 'find-id', 'find-password']);

  const handleLogin = (role: 'contractor' | 'subcontractor') => {
    setIsAuthenticated(true);
    setUserType(role);
    setCurrentPage('dashboard');
  };

  const handleNavigation = (page: string) => {
    if (!isAuthenticated && !publicPages.has(page)) {
      setCurrentPage('login');
    } else {
      setCurrentPage(page);
    }
  };

  const renderPage = () => {
    switch (currentPage) {
      case 'landing':
        return <LandingPage onNavigate={handleNavigation} />;
      case 'login':
        return <LoginPage onLogin={handleLogin} onNavigate={handleNavigation} />;
      case 'signup':
        return <SignupPage onNavigate={handleNavigation} />;
      case 'find-id':
        return <FindIdPage onNavigate={handleNavigation} />;
      case 'find-password':
        return <FindPasswordPage onNavigate={handleNavigation} />;
      case 'dashboard':
        return userType === 'subcontractor'
          ? <SubcontractorDashboard onNavigate={handleNavigation} />
          : <ContractorDashboard onNavigate={handleNavigation} />;
      case 'actions':
        return <ActionManagementAdvanced onNavigate={handleNavigation} incomingActions={aiActions} onIncomingConsumed={() => setAiActions([])} userType={userType} />;
      case 'actions-new':
        return <ActionRegistration onNavigate={handleNavigation} />;
      case 'upload':
        return <UploadPage onNavigate={handleNavigation} onCreateActions={(actions, images) => { setAiActions(actions); if (images?.length) setRegisteredImages(images); handleNavigation('actions'); }} />;
      case 'actions-detail':
        return <ReportDetail
          onNavigate={handleNavigation}
          beforeImages={registeredImages}
          onStartReport={(actions) => { setStandaloneTemplate(null); setPendingReportActions(actions); handleNavigation('ai-report'); }}
        />;
      case 'documents':
        return <SafetyDocuments onNavigate={handleNavigation} onCreate={(templateId) => { setPendingReportActions([]); setStandaloneTemplate(templateId); handleNavigation('ai-report'); }} />;
      case 'analytics':
        return <Analytics onNavigate={handleNavigation} />;
      case 'ai-analysis':
        return <AIAnalysisPage onNavigate={handleNavigation} />;
      case 'ai-report':
        return <AIReportPage
          onNavigate={handleNavigation}
          completedActions={pendingReportActions.length ? pendingReportActions : undefined}
          onConsumeActions={() => setPendingReportActions([])}
          initialStandaloneTemplate={standaloneTemplate ?? undefined}
          onReportSaved={({ title, actionCount, site, author, createdAt, snapshot }) => {
            const id = `SR-2026-${String(savedReports.length + 7).padStart(3, '0')}`;
            setSavedReports(prev => [{
              id,
              title,
              site,
              author,
              createdAt,
              actionCount,
              aiGenerated: true,
              snapshot: { ...snapshot, documentNumber: id },
            }, ...prev]);
            setStandaloneTemplate(null);
          }}
        />;
      case 'saved-reports':
        return <SavedReports onNavigate={handleNavigation} reports={savedReports} />;
      case 'notifications':
        return <Notifications onNavigate={handleNavigation} />;
      case 'mypage':
        return <MyPage onNavigate={handleNavigation} userType={userType} />;
      case 'report-board':
        return <ReportBoard onNavigate={handleNavigation} />;
      case 'report-board-detail':
        return <ReportBoardDetail onNavigate={handleNavigation} />;
      default:
        return <LandingPage onNavigate={handleNavigation} />;
    }
  };

  const SHOW_QUICK_NAV = true;
  const showQuickNav = SHOW_QUICK_NAV && !publicPages.has(currentPage);

  return (
    <div className="min-h-screen">
      {renderPage()}
      {showQuickNav && <QuickNav onNavigate={handleNavigation} currentPage={currentPage} />}
      <Toaster position="top-right" richColors />
    </div>
  );
}
