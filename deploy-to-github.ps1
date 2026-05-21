# VI One — Legal Docs GitHub Pages 1-shot Deploy
# 실행: PowerShell에서 다음 한 줄
#   cd C:\Users\hello\Downloads\vione_release\legal ; .\deploy-to-github.ps1
#
# 사전 조건:
#   - Git 설치됨 (winget install Git.Git 또는 https://git-scm.com/)
#   - GitHub CLI 설치 + 로그인 (winget install GitHub.cli ; gh auth login)
#   - 리포 이름 vione-legal 가 이미 존재하지 않을 것

$ErrorActionPreference = "Stop"

$USER  = "Rigidpointadvisory"
$REPO  = "vione-legal"
$DIR   = $PSScriptRoot   # 이 스크립트가 있는 폴더 = legal/

Write-Host ""
Write-Host "🚀 VI One Legal Docs → GitHub Pages 배포" -ForegroundColor Cyan
Write-Host "   User: $USER"
Write-Host "   Repo: $REPO"
Write-Host "   Dir : $DIR"
Write-Host ""

Set-Location $DIR

# 1) git init (없을 때만)
if (-not (Test-Path ".git")) {
    git init -b main
    Write-Host "✓ git init" -ForegroundColor Green
}

# 2) .nojekyll 추가 (HTML 직접 서빙)
"" | Out-File -FilePath ".nojekyll" -Encoding ASCII -NoNewline

# 3) index.html 자동 생성 (랜딩)
@'
<!DOCTYPE html>
<html lang="ko"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>VI One — Legal</title>
<style>body{font-family:-apple-system,sans-serif;max-width:600px;margin:60px auto;padding:0 20px;line-height:1.6;color:#1C1C1E}h1{font-size:28px;margin-bottom:10px}a{color:#50AAEE;text-decoration:none;display:block;padding:14px;background:#F8FAFE;border-radius:10px;margin:8px 0;font-weight:600}a:hover{background:#EEF6FF}</style>
</head><body>
<h1>VI One — Legal</h1>
<p style="color:#8E8E93;margin-bottom:24px">소상공인을 위한 AI CRM · 리지드포인트 어드바이져리</p>
<a href="privacy-policy.html">📄 개인정보 처리방침</a>
<a href="terms-of-service.html">📋 이용약관</a>
</body></html>
'@ | Out-File -FilePath "index.html" -Encoding UTF8

# 4) commit
git add .
git commit -m "VI One legal docs initial publish" 2>&1 | Out-Null
Write-Host "✓ commit" -ForegroundColor Green

# 5) GitHub 리포 생성 + push
gh repo create "$USER/$REPO" --public --source=. --push --description "VI One legal documents (privacy, terms)"
Write-Host "✓ repo created + pushed" -ForegroundColor Green

# 6) Pages 활성화
gh api -X POST "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" 2>&1 | Out-Null
Write-Host "✓ Pages enabled" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 배포 완료. 1~5분 후 다음 URL 동작:" -ForegroundColor Yellow
Write-Host "   https://rigidpointadvisory.github.io/$REPO/" -ForegroundColor White
Write-Host "   https://rigidpointadvisory.github.io/$REPO/privacy-policy.html" -ForegroundColor White
Write-Host "   https://rigidpointadvisory.github.io/$REPO/terms-of-service.html" -ForegroundColor White
Write-Host ""
Write-Host "→ App Store Connect 의 Privacy Policy URL 필드에 위 URL 입력하세요." -ForegroundColor Cyan
