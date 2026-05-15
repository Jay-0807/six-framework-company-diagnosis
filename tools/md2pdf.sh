#!/usr/bin/env bash
# md2pdf.sh — macOS / Linux / WSL: convert markdown report → PDF.
#
# Pipeline (3 fallback strategies, picks the first that works):
#   A. pandoc + weasyprint (preferred — cleanest PDF output with mermaid via filter)
#   B. pandoc → HTML, then wkhtmltopdf
#   C. pandoc → HTML, then headless Chrome / Chromium
#
# Usage:
#   ./md2pdf.sh report.md report.pdf "公司诊断报告"
#
# Requires (one of):
#   - pandoc + weasyprint (brew install pandoc weasyprint)
#   - pandoc + wkhtmltopdf (brew install pandoc wkhtmltopdf)
#   - pandoc + google-chrome / chromium

set -euo pipefail

INPUT_FILE="${1:?用法: md2pdf.sh <input.md> <output.pdf> [title]}"
OUTPUT_FILE="${2:?用法: md2pdf.sh <input.md> <output.pdf> [title]}"
TITLE="${3:-诊断报告}"

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ 输入文件不存在: $INPUT_FILE" >&2
    exit 1
fi

if ! command -v pandoc >/dev/null 2>&1; then
    echo "❌ 需要 pandoc。安装: brew install pandoc (macOS) | sudo apt install pandoc (Ubuntu)" >&2
    exit 1
fi

# Strategy A: pandoc + weasyprint
if command -v weasyprint >/dev/null 2>&1; then
    echo "→ 使用 pandoc + weasyprint"
    HTML=$(mktemp --suffix=.html)
    pandoc "$INPUT_FILE" -f gfm -t html5 -s \
        --metadata title="$TITLE" \
        --highlight-style=tango \
        -o "$HTML"
    weasyprint "$HTML" "$OUTPUT_FILE"
    rm -f "$HTML"
    echo "✅ PDF: $OUTPUT_FILE"
    exit 0
fi

# Strategy B: pandoc + wkhtmltopdf
if command -v wkhtmltopdf >/dev/null 2>&1; then
    echo "→ 使用 pandoc + wkhtmltopdf"
    HTML=$(mktemp --suffix=.html)
    pandoc "$INPUT_FILE" -f gfm -t html5 -s \
        --metadata title="$TITLE" \
        -o "$HTML"
    wkhtmltopdf --enable-local-file-access "$HTML" "$OUTPUT_FILE"
    rm -f "$HTML"
    echo "✅ PDF: $OUTPUT_FILE"
    exit 0
fi

# Strategy C: pandoc + headless Chrome
CHROME=""
for c in google-chrome chromium chromium-browser chrome; do
    if command -v "$c" >/dev/null 2>&1; then
        CHROME="$c"
        break
    fi
done
# macOS default location
if [ -z "$CHROME" ] && [ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
    CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
fi

if [ -n "$CHROME" ]; then
    echo "→ 使用 pandoc + headless Chrome ($CHROME)"
    HTML=$(mktemp --suffix=.html)
    # Add mermaid CDN + minimal CSS
    pandoc "$INPUT_FILE" -f gfm -t html5 -s \
        --metadata title="$TITLE" \
        --css=https://cdn.jsdelivr.net/gh/sindresorhus/github-markdown-css/github-markdown.css \
        -H <(cat <<'HEAD'
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<script>mermaid.initialize({startOnLoad:true,theme:'default'});
// Mark mermaid code blocks for mermaid.js to find them
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('pre code.language-mermaid').forEach(function(el) {
    var div = document.createElement('div');
    div.className = 'mermaid';
    div.textContent = el.textContent;
    el.parentNode.replaceWith(div);
  });
  if (window.mermaid) mermaid.run();
});
</script>
<style>body{max-width:1100px;margin:0 auto;padding:20px;}
.mermaid{text-align:center;margin:20px 0;background:#fbfcfd;padding:16px;border-radius:8px;border:1px solid #e1e4e8;}
@page{size:A4;margin:14mm 12mm;}</style>
HEAD
) -o "$HTML"

    "$CHROME" --headless=new --disable-gpu --no-sandbox --no-first-run \
        --no-pdf-header-footer --virtual-time-budget=30000 \
        --print-to-pdf="$OUTPUT_FILE" "file://$HTML" 2>/dev/null
    rm -f "$HTML"
    echo "✅ PDF: $OUTPUT_FILE"
    exit 0
fi

echo "❌ 找不到 PDF 渲染工具。请安装以下任一:" >&2
echo "   - weasyprint (brew install weasyprint | pip install weasyprint)" >&2
echo "   - wkhtmltopdf (brew install wkhtmltopdf)" >&2
echo "   - Google Chrome 或 Chromium" >&2
exit 1
