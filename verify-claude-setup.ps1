# ================================================================
#  Claude Code 팀 세팅 검증 스크립트 (Windows / PowerShell)
#  Java Spring Boot 백엔드 / official 플러그인 + 직접 작성 스킬
# ================================================================
#  팀장이 레포 루트에서 한 번 실행한다.
#  실행:
#    powershell -ExecutionPolicy Bypass -File .\verify-claude-setup.ps1
# ================================================================

$ErrorActionPreference = "Stop"
$ok = $true

function Check($path, $label) {
    if (Test-Path $path) {
        Write-Host "  [OK] $label" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $label  ->  $path" -ForegroundColor Red
        $script:ok = $false
    }
}

Write-Host ""
Write-Host "[*] .claude 구조 점검" -ForegroundColor Cyan
Check ".claude/settings.json" "official 플러그인 자동설치 설정"
Check ".claude/skills/spring-code-reviewer/SKILL.md" "코드 리뷰 스킬"
Check ".claude/skills/spring-commit-style/SKILL.md" "커밋 메시지 스킬"
Check ".claude/skills/spring-test-writer/SKILL.md" "테스트 작성 스킬"
Check "docs/CLAUDE_SETUP.md" "팀원 안내 문서"

Write-Host ""
Write-Host "[*] description 필드 점검 (자동 호출의 핵심)" -ForegroundColor Cyan
$skillFiles = Get-ChildItem ".claude/skills" -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue
foreach ($f in $skillFiles) {
    $txt = Get-Content $f.FullName -Raw
    if ($txt -match "PLACEHOLDER") {
        Write-Host "  [WARN] PLACEHOLDER 남아있음: $($f.FullName)" -ForegroundColor Yellow
        $ok = $false
    } elseif ($txt -match "(?m)^description:\s*\S") {
        Write-Host "  [OK] $($f.Directory.Name)" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] description 비어있음: $($f.FullName)" -ForegroundColor Yellow
        $ok = $false
    }
}

Write-Host ""
Write-Host "[*] .gitignore 점검" -ForegroundColor Cyan
if (Test-Path ".gitignore") {
    if ((Get-Content ".gitignore" -Raw) -match "(?m)^\s*\.claude") {
        Write-Host "  [WARN] .gitignore 가 .claude 를 제외하고 있습니다. 해당 줄을 지우세요." -ForegroundColor Yellow
        $ok = $false
    } else {
        Write-Host "  [OK] .claude 커밋 가능" -ForegroundColor Green
    }
} else {
    Write-Host "  [OK] .gitignore 없음" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================================"
if ($ok) {
    Write-Host " 점검 통과. 아래로 커밋/푸시하세요:" -ForegroundColor Green
    Write-Host ""
    Write-Host "   git add .claude docs .gitattributes verify-claude-setup.ps1"
    Write-Host '   git commit -m "chore: add team Claude Code setup"'
    Write-Host "   git push"
    Write-Host ""
    Write-Host " 이후 팀원은 docs\CLAUDE_SETUP.md 순서만 따르면 됩니다."
} else {
    Write-Host " 위에 표시된 항목을 먼저 해결한 뒤 다시 실행하세요." -ForegroundColor Yellow
}
Write-Host "================================================================"
Write-Host ""
