# md2pdf.ps1 — Windows: convert markdown report → PDF via headless Chrome.
#
# Pipeline:
#   1. md2html.ps1 to render markdown → standalone HTML (mermaid passes through as <div class="mermaid">)
#   2. Download mermaid.min.js locally on first run (for offline-friendly + speed)
#   3. Headless Chrome --print-to-pdf renders the HTML (mermaid.js executes during render)
#
# Usage:
#   .\md2pdf.ps1 -InputFile report.md -OutputFile report.pdf -Title "公司诊断报告"
#
# Requires:
#   - Chrome installed at standard location (auto-detected)
#   - Internet on first run (to fetch mermaid.min.js); offline thereafter
param(
    [Parameter(Mandatory=$true)][string]$InputFile,
    [Parameter(Mandatory=$true)][string]$OutputFile,
    [string]$Title = "诊断报告"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. Locate Chrome
$chromePaths = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)
$chrome = $chromePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) {
    throw "找不到 Chrome 或 Edge。请确认浏览器已安装,或自行修改 \$chromePaths"
}

# 2. Ensure mermaid.min.js exists alongside (download once)
$mermaidPath = Join-Path $scriptDir "mermaid.min.js"
if (-not (Test-Path $mermaidPath)) {
    Write-Host "正在下载 mermaid.min.js(约 3MB,只首次需要)..."
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri 'https://cdn.jsdelivr.net/npm/mermaid@10.9.0/dist/mermaid.min.js' `
        -OutFile $mermaidPath -UseBasicParsing
}

# 3. Generate HTML
$htmlPath = [System.IO.Path]::ChangeExtension($OutputFile, ".html")
& (Join-Path $scriptDir "md2html.ps1") -InputFile $InputFile -OutputFile $htmlPath -Title $Title

# 4. Patch HTML to use local mermaid (replace CDN URL → local file)
$html = Get-Content -Path $htmlPath -Raw -Encoding UTF8
$html = $html -replace 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js', 'mermaid.min.js'
# Also copy mermaid.min.js to HTML dir (Chrome will read from same folder as the HTML)
$htmlDir = Split-Path -Parent (Resolve-Path $htmlPath).Path
$mermaidNextToHtml = Join-Path $htmlDir "mermaid.min.js"
if (-not (Test-Path $mermaidNextToHtml)) {
    Copy-Item -Path $mermaidPath -Destination $mermaidNextToHtml
}
[System.IO.File]::WriteAllText($htmlPath, $html, (New-Object System.Text.UTF8Encoding($true)))

# 5. Run headless Chrome to print to PDF
$htmlUri = "file:///" + ((Resolve-Path $htmlPath).Path -replace '\\', '/')
$absOut = $OutputFile
if (-not [System.IO.Path]::IsPathRooted($absOut)) {
    $absOut = Join-Path (Get-Location) $absOut
}
Write-Host "渲染 PDF: $absOut"
& $chrome --headless=new --disable-gpu --no-sandbox --no-first-run `
    --no-pdf-header-footer --virtual-time-budget=30000 `
    "--print-to-pdf=$absOut" $htmlUri 2>$null

if (Test-Path $absOut) {
    $sz = (Get-Item $absOut).Length
    Write-Host "✅ PDF 已生成: $absOut ($([math]::Round($sz/1KB)) KB)"
} else {
    throw "❌ PDF 生成失败,请检查 Chrome 路径和 HTML 渲染"
}
