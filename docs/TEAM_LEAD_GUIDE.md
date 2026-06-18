# 팀장용 가이드 — 깃허브 세팅부터 "레포만 받으면 자동" 까지 (Windows / Java Spring Boot)

목표: 팀원이 `git clone` → 폴더 신뢰 → 설치 수락, 이 세 동작만으로
official 플러그인과 우리 팀 스킬을 자동으로 쓰게 만든다.

구성은 두 층이다.
- **A층 — official 플러그인** (`.claude/settings.json`): Anthropic 공식. 출처 명확, 보안 검수됨.
- **B층 — 프로젝트 스킬** (`.claude/skills/*/SKILL.md`): 우리 팀이 직접 작성. 외부 코드 없음.

---

## STEP 1 — 백엔드 깃허브 레포 준비

이미 레포가 있으면 STEP 2로.

```powershell
# 새로 시작하는 경우
mkdir my-backend
cd my-backend
git init -b main

# Spring Boot 프로젝트가 이미 있다면 그 폴더에서 git init
```

`.gitignore`에 빌드 산출물이 들어가 있는지 확인한다 (Gradle 기준 예):
```
build/
.gradle/
*.class
.idea/
```
**주의: `.claude/` 를 `.gitignore`에 넣지 말 것.** 이게 빠지면 자동 세팅이 깨진다.

원격 연결:
```powershell
git remote add origin https://github.com/<org>/<repo>.git
```

---

## STEP 2 — 이 세팅 파일들을 레포에 넣기

이 패키지(zip)를 풀면 아래 구조가 나온다. 레포 루트에 그대로 복사한다.

```
<레포 루트>/
├── .claude/
│   ├── settings.json                         (A층: official 플러그인 자동설치)
│   └── skills/
│       ├── spring-code-reviewer/SKILL.md     (B층)
│       ├── spring-commit-style/SKILL.md      (B층)
│       └── spring-test-writer/SKILL.md       (B층)
├── .gitattributes                            (줄바꿈 보호)
├── verify-claude-setup.ps1                   (검증 스크립트)
└── docs/
    └── CLAUDE_SETUP.md                        (팀원 안내)
```

---

## STEP 3 — A층 확인: official 플러그인 목록

`.claude/settings.json`에 아래가 들어 있다. 전부 Anthropic 공식 마켓플레이스 플러그인이다.

| 플러그인 | 역할 |
| --- | --- |
| `commit-commands` | 커밋·푸시·PR 생성 워크플로우 |
| `pr-review-toolkit` | PR 리뷰 전문 에이전트 |
| `security-guidance` | Claude가 만든 변경을 보안 관점으로 점검·수정 |
| `github` | GitHub 연동 (MCP) |
| `jdtls-lsp` | Java 코드 인텔리전스 (타입체크·정의이동) |

`jdtls-lsp`는 팀원 PC에 `jdtls` 바이너리가 있어야 동작한다(없으면 이 기능만 비활성).
나머지는 바이너리 불필요.

> 플러그인을 빼거나 더하려면 `enabledPlugins`에서 한 줄씩 조정하면 된다.

---

## STEP 4 — B층 확인: 우리 팀 스킬

`.claude/skills/` 아래 3개 스킬은 우리가 직접 작성한 것이라 외부 의존성이 없다.
각 `SKILL.md` 상단의 `description` 필드가 자동 호출의 트리거다 — 비우지 말 것.

- `spring-code-reviewer` — "리뷰해줘"에 반응, Spring Boot 코드 심각도별 리뷰
- `spring-commit-style` — "커밋 메시지"에 반응, Conventional Commits
- `spring-test-writer` — "테스트 짜줘"에 반응, JUnit5 + Spring Boot Test

프로젝트 컨벤션(패키지 규칙, 락 전략 등)을 바꾸려면 해당 SKILL.md 본문만 수정하면 된다.
수정 후 커밋하면 팀원은 `git pull`로 함께 갱신된다.

---

## STEP 5 — 검증

레포 루트에서:
```powershell
powershell -ExecutionPolicy Bypass -File .\verify-claude-setup.ps1
```
모든 항목이 [OK]면 통과. PLACEHOLDER나 빈 description이 잡히면 그 파일을 고친다.

---

## STEP 6 — 커밋 & 푸시

```powershell
git add .claude docs .gitattributes verify-claude-setup.ps1
git commit -m "chore: add team Claude Code setup (official plugins + spring skills)"
git push -u origin main
```

이걸로 팀장 작업 끝. 팀원에게 `docs/CLAUDE_SETUP.md`를 보라고 공유한다.

---

## STEP 7 — (선택) 브랜치 보호로 워크플로우 강제

GitHub 레포 Settings → Branches → main 브랜치 보호 규칙:
- PR 없이 main 직접 push 금지
- merge 전 1명 이상 리뷰 승인 필수

이러면 `pr-review-toolkit`로 리뷰하고 PR로만 머지되는 흐름이 강제된다.

---

## 팀장 체크리스트 (순서대로)

1. [ ] 백엔드 깃허브 레포 준비 (`.claude/`를 .gitignore에 넣지 않기)
2. [ ] 이 패키지를 레포 루트에 복사
3. [ ] `.claude/settings.json`의 official 플러그인 목록 확인 (필요시 가감)
4. [ ] `.claude/skills/` 3종의 description·본문이 프로젝트에 맞는지 확인
5. [ ] `verify-claude-setup.ps1` 실행 → 전부 [OK]
6. [ ] `git add .claude docs .gitattributes verify-claude-setup.ps1` → commit → push
7. [ ] (선택) main 브랜치 보호 규칙 설정
8. [ ] 팀원에게 `docs/CLAUDE_SETUP.md` 공유

---

## 보안 메모

- A층은 전부 Anthropic 공식 마켓플레이스(`claude-plugins-official`) 플러그인이다.
- B층은 외부에서 받은 코드가 아니라 이 가이드와 함께 제공된, 사람이 읽을 수 있는 Markdown 지침이다.
  실행 코드가 아니므로 임의 코드 실행 위험이 없다. 커밋 전 한 번 읽어보면 충분하다.
- 플러그인/마켓플레이스는 사용자 권한으로 코드를 실행할 수 있는 신뢰 구성요소다.
  공식 마켓플레이스 외 서드파티를 추가하지 않는 한, 이 세팅은 official 범위 안에 있다.
