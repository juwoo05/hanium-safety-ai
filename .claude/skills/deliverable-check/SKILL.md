---
name: deliverable-check
description: 수행계획서 기준 산출물 및 개발 진척도 체크 — 현재 단계(개발 중)에 맞는 설계문서·API 명세·테스트 결과물 존재 여부를 확인한다
metadata:
  type: skill
---

# 산출물 체크

## Trigger
"산출물", "체크", "진척", "deliverable", "제출 준비", "공모전 준비" 같은 말을 하면 이 스킬을 사용한다.

## Instructions

수행계획서 기준으로 현재 개발 단계의 산출물 상태를 확인하고 ✅ / ❌ 표로 출력한다.

---

### 개발 단계별 산출물 체크

**설계 산출물 (4~5월 완료 대상)**
- [ ] `docs/설계/시스템설계서.md` — 전체 아키텍처 (Spring Boot + FastAPI + AWS) 포함 여부
- [ ] `docs/설계/DB설계.md` — ERD, 테이블 정의, 관계 명세
- [ ] `docs/설계/API명세.md` — Spring Boot ↔ FastAPI 인터페이스, 클라이언트 API 명세
- [ ] `README.md` — 프로젝트 실행 방법, 환경변수 설명

**개발 산출물 (5~8월 목표)**

기능별 구현 현황:
- [ ] 위험요소 분석 파이프라인 (FastAPI + LangGraph + Bedrock)
- [ ] RAG 검색 구축 (OpenSearch + Knowledge Bases + Cohere Rerank)
- [ ] 보고서 자동 생성 (MCP + 보고서 저장 API)
- [ ] 원청/하청 대시보드 (조치 현황 실시간 공유)
- [ ] SMS 알림 기능 (Amazon SNS + 기한 초과 감지)
- [ ] Wizard Steps UI (단계형 점검 입력 화면)

**테스트 산출물 (8~9월 목표)**
- [ ] Spring Boot 단위 테스트 커버리지 (주요 Service 클래스)
- [ ] FastAPI 파이프라인 테스트 (pytest, AWS 서비스 모킹)
- [ ] 통합 테스트 결과 (Spring Boot ↔ FastAPI 연동)

**공모전 제출 체크리스트**
- [ ] 시연 가능한 배포 환경 (로컬 또는 AWS)
- [ ] 한국 정보처리학회 논문 초안
- [ ] 엑스포 시연 시나리오 문서

---

### 현재 단계 판별 기준
확인 결과를 바탕으로 현재 어느 단계에 있는지 판단하고 다음 우선순위 작업을 제안한다.
