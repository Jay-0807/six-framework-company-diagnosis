---
name: six-framework-company-diagnosis
description: Use when running a full consulting-style strategic diagnostic on a company — PEST→Five Forces→McKinsey 7S→VRIO→Value Chain→SWOT in strict order, anchored to the user's own business path. Triggers include "六框架分析公司", "战略诊断", "PEST 五力 SWOT 全套", "consulting diagnostic on company", "麦肯锡式企业分析", "全套企业诊断".
---

# 六框架企业战略诊断（通用版）

## 它是什么

一个**通用**的咨询级公司诊断 skill。任何使用者都可以装。诊断过程会读使用者自己的"商业路径规划"，把目标公司的发现反哺到使用者的战略上。

**关键设计**：
- Skill 本体（这个 repo）**不含任何使用者业务数据**，公开
- 每个使用者的商业路径、调研历史、自定义信源都在使用者本地 `~/.company-diagnosis/`，**永不进 GitHub**
- 跨公司调研有长期记忆：分析新公司前先按 4 维 tag（行业 / 规模 / 商业模式 / 目标客户）查相似历史调研
- 信源治理：[公开数据] / [行业共识] / [需验证] / [推断] 强制标签 + 黑名单兜底

## 12 条铁律

继承 baseline 测试发现的 LLM 7 类失败模式（详见 docs/baseline-test-results.md）：

1. **顺序不可乱**：PEST → 五力 → 7S → VRIO → 价值链 → SWOT。前一步是后一步的输入。
2. **因果链显式**：SWOT 每条标 `[来源: 框架-子项]`，禁止凭空。
3. **VRIO 走 V→R→I→O 决策树**，结论落在 `{劣势 / 对等 / 暂时优势 / 未利用 / 持续优势}` 之一，**禁用"高/中/低"**。
4. **7S 必须做 7×7 对齐矩阵** + 错配清单。
5. **价值链按 Porter 9 活动**（5 主 + 4 辅）+ 毛利贡献 + cost/diff 类型 + vs 竞品。
6. **每条洞察带证据标签**：`[公开数据] / [行业共识] / [需验证] / [推断]`。全文 `[公开数据]` ≥ 5。
7. **以 TOWS 矩阵 + 一句战略建议收束 SWOT**。

新加（v2，多使用者公共化的产物）：

8. **必须有第七节"对使用者商业路径的启示"**：把诊断反哺回使用者 user-profile。否则只是研报，不是咨询。

新加（v3，方法论可读性 + 可视化的产物）：

9. **报告首页必须有"序章:为什么用这六个框架"**：一句话回答 + 6 框架能力分工表 + Mermaid 流程图（外部→内部→综合 3 段式）+ 顺序为什么不能乱。否则外行读者看不懂体系。
10. **每个框架节正文前必须有"框架解释（2-3 句话）"**：① 这个框架是什么 ② 它反映什么问题 ③ 在六框架体系中的角色。否则不懂框架的读者无法判断 7×7 矩阵 / VRIO 决策树之类的产出有何意义。
11. **每节必须嵌入对应的标准可视化**（见 docs/visualization-templates.md）：
    - PEST → 强度可视化（条形 / 表格）
    - 五力 → 五力图（mermaid 或 ASCII 雷达）
    - 7S → 7×7 Heatmap（emoji 颜色，不只是 ✓/✗）
    - VRIO → 决策树 Mermaid flowchart
    - 价值链 → Porter 经典图（mermaid 或 ASCII box）
    - SWOT + TOWS → 强化样式的 2×2 矩阵
    - 第七节 → mindmap（不确定性回答）+ gantt（行动路线图）

12. **缩写必须自解释**：① 报告首次出现关键缩写时,在该处用括号或注释展开(如 `PEST(Political 政治 / Economic 经济 / Social 社会 / Technological 技术)`)。② 报告末尾必须有**附录 G「术语 & 缩写表」**,按字母顺序索引全部缩写,中文意思 + 英文全称。否则非战略背景的读者(团队 / 合伙人 / 投资人)看不懂。

## 调用流程（v2）

