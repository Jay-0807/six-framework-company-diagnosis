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

## 8 条铁律

继承 baseline 测试发现的 LLM 7 类失败模式（详见 baseline-test-results.md）：

1. **顺序不可乱**：PEST → 五力 → 7S → VRIO → 价值链 → SWOT。前一步是后一步的输入。
2. **因果链显式**：SWOT 每条标 `[来源: 框架-子项]`，禁止凭空。
3. **VRIO 走 V→R→I→O 决策树**，结论落在 `{劣势 / 对等 / 暂时优势 / 未利用 / 持续优势}` 之一，**禁用"高/中/低"**。
4. **7S 必须做 7×7 对齐矩阵** + 错配清单。
5. **价值链按 Porter 9 活动**（5 主 + 4 辅）+ 毛利贡献 + cost/diff 类型 + vs 竞品。
6. **每条洞察带证据标签**：`[公开数据] / [行业共识] / [需验证] / [推断]`。全文 `[公开数据]` ≥ 5。
7. **以 TOWS 矩阵 + 一句战略建议收束 SWOT**。

新加（v2，多使用者公共化的产物）：

8. **必须有第七节"对使用者商业路径的启示"**：把诊断反哺回使用者 user-profile。否则只是研报，不是咨询。

## 调用流程（v2）

```
用户：用六框架分析 X 公司
  ↓
Step 0：检查 ~/.company-diagnosis/user-profile.md
  ├─ 不存在 → 走 onboarding-guide.md，收集使用者商业路径
  │           收集完才能继续诊断（禁止跳过）
  └─ 存在  → 读入作为诊断锚点
  ↓
Step 1：估算 X 公司的 4 维 tag（行业 / 规模 / 商业模式 / 目标客户）
  ↓ 读 ~/.company-diagnosis/memory/_index.md
  ├─ 找到至少 2 维 tag 重合的历史调研 → 报告头部加"相关历史调研"段
  └─ 无相似 → 跳过
  ↓
Step 2：按 source-policy.md + ~/.company-diagnosis/source-allowlist.local.md 决定信源范围
  ↓
Step 3：执行 PEST → 五力 → 7S → VRIO → 价值链 → SWOT 六节（按铁律 1-7）
  ↓
Step 4：第七节"对使用者商业路径的启示"（铁律 8）
  ├─ 直接借鉴：X 公司哪些能力 / 策略可被使用者借鉴
  ├─ 主动避免：X 公司哪些失误应规避
  ├─ 验证 / 挑战：对照使用者商业纪律 + 路线图 + 关键不确定性，标 ✅ / ⚠️ / ❓
  └─ user-profile 更新建议：具体到字段级
  ↓
Step 5：归档
  ├─ 报告写入 ~/.company-diagnosis/memory/<公司>-<YYYY-MM-DD>.md
  ├─ 在 _index.md 追加一行（含 4 维 tag + 30 字关键洞察）
  └─ 询问使用者：是否要根据本次发现更新 user-profile.md？
```

## 文件导航

| 想知道 | 看哪个 |
|---|---|
| 每个框架的检查清单 + 评分锚点 + SWOT 传递规则 | framework-checklists.md |
| 报告 Markdown 模板（7 节 + 附录） | output-template.md |
| 首次调用怎么收集使用者数据 | onboarding-guide.md |
| 商业路径规划模板（让使用者填什么） | user-profile-template.md |
| 记忆系统规范（索引格式 + 归档约定 + 检索规则） | memory-spec.md |
| 信源白 / 黑名单 + 三层评分 | source-policy.md |
| 推荐对接的 MCP / skill 清单 + 中文缺口 | source-skills-registry.md |
| Baseline 测试记录（为什么有这些铁律） | baseline-test-results.md |
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

## 路径配置

skill 默认读 `~/.company-diagnosis/`（适配 Linux/macOS/腾讯云轻量服务器等 *nix 环境）。

如果你的 hermes 部署在别的环境（Windows / 容器 / 自定义挂载路径），改这一个变量即可：

```
USER_DATA_PATH = ~/.company-diagnosis/
```

所有 skill 内部对使用者数据的读写都走这个路径。
