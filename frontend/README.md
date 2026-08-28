
  # Web UI Design for SafeMate

  This is a code bundle for Web UI Design for SafeMate. The original project is available at https://www.figma.com/design/ZI5YVY8alXdmAYHRTLiG5I/Web-UI-Design-for-SafeMate.

  ## Running the code

  Run `npm i` to install the dependencies.

  Run `npm run dev` to start the development server (http://localhost:5173/app/).

  ## Spring Boot 통합

  이 앱은 Figma export 원본을 그대로 이식한 것이며, `kopo.poly` Spring Boot 프로젝트의
  프론트엔드로 통합되어 있다.

  - `npm run build` → 산출물이 `../src/main/resources/static/app/` 로 나간다.
  - Spring Boot 기동 후 `http://localhost:8080/app/` 로 접속하면 SafeMate SPA 전체가 뜬다.
    (`kopo.poly.controller.SpaController` 가 `/app` → `/app/index.html` forward,
     `SecurityConfig` 가 `/app/**` 를 permitAll 처리한다.)
  - 개발 모드에서는 `npm run dev` 의 Vite 서버가 `/api` 요청을 `localhost:8080` 으로 프록시한다.

  ## 화면 흐름 (src/app/App.tsx)

  상태 기반 라우팅. 초기 페이지 `landing`.
  - public: `landing`, `login`, `signup`, `find-id`, `find-password`
  - 로그인 후 `dashboard` 로 이동, `userType` 에 따라 Contractor/Subcontractor 대시보드 분기
  - `upload` → AI 분석/조치 생성 → `actions` → `actions-detail` → `ai-report`
  - 미인증 상태로 인증 필요 페이지 접근 시 `login` 으로 이동
  - public 이 아닌 페이지에서는 `QuickNav` 표시, 전역 `sonner` Toaster 표시

  ## 원본 대비 변경점 (빌드/경로 조정만)

  - `src/imports/조치검증Ai/` → `src/imports/action-verify-ai/` 로 폴더명 변경 (한글 경로 빌드 이슈 회피),
    `ActionVerificationPanel.tsx` 의 import 2줄 동일하게 수정.
  - `package.json` 에 `react`/`react-dom` `18.3.1` 및 `@types/react(-dom)` 추가 (원본은 peerDependency 로만 선언).
  - `vite.config.ts` 에 `base: '/app/'`, `build.outDir`, `/api` dev 프록시 추가.

  나머지 페이지/컴포넌트/스타일/에셋/shadcn ui 컴포넌트는 원본 그대로다.
