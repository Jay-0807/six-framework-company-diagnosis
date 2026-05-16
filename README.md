# six-framework-company-diagnosis(Firefly · 六框架企业战略诊断)

**一个通用的咨询级公司战略诊断 skill** —— PEST → 五力 → 7S → VRIO → 价值链 → SWOT,6 个框架严格顺序串联,每次调研都锚定到**使用者自己的商业路径**。

> ⚠️ 这个 repo 不存任何使用者业务数据。每个使用者的商业路径规划、历史调研、自定义信源白名单都在 **使用者本地** `~/.company-diagnosis/`，永不上 GitHub。

## 它解决什么

LLM 直接跑 6 框架分析时的 7 类天然失败模式（实测见 [baseline-test-results.md](docs/baseline-test-results.md)）：

- 框架孤岛输出，SWOT 不引用前面发现
- VRIO 退化成"高 / 中 / 低"打分（丢失 V→R→I→O 顺序判定）
- 7S 不做对齐矩阵
- 价值链泛化成通用流程
- 零证据标签，数字真假难辨
- 缺 TOWS 矩阵
- 6 节排版风格不一致

本 skill 用 8 条铁律 + 强制模板 + 使用者 profile 锚定 + 跨公司长期记忆 + 信源治理把这些洞都堵掉。

## 安装

```bash
# 克隆到你的 agent 的 skill 目录
cd <你的 agent 的 skill 目录>
git clone https://github.com/Jay-0807/six-framework-company-diagnosis.git
```

首次调用时，skill 会发现 `~/.company-diagnosis/user-profile.md` 不存在，自动进入 onboarding 流程引导你填写自己的商业路径规划。

## 路径约定

`USER_DATA_PATH = ~/.company-diagnosis/`,跨平台路径如下:

| 平台 | 实际路径 |
|---|---|
| Linux / macOS / WSL | `~/.company-diagnosis/` |
| Windows(原生 PowerShell / cmd) | `C:\Users\<用户名>\.company-diagnosis\` |

| 路径 | 内容 | 进 GitHub? |
|---|---|:-:|
| 本 repo | skill 本体(铁律、模板、规范、虚构示例) | ✅ 公开 |
| `USER_DATA_PATH/user-profile.md` | 你的商业路径规划(活文档) | ❌ |
| `USER_DATA_PATH/user-profile.history/` | 商业路径历史版本 | ❌ |
| `USER_DATA_PATH/memory/<公司>-<日期>.md` | 调研归档(Markdown 源) | ❌ |
| `USER_DATA_PATH/memory/<公司>-<日期>.pdf` | 调研归档(可视化 PDF,**v3 强制双份**) | ❌ |
| `USER_DATA_PATH/memory/_index.md` | 4 维 tag 跨公司索引 | ❌ |
| `USER_DATA_PATH/source-allowlist.local.md` | 自定义信源白名单(含中文媒体) | ❌ |
| `USER_DATA_PATH/session-cache/` | 短期会话缓存(可选) | ❌ |

## 导出 PDF(v3 必备)

铁律 11 要求每份诊断报告同时归档 `.md` + `.pdf`,因为六框架本身高度可视化(7×7 矩阵 / VRIO 决策树 / Porter 价值链 / SWOT 2×2)。

### Windows

```powershell
# 一键转换
powershell.exe -ExecutionPolicy Bypass `
  -File tools\md2pdf.ps1 `
  -InputFile  ~\.company-diagnosis\memory\<公司>-<日期>.md `
  -OutputFile ~\.company-diagnosis\memory\<公司>-<日期>.pdf `
  -Title "<公司> 六框架诊断"
```

依赖:Chrome 或 Edge(标准位置即可)。首次运行会下载 mermaid.min.js 到 `tools/`(3.3MB,之后离线可用)。

### macOS / Linux / WSL

```bash
chmod +x tools/md2pdf.sh
./tools/md2pdf.sh ~/.company-diagnosis/memory/<公司>-<日期>.md \
                  ~/.company-diagnosis/memory/<公司>-<日期>.pdf \
                  "<公司> 六框架诊断"
