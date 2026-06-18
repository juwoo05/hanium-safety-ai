# Claude Code 팀 세팅 — 팀원용 안내 (Windows)

이 레포는 Claude Code 환경이 미리 구성돼 있습니다.
**아래 순서만 따르면 팀 전원이 동일한 환경에서 바로 개발을 시작합니다.**

구성은 두 층입니다.
- **official 플러그인** (Anthropic 공식): 커밋/PR 리뷰/보안 리뷰/GitHub 연동/Java 코드 인텔리전스
- **프로젝트 스킬** (우리 팀이 직접 작성): Spring Boot 코드 리뷰 · 커밋 메시지 · 테스트 작성

---

## 0. 사전 준비 (최초 1회)

1. **Claude Code 설치** — 이미 있으면 건너뜁니다.
   설치 후 버전 확인:
   ```powershell
   claude --version
   ```
   너무 낮으면 업데이트:
   ```powershell
   npm install -g @anthropic-ai/claude-code@latest
   ```

2. **Java 언어 서버** — `jdtls`가 PATH에 있어야 Java 코드 인텔리전스(자동 타입체크)가 동작합니다.
   없으면 코드 인텔리전스만 비활성일 뿐 나머지는 정상 동작합니다. (선택)

3. **GitHub 인증** — `github` 플러그인 연동을 쓰려면 최초 1회 인증 안내를 따릅니다.

---

## 1. 레포 받기

```powershell
git clone <레포-URL>
cd <레포-폴더>
```

이미 받아둔 사람은 최신화만:
```powershell
git pull
```

이 시점에 `.claude/` 안의 설정과 스킬이 이미 로컬에 들어와 있습니다.

---

## 2. Claude Code 실행 + 폴더 신뢰

레포 **루트**에서:
```powershell
claude
```

처음 실행하면 이 폴더를 신뢰할지 묻습니다. **신뢰(trust)를 선택**하세요.
신뢰하면 레포의 `settings.json`에 등록된 official 플러그인을 설치할지 안내가 뜹니다.
**설치를 수락**하세요. (commit-commands, pr-review-toolkit, security-guidance, github, jdtls-lsp)

설치 후 적용:
```text
/reload-plugins
```

---

## 3. 설치 확인

```text
/plugin list
```
official 플러그인 5종이 보이면 정상입니다.

```text
/skills
```
프로젝트 스킬 3종(spring-code-reviewer, spring-commit-style, spring-test-writer)이 보이면 정상입니다.

---

## 4. 끝. 그냥 쓰면 됩니다

**프로젝트 스킬은 자동 호출**입니다. 평소처럼 부탁하면 맥락을 보고 알아서 동작합니다.

```text
"내 변경사항 리뷰해줘"            → spring-code-reviewer
"이거 커밋 메시지 써줘"           → spring-commit-style
"OrderService 테스트 짜줘"        → spring-test-writer
```

**official 플러그인은 슬래시 명령**으로 부릅니다(이름공간이 플러그인명).
```text
/commit-commands:commit          → 스테이징 변경 커밋
/pr-review-toolkit:...           → PR 리뷰 (플러그인 detail에서 명령 확인)
```
security-guidance는 Claude가 코드를 수정할 때 백그라운드로 보안 점검을 겁니다.

---

## 문제 해결

**플러그인 자동 설치 안내가 안 떴어요**
- 폴더를 신뢰했는지 확인. 신뢰 안 하면 자동 설치 안내가 뜨지 않습니다.
- 수동으로 마켓플레이스 갱신 후 재시도:
  ```text
  /plugin marketplace update claude-plugins-official
  ```

**스킬이 `/skills`에 안 보여요**
- 레포 루트에서 `claude`를 실행했는지 확인.
- `.claude/skills/<이름>/SKILL.md` 경로가 한 단계 더 중첩되지 않았는지 확인.
- 새 세션을 시작.

**스킬이 자동으로 안 불려요**
- 한 번은 직접 지목: "spring-code-reviewer 스킬로 리뷰해줘".
- 그래도 안 되면 팀장에게 `description` 필드 확인 요청.

**Java 진단(타입체크)이 안 떠요**
- `jdtls`가 PATH에 있는지 확인. 없으면 이 기능만 비활성이고 나머지는 정상.
