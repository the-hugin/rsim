# RSIm — Recursively Self-Improving Module

> Persistent memory and a structured improvement loop for Claude Code.
> The more you use it, the smarter your Claude gets — at your specific stack, your projects, your patterns.

---

## The problem it solves

Every Claude session starts from zero. You re-explain context. You re-discover solutions you found last week. You hit the same walls. The model is capable, but it doesn't remember.

RSIm fixes this — not by changing the model, but by giving it a place to remember.

It's a structured directory (`~/.claude/`) that persists between sessions and a cycle (reflect → improve) that makes that directory richer after every session you close. No infrastructure. No vector databases. No API keys beyond what you already have. Just files, a few slash commands, and a loop that compounds.

---

## How it works

RSIm externalizes Claude's memory into four layers:

| Layer | Location | What it stores |
|-------|----------|----------------|
| Episodic — failures | `memory/episodic/failures/` | What broke, why, and how to avoid it next time |
| Episodic — heuristics | `memory/episodic/hard-problems.md` | Solutions to specific problems you actually hit |
| Episodic — patterns | `memory/episodic/best-practices.md` | What worked and is worth repeating |
| Semantic | `memory/semantic/patterns.md` | Distilled timeless rules, no dates, no project names |
| Procedural | `skills/[name]/SKILL.md` | How Claude does specific tasks — improvable via `/improve` |

At the start of each session, Claude checks these layers against your current project's stack tags and surfaces relevant context in one line each — without flooding the context window.

After each session, `/reflect` writes a structured review. After you fill in a correction, `/improve` proposes targeted changes — new memory entries (L1) or skill workflow updates (L2) — one at a time, with your explicit approval on each.

That's the loop:

```
/intake  →  work  →  "done"  →  /reflect  →  fill correction  →  /improve
    ↑_______________________________________________________________|
```

---

## What you get after a few weeks

- Claude remembers that your FastAPI app uses a non-standard auth pattern — without you explaining it again
- Before touching auth code, it surfaces the failure record from three sessions ago: *"JWT decode fails silently if SECRET_KEY is missing — always validate env at startup"*
- Skills you use often have been tuned to how you actually work, not how they were when you installed them
- Your semantic patterns file contains distilled principles Claude extracted from your own experience — things like *"in this stack, optimistic UI updates reliably reduce perceived latency but require explicit rollback handling"*

None of this is magic. It's structure. Files that persist, a loop that writes to them, and a human (you) who approves every change.

---

## Install

**Unix / macOS / WSL**
```bash
curl -fsSL https://raw.githubusercontent.com/the-hugin/rsim/main/install.sh | bash
```

**Windows PowerShell**
```powershell
irm https://raw.githubusercontent.com/the-hugin/rsim/main/install.ps1 | iex
```

The installer backs up your existing `~/.claude/` first, then installs skills and commands. Your existing memory files are never overwritten.

After install, start your first project:
```
/intake
```

---

## Requirements

- [Claude Code](https://claude.ai/code)
- [gh CLI](https://cli.github.com/) + `gh auth login` — only needed for `/rsim-export` and `/rsim-sync`

---

## Daily workflow

| When | Command | What happens |
|------|---------|--------------|
| New project | `/intake` | Sets up project `CLAUDE.md`, Claude learns your stack |
| End of session | say `"done"` | `/reflect` triggers automatically — structured session review |
| After reflect | fill correction in `reflection.md`, then `"improve"` | Claude proposes memory + skill updates, you approve each |
| Weekly | `/rsim-sync` | Pull skill updates from this repo |
| When you've improved things | `/rsim-export` | Contribute your skill changes back via PR |

---

## What's included

**30+ skills** covering the full development lifecycle:

- **Cycle** — `intake`, `reflect`, `improve` (the core loop)
- **Security** — `differential-review`, `insecure-defaults`, `rsim-security-scan`
- **Backend** — `backend-code-review`, `postgres-patterns`, `python-patterns`, `docker-patterns`, `docker-deploy`
- **Frontend** — `frontend-design`, `ui-ux-pro-max`, `design-master`
- **Data** — `data-analyst`, `data-storytelling`, `kpi-dashboard-design`
- **Domain** — `electron-dev`, `web-scraper`, `searxng-search`, `api-endpoint-probe`
- **Meta** — `project-planner`, `multi-agent-patterns`, `strategic-review`, `fact-checker`
- **Federation** — `rsim-export`, `rsim-sync` (share improvements, pull updates)

**14 slash commands** — `/reflect`, `/improve`, `/intake`, `/rsim-export`, `/rsim-sync`, `/review`, `/diff-review`, `/done`, and more.

---

## Improvement levels

Not all improvements are equal. RSIm classifies every proposed change:

| Level | What changes | Risk | Threshold |
|-------|-------------|------|-----------|
| **L1** — Knowledge | Adds to memory files | Low | Single session observation |
| **L2** — Workflow | Modifies skill behavior | High | Recurring friction (2+ sessions) |
| **L3** — Strategy | Meta-objectives | Not implemented | Requires scoring system |

L2 changes always show a ⚠️ warning. You approve every single one. The system cannot modify itself without your explicit "да" (or "yes").

---

## Privacy

RSIm keeps your personal data local:

| What | Exported? |
|------|-----------|
| `skills/` — skill definitions | ✅ Yes (universal) |
| `commands/` — slash commands | ✅ Yes (universal) |
| `memory/episodic/` — your failure history | ❌ Never |
| `memory/semantic/patterns.md` — your patterns | ⚠️ Opt-in only |
| `reflection*.md` — session reviews | ❌ Never |
| `user-preferences.md` | ❌ Never |

When you run `/rsim-export`, only skill changes go into the PR. Your personal memory stays on your machine.

---

## Documentation

| Document | Audience |
|----------|----------|
| [docs/rsim-guide.md](docs/rsim-guide.md) | You — practical usage, daily workflow, troubleshooting |
| [docs/rsim-for-ai.md](docs/rsim-for-ai.md) | Claude — technical spec, invariants, file map |
| [docs/rsim-paper.md](docs/rsim-paper.md) | Researchers — architecture, philosophical and technical limits |
| [docs/rsim-paper-ru.md](docs/rsim-paper-ru.md) | Русская версия исследовательской статьи |

---

## Contributing

Found a skill improvement that works well for you? Share it:

```
/rsim-export
```

This reads your `skills/changelog.md` since your last export, packages changed skills, and opens a PR here. A security scan runs on every file before it leaves your machine. Your memory stays private.

To pull merged contributions:

```
/rsim-sync
```

This downloads the latest release, shows you each change as a diff, and lets you approve or skip individually. Nothing applies without your review.

---

## Philosophy

RSIm is based on a simple observation: the bottleneck isn't Claude's capability — it's the lack of continuity between sessions. A senior engineer gets better at your codebase over time. Claude resets. RSIm is an attempt to build that continuity from the outside, using the only thing that persists: files.

The improvement loop is deliberately human-supervised. Every change proposed by `/improve` requires explicit approval. The system can improve the rules it uses for improving itself — but only when you say yes. That's the design. Not because Claude can't be trusted, but because the human correction string is the highest-quality signal in the loop.

For the full technical treatment — limitations, related work, architectural decisions — see [docs/rsim-paper.md](docs/rsim-paper.md) (or the [Russian version](docs/rsim-paper-ru.md)).

---

*RSIm v1.0 — 2026*
