---
name: spring-test-writer
description: Use when the user asks to write tests, add unit tests, add integration tests, or improve test coverage for Java Spring Boot code. Triggers on "테스트 짜줘", "테스트 추가", "write tests for", "unit test", "integration test". Writes JUnit 5 + Spring Boot Test code following this team's conventions (given-when-then, Mockito, slice tests).
---

# Spring Boot 테스트 작성

이 스킬은 JUnit 5와 Spring Boot Test로 팀 컨벤션에 맞는 테스트를 작성한다.

## 먼저 확인
1. 대상 클래스/메서드의 실제 코드를 읽는다. 시그니처·의존성·예외 경로를 추측하지 않는다.
2. 기존 테스트가 있으면 그 스타일(네이밍, 픽스처, 헬퍼)을 따른다. 새 스타일을 임의로 도입하지 않는다.
3. 빌드 도구(Gradle/Maven)와 이미 있는 테스트 의존성을 확인한다. 없는 라이브러리를 전제로 작성하지 않는다.

## 테스트 종류 선택
- **단위 테스트**: 서비스/도메인 로직. 스프링 컨텍스트 없이 순수 JUnit + Mockito.
- **슬라이스 테스트**: 웹 계층은 `@WebMvcTest` + `MockMvc`, JPA 계층은 `@DataJpaTest`.
- **통합 테스트**: 여러 계층이 엮인 경우만 `@SpringBootTest`. 느리므로 남용하지 않는다.

기본은 가장 좁은 범위를 택한다. 통합 테스트는 꼭 필요할 때만.

## 작성 규칙
- 구조는 given-when-then 주석으로 구분한다.
- 테스트 메서드 이름은 한국어로 동작과 기대를 드러낸다. 예: `재고가_부족하면_주문생성에_실패한다`.
- `@DisplayName`으로 사람이 읽을 설명을 단다.
- 단언은 AssertJ(`assertThat`)를 우선 사용한다(프로젝트에 이미 있으면).
- Mock은 Mockito(`@Mock`, `@InjectMocks`, `given(...).willReturn(...)`).
- 경계/예외 경로를 반드시 포함한다: null, 빈 컬렉션, 권한 없음, 동시성 충돌 등 해당되는 것.
- 하나의 테스트는 하나의 행위만 검증한다.

## 프로젝트 패키지 구조
- 인터페이스: `kopo.poly.service.IXxxService`
- 구현체: `kopo.poly.service.impl.XxxService`
- 테스트 대상이 구현체(`impl`)일 때 `@InjectMocks`에 구현체 클래스를 사용한다.

## 예시 골격 (단위 테스트 — UserService)

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock UserRepository userRepository;
    @InjectMocks UserService userService; // kopo.poly.service.impl

    @Test
    @DisplayName("이미 존재하는 이메일로 가입하면 예외가 발생한다")
    void 이미_존재하는_이메일로_가입하면_예외가_발생한다() {
        // given
        given(userRepository.existsByEmail("test@example.com")).willReturn(true);

        // when / then
        assertThatThrownBy(() -> userService.register(new UserDTO("test@example.com", "pw")))
            .isInstanceOf(DuplicateEmailException.class);
        then(userRepository).should(never()).save(any());
    }
}
```

## 예시 골격 (Spring AI 관련 단위 테스트)

```java
@ExtendWith(MockitoExtension.class)
class SafetyAnalysisServiceTest {

    @Mock ChatClient chatClient;
    @InjectMocks SafetyAnalysisService safetyAnalysisService;

    @Test
    @DisplayName("AI가 위험 판정을 반환하면 DANGER 상태로 저장된다")
    void AI가_위험_판정을_반환하면_DANGER_상태로_저장된다() {
        // given
        given(chatClient.prompt(any()).call().content()).willReturn("DANGER");

        // when
        SafetyResult result = safetyAnalysisService.analyze("위험한 상황 설명");

        // then
        assertThat(result.getStatus()).isEqualTo(SafetyStatus.DANGER);
    }
}
```

## 원칙
- 실제로 통과할 테스트만 작성한다. 추측으로 "아마 통과할 것"이라고 하지 않는다. 실행 가능한 환경이면 직접 돌려 확인한다.
- 테스트를 통과시키려고 프로덕션 코드의 의미를 바꾸지 않는다. 코드에 버그가 보이면 별도로 알린다.
- 사용자가 요청하지 않은 리팩토링은 하지 않는다.
