# six-framework-company-diagnosis

**一个通用的咨询级公司战略诊断 Claude Code skill** —— PEST → 五力 → 7S → VRIO → 价值链 → SWOT，6 个框架严格顺序串联，每次调研都锚定到**使用者自己的商业路径**。

> ⚠️ 这个 repo 不存任何使用者业务数据。每个使用者的商业路径规划、历史调研、自定义信源白名单都在 **使用者本地** `~/.company-diagnosis/`，永不上 GitHub。

## 它解决什么

LLM 直接跑 6 框架分析时的 7 类天然失败模式（实测见 [baseline-test-results.md](baseline-test-results.md)）：

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
# 克隆到你的 skill 目录
cd ~/.claude/skills/        # 或者你的 hermes agent 的 skill 目录
git clone https://github.com/<author>/six-framework-company-diagnosis.git
```

首次调用时，skill 会发现 `~/.company-diagnosis/user-profile.md` 不存在，自动进入 onboarding 流程引导你填写自己的商业路径规划。

## 路径约定

| 路径 | 内容 | 进 GitHub？ |
|---|---|:-:|
| 本 repo | skill 本体（铁律、模板、规范、虚构示例） | ✅ 公开 |
| `~/.company-diagnosis/user-profile.md` | 你的商业路径规划（活文档） | ❌ |
| `~/.company-diagnosis/user-profile.history/` | 商业路径历史版本 | ❌ |
| `~/.company-diagnosis/memory/` | 你的历史调研归档 + 4 维 tag 索引 | ❌ |
| `~/.company-diagnosis/source-allowlist.local.md` | 你自定义的信源白名单（含中文媒体） | ❌ |
| `~/.company-diagnosis/session-cache/` | 短期会话缓存（可选） | ❌ |

## 推荐 MCP（可选但显著提升质量）

5 件套（按"真实性 × 引用质量"排序）：

| MCP | 用途 | 费用 |
|---|---|---|
| [EdgarTools](https://www.edgartools.io/edgartools-mcp-for-sec-filings/) | SEC EDGAR 财报实时（美股） | 免费 MIT |
| [Brave Search](https://brave.com/search/api/) | 独立 web 索引（非 Google） | 免费 2k/月 |
| [LinkedIn MCP](https://github.com/stickerdaniel/linkedin-mcp-server) | 高管 + 招聘信号（7S Staff / VRIO 人才） | 需 LinkedIn API |
| [Guidepoint](https://www.guidepoint.com/) | 10万+ 专家访谈转录 | 企业级 |
| [FactSet](https://www.factset.com/marketplace) | 机构级市场数据 + 分析师一致预期 | 企业级 |

完整清单 + 装机指引：[source-skills-registry.md](source-skills-registry.md)

**中国市场提醒**：MCP 生态对中文一手源（财新 / 36kr / 雪球 / 天眼查 / 工信部 / CNIPA / 同花顺）目前**无可用 MCP**。变通方案：靠 WebSearch + Brave Search + 使用者本地维护的中文信源白名单。

## 用法

```
你：用六框架分析 钉钉

Claude：
  → 读 ~/.company-diagnosis/user-profile.md
  → 提取「钉钉」的 4 维 tag（SaaS-协同 / 大厂事业部 / 双轮 / 大企业+SMB+政企）
  → 查 _index.md 找相似历史调研
  → 按 source-policy.md 决定信源
  → 执行 6 框架（铁律 1-7）
  → 第七节"对使用者商业路径的启示"（铁律 8）
  → 归档到 memory/钉钉-2026-05-12.md
  → 询问：要根据本次发现更新 user-profile.md 吗？
```

## 文件清单

| 文件 | 作用 |
|---|---|
| [SKILL.md](SKILL.md) | 主入口（流程总指挥） |
| [framework-checklists.md](framework-checklists.md) | 每框架检查清单 + 评分锚点 |
| [output-template.md](output-template.md) | 报告模板（7 节 + 附录） |
| [onboarding-guide.md](onboarding-guide.md) | 首次调用引导 |
| [user-profile-template.md](user-profile-template.md) | 商业路径规划模板 |
| [memory-spec.md](memory-spec.md) | 长短期记忆系统规范 |
| [source-policy.md](source-policy.md) | 信源治理（白 / 黑名单） |
| [source-skills-registry.md](source-skills-registry.md) | 可对接 MCP 清单 |
| [baseline-test-results.md](baseline-test-results.md) | 7 类失败模式实测记录 |
| [examples/example-user-profile.md](examples/example-user-profile.md) | 虚构使用者「云栖咨询」示例 |

## License

MIT
