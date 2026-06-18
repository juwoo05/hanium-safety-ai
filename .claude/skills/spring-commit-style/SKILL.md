---
name: spring-commit-style
description: Use when the user asks to write a commit message, draft a commit, or summarize staged changes for committing in this repository. Triggers on "커밋 메시지", "commit 메시지 써줘", "이거 커밋", "write a commit message". Generates a Conventional Commits message in Korean by analyzing staged changes. Does not run git commit unless explicitly asked.
---

# 커밋 메시지 작성 (Conventional Commits)

이 스킬은 스테이징된 변경을 분석해 팀 컨벤션에 맞는 커밋 메시지를 작성한다.

## 절차
1. `git diff --staged`로 스테이징된 변경을 확인한다. 비어 있으면 사용자에게 `git add`가 필요한지 알린다.
2. 변경의 핵심 의도를 파악한다(무엇을 왜 바꿨는지). 파일 나열이 아니라 의도를 요약한다.
3. 아래 형식으로 메시지를 작성해 사용자에게 보여준다.
4. **`git commit`은 사용자가 명시적으로 "커밋해줘"라고 할 때만 실행한다.** 기본은 메시지 제안까지만.

## 형식

```
<type>(<scope>): <제목 50자 이내, 명령형, 마침표 없음>

<본문: 무엇을 왜 바꿨는지. 한 줄 72자 이내로 줄바꿈. 선택>

<푸터: 이슈 참조 등. 예) Refs: #123. 선택>
```

### type 목록
- `feat`: 새 기능
- `fix`: 버그 수정
- `refactor`: 동작 변화 없는 구조 개선
- `perf`: 성능 개선
- `test`: 테스트 추가/수정
- `docs`: 문서
- `build`: Gradle/Maven, 의존성, 빌드 설정
- `ci`: CI 설정
- `chore`: 기타 잡무

### scope (Spring Boot 기준 예시)
- 도메인/모듈 이름을 쓴다: `auth`, `order`, `payment`, `user`
- 계층이 핵심이면: `controller`, `service`, `repository`, `config`
- 애매하면 scope 생략 가능.

## 예시

```
feat(order): 주문 취소 시 재고 자동 복원 추가

주문이 CANCELLED 상태로 전이될 때 OrderItem 수량만큼
재고를 되돌리도록 도메인 이벤트 핸들러를 추가했다.
동시 취소 시 재고 중복 복원을 막기 위해 비관적 락을 적용했다.

Refs: #482
```

```
fix(auth): 만료된 리프레시 토큰 재사용 차단
```

## 원칙
- 제목은 한국어 명령형("추가한다"가 아니라 "추가"처럼 간결하게). 끝에 마침표 없음.
- 한 커밋이 여러 무관한 변경을 담고 있으면, 그 사실을 알리고 분리 커밋을 제안한다.
- 변경 내용에 없는 것을 메시지에 지어내지 않는다.
- 사용자가 요청하지 않는 한 메시지에 AI 생성 표식이나 푸터를 넣지 않는다.
