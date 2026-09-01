/*
 * "저장된 보고서" 화면(시연용 프론트 더미 데이터)의 단일 데이터 소스.
 * saved-reports.jsp(목록)와 saved-report-detail.jsp(상세)에서 함께 불러 쓴다.
 * 나중에 실제 API로 교체할 때는 이 배열을 fetch('/api/documents/mine') 결과로 바꿔치기만 하면 된다.
 */
var SAVED_REPORTS = [
  {
    id: 1,
    type: "조치결과보고서",
    siteName: "삼성물산",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.31 17:43",
    detail: {
      completedAction: "추락 위험: 작업 구역 경계 설정 및 안전난간 설치",
      preventionPlan: "개구부 및 단부에는 안전난간 또는 방호망을 상시 설치하고, 고소작업 시 안전대(하네스) 체결 상태를 작업 전 확인한다.",
      items: [
        { name: "추락 위험", result: "조치 완료", note: "작업 구역 경계 설정 및 안전난간 설치" },
        { name: "안전모 착용 불량", result: "승인 대기", note: "모든 작업자에게 올바른 안전모 착용 교육 실시 및 착용 상태 수시 점검" }
      ]
    }
  },
  {
    id: 2,
    type: "조치결과보고서",
    siteName: "QA테스트현장",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.31 16:52",
    detail: {
      completedAction: "안전모 미착용: 전 작업자 안전모 지급 및 착용 확인 완료",
      preventionPlan: "작업 전 안전모 착용 상태를 수시 점검하고, 턱끈 체결 여부를 확인한다.",
      items: [
        { name: "안전모 미착용", result: "조치 완료", note: "전 작업자 안전모 지급 및 착용 상태 확인" },
        { name: "작업장 정리정돈 미흡", result: "조치 완료", note: "자재 및 잔해물 정리, 정기 청소 실시" }
      ]
    }
  },
  {
    id: 3,
    type: "조치결과보고서",
    siteName: "QA테스트현장",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.31 13:51",
    detail: {
      completedAction: "불안정한 작업 자세: 안전한 작업 자세 교육 실시 및 작업대 설치",
      preventionPlan: "고위험 작업 전 자세 안전 교육을 실시하고 필요 시 작업대를 설치한다.",
      items: [
        { name: "불안정한 작업 자세", result: "조치 완료", note: "안전한 작업 자세 교육 실시, 필요시 작업대 설치" }
      ]
    }
  },
  {
    id: 4,
    type: "안전점검일지",
    siteName: "마곡 센트럴시티",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.28 14:38",
    detail: {
      overallResult: "조치중",
      items: [
        { name: "안전표지 부족", result: "개선 필요", note: "위험구역 안전표지판 추가 설치 필요" },
        { name: "안전장비 미착용", result: "개선 필요", note: "개인보호구 착용 의무화 및 교육 실시" }
      ]
    }
  },
  {
    id: 5,
    type: "안전점검일지",
    siteName: "마곡 센트럴시티",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.28 14:33",
    detail: {
      overallResult: "양호",
      items: [
        { name: "작업장 바닥 정리 미흡", result: "양호", note: "정리 조치 완료 확인" },
        { name: "목재 운반 시 안전거리 미확보", result: "양호", note: "안전거리 확보 교육 완료" }
      ]
    }
  },
  {
    id: 6,
    type: "안전점검일지",
    siteName: "코엑스",
    generationType: "AI 자동생성",
    updatedAt: "2026.08.28 14:06",
    detail: {
      overallResult: "불량",
      items: [
        { name: "중량물 취급 시 안전장비 미착용", result: "개선 필요", note: "중량물 취급 전 안전장비 착용 의무화" },
        { name: "작업자 간 안전거리 미확보", result: "개선 필요", note: "작업 구역별 최소 안전거리 기준 재교육" }
      ]
    }
  }
];
