# tools/ — 报告导出与可视化渲染脚本

> 铁律 11 + 双份归档约定的实现层。

## 文件

| 文件 | 平台 | 用途 |
|---|---|---|
| `md2html.ps1` | Windows | Markdown → HTML(mermaid 块保留为 `<div class="mermaid">`,通过浏览器 JS 渲染) |
| `md2pdf.ps1` | Windows | Markdown → PDF(走 Chrome headless,本地缓存 mermaid.min.js) |
| `md2pdf.sh` | macOS / Linux / WSL | Markdown → PDF(走 pandoc + weasyprint / wkhtmltopdf / headless Chrome,自动 fallback) |

## 用法

### Windows

```powershell
# PDF 一键转换(推荐)
.\md2pdf.ps1 -InputFile ..\memory\anta-2026-05-15.md `
             -OutputFile ..\memory\anta-2026-05-15.pdf `
             -Title "安踏六框架诊断"

# 或者只生成 HTML(浏览器手动打开)
.\md2html.ps1 -InputFile report.md -OutputFile report.html -Title "标题"
```

> **执行策略**:首次跑可能报错 `cannot be loaded because running scripts is disabled`,加 `-ExecutionPolicy Bypass`:
> ```powershell
> powershell.exe -ExecutionPolicy Bypass -File .\md2pdf.ps1 -InputFile report.md -OutputFile report.pdf
> ```

### macOS / Linux / WSL

```bash
chmod +x md2pdf.sh
./md2pdf.sh report.md report.pdf "标题"
```

脚本自动按下面顺序尝试,选第一个能用的:
1. `pandoc + weasyprint`(最干净,推荐)
2. `pandoc + wkhtmltopdf`
3. `pandoc + headless Chrome / Chromium`

如果都没装,会提示安装。

## 依赖

### Windows(`md2pdf.ps1`)
- ✅ Chrome 或 Edge(标准位置)
- ✅ 互联网(首次下载 mermaid.min.js 到 tools/;之后离线可用)
- ❌ 不需要 node / pandoc / python

### macOS / Linux(`md2pdf.sh`)
任一组合:
- `pandoc + weasyprint`(推荐):`brew install pandoc weasyprint` 或 `apt install pandoc && pip install weasyprint`
- `pandoc + wkhtmltopdf`:`brew install pandoc wkhtmltopdf`
- `pandoc + Chrome`:已装 Chrome / Chromium 即可

## 与 skill 主流程的关系

六框架诊断 SKILL.md Step 6 归档阶段会调用:

```
~/.company-diagnosis/memory/<公司>-<日期>.md   ← Markdown 源(LLM 直接写)
                                  .pdf         ← 用 tools/md2pdf.* 转换
```

LLM 在 Step 6 应该:
1. 写 Markdown 到 memory/
2. **如果环境是 Windows**:调用 `tools/md2pdf.ps1`
3. **如果环境是 macOS/Linux**:调用 `tools/md2pdf.sh`
4. 检查 `.pdf` 是否生成,失败则报红旗(铁律 11 自检)