```
用户：用六框架分析 X 公司
  ↓
Step 0：检查 ~/.company-diagnosis/user-profile.md
  ├─ 不存在 → 走 docs/onboarding-guide.md，收集使用者商业路径
  │           收集完才能继续诊断（禁止跳过）
  └─ 存在  → 读入作为诊断锚点
  ↓
Step 1：估算 X 公司的 4 维 tag（行业 / 规模 / 商业模式 / 目标客户）
  ↓ 读 ~/.company-diagnosis/memory/_index.md
  ├─ 找到至少 2 维 tag 重合的历史调研 → 报告头部加"相关历史调研"段
  └─ 无相似 → 跳过
  ↓
Step 2：按 docs/source-policy.md + ~/.company-diagnosis/source-allowlist.local.md 决定信源范围
  ↓
Step 3：写"序章:为什么用这六个框架"（铁律 9）
  ├─ 一句话回答
  ├─ 六框架能力分工表
  ├─ Mermaid flowchart：外部→内部→综合
  └─ 段落:顺序为什么不能乱
  ↓
Step 4：执行 PEST → 五力 → 7S → VRIO → 价值链 → SWOT 六节（按铁律 1-7 + 10-11）
  每节都按"框架解释 → 标准可视化 → 详表 → 输入到 SWOT"结构输出。
  ↓
Step 5：第七节"对使用者商业路径的启示"（铁律 8）
  ├─ 7.0 直接回答 onboarding 时填的"本次诊断目的"
  ├─ 7.1 直接借鉴：X 公司哪些能力 / 策略可被使用者借鉴
  ├─ 7.2 主动避免：X 公司哪些失误应规避
  ├─ 7.3 验证 / 挑战：对照使用者商业纪律 + 路线图 + 关键不确定性，标 ✅ / ⚠️ / ❓
  ├─ 7.4 user-profile 更新建议：具体到字段级
  └─ 7.5 战略路线图 mindmap + gantt（铁律 11）
  ↓
Step 6：归档（双份）
  ├─ Markdown：~/.company-diagnosis/memory/<公司>-<YYYY-MM-DD>.md
  ├─ PDF：~/.company-diagnosis/memory/<公司>-<YYYY-MM-DD>.pdf（用 tools/md2html.ps1 / md2pdf.sh 转）
  ├─ 在 _index.md 追加一行（含 4 维 tag + 30 字关键洞察）
  └─ 询问使用者：是否要根据本次发现更新 user-profile.md？
```

## 文件导航

| 想知道 | 看哪个 |
|---|---|
| 每个框架的检查清单 + 评分锚点 + SWOT 传递规则 | docs/frameworks.md |
| 报告 Markdown 模板（7 节 + 附录） | docs/output-template.md |
| 首次调用怎么收集使用者数据 | docs/onboarding-guide.md |
| 商业路径规划模板（让使用者填什么） | docs/user-profile-template.md |
| 记忆系统规范（索引格式 + 归档约定 + 检索规则） | docs/memory-spec.md |
| 信源白 / 黑名单 + 三层评分 | docs/source-policy.md |
| 推荐对接的 MCP / skill 清单 + 中文缺口 | docs/source-skills-registry.md |
| Baseline 测试记录（为什么有这些铁律） | docs/baseline-test-results.md |
| 每个框架的标准可视化 Mermaid 模板 | docs/visualization-templates.md |
| 完整示例（虚构使用者「云栖咨询」） | examples/example-user-profile.md |
| 安装与部署 | README.md |

## 红旗清单（出现即返工）

**继承原 7 项**（v1）：
- 6 框架顺序乱 → 重排
- VRIO 用了"高/中/低" → 重做该节用 V/R/I/O 决策树
- 7S 缺 7×7 对齐矩阵 → 补
- 价值链缺毛利贡献度 或 不分主 / 辅 → 重做
- SWOT 任一条缺 `[来源: 框架-子项]` → 补
- 缺 TOWS 矩阵 或 缺最终战略建议 → 补
- 全篇 `[公开数据]` 标签 = 0 → 退回补一手证据

**新增 4 项**（v2）：
- `user-profile.md` 不存在但直接开始诊断 → **停下，先 onboarding**
- 报告缺第七节"对使用者商业路径的启示" → 补
- 没查 `_index.md` 就开始诊断 → 退回查
- 调研结束没归档到 `memory/` + 没更新 `_index.md` → 补归档

**新增 5 项**(v3):
- 报告缺序章"为什么用这六个框架" → **补**(铁律 9)
- 任一节缺"框架解释" → **补**(铁律 10)
- 任一节缺对应的标准可视化(Mermaid / Heatmap / 决策树)→ **补**(铁律 11;见 docs/visualization-templates.md)
- 归档只有 `.md` 没有 `.pdf` → 用 tools/md2html.ps1 或 tools/md2pdf.sh 补出 PDF
- 报告出现缩写未在首处展开 / 缺附录 G 术语表 → **补**(铁律 12)

## 路径配置

skill 默认读 `USER_DATA_PATH = ~/.company-diagnosis/`，对照各平台实际路径如下：

| 平台 | 实际路径 |
|---|---|
| Linux / macOS / WSL | `~/.company-diagnosis/` |
| Windows(原生 PowerShell / cmd) | `C:\Users\<用户名>\.company-diagnosis\` |
| 容器 / 服务器自定义挂载 | 由部署者决定，覆盖此变量即可 |

所有 skill 内部对使用者数据的读写都走这个路径。

> **Windows 提示**:不要用 Git Bash 的 `~` 解析，因为 Git Bash 的 `~` 是 `C:\Users\<用户名>`，但调用 PowerShell / cmd 时不会自动展开。直接写绝对路径最稳。
