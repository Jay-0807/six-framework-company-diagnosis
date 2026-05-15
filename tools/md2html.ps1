# Minimal markdown → HTML converter targeted at this report's feature set.
# Supports: ATX headings, fenced code (with mermaid pass-through),
# tables with | --- |, ordered/unordered lists, blockquotes, horizontal rules,
# bold (**), inline code (`), links [t](u), images, hr (---).
param(
    [Parameter(Mandatory=$true)][string]$InputFile,
    [Parameter(Mandatory=$true)][string]$OutputFile,
    [string]$Title = "Report"
)

$ErrorActionPreference = "Stop"

$raw = Get-Content -Path $InputFile -Raw -Encoding UTF8
$raw = $raw -replace "`r`n", "`n"
$lines = $raw -split "`n"

function Escape-Html([string]$s) {
    if ($null -eq $s) { return "" }
    $s = $s -replace '&', '&amp;'
    $s = $s -replace '<', '&lt;'
    $s = $s -replace '>', '&gt;'
    return $s
}

function Format-Inline([string]$s) {
    if ($null -eq $s) { return "" }
    # Inline code first (so we don't process its content)
    $s = [regex]::Replace($s, '`([^`]+)`', { param($m) "<code>" + (Escape-Html $m.Groups[1].Value) + "</code>" })
    # Bold
    $s = [regex]::Replace($s, '\*\*([^\*]+)\*\*', '<strong>$1</strong>')
    # Links [text](url)
    $s = [regex]::Replace($s, '\[([^\]]+)\]\(([^\)]+)\)', '<a href="$2">$1</a>')
    return $s
}

$html = New-Object System.Collections.Generic.List[string]
$i = 0
$N = $lines.Length

