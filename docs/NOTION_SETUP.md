# Notion MCP 환경 설정 가이드

Notion MCP를 통해 Claude Code가 팀 워크스페이스에 자동으로 개발 현황을 기록할 수 있습니다.
아래 순서대로 설정하면 됩니다.

---

## 사전 준비

> **액세스 키(토큰)는 팀장에게 USB로 받아야 합니다.**
> 개인이 직접 발급하지 않으며, 팀 공용 토큰을 사용합니다.

---

## 설정 순서

### 1단계 — 액세스 키 수령

팀장에게 USB를 받아 `notion_token.txt` 파일 안의 `ntn_...` 으로 시작하는 토큰 값을 확인합니다.

> 토큰을 메모장 등에 임시로 복사해두세요. 환경변수 등록 후 파일은 바로 삭제합니다.

---

### 2단계 — 환경변수 등록

#### Windows (PowerShell)

```powershell
# 1) 변수에 토큰 입력
$token = "ntn_여기에토큰붙여넣기"

# 2) 영구 등록 (재부팅 후에도 유지됨)
[System.Environment]::SetEnvironmentVariable("NOTION_TOKEN", $token, "User")
```

등록 후 확인:

```powershell
[System.Environment]::GetEnvironmentVariable("NOTION_TOKEN", "User")
# ntn_... 값이 출력되면 성공
```

#### Mac / Linux

```bash
# 1) 변수에 토큰 입력
token="ntn_여기에토큰붙여넣기"

# 2) 영구 등록 — ~/.zshrc 또는 ~/.bashrc 맨 아래에 추가
echo "export NOTION_TOKEN=\"$token\"" >> ~/.zshrc   # zsh 사용 시
echo "export NOTION_TOKEN=\"$token\"" >> ~/.bashrc  # bash 사용 시

# 3) 적용
source ~/.zshrc   # zsh 사용 시
source ~/.bashrc  # bash 사용 시
```

등록 후 확인:

```bash
echo $NOTION_TOKEN
# ntn_... 값이 출력되면 성공
```

---

### 3단계 — Claude Code 재시작

환경변수는 Claude Code 실행 시점에 읽힙니다.
등록 후 반드시 Claude Code를 완전히 종료하고 다시 실행하세요.

---

### 4단계 — 연결 확인

Claude Code 터미널에서 아래 문장을 입력해 테스트합니다.

```
Notion MCP 연결 테스트해봐
```

다음과 같이 봇 정보가 출력되면 정상입니다.

```
봇 이름: 한이음 2026
워크스페이스: 지주우님의 워크스페이스
```

---

## 주의사항

| 항목 | 내용 |
|---|---|
| 토큰 유출 금지 | 토큰을 코드에 직접 입력하거나 git에 커밋하지 마세요 |
| `.env` 파일 사용 금지 | 환경변수는 OS 설정으로만 등록합니다 |
| USB 파일 삭제 | 토큰 확인 후 USB 내 `notion_token.txt`는 즉시 삭제 요청 |
| 토큰 분실 시 | 팀장에게 문의 — 개인이 재발급 불가 |

---

## 문의

설정 중 문제가 생기면 팀장(지주우)에게 문의하세요.