```

依赖任一:`pandoc + weasyprint`(推荐) / `pandoc + wkhtmltopdf` / `pandoc + Chrome`(自动 fallback)。详见 [tools/README.md](tools/README.md)。

## 推荐 MCP（可选但显著提升质量）

5 件套（按"真实性 × 引用质量"排序）：

| MCP | 用途 | 费用 |
|---|---|---|
| [EdgarTools](https://www.edgartools.io/edgartools-mcp-for-sec-filings/) | SEC EDGAR 财报实时（美股） | 免费 MIT |
| [Brave Search](https://brave.com/search/api/) | 独立 web 索引（非 Google） | 免费 2k/月 |
| [LinkedIn MCP](https://github.com/stickerdaniel/linkedin-mcp-server) | 高管 + 招聘信号（7S Staff / VRIO 人才） | 需 LinkedIn API |
| [Guidepoint](https://www.guidepoint.com/) | 10万+ 专家访谈转录 | 企业级 |
| [FactSet](https://www.factset.com/marketplace) | 机构级市场数据 + 分析师一致预期 | 企业级 |

完整清单 + 装机指引：[source-skills-registry.md](docs/source-skills-registry.md)

**中国市场提醒**：MCP 生态对中文一手源（财新 / 36kr / 雪球 / 天眼查 / 工信部 / CNIPA / 同花顺）目前**无可用 MCP**。变通方案：靠 WebSearch + Brave Search + 使用者本地维护的中文信源白名单。

## 用法

```
你:用六框架分析 钉钉

Firefly:
  → 读 ~/.company-diagnosis/user-profile.md
  → 提取「钉钉」的 4 维 tag(SaaS-协同 / 大厂事业部 / 双轮 / 大企业+SMB+政企)
  → 查 _index.md 找相似历史调研
  → 按 docs/source-policy.md 决定信源
  → 执行 6 框架(铁律 1-7)
  → 序章 + 每节框架解释 + 标准可视化(铁律 9-11)
  → 第七节"对使用者商业路径的启示"(铁律 8)
  → 缩写首处展开 + 末尾附录 G 术语表(铁律 12)
  → 归档到 memory/钉钉-2026-05-12.md + .pdf(铁律 11 双份)
  → 询问:要根据本次发现更新 user-profile.md 吗?
```

## 文件清单

| 文件 | 作用 |
|---|---|
| [SKILL.md](SKILL.md) | 主入口(流程总指挥) |
| [frameworks.md](docs/frameworks.md) | 每框架检查清单 + 评分锚点 + 读法说明 |
| [output-template.md](docs/output-template.md) | 报告模板(序章 + 7 节 + 附录) |
| [visualization-templates.md](docs/visualization-templates.md) | 每个框架的 Mermaid 标准模板(v3 新增) |
| [onboarding-guide.md](docs/onboarding-guide.md) | 首次调用引导(v3 改造:行业自适应) |
| [user-profile-template.md](docs/user-profile-template.md) | 商业路径规划模板 |
| [memory-spec.md](docs/memory-spec.md) | 长短期记忆系统规范(v3:md + pdf 双份) |
| [source-policy.md](docs/source-policy.md) | 信源治理(白 / 黑名单) |
| [source-skills-registry.md](docs/source-skills-registry.md) | 可对接 MCP 清单 |
| [baseline-test-results.md](docs/baseline-test-results.md) | 7 类失败模式实测记录 |
| [tools/](tools/) | MD→PDF 转换脚本(Windows + macOS/Linux,v3 新增) |
| [examples/example-user-profile.md](examples/example-user-profile.md) | 虚构使用者「云栖咨询」示例 |

## License

MIT
