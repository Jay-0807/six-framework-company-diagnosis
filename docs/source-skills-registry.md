# 可对接的信源 MCP / Skill 清单

调研于 2026 年 5 月。MCP 生态变化快，建议每 3-6 个月重扫一次。

## 推荐 5 件套（按 真实性 × 引用质量 × 可获取性 排序）

| MCP | 类别 | URL | 费用 | 备注 |
|---|---|---|---|---|
| **EdgarTools** | SEC 财报 | https://www.edgartools.io/edgartools-mcp-for-sec-filings/ | 免费 MIT | 美股财报实时；建议起手必装 |
| **Brave Search** | 独立 web 索引 | https://brave.com/search/api/ | 免费 2k / 月 | 非 Google 索引，适合 PEST + 突发威胁检测 |
| **LinkedIn MCP** | 高管 + 招聘 | https://github.com/stickerdaniel/linkedin-mcp-server | 需 LinkedIn API | 7S Staff / VRIO 人才的硬证据 |
| **Guidepoint** | 专家访谈 | https://www.guidepoint.com/ (企业 API) | 企业级订阅 | 10 万+ 转录，机构级一手 |
| **FactSet** | 机构市场数据 | https://www.factset.com/marketplace | 企业级 | 唯一带分析师一致预期的源 |

## 辅助层（按需）

| MCP | 类别 | 备注 |
|---|---|---|
| Yahoo Finance MCP | 美股 + 港股财务 | 免费，精度一般，覆盖广 |
| Google Patents | 专利搜索 | 需 SerpApi Key |
| AlphaVantage | 经济数据 | 免费层有，TAM / SAM 代理 |
| Economic Calendar | 宏观日历 | PEST Economic 维度数据 |
| TheirStack | 1.93 亿岗位 + 技术栈 | VRIO 技术能力评估 |
| Perplexity Research | 实时网页研究 | 速度快，引用清楚 |
| Meltwater MCP | 新闻 + 情感聚合 | 企业级 |
| Finviz | 美股筛选 + earnings alert | 免费 / Paid 双轨 |
| last30days | 近 30 天资讯（你已有） | 跟踪行业突发 |
| xAI X Search | 实时 Twitter / X | 舆情早期信号 |

## "Junk Skill" 黑名单（无真实数据接入，不要装）

这些在搜索结果里出现频繁但只是 **LLM prompt 包装**，没有真实数据后端：

- ❌ "Market Research Orchestrator" v2 / v3 等变体 — 重打包 web search prompt
- ❌ "Strategy & Competitive Analysis" — 通用 SWOT 模板，无数据接入
- ❌ 独立的 "PEST Analysis" / "Porter's Five Forces" skill — 框架模板，要靠你手动喂数据
- ❌ 大多数 SkillHub / LobeHub 上的 "Skills" — instruction-only，无 MCP 后端
- ❌ "Interview Practice Coaching" — 场景生成不是真实访谈
- ❌ "Company Intelligence Research"（自媒体重打包类）— 仍是 LLM 推断

> **讽刺的提醒**：本 skill 本质也属于"框架模板"类。靠 **铁律 + 模板 + 使用者 profile 锚定 + 跨公司记忆 + 强制证据标签** 避免变成 junk。如果使用本 skill 时不接 MCP、不读 user-profile、不打证据标签、不归档 memory，那它就退化成另一个 junk skill。

## 中国市场重大缺口

MCP 生态对中文一手源覆盖**很差**。下表的源**都没有可用 MCP**，必须靠 WebSearch + 使用者本地白名单（`~/.company-diagnosis/source-allowlist.local.md`）解决：

| 类别 | 缺失的 MCP |
|---|---|
| 公司注册 / 司法 / 招投标 | 天眼查 / 企查查 / 启信宝 |
| 政策聚合 | 工信部 / 网信办 / 国家发改委 / 各地政府 / 央行 / 证监会 |
| 中文财经媒体 | 财新 / 36kr / 虎嗅 / 钛媒体 / 晚点 LatePost / 第一财经 / 经济观察网 |
| 中文股票数据 | 雪球 / 同花顺 / 东方财富 / 富途 / 老虎 |
| 中文专利 | 国家知识产权局 CNIPA |
| 中文行业报告 | 艾瑞 / QuestMobile / 易观 / 头豹研究院 / 沙利文中国 |

**变通**：
1. `Brave Search MCP` + `WebSearch` 实时搜，配合本地白名单标记可信源
2. 行业头部信源的官网 RSS 订阅（如果有）
3. 长期：考虑给 mcp-builder 立项做 1-2 个"中文一手源 MCP"（雪球 / 天眼查 优先），但要注意各家服务条款 / 反爬政策

## MCP 注册表 / 目录（找新 MCP 用）

| 名字 | URL | 说明 |
|---|---|---|
| MCPMarket | https://mcpmarket.com | 4200+ skills + 770+ MCP，索引最全 |
| MCPServers.org | https://mcpservers.org | 官方注册，curated |
| Awesome MCP Servers | https://github.com/wong2/awesome-mcp-servers | 社区 curated 排名 |
| Glama.ai | https://glama.ai/mcp/servers | 评测 + 搜索 |
| PulseMCP | https://www.pulsemcp.com/servers | 发现 + use-case playbook |
| LobeHub Skills | https://lobehub.com/skills | 联邦 skill 市场 |
| ClawHub | https://clawhub.ai | Skill marketplace |

## 装机检查（skill 初始化时跑）

skill 启动时检查这 5 件套是否装上，给使用者一个状态报告：

```
📊 信源能力检查
✅ WebSearch（内置）
✅ WebFetch（内置）
❓ EdgarTools MCP — 未检测到，[强烈推荐] 美股财报关键
❓ Brave Search MCP — 未检测到，[强烈推荐] 替代 Google 索引
❓ LinkedIn MCP — 未检测到，[推荐] 7S/VRIO 人才信号
❓ Guidepoint — 未检测到 (企业级)
❓ FactSet — 未检测到 (企业级)

当前可信源等级：基础（WebSearch only）
建议：先装 EdgarTools + Brave Search（都免费），其他按需。
```

如果使用者全部不装，skill 仍然能跑（用 WebSearch 兜底），但报告里要标"基础信源模式，结论可信度上限有限"。
