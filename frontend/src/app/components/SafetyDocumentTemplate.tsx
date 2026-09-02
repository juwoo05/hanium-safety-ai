import type { CompletedAction } from '../App';

export type SafetyTemplateId = 'action' | 'inspection' | 'risk' | 'tbm' | 'edu' | 'ppe' | 'work' | 'expense';

export interface SafetyDocumentTable {
  title: string;
  headers: string[];
  rows: string[][];
  widths?: string[];
}

export interface SafetyDocumentSnapshot {
  templateId: SafetyTemplateId;
  templateName: string;
  documentNumber: string;
  siteName: string;
  documentDate: string;
  writer: string;
  contractor: string;
  subcontractor: string;
  summary: string;
  information: Array<[string, string]>;
  tables: SafetyDocumentTable[];
  signatures: string[];
  sourceNote: string;
}

export const SAFETY_TEMPLATE_META: Array<{ id: SafetyTemplateId; name: string; desc: string }> = [
  { id: 'action', name: '조치결과보고서', desc: '위험요인별 조치 전·후 결과와 재발방지 대책 기록' },
  { id: 'inspection', name: '안전점검일지', desc: '점검 항목별 적합 여부, 지적사항과 조치기한 기록' },
  { id: 'risk', name: '위험성평가서', desc: '유해·위험요인의 가능성·중대성과 감소대책 기록' },
  { id: 'tbm', name: 'TBM 일지', desc: '작업 전 위험요인·안전대책 공유와 참석자 확인' },
  { id: 'edu', name: '안전보건교육일지', desc: '교육 구분·내용·시간과 참석자 서명 기록' },
  { id: 'ppe', name: '보호구 지급대장', desc: '보호구 품목·수량·수령자와 지급 확인 기록' },
  { id: 'work', name: '안전작업허가서', desc: '위험작업 전 안전조치 점검과 작업 승인 기록' },
  { id: 'expense', name: '산업안전보건관리비 사용내역서', desc: '안전관리비 집행 항목·금액·증빙과 누계 기록' },
];

const defaultActions: CompletedAction[] = [
  {
    title: '안전난간 미설치', risk: 'high', location: '3동 옥상', confidence: 96,
    description: '단부 안전난간 및 발끝막이판 설치 완료',
    recommendation: '작업 전 난간 고정상태를 일일 점검하고 임의 해체를 금지한다.',
    regulation: '산업안전보건기준에 관한 규칙 제13조',
  },
  {
    title: '임시 배선 노출', risk: 'medium', location: '지하 1층', confidence: 92,
    description: '노출 배선을 절연 보강하고 케이블 보호덮개 설치 완료',
    recommendation: '분전반과 임시배선의 피복 및 누전차단기 작동상태를 점검한다.',
    regulation: '산업안전보건기준에 관한 규칙 제302조',
  },
];

const riskLabel = { high: '상', medium: '중', low: '하' } as const;

function actionRows(actions: CompletedAction[]) {
  return (actions.length ? actions : defaultActions).map((action, index) => [
    String(index + 1), action.title, action.location, riskLabel[action.risk], action.description, '완료',
  ]);
}

