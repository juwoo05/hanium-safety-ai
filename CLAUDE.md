# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

**프로젝트명**: 건설현장 현장관리자 AI 플랫폼 (안전고리)  
**공모전**: 2026 한이음 드림업 AI 프로젝트  
**목표**: ICT 한이음 드림업 공모전 출품 + 한국 정보처리학회 추계학술대회 논문 게재  
**기간**: 2026.02 ~ 2026.10

## Commands

```powershell
# Spring Boot 빌드
./gradlew build

# 빌드 (테스트 제외)
./gradlew build -x test

# Spring Boot 앱 실행
./gradlew bootRun

# 전체 테스트
./gradlew test

# 단일 테스트 클래스 실행
./gradlew test --tests "kopo.poly.서비스명Test"

# 단일 테스트 메서드 실행
./gradlew test --tests "kopo.poly.서비스명Test.메서드명"

# FastAPI 서버 실행 (AI 파이프라인)
uvicorn main:app --reload --port 8000

# FastAPI 의존성 설치
pip install fastapi uvicorn langgraph boto3 langchain-aws

# Python 테스트
pytest -v
```

## Architecture

**Spring Boot 4.1.0 / Java 17 / Gradle + FastAPI / Python**

두 서버가 협력하는 구조. Spring Boot는 비즈니스 로직·인증·DB를 담당하고, FastAPI는 AI 분석 파이프라인을 담당한다.

```
[클라이언트 - Thymeleaf + Wizard Steps UI]
    ↓
[Spring Boot 서버]                    [FastAPI 서버]
 Controller (Spring MVC)               /analyze  ← 위험요소 분석
     ↓                                 /report   ← 보고서 생성
 Service (비즈니스 로직)    ←REST→    LangGraph 파이프라인
     ↓                                   ↓
 Repository (Spring Data JPA)        Amazon Bedrock (Claude 멀티모달)
     ↓                                   ↓
 Entity (JPA, MariaDB)              OpenSearch + Knowledge Bases (RAG)
                                         ↓
                                    Cohere Rerank 3.5
```

**AWS 서비스 구성**
- `Amazon Bedrock` — Claude 멀티모달로 현장 사진 위험요소 분석
- `Bedrock Titan Embeddings` — 텍스트·이미지 요약 벡터화
- `Knowledge Bases (RAG)` — 산업안전보건법·사고사례·점검기준 문서 검색
- `Amazon OpenSearch Service` — 대용량 안전관리 문서 고속 탐색
- `Cohere Rerank 3.5` — 검색 문서 관련도 재순위화
- `Amazon S3` — 현장 점검 사진·보고서 PDF 저장
- `Amazon SNS` — 조치 기한 초과 시 담당자 SMS 발송
- `Amazon Translate` — 다국어 지원
- `MCP` — 위험분석 결과를 컨텍스트로 구성해 보고서 자동 생성

루트 패키지: `kopo.poly`  
DB: MariaDB (드라이버: `mariadb-java-client`)  
Lombok 사용 — 엔티티/DTO에 `@Getter`, `@Builder` 등 적극 활용.

## 도메인 용어

| 용어 | 설명 |
|---|---|
| 현장관리자 | 건설현장 안전 점검 담당자 (주요 사용자) |
| 원청 | 발주처·주도 업체. 위험요소 등록 및 전체 현황 관리 |
| 하청 | 하도급 업체. 원청이 등록한 위험요소 조치 담당 |
| 위험요소 | 현장 사진 분석으로 감지된 안전 위험 항목 |
| 조치 상태 | `요청중 → 진행중 → 완료` 3단계로 관리 |
| TBM 보고서 | Tool Box Meeting 보고서 (작업 전 안전 교육 기록) |
| 안전관리 보고서 | 점검 결과·위험요소·조치 내역이 포함된 자동 생성 보고서 |
| 신고 게시판 | 조치 미이행 항목이 기한 초과 시 자동 등록되는 게시판 |
| Wizard Steps | 현장선택→사진등록→분석확인→조치입력→보고서 순 단계형 UI |

## 개발 일정 (현재: 6월 - 개발 진행 중)

| 단계 | 내용 | 기간 |
|---|---|---|
| 계획/분석 | 아이디어 결정, 요구사항 분석 | 2~3월 |
| 설계 | 시스템 설계, DB 설계, 개발환경 세팅 | 4~5월 |
| **개발** | **위험요소분석 파이프라인, RAG, 보고서자동생성, 대시보드, SMS알림** | **5~8월** |
| 테스트 | 통합 테스트, QA | 8~9월 |
| 종료 | 결과보고서, 유지보수 | 9~10월 |

## Conventions

**커밋 메시지** — Conventional Commits, 한국어 제목.  
예: `feat(auth): 로그인 토큰 만료 처리 추가`  
→ "커밋 메시지 써줘"라고 하면 `spring-commit-style` 스킬이 자동 작성.

**테스트**
- Spring: JUnit 5 + Mockito, given-when-then 구조, 메서드명 한국어.  
  예: `재고가_부족하면_주문생성에_실패한다()`  
  단위 테스트는 스프링 컨텍스트 없이, 슬라이스 테스트는 `@WebMvcTest`/`@DataJpaTest`.
- Python: pytest, given-when-then 구조, AWS 서비스는 `moto` 또는 `unittest.mock`으로 모킹.

**코드 리뷰** — "리뷰해줘"로 `spring-code-reviewer` 스킬 호출. Critical → Warning → Suggestion 순 심각도별 출력.  
Python/AI 파이프라인 리뷰는 `fastapi-ai-reviewer` 스킬 사용.

## DB 설정

`src/main/resources/application.properties`에 DB 접속 정보를 추가해야 앱이 기동된다.

```properties
spring.datasource.url=jdbc:mariadb://localhost:3306/hanium
spring.datasource.username=...
spring.datasource.password=...
spring.jpa.hibernate.ddl-auto=update
```

FastAPI 서버는 `.env` 파일로 환경변수를 관리한다.

```env
AWS_REGION=ap-northeast-2
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
BEDROCK_MODEL_ID=anthropic.claude-3-5-sonnet-20241022-v2:0
OPENSEARCH_ENDPOINT=...
S3_BUCKET_NAME=...
SNS_TOPIC_ARN=...
SPRING_BOOT_BASE_URL=http://localhost:8080
```
