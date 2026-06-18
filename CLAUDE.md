# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```powershell
# 빌드
./gradlew build

# 빌드 (테스트 제외)
./gradlew build -x test

# 앱 실행
./gradlew bootRun

# 전체 테스트
./gradlew test

# 단일 테스트 클래스 실행
./gradlew test --tests "kopo.poly.서비스명Test"

# 단일 테스트 메서드 실행
./gradlew test --tests "kopo.poly.서비스명Test.메서드명"
```

## Architecture

**Spring Boot 4.1.0 / Java 17 / Gradle**

서버사이드 렌더링 MVC 구조. REST API가 아니라 Thymeleaf 템플릿으로 HTML을 직접 반환한다.

```
Controller (Spring MVC)
    ↓
Service (비즈니스 로직)
    ↓
Repository (Spring Data JPA)
    ↓
Entity (JPA, MariaDB)
```

루트 패키지: `kopo.poly`  
DB: MariaDB (드라이버: `mariadb-java-client`)  
Lombok 사용 — 엔티티/DTO에 `@Getter`, `@Builder` 등 적극 활용.

## Conventions

**커밋 메시지** — Conventional Commits, 한국어 제목.  
예: `feat(auth): 로그인 토큰 만료 처리 추가`  
→ "커밋 메시지 써줘"라고 하면 `spring-commit-style` 스킬이 자동 작성.

**테스트** — JUnit 5 + Mockito, given-when-then 구조, 메서드명 한국어.  
예: `재고가_부족하면_주문생성에_실패한다()`  
단위 테스트는 스프링 컨텍스트 없이, 슬라이스 테스트는 `@WebMvcTest`/`@DataJpaTest`.

**코드 리뷰** — "리뷰해줘"로 `spring-code-reviewer` 스킬 호출. Critical → Warning → Suggestion 순 심각도별 출력.

## DB 설정

`src/main/resources/application.properties`에 DB 접속 정보를 추가해야 앱이 기동된다. (현재 `spring.application.name`만 있음)

```properties
spring.datasource.url=jdbc:mariadb://localhost:3306/hanium
spring.datasource.username=...
spring.datasource.password=...
spring.jpa.hibernate.ddl-auto=update
```