while ($i -lt $N) {
    $line = $lines[$i]

    # Fenced code block
    if ($line -match '^```(.*)$') {
        $lang = $matches[1].Trim()
        $i++
        $buf = New-Object System.Collections.Generic.List[string]
        while ($i -lt $N -and -not ($lines[$i] -match '^```\s*$')) {
            $buf.Add($lines[$i])
            $i++
        }
        $i++  # consume closing ```
        $content = ($buf -join "`n")
        if ($lang -eq "mermaid") {
            $html.Add('<div class="mermaid">')
            $html.Add($content)
            $html.Add('</div>')
        } else {
            $escaped = Escape-Html $content
            $cls = if ($lang) { " class=`"language-$lang`"" } else { "" }
            $html.Add("<pre><code$cls>$escaped</code></pre>")
        }
        continue
    }

    # ATX headings
    if ($line -match '^(#{1,6})\s+(.+)$') {
        $level = $matches[1].Length
        $content = Format-Inline $matches[2]
        $html.Add("<h$level>$content</h$level>")
        $i++
        continue
    }

    # Horizontal rule
    if ($line -match '^-{3,}\s*$') {
        $html.Add('<hr>')
        $i++
        continue
    }

    # Blockquote (single or multi-line consecutive)
    if ($line -match '^>\s?(.*)$') {
        $buf = New-Object System.Collections.Generic.List[string]
        while ($i -lt $N -and $lines[$i] -match '^>\s?(.*)$') {
            $buf.Add((Format-Inline $matches[1]))
            $i++
        }
        $html.Add("<blockquote>$(($buf -join '<br>'))</blockquote>")
        continue
    }

    # Table (header row + separator)
    if ($line -match '^\|.*\|\s*$' -and ($i + 1) -lt $N -and $lines[$i+1] -match '^\|[\s\-:|]+\|\s*$') {
        $headerCells = ($line.Trim().TrimStart('|').TrimEnd('|')) -split '\|'
        $i += 2  # skip header + separator
        $html.Add('<table>')
        $html.Add('<thead><tr>')
        foreach ($h in $headerCells) {
            $html.Add("<th>$(Format-Inline ($h.Trim()))</th>")
        }
        $html.Add('</tr></thead>')
        $html.Add('<tbody>')
        while ($i -lt $N -and $lines[$i] -match '^\|.*\|\s*$') {
            $cells = ($lines[$i].Trim().TrimStart('|').TrimEnd('|')) -split '\|'
            $html.Add('<tr>')
            foreach ($c in $cells) {
                $html.Add("<td>$(Format-Inline ($c.Trim()))</td>")
            }
            $html.Add('</tr>')
            $i++
        }
        $html.Add('</tbody></table>')
        continue
    }

    # Unordered list
    if ($line -match '^[\-\*]\s+(.+)$') {
        $html.Add('<ul>')
        while ($i -lt $N -and $lines[$i] -match '^[\-\*]\s+(.+)$') {
            $html.Add("<li>$(Format-Inline $matches[1])</li>")
            $i++
        }
        $html.Add('</ul>')
        continue
    }

    # Ordered list
    if ($line -match '^\d+\.\s+(.+)$') {
        $html.Add('<ol>')
        while ($i -lt $N -and $lines[$i] -match '^\d+\.\s+(.+)$') {
            $html.Add("<li>$(Format-Inline $matches[1])</li>")
            $i++
        }
        $html.Add('</ol>')
        continue
    }

    # Blank line
    if ($line -match '^\s*$') {
        $i++
        continue
    }

    # Paragraph: gather consecutive non-special lines
    $paraBuf = New-Object System.Collections.Generic.List[string]
    $paraBuf.Add($line)
    $i++
    while ($i -lt $N) {
        $ln = $lines[$i]
        if ($ln -match '^\s*$') { break }
        if ($ln -match '^(#{1,6})\s' ) { break }
        if ($ln -match '^```' ) { break }
        if ($ln -match '^-{3,}\s*$' ) { break }
        if ($ln -match '^>') { break }
        if ($ln -match '^\|') { break }
        if ($ln -match '^[\-\*]\s+') { break }
        if ($ln -match '^\d+\.\s+') { break }
        $paraBuf.Add($ln)
        $i++
    }
    $html.Add("<p>$(Format-Inline ($paraBuf -join ' '))</p>")
}

$body = $html -join "`n"

$css = @"
* { box-sizing: border-box; }
html { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
body {
    font-family: 'Microsoft YaHei', 'PingFang SC', 'Hiragino Sans GB', 'Source Han Sans CN', 'Noto Sans CJK SC', system-ui, -apple-system, sans-serif;
    line-height: 1.75;
    color: #1f2933;
    max-width: 980px;
    margin: 0 auto;
    padding: 40px 52px;
    font-size: 14.5px;
    letter-spacing: 0.01em;
}

/* Title (H1) — only the first H1 acts as report cover title */
h1 {
    font-size: 32px;
    color: #0d2c4f;
    border-bottom: 4px double #0d2c4f;
    padding-bottom: 14px;
    margin-top: 48px;
    margin-bottom: 24px;
    font-weight: 700;
    letter-spacing: 0.02em;
}
h1:first-of-type {
    margin-top: 0;
    text-align: center;
    border-bottom: 4px double #0d2c4f;
    padding: 30px 0 18px;
}
h2 {
    font-size: 23px;
    color: #1a3a5c;
    border-bottom: 2px solid #1a3a5c;
    padding-bottom: 8px;
    margin-top: 44px;
    margin-bottom: 18px;
    font-weight: 600;
}
h3 {
    font-size: 18px;
    color: #205080;
    margin-top: 32px;
    margin-bottom: 12px;
    font-weight: 600;
    border-left: 4px solid #205080;
    padding-left: 12px;
}
h4 {
    font-size: 16px;
    color: #2d6299;
    margin-top: 24px;
    margin-bottom: 10px;
    font-weight: 600;
}

p {
    margin: 10px 0 14px;
    text-align: justify;
}
strong { color: #0d2c4f; font-weight: 600; }
em { color: #4a5568; }

/* Inline code */
code {
    background: #f3f4f6;
    padding: 2px 7px;
    border-radius: 4px;
    font-family: 'Cascadia Code', 'JetBrains Mono', 'Consolas', 'Courier New', monospace;
    font-size: 0.9em;
    color: #c7254e;
    border: 1px solid #e5e7eb;
}

/* Code blocks — including ASCII art rendered as preformatted */
pre {
    background: #f6f8fa;
    border: 1px solid #d0d7de;
    border-left: 4px solid #1a4a73;
    border-radius: 6px;
    padding: 16px 20px;
    overflow-x: auto;
    font-family: 'Cascadia Code', 'JetBrains Mono', 'Consolas', 'Courier New', monospace;
    font-size: 13px;
    line-height: 1.55;
    margin: 16px 0;
    white-space: pre;
}
pre code {
    background: none;
    padding: 0;
    color: #24292f;
    border: none;
    font-size: inherit;
}

blockquote {
    border-left: 4px solid #1a4a73;
    background: linear-gradient(to right, #eaf4fb 0%, #f5f9fc 100%);
    padding: 14px 20px;
    margin: 16px 0;
    color: #1a3a5c;
    border-radius: 0 8px 8px 0;
    font-style: normal;
}
blockquote p { margin: 4px 0; }
blockquote strong { color: #0d2c4f; }

hr {
    border: 0;
    border-top: 2px solid #cbd5e0;
    margin: 36px 0;
    height: 0;
    position: relative;
}
hr::after {
    content: "◆";
    position: absolute;
    top: -12px;
    left: 50%;
    transform: translateX(-50%);
    background: white;
    padding: 0 12px;
    color: #94a3b8;
    font-size: 12px;
}

/* Tables — stronger contrast, alternating rows, sticky header on print */
table {
    border-collapse: collapse;
    margin: 18px 0;
    width: 100%;
    font-size: 13.5px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04);
    border-radius: 6px;
    overflow: hidden;
}
thead { background: #1a3a5c; }
th {
    color: #ffffff;
    font-weight: 600;
    text-align: left;
    padding: 10px 12px;
    border: 1px solid #1a3a5c;
    font-size: 13.5px;
    letter-spacing: 0.02em;
}
td {
    border: 1px solid #e2e8f0;
    padding: 10px 12px;
    text-align: left;
    vertical-align: top;
    line-height: 1.6;
}
tbody tr:nth-child(odd) td { background: #ffffff; }
tbody tr:nth-child(even) td { background: #f7fafc; }
tbody tr:hover td { background: #eef2f7; }

/* Lists */
ul, ol { margin: 10px 0 14px 0; padding-left: 28px; }
li { margin: 6px 0; line-height: 1.7; }
li > p { margin: 4px 0; }

a {
    color: #1a4a73;
    text-decoration: none;
    border-bottom: 1px dotted #1a4a73;
}
a:hover { color: #0d2c4f; border-bottom-style: solid; }

/* Mermaid diagrams */
.mermaid {
    text-align: center;
    margin: 24px 0;
    background: #fbfcfd;
    padding: 16px 12px;
    border-radius: 8px;
    border: 1px solid #e1e4e8;
    overflow-x: auto;
    /* Important: do NOT set fixed height; let SVG dictate size */
}
.mermaid svg {
    width: 100% !important;       /* expand small diagrams to fill container width */
    max-width: 100% !important;
    height: auto;
    max-height: 230mm;            /* near A4 printable height minus heading + padding */
    display: inline-block;
}

/* Print rules */
@page {
    size: A4;
    margin: 14mm 14mm 16mm 14mm;
}
@media print {
    body {
        max-width: none;
        padding: 0;
        font-size: 11pt;
        line-height: 1.65;
    }
    h1 { font-size: 22pt; margin-top: 24pt; page-break-before: avoid; }
    h1:first-of-type { padding: 12pt 0 10pt; margin-bottom: 16pt; }
    h2 { font-size: 16pt; margin-top: 22pt; }
    h3 { font-size: 13pt; margin-top: 16pt; }
    h4 { font-size: 12pt; }
    /* Headings: keep with following content, but don't be too aggressive */
    h2, h3, h4 { page-break-after: avoid; break-after: avoid-page; }
    /* Tables / blockquotes / pre: keep together if reasonably sized */
    table, pre, blockquote { page-break-inside: avoid; break-inside: avoid-page; }
    /* Mermaid: let it break across pages if too tall (better than empty pages) */
    .mermaid {
        padding: 10pt 8pt;
        page-break-inside: auto;
        break-inside: auto;
    }
    .mermaid svg {
        max-height: 230mm;   /* fill page with diagram; heading sits above */
        width: 100% !important;
    }
    pre { font-size: 9pt; }
    table { font-size: 9.5pt; }
    th, td { padding: 5pt 7pt; }
}
"@

$template = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>$Title</title>
<style>
$css
</style>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({
    startOnLoad: true,
    theme: 'default',
    flowchart: { useMaxWidth: true, htmlLabels: true },
    themeVariables: {
      fontFamily: "'Microsoft YaHei', 'PingFang SC', sans-serif",
      fontSize: '14px'
    }
  });
</script>
</head>
<body>
$body
</body>
</html>
"@

# Write file as UTF-8 with BOM so Chrome detects encoding reliably
$utf8Bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($OutputFile, $template, $utf8Bom)
Write-Output "Wrote HTML: $OutputFile (length: $($template.Length) chars)"
