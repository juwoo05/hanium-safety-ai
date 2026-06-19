---
name: spring-code-reviewer
description: Use when the user asks to review code, review changes, review a diff, or review a pull request in this Java Spring Boot backend. Triggers on "리뷰", "코드 리뷰", "review my changes", "check this code", or when staged/unstaged changes need a quality pass before commit or PR. Reviews Java Spring Boot code for correctness, security, performance, and team conventions, grouping findings by severity.
---

# Spring Boot 코드 리뷰

이 스킬은 이 레포의 Java Spring Boot 코드를 일관된 기준으로 리뷰한다.

## 리뷰 범위 결정
1. 사용자가 특정 파일/PR을 지목하지 않았으면, 먼저 `git diff`(unstaged)와 `git diff --staged`를 확인해 변경된 부분만 리뷰한다.
2. 변경량이 크면(파일 10개 이상) 변경 파일 목록을 먼저 보여주고, 가장 위험한 파일부터 리뷰한다.
3. 리뷰는 변경된 라인 중심으로 한다. 무관한 기존 코드를 임의로 리팩토링 제안하지 않는다.

## 점검 항목 (Spring Boot 특화)

### Critical (반드시 막아야 함)
- SQL/JPQL 인젝션: 문자열 연결로 만든 쿼리, `@Query`의 동적 문자열 결합. 파라미터 바인딩(`:param`, `?1`) 사용을 권고한다.
- 인증/인가 누락: 새 엔드포인트에 `@PreAuthorize`/`SecurityFilterChain` 규칙이 빠졌는지. 공개돼선 안 되는 경로가 열려 있는지.
- 민감정보 노출: 로그·응답 DTO·예외 메시지에 비밀번호·토큰·PII가 새는지. `@ToString`이 민감 필드를 포함하는지.
- 트랜잭션 경계 오류: `@Transactional`이 self-invocation(같은 클래스 내부 호출)으로 무효화되는 패턴. readOnly 트랜잭션에서 쓰기.
- 자원 누수: `try-with-resources` 없이 여는 스트림/커넥션.
- **[AI 특화]** 프롬프트 인젝션: 사용자 입력을 검증·이스케이프 없이 프롬프트에 직접 삽입. 입력값은 반드시 별도 변수로 분리한다.
- **[AI 특화]** API 키 하드코딩: `spring.ai.*` 키나 외부 AI 서비스 키가 소스코드·로그에 노출되는지. `application.properties` 환경변수 참조(`${...}`) 사용을 권고한다.
- **[AI 특화]** AI 응답 무검증 저장: AI 모델 응답을 파싱·검증 없이 DB에 직접 저장하는 패턴. 응답 스키마 검증 후 저장한다.

### Warning (고쳐야 함)
- N+1 쿼리: 연관 엔티티 지연 로딩을 루프에서 접근. `@EntityGraph`나 fetch join 권고.
- 검증 누락: `@RequestBody` DTO에 `@Valid`와 제약(`@NotNull`, `@Size` 등)이 없는지.
- 예외 처리: 광범위한 `catch (Exception e)` 후 무시(swallow). 도메인 예외와 `@ControllerAdvice` 사용 권고.
- 동시성: 공유 가변 상태, 싱글톤 빈의 인스턴스 필드에 요청별 데이터 저장.
- 부적절한 응답 코드/상태 매핑.

### Warning (고쳐야 함) — AI 특화 추가
- **[AI 특화]** AI 호출 결과를 캐싱 없이 매 요청마다 재호출: 동일 입력에 대한 불필요한 API 비용 발생. 결과 캐싱 또는 배치 처리 권고.
- **[AI 특화]** AI 응답 타임아웃/예외 처리 누락: `ChatClient` 호출에 타임아웃 설정과 fallback이 없는 경우.

### Suggestion (개선하면 좋음)
- 생성자 주입 권장(필드 `@Autowired` 지양), `final` 필드.
- 매직 넘버·하드코딩된 설정값 → `@ConfigurationProperties`/`application.yml`.
- 불필요한 `Optional.get()` 직접 호출.
- 네이밍·패키지 구조의 팀 컨벤션 일치: 인터페이스는 `service/`, 구현체는 `service/impl/`에 위치.

## 출력 형식
심각도별로 그룹화한다. 각 항목은 다음을 포함한다:
- 파일 경로와 라인 번호
- 심각도 (Critical / Warning / Suggestion)
- 무엇이 문제인지 한 줄
- 구체적 수정 방향 (가능하면 짧은 코드 예시)

먼저 Critical을 모두 나열하고, 그다음 Warning, Suggestion 순으로. 발견이 없으면 그 심각도는 "없음"으로 표기한다.

## 원칙
- 추측으로 파일·메서드·설정 이름을 만들지 않는다. 언급 전 실제 코드에서 확인한다.
- 불확실한 지적은 불확실하다고 표시한다.
- `force push`, `git reset --hard`, 데이터 삭제 등 파괴적 명령을 수정안으로 제시하지 않는다.
- 리뷰만 한다. 사용자가 명시적으로 요청하기 전에는 코드를 직접 수정하지 않는다.