export function createSafetyDocumentSnapshot(input: {
  templateId?: string | null;
  siteName: string;
  documentDate: string;
  writer: string;
  documentNumber: string;
  actions?: CompletedAction[];
}): SafetyDocumentSnapshot {
  const templateId = SAFETY_TEMPLATE_META.some(item => item.id === input.templateId)
    ? input.templateId as SafetyTemplateId
    : 'action';
  const meta = SAFETY_TEMPLATE_META.find(item => item.id === templateId)!;
  const actions = input.actions?.length ? input.actions : defaultActions;
  const common = {
    templateId,
    templateName: meta.name,
    documentNumber: input.documentNumber,
    siteName: input.siteName,
    documentDate: input.documentDate,
    writer: input.writer,
    contractor: '대한안전건설',
    subcontractor: '안전하도급',
    sourceNote: '한국산업안전보건공단(KOSHA) 및 고용노동부 공개자료의 필수 기록 항목을 참고한 현장용 양식',
  };

  if (templateId === 'inspection') {
    return {
      ...common,
      summary: '추락·감전·보호구·정리정돈 등 주요 위험요인을 점검하고 부적합 항목의 조치 상태를 확인함.',
      information: [['점검구분', '일일 안전점검'], ['점검시간', '08:00 ~ 09:00'], ['점검구역', '3동 옥상 및 지하 1층'], ['기상상태', '맑음 / 28℃']],
      tables: [{
        title: '안전점검 결과',
        headers: ['No.', '점검분야', '점검항목', '결과', '지적 및 조치사항', '조치기한'],
        rows: actions.map((action, index) => [String(index + 1), index % 2 ? '전기안전' : '추락방지', action.title, '조치완료', action.description, input.documentDate]),
      }],
      signatures: ['점검자', '안전관리자', '현장소장'],
    };
  }

  if (templateId === 'risk') {
    return {
      ...common,
      summary: 'AI 점검에서 확인된 유해·위험요인의 현재 위험성을 평가하고 위험성 감소대책과 담당자를 지정함.',
      information: [['평가구분', '수시 위험성평가'], ['대상공정', '골조 및 전기 작업'], ['평가방법', '상·중·하 3단계 판단법'], ['허용기준', '상·중: 개선 필요 / 하: 허용 가능']],
      tables: [{
        title: '위험성평가 및 감소대책',
        headers: ['No.', '공정·작업', '유해·위험요인', '현재조치', '위험성', '감소대책', '담당자', '완료일'],
        rows: actions.map((action, index) => [String(index + 1), index % 2 ? '임시전기' : '옥상 작업', action.title, action.description, riskLabel[action.risk], action.recommendation, input.writer, input.documentDate]),
      }],
      signatures: ['평가자', '관리감독자', '안전보건관리책임자'],
    };
  }

  if (templateId === 'tbm') {
    return {
      ...common,
      summary: '당일 작업의 위험요인과 안전대책을 작업 전에 공유하고 작업자의 건강상태와 이해 여부를 확인함.',
      information: [['TBM 일시', `${input.documentDate} 07:30 ~ 07:45`], ['작업장소', '3동 옥상'], ['오늘의 작업', '옥상 외곽부 마감 및 임시전기 정리'], ['진행자', input.writer], ['참석인원', '6명'], ['비상연락', '현장 안전관리실 02-1234-5678']],
      tables: [
        { title: '작업 전 위험요인 및 안전대책', headers: ['No.', '주요 작업', '위험요인', '안전대책', '담당자'], rows: actions.map((action, index) => [String(index + 1), index % 2 ? '임시전기 정리' : '옥상 마감', action.title, action.recommendation, input.writer]) },
        { title: '참석자 확인', headers: ['No.', '성명', '소속', '건강상태', '내용 이해', '서명'], rows: [['1', '박근로', '안전하도급', '양호', '확인', '(서명)'], ['2', '이작업', '안전하도급', '양호', '확인', '(서명)'], ['3', '최기술', '대한안전건설', '양호', '확인', '(서명)']] },
      ],
      signatures: ['TBM 리더', '관리감독자', '안전관리자'],
    };
  }

  if (templateId === 'edu') {
    return {
      ...common,
      summary: '당일 작업 위험요인, 보호구 착용 및 비상 대응 절차를 중심으로 정기 안전보건교육을 실시함.',
      information: [['교육구분', '정기교육'], ['교육일시', `${input.documentDate} 13:00 ~ 14:00`], ['교육장소', '현장 안전교육장'], ['교육강사', input.writer], ['교육대상', '현장 근로자'], ['교육인원', '8명']],
      tables: [
        { title: '교육 내용', headers: ['No.', '교육과목', '세부 내용', '교육시간', '교육방법'], rows: [['1', '사고 예방', '추락·감전 위험요인 및 예방대책', '30분', '시청각·사례'], ['2', '보호구', '안전모·안전화·안전대 올바른 착용법', '20분', '실습'], ['3', '비상 대응', '사고 보고 및 대피 절차', '10분', '강의']] },
        { title: '교육 참석자 명부', headers: ['No.', '성명', '소속', '직종', '서명'], rows: [['1', '박근로', '안전하도급', '형틀', '(서명)'], ['2', '이작업', '안전하도급', '전기', '(서명)'], ['3', '최기술', '대한안전건설', '안전', '(서명)']] },
      ],
      signatures: ['교육담당자', '안전관리자', '현장소장'],
    };
  }

  if (templateId === 'ppe') {
    return {
      ...common,
      summary: '작업별 유해·위험요인에 적합한 안전인증 보호구를 지급하고 수령 및 상태를 확인함.',
      information: [['지급구분', '신규 및 정기교체'], ['지급장소', '현장 안전관리실'], ['지급담당', input.writer], ['확인사항', '안전인증 표시 및 외관상태 확인']],
      tables: [{
        title: '개인보호구 지급 내역',
        headers: ['No.', '지급일', '수령자', '소속/직종', '보호구명', '규격', '수량', '지급사유', '수령서명'],
        rows: [['1', input.documentDate, '박근로', '안전하도급/형틀', '안전모 ABE형', 'M', '1', '신규 지급', '(서명)'], ['2', input.documentDate, '이작업', '안전하도급/전기', '안전화', '270mm', '1', '정기 교체', '(서명)'], ['3', input.documentDate, '최기술', '대한안전건설/안전', '그네식 안전대', '공용', '1', '고소작업', '(서명)']],
      }],
      signatures: ['지급담당자', '안전관리자', '현장소장'],
    };
  }

  if (templateId === 'work') {
    return {
      ...common,
      summary: '작업 시작 전 작업구역 통제, 보호구, 화재·추락·감전 방지조치와 비상대응 준비상태를 확인함.',
      information: [['허가작업', '옥상 용접 및 고소작업'], ['작업장소', '3동 옥상'], ['작업시간', `${input.documentDate} 09:00 ~ 17:00`], ['작업업체', '안전하도급'], ['작업책임자', '박반장'], ['작업인원', '4명']],
      tables: [
        { title: '작업 전 안전조치 확인', headers: ['No.', '안전조치 요구사항', '해당', '실시', '확인내용'], rows: [['1', '작업 절차 및 위험성평가 공유', 'Y', '완료', 'TBM 실시'], ['2', '작업구역 설정 및 출입금지 표시', 'Y', '완료', '라바콘·표지 설치'], ['3', '가연성 물질 제거 및 불티 비산방지', 'Y', '완료', '방화포 설치'], ['4', '소화기 및 화재감시자 배치', 'Y', '완료', '소화기 2대'], ['5', '안전대 부착설비 및 보호구 착용', 'Y', '완료', '2중 안전고리'], ['6', '전기기구 접지·절연 및 누전차단기', 'Y', '완료', '시험 정상']] },
        { title: '가스농도 측정 및 비상조치', headers: ['측정시간', '산소(O₂)', '가연성가스(LEL)', '일산화탄소(CO)', '측정자', '비상연락'], rows: [['08:50', '20.9%', '0%', '0 ppm', input.writer, '안전관리실']] },
      ],
      signatures: ['작업신청자', '안전조치 확인자', '작업승인자'],
    };
  }

  if (templateId === 'expense') {
    return {
      ...common,
      summary: '산업재해 예방 목적으로 집행한 안전보건관리비의 사용 항목과 증빙을 확인하고 누계를 관리함.',
      information: [['공사명', input.siteName], ['계약금액', '12,500,000,000원'], ['계상 안전보건관리비', '325,000,000원'], ['대상기간', `${input.documentDate.slice(0, 7)}월`], ['전월 누계', '82,450,000원'], ['작성자', input.writer]],
      tables: [{
        title: '산업안전보건관리비 사용 내역',
        headers: ['No.', '사용일', '사용항목', '세부 사용내역', '공급가액', '부가세', '합계', '증빙'],
        rows: [['1', input.documentDate, '안전시설비', '옥상 안전난간 및 발끝막이판', '2,400,000', '240,000', '2,640,000', '세금계산서·사진'], ['2', input.documentDate, '개인보호구', '안전모·안전화·안전대', '1,200,000', '120,000', '1,320,000', '거래명세서'], ['3', input.documentDate, '안전교육비', '근로자 안전교육 교재', '350,000', '35,000', '385,000', '영수증']],
      }],
      signatures: ['작성자', '안전관리자', '현장소장'],
    };
  }

  return {
    ...common,
    summary: `AI 안전점검 결과 확인된 ${actions.length}건의 위험요소에 대한 조치 완료 여부와 재발방지 대책을 확인함.`,
    information: [['보고구분', '위험요소 조치 완료'], ['조치기간', `${input.documentDate} 완료`], ['대상구역', '3동 옥상 및 지하 1층'], ['검증방법', '조치 사진 및 현장 재점검']],
    tables: [
      { title: '위험요소 조치 결과', headers: ['No.', '위험요소', '위치', '위험성', '조치내용', '결과'], rows: actionRows(actions) },
      { title: '재발방지 및 후속관리', headers: ['No.', '위험요소', '재발방지 대책', '관련 기준', '담당자'], rows: actions.map((action, index) => [String(index + 1), action.title, action.recommendation, action.regulation, input.writer]) },
    ],
    signatures: ['조치담당자', '안전관리자', '현장소장'],
  };
}

