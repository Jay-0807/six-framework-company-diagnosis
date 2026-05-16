# Changelog

## v3.2 (2026-05-16) — Workspace 卫生 + 仓库重命名

- **新增铁律 13**:Workspace 不留痕——所有报告产物(md / pdf / 截图 / 中间 HTML)强制归档到 `~/.company-diagnosis/memory/`,**任何**临时文件不允许留在使用者当前工作目录或 skill 仓库目录
- 流程 Step 6 加显式"工作目录清扫"步骤 + 自检
- 红旗清单新增:"任务结束工作目录还有本次诊断产物" = 必须清理
- 仓库重命名 `six-framework-company-diagnosis` → `firefly-six-framework-company-diagnosis`(README / SKILL.md `name:` 字段 / LICENSE 同步)

## v3.1 (2026-05-16) — 目录结构整理

- 9 个规范文档全部从根目录移到 `docs/` 子目录,根目录从 13 文件压到 4 文件
- `framework-checklists.md` 顺手简化命名为 `frameworks.md`
- SKILL.md / README.md 里所有交叉引用路径全部更新到 `docs/xxx.md`
- 无功能变化,纯结构整理

## v3 (2026-05-15) — 方法论可读性 + 可视化 + 工具链

### 新增 4 条铁律(9-12)

- **铁律 9**:报告首页必须有"序章:为什么用这六个框架"——一句话回答 + 6 框架能力分工表 + Mermaid 流程图 + 顺序为什么不能乱
- **铁律 10**:每个框架节正文前必须有"框架解释(2-3 句话)"——说清楚这个框架是什么、反映什么问题、在六框架体系中的角色
- **铁律 11**:每节必须嵌入对应的标准可视化(PEST 强度条 / 五力雷达 / 7S Heatmap / VRIO 决策树 / 价值链 Porter 图 / SWOT 2×2 / 第七节 mindmap+gantt)
- **铁律 12**:缩写必须自解释——首次出现处展开 + 报告末尾附录 G「术语 & 缩写表」

### Onboarding 改造

- Block 1 拆成 1a 行业先行 / 1b 商业模式自适应 / 1c 一句话业务(修掉默认 SaaS 偏见)
- 新增 Block 0 "本次诊断聚焦问题"(必填,第七节会逐问回答)
- Block 3 红线允许自动推导(降低 onboarding 门槛,推导版标 `[v0.5-推导]`,首次诊断后让使用者拍板升级 `[v1-用户确认]`)

### 新增

- `visualization-templates.md`:每个框架的标准 Mermaid 模板 + 颜色规范 + 自检清单
- `tools/md2html.ps1`(Windows):自实现 MD→HTML 解析器
- `tools/md2pdf.ps1`(Windows):MD→PDF 一键转换(Chrome headless + mermaid.js)
- `tools/md2pdf.sh`(macOS / Linux):pandoc + weasyprint / wkhtmltopdf / Chrome 三套 fallback
- `tools/README.md`:工具链使用文档

### 改造

- 归档约定:`memory/<公司>-<日期>.md` + `.pdf` **双份**(铁律 11 强制)
- 跨平台路径表(Linux / macOS / Windows)
- 报告附录加 "G. 术语 & 缩写表" 模板(22 个标准缩写)
- `output-template.md` 每节增加"框架解释"段
- `framework-checklists.md` 每个框架加"读法说明"

## v2 (2026-05-11)

- 多使用者通用版(去除单使用者硬编码)
- 新增第七节"对使用者商业路径的启示"(诊断反哺 user-profile)
- 新增长期记忆:`~/.company-diagnosis/memory/` + 4 维 tag 索引
- 新增 onboarding 流程
- 新增信源治理(三层评级 + 4 种证据标签)
- 新增 MCP / skill registry

## v1

- 初版六框架诊断,8 条铁律(顺序 / 因果链 / VRIO 决策树 / 7×7 矩阵 / 价值链 9 活动 / 证据标签 / TOWS + 战略建议 / 第七节反哺)
