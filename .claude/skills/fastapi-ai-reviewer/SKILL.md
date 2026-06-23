---
name: fastapi-ai-reviewer
description: FastAPI AI 파이프라인 코드 리뷰 — LangGraph 노드 순서, Bedrock/OpenSearch/Cohere 호출 오류 처리, S3 업로드 규칙, Spring Boot 인터페이스 일관성을 검증한다
metadata:
  type: skill
---

# FastAPI AI 파이프라인 코드 리뷰

## Trigger
`.py` 파일, "fastapi", "langgraph", "bedrock", "pipeline", "파이프라인", "AI 서버" 관련 코드가 대상일 때 이 스킬을 사용한다.

## Instructions

안전고리 프로젝트의 FastAPI 기반 AI 분석 파이프라인을 리뷰한다.
Critical → Warning → Suggestion 순으로 출력하고, 각 항목에 파일명:라인번호를 포함한다.

---

### LangGraph 파이프라인 순서 검증

올바른 노드 실행 순서:
```
이미지 분석 (Bedrock 멀티모달)
    ↓
텍스트 벡터화 (Titan Embeddings)
    ↓
문서 검색 (OpenSearch + Knowledge Bases RAG)
    ↓
재순위화 (Cohere Rerank 3.5)
    ↓
응답 생성 (Bedrock Claude)
    ↓
보고서 작성 (MCP 컨텍스트 구성)
```
- 노드 순서가 위와 다르면 Critical.
- 노드 간 상태(state)가 TypedDict로 정의되어 있어야 한다.
- 각 노드는 단일 책임 원칙 — 이미지 분석 노드에서 DB 저장을 하면 Warning.

### Amazon Bedrock 호출
- 모델 ID는 환경변수(`BEDROCK_MODEL_ID`)에서 읽어야 한다. 하드코딩이면 Critical.
- `invoke_model` / `converse` 호출에 타임아웃과 재시도 로직이 있어야 한다.
- 멀티모달 입력 시 이미지는 base64 인코딩 후 전달한다.
- 응답 파싱 시 `KeyError` 방어 코드가 없으면 Warning.

### OpenSearch / Knowledge Bases
- 검색 쿼리는 사용자 입력을 그대로 쓰지 않고 전처리(번역·정규화) 후 사용해야 한다.
- `Amazon Translate`로 번역 후 검색하는 흐름이 있어야 다국어 지원 가능.
- 검색 결과가 0건일 때 빈 리스트로 처리하고 파이프라인이 중단되지 않아야 한다.

### Cohere Rerank 3.5
- 재순위화 입력 문서 수는 상한(예: 20개)이 있어야 한다.
- 재순위화 결과에서 상위 N개만 선택하는 `top_n` 파라미터가 명시되어야 한다.

### Amazon S3 업로드
- 업로드 경로 규칙: `현장ID/날짜/파일명` 구조를 지켜야 한다.
- 업로드 성공 후 presigned URL 또는 S3 키를 Spring Boot에 반환해야 한다.
- 파일 확장자·MIME 타입 검증 없이 업로드하면 Warning.

### FastAPI 엔드포인트
- 요청/응답 스키마는 `pydantic BaseModel`로 정의되어야 한다.
- Spring Boot와 주고받는 필드명·타입이 CLAUDE.md 인터페이스 정의와 일치해야 한다.
- `/analyze` 엔드포인트는 `AnalyzeRequest` → `AnalyzeResponse` 구조를 따른다.
- `/report` 엔드포인트는 MCP 컨텍스트 포함 여부를 확인한다.
- 인증 없이 엔드포인트가 열려 있으면 Critical (최소 API 키 또는 내부망 제한 필요).

### 오류 처리
- AWS 서비스 호출 실패는 `botocore.exceptions`를 캐치하고 의미 있는 오류 메시지를 반환해야 한다.
- 파이프라인 중간 실패 시 부분 결과가 아닌 명확한 오류 응답을 Spring Boot에 전달해야 한다.
- `except Exception`으로 모든 예외를 무시하면 Critical.