export function SafetyDocumentPreview({ document }: { document: SafetyDocumentSnapshot }) {
  return (
    <article className="bg-white text-slate-800 text-xs">
      <header className="text-center pb-4 border-b-2 border-slate-800">
        <div className="flex justify-between text-[11px] text-slate-500 mb-3">
          <span>문서번호: {document.documentNumber}</span><span>AI 자동작성 · 원본 보존</span>
        </div>
        <h3 className="text-xl font-bold text-slate-950">{document.templateName}</h3>
        <p className="mt-1 text-slate-500">{document.siteName} · {document.documentDate}</p>
      </header>

      <table className="w-full border-collapse border border-slate-400 mt-5">
        <tbody>
          <tr><th className="bg-slate-100 border border-slate-400 px-3 py-2 w-24">현장명</th><td className="border border-slate-400 px-3 py-2" colSpan={3}>{document.siteName}</td></tr>
          <tr><th className="bg-slate-100 border border-slate-400 px-3 py-2">원청사</th><td className="border border-slate-400 px-3 py-2">{document.contractor}</td><th className="bg-slate-100 border border-slate-400 px-3 py-2 w-24">협력사</th><td className="border border-slate-400 px-3 py-2">{document.subcontractor}</td></tr>
          <tr><th className="bg-slate-100 border border-slate-400 px-3 py-2">작성일</th><td className="border border-slate-400 px-3 py-2">{document.documentDate}</td><th className="bg-slate-100 border border-slate-400 px-3 py-2">작성자</th><td className="border border-slate-400 px-3 py-2">{document.writer}</td></tr>
          {document.information.map(([label, value], index) => index % 2 === 0 && (
            <tr key={label}>
              <th className="bg-slate-100 border border-slate-400 px-3 py-2">{label}</th><td className="border border-slate-400 px-3 py-2">{value}</td>
              {document.information[index + 1] ? <><th className="bg-slate-100 border border-slate-400 px-3 py-2">{document.information[index + 1][0]}</th><td className="border border-slate-400 px-3 py-2">{document.information[index + 1][1]}</td></> : <td className="border border-slate-400" colSpan={2} />}
            </tr>
          ))}
        </tbody>
      </table>

      <section className="mt-5">
        <h4 className="font-bold mb-2">종합 내용</h4>
        <div className="border border-slate-400 p-3 leading-5 bg-slate-50">{document.summary}</div>
      </section>

      {document.tables.map((table, tableIndex) => (
        <section className="mt-5 overflow-x-auto" key={`${table.title}-${tableIndex}`}>
          <h4 className="font-bold mb-2">{tableIndex + 1}. {table.title}</h4>
          <table className="w-full border-collapse border border-slate-400 min-w-[640px]">
            <thead><tr className="bg-slate-100">{table.headers.map(header => <th key={header} className="border border-slate-400 px-2 py-2 text-center whitespace-nowrap">{header}</th>)}</tr></thead>
            <tbody>{table.rows.map((row, rowIndex) => <tr key={rowIndex}>{row.map((cell, cellIndex) => <td key={cellIndex} className="border border-slate-400 px-2 py-2 align-top leading-5 text-center">{cell}</td>)}</tr>)}</tbody>
          </table>
        </section>
      ))}

      <section className="mt-6">
        <h4 className="font-bold mb-2">확인 및 승인</h4>
        <table className="w-full border-collapse border border-slate-400">
          <thead><tr className="bg-slate-100">{document.signatures.map(label => <th key={label} className="border border-slate-400 px-3 py-2">{label}</th>)}</tr></thead>
          <tbody><tr>{document.signatures.map((label, index) => <td key={label} className="border border-slate-400 px-3 py-5 text-center">{index === 0 ? document.writer : ''} <span className="text-slate-400">(서명)</span></td>)}</tr></tbody>
        </table>
      </section>
      <footer className="mt-4 pt-3 border-t border-slate-200 text-[10px] text-slate-400 text-right">{document.sourceNote}</footer>
    </article>
  );
}
