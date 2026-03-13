# Cross-Cutting Principles

> Mandatory checklist applied to ALL skills — at creation, at update, and at delivery.
> When a new principle is discovered → add here → propagate to affected skills.
> Read by: `skill-creator`, `improve`, `reflect`.

---

## Skill Frontmatter Schema (RSIm)

Every `SKILL.md` must have a YAML frontmatter block. Required fields:

```yaml
---
name: skill-name                    # kebab-case, matches directory name
group: cycle|security|domain|design|deploy|system
triggers:                           # keywords for Rule 4 dispatch (empty list if called explicitly)
  - "keyword or phrase"
output: "what this skill produces"  # file path, report type, or action description
calls: []                           # other skill names this skill invokes
---
```

**Group values:**
- `cycle` — meta-loop skills: intake, reflect, improve
- `security` — security auditing: differential-review, insecure-defaults, backend-code-review
- `domain` — specialized dev skills: data-analyst, electron-dev, web-scraper, etc.
- `design` — UI/design: design-master, ui-ux-pro-max, frontend-design
- `deploy` — infrastructure: docker-deploy, vps-verify
- `system` — RSIm maintenance: rsim-export, rsim-sync, skill-generator, etc.

**Triggers field:**
- Rule 4 skills: list their Rule 4 keywords here (source of truth for dispatch table)
- Meta-cycle skills (intake/reflect/improve): empty list `[]` — invoked by Rule 2/3, not Rule 4
- System skills: empty list — called explicitly

**When creating a new skill via `/improve`:**
1. Fill all frontmatter fields
2. If triggers is non-empty → show diff to add row to Rule 4 in CLAUDE.md

---

## How to use

**When creating a skill:** Verify the new SKILL.md satisfies every principle below.
**When improving a skill:** Check if the improvement violates any principle.
**When delivering skill output:** Pre-flight — re-read relevant principles before output.

---

## Principles

### P1 — Show plan before executing

For any multi-step task: show the plan first, wait for confirmation before starting.
- Exception: trivial single-step actions (one file edit, one command)
- Format: numbered list of steps with expected output per step

### P2 — Confirm before irreversible actions

Before: deleting files, overwriting content, git push, sending external requests, modifying shared state.
- State what will happen, ask "продолжить?" or equivalent
- One confirmation per session scope — not per individual action within the same confirmed task

### P3 — Pre-flight verification

Every skill with explicit rules must re-read its own ## RULES and ## CHECKLIST before delivering output.
- Fix violations before delivery — never deliver and note issues afterward
- If violation cannot be fixed → tell user why and what's missing

### P4 — Single responsibility

One skill = one clear responsibility. If a skill needs to do two unrelated things → split into two skills.
- Test: can you describe the skill in one sentence without "and"?
- Exception: meta-skills (reflect, improve) that orchestrate other skills by design

### P5 — Fail loudly, not silently

If a skill cannot complete its task: say so immediately, explain why, suggest next step.
- Never produce partial output without marking it as partial
- Never skip a step without stating it was skipped and why

### P6 — Update project files after significant actions

After completing a meaningful step in a project context:
- Task done → mark `- [x]` in `plan.md` (active phase)
- Phase done → update phase status in `plan.md` frontmatter + header
- Session milestone → add entry to LOG in `CLAUDE.md`
- Discovered issue → add to `ISSUES:` in `CLAUDE.md`
- Skip only if no project CLAUDE.md / plan.md exists

### P7 — Applicability Check before implementing

Before implementing any external feature, idea, or pattern:
1. Does it change actual behavior in our system — or is it just documentation?
2. Does it integrate with existing architecture without adding dead weight?
3. Is it actionable now — or better deferred until a real use case appears?

If all three pass → implement.
If any fails → record the insight (best-practices.md) but don't implement.

### P9 — Ask on External Access Failure

When a URL returns an error (403, 404, timeout) on the first attempt:
- Do NOT try alternative approaches autonomously (different raw paths, API endpoints, Python workarounds, encoding fixes, etc.)
- Immediately ask the user: "URL недоступен ([код]). Пришлите файл напрямую или рабочую ссылку."
- Exception: one obvious fallback is acceptable (e.g., http → https upgrade), but if that also fails → stop and ask.

Rationale: autonomous retries on blocked URLs burn tokens without guaranteed success. The user knows the source better than the agent.

---

### P8 — Documentation: English, YAML, Progressive Context

**Language:** All documentation (SKILL.md, CLAUDE.md, plan.md, reflection.md, memory files) is written in English. Russian only where the user explicitly writes it (user-facing strings, quotes, correction strings).

**YAML where appropriate:** Use YAML for structured metadata and key-value state (frontmatter, config, status fields). Use prose only for human-readable explanations and step descriptions. Rule of thumb: if a field will be read programmatically → YAML. If it's instructions → prose.

**Progressive context:** Structure documents dense-first, detail-second:
- Most critical info at the top (QUICK CONTEXT, frontmatter, summary line)
- Details follow in predictable sections
- Claude reads top-down: if context window is limited, the top must be self-sufficient
- Applied to: CLAUDE.md (QUICK CONTEXT → details), plan.md (frontmatter → phases), reflection.md (YAML header → analysis), SKILL.md (frontmatter → process → rules → checklist)

---

## Changelog

| Date | Principle | Change |
|------|-----------|--------|
| 2026-03-11 | P1–P6 | Initial set created |
| 2026-03-11 | P7 | Applicability Check — из строки коррекции |
| 2026-03-12 | P6 | Обновлён: CLAUDE.md → plan.md + CLAUDE.md (разделение ответственности) |
| 2026-03-12 | P8 | Добавлен: English docs, YAML where appropriate, Progressive Context |
| 2026-03-13 | P9 | Добавлен: Ask on External Access Failure — не перебирать альтернативы, просить файл |
