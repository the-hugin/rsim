# Skills Index

> Registry of all system skills. Lives in `~/.claude/skills/` — works across all projects.
> Updated by Improve Skill after each reflect → improve cycle.
> **Rule:** before creating a new skill — check this file for duplicates.

---

## Group: Cycle (Meta-Loop)

> Three skills forming the self-improving loop. Run in this order.

| # | Skill     | Purpose                                   | Tags           | Uses | Status   |
|---|-----------|-------------------------------------------|----------------|------|----------|
| 1 | `intake`  | Project onboarding → filled CLAUDE.md     | meta, start    | 0    | ✅ Ready |
| 2 | `reflect` | Session analysis → reflection.md          | meta, loop     | 9    | ✅ Ready |
| 3 | `improve` | Update skills from reflection.md          | meta, loop     | 6    | ✅ Ready |

```
Flow: intake → [work] → reflect → [correction string] → improve → updated skills
```

---

## Group: System (Meta-Tools)

> Skills for maintaining the skill system itself.

| Skill           | Purpose                                  | Tags         | Uses | Status   |
|-----------------|------------------------------------------|--------------|------|----------|
| `skill-creator` | Create a new skill from template         | meta, tools  | 0    | ✅ Ready |

---

## Group: Security

> Specialized skills for security auditing. Adapted from Trail of Bits methodology.

| Skill | Purpose | Tags | Uses | Status |
|-------|---------|------|------|--------|
| `differential-review` | Security review of PR/diff: blast radius, adversarial modeling, 7-phase workflow | security, review | 0 | ✅ Ready |
| `insecure-defaults` | Find fail-open vulnerabilities: weak env var defaults, hardcoded creds, weak algorithms | security, config | 0 | ✅ Ready |

---

## Group: Domain

> Specialized skills for specific development task types.

| Skill                 | Purpose                                               | Tags              | Uses | Status   |
|-----------------------|-------------------------------------------------------|-------------------|------|----------|
| `backend-code-review` | Backend code review for quality and security          | code, review      | 0  | ✅ Ready |
| `design-master`       | Unified mega-skill: landing, dashboard, poster, interactive — with quality gate | code, ui, design | 1 | ✅ Ready |
| `frontend-design`     | Create production-grade interfaces                    | code, ui          | 0  | ✅ Ready |
| `ui-ux-pro-max`       | 67 styles, 96 palettes, 57 fonts, design system generator | code, ui, design | 0 | ✅ Ready |
| `electron-dev`        | Desktop apps with Electron + React + Vite             | code, desktop     | 0  | ✅ Ready |
| `data-analyst`        | SQL, pandas, statistical data analysis                | data, sql         | 0  | ✅ Ready |
| `web-scraper`         | Scraping + anti-bot/Cloudflare bypass via Scrapling   | data, scraping    | 0  | ✅ Ready |
| `postgres-patterns`   | PostgreSQL indexing, RLS, diagnostics + Drizzle ORM (schema, queries, TypeScript) | data, sql, drizzle | 0 | ✅ Ready |
| `kpi-dashboard-design`| KPI framework, SQL for MRR/retention, Streamlit       | data, analytics   | 0  | ✅ Ready |
| `data-storytelling`   | Setup→Conflict→Resolution data narrative framework    | data, presentation| 0  | ✅ Ready |
| `python-patterns`     | Pythonic idioms, type hints, EAFP, tooling (Black/Ruff/MyPy) | code, python | 0  | ✅ Ready |
| `docker-patterns`     | Multi-stage builds, volumes, networking, container security | code, docker  | 1  | ✅ Ready |
| `academic-researcher` | Literature reviews, paper analysis, citation formatting | research, docs   | 0  | ✅ Ready |
| `fact-checker`        | Evidence-based claim verification, TRUE→UNVERIFIABLE scale | research      | 0  | ✅ Ready |
| `ui-component-library`| HTML/CSS/JS component catalog for dashboard projects  | code, ui          | 0  | ✅ Ready |
| `doc-creator`         | Create documents/guides from sources (PDF, DOCX, site) | code, docs       | 0  | ✅ Ready |
| `extract-brand-palette`| Extract brand hex palette from image-based PDF/PNG  | data, pdf         | 0  | ✅ Ready |
| `api-endpoint-probe`  | Reconnaissance of API endpoint params (filters, pagination, limits) | data, api | 0 | ✅ Ready |
| `vps-verify`          | Post-deploy verification: HTTP status + HTML elements → pass/fail table | deploy, infra | 2 | ✅ Ready |
| `docker-deploy`       | Full deploy cycle for baked-image Docker projects: sync → build → up → verify code → health | deploy, infra | 0 | ✅ Ready |
| `sales-guide`         | Onboarding and creation of product/portfolio guides from documents | docs, sales | 0 | ✅ Ready |

---

## Group: Search & Data

| Skill            | Purpose                                   | Tags          | Uses | Status   |
|------------------|-------------------------------------------|---------------|------|----------|
| `searxng-search` | Web search via local SearXNG instance     | search, data  | 0    | ✅ Ready |

---

## Group: Automation

| Skill                    | Purpose                                      | Tags               | Uses | Status   |
|--------------------------|----------------------------------------------|--------------------|------|----------|
| `hooks-automation`       | Automation via Claude Code hooks + MCP       | automation, tools  | 0    | ✅ Ready |
| `configure-notifications`| Configure notifications (Telegram, Discord, Slack) | automation, tools | 0 | ✅ Ready |

---

## Group: Federation (Distributed RSIm)

> Skills for RSIm cross-user enrichment via GitHub.

| Skill | Purpose | Tags | Uses | Status |
|-------|---------|------|------|--------|
| `rsim-export` | Package RSIm improvements and publish to GitHub | meta, federation | 0 | ✅ Ready |
| `rsim-sync` | Pull RSIm skill updates from GitHub, preserve local memory | meta, federation | 0 | ✅ Ready |
| `rsim-security-scan` | Security patterns for incoming/outgoing content | meta, security, federation | 0 | ✅ Ready |

---

## Group: Meta

| Skill                 | Purpose                                          | Tags          | Uses | Status   |
|-----------------------|--------------------------------------------------|---------------|------|----------|
| `skill-generator`     | Create new skills with proper structure          | meta, tools   | 0    | ✅ Ready |
| `extract-errors`      | Add error codes to React projects                | code, react   | 0    | ✅ Ready |
| `multi-agent-patterns`| Orchestrate multi-agent architectures            | meta, agents  | 0    | ✅ Ready |
| `project-planner`     | Decompose projects into tasks with dependencies  | meta, planning| 0    | ✅ Ready |
| `security-baseline`   | Generate SECURITY section in CLAUDE.md           | meta, security| 0    | ✅ Ready |
| `validate-claude-md`  | Check CLAUDE.md against intake standard          | meta, quality | 0    | ✅ Ready |
| `migrate-claude-md`   | Bring old CLAUDE.md to current standard          | meta, quality | 0    | ✅ Ready |
| `strategic-compact`   | Suggest /compact at logical phase boundaries     | meta, context | 0    | ✅ Ready |
| `strategic-review`    | Strategic analysis at phase transitions: baseline → diagnosis → 5 areas → priority matrix → roadmap | meta, planning | 0 | ✅ Ready |

---

## How to invoke a skill

```
"Use skill [name]"
"@~/.claude/skills/[name]/SKILL.md"
```

Or via slash command:

| Command          | File                                      |
|------------------|-------------------------------------------|
| `/intake`        | `~/.claude/commands/intake.md`            |
| `/reflect`       | `~/.claude/commands/reflect.md`           |
| `/improve`       | `~/.claude/commands/improve.md`           |
| `/rsim`          | `~/.claude/commands/rsim.md`              |
| `/rsim-export`   | `~/.claude/commands/rsim-export.md`       |
| `/rsim-sync`     | `~/.claude/commands/rsim-sync.md`         |
| `/weekly-review` | `~/.claude/commands/weekly-review.md`     |
| `/diff-review`   | `~/.claude/commands/diff-review.md`       |

**Knowledge base files:**
- `~/.claude/memory/episodic/hard-problems.md` — hard cases journal
- `~/.claude/memory/episodic/best-practices.md` — successful patterns journal
- `~/.claude/memory/episodic/failures/` — failure memory
- `~/.claude/memory/semantic/patterns.md` — distilled semantic patterns
- `~/.claude/reflection.md` — current pending reflection (global)
- `~/.claude/reflection-*.md` — completed reflection archive

---

## How to add a new skill

1. Run `skill-creator` — it creates `~/.claude/skills/[name]/SKILL.md` from template
2. Add row to correct group above
3. Optional: create `~/.claude/commands/[name].md`

---

## Archive (deprecated skills)

| Skill | Reason | Date |
|-------|--------|------|
| —     | —      | —    |
