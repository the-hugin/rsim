# RSIm — User Guide

> **Recursively Self-Improving Module**
> Persistent memory + structured improvement loop for Claude Code.

---

## What You Get

RSIm teaches your Claude to learn from its own mistakes — across sessions.

Without RSIm, every Claude session starts from zero. You re-explain context, re-discover
the same solutions, hit the same walls. With RSIm, Claude:

- Remembers past failures and their root causes
- Carries forward patterns that worked
- Improves its own workflows based on your feedback
- Gets smarter at your specific stack with every session

The mechanism: structured files under `~/.claude/` that persist between sessions,
plus a cycle (reflect → improve) that makes those files richer over time.

---

## Requirements

- [Claude Code](https://claude.ai/code) installed and running
- [gh CLI](https://cli.github.com/) — for `/rsim-export` and `/rsim-sync` only
- `gh auth login` completed (same — only for export/sync)

---

## Install

**Unix / macOS / WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/[OWNER]/rsim/main/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/[OWNER]/rsim/main/install.ps1 | iex
```

**What happens:**
1. Backup: your existing `~/.claude/` is copied to `~/.claude-backup-YYYY-MM-DD/`
2. Install: skills, commands, and CLAUDE.md are written to `~/.claude/`
3. Memory preserved: existing `memory/` files are never overwritten

---

## Daily Workflow

### Starting a project

```
/intake
```

Run once per project. RSIm asks about your stack, goal, and constraints,
then creates a `CLAUDE.md` in your project directory. This file is the
anchor — Claude reads it at every session start.

### During work

Normal conversation. No special commands needed. Claude checks your project
`CLAUDE.md` automatically and surfaces relevant memory at session start.

At the start of each session you may see one-line reminders like:
```
Из hard-problems: [insight] — актуально для [stack]?
Из failures: [preventive_rule] — избежать повтора?
```
These are retrieved from your memory based on the current project's stack tags.

### Ending a session

Just say one of: `"всё"`, `"done"`, `"пока"`, `"закончили"`, `"на сегодня"`

RSIm triggers `/reflect` automatically. It:
1. Reviews what happened in the session
2. Rates each skill used (✅ / ⚠️ / ❌)
3. Writes a structured `reflection.md` to `~/.claude/`

### After reflect: apply improvements

1. Open `~/.claude/reflection.md`
2. Find the **correction string** field — fill it in (what to improve, what mattered)
3. Return to Claude and say: `"improve"` or `"улучшай"`

Claude reads your correction, proposes changes at two levels:
- **L1** (knowledge): adds to memory files — safe, low-risk
- **L2** (workflow): modifies skill behavior — shown with ⚠️ warning, needs careful approval

Approve each change individually. Every "да" is applied. Every "нет" is skipped.

---

## Commands Reference

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/intake` | Project setup — creates CLAUDE.md | First session of a new project |
| `/reflect` | Session review — writes reflection.md | Auto-triggered at session end |
| `/improve` | Apply improvements from reflection | After filling correction string |
| `/rsim-export` | Package skill changes → GitHub PR | After accumulating skill improvements |
| `/rsim-sync` | Pull skill updates from GitHub | Periodically to receive community updates |
| `/rsim` | Health check — verify RSIm state | When something seems off |
| `/review` | Code review for files/functions | On demand |
| `/diff-review` | Security review of diffs/PRs | On demand |
| `/done` | Mark task done + update plan.md | When using plan.md for task tracking |
| `/weekly-review` | Weekly retrospective | End of week |

---

## Memory System

### What gets remembered automatically

| What | Where | How |
|------|-------|-----|
| Session failures (❌ rating) | `memory/episodic/failures/` | `/reflect` writes automatically |
| Skill ratings | `reflection.md` | `/reflect` writes each session |

### What you add via /improve

| What | Where |
|------|-------|
| Hard problems & solutions | `memory/episodic/hard-problems.md` |
| Reusable patterns | `memory/episodic/best-practices.md` |
| Distilled generalizations | `memory/semantic/patterns.md` |
| Skill workflow updates | `skills/[name]/SKILL.md` |

### How to search your memory

Memory is grep-friendly plain text. Tag format: `**Tags:** stack / type / domain`

```bash
# Find everything related to a stack
grep -r "fastapi" ~/.claude/memory/

# Find failure records for a type
grep -r "auth" ~/.claude/memory/episodic/failures/

# Find semantic patterns by domain
grep -A10 "api" ~/.claude/memory/semantic/patterns.md
```

RSIm also surfaces memory automatically at session start via tag matching (Rule 1.5).

---

## Customizing

### Add a personal skill

```
/skill-generator
```

Or manually:
1. Create `~/.claude/skills/[name]/SKILL.md`
2. Add YAML frontmatter with `triggers:` field
3. Add a row to `~/.claude/skills/index.md`
4. Add trigger to Rule 4 dispatch table in `~/.claude/CLAUDE.md`

### Edit global rules

`~/.claude/CLAUDE.md` — Rules 0–6. Edit carefully.
Rule 4 (skill dispatch) is auto-generated from skill frontmatter — note the header warning.

### Set personal preferences

`~/.claude/user-preferences.md` — loaded silently at every session start.
Write anything: preferred language, coding style, what to avoid.

### Edit a skill's behavior

Open `~/.claude/skills/[name]/SKILL.md` and edit directly.
Or use `/improve` after a session where the skill behaved suboptimally — it will propose
a targeted edit with a diff.

---

## Sharing Improvements

After you've improved several skills via `/improve`:

```
/rsim-export
```

This:
1. Reads `skills/changelog.md` since your last export
2. Collects changed SKILL.md files
3. Asks if you want to include new semantic patterns (opt-in)
4. Creates a GitHub PR to the RSIm base repo

Your `memory/episodic/` is **never** included — it stays private.

To receive improvements from the community:

```
/rsim-sync
```

This downloads the latest release, shows you each change with a diff, and lets you
approve or skip individually. A security scan runs on every file before it's shown.

---

## Troubleshooting

**"Нет CLAUDE.md. Запустить /intake?"**
You're in a project directory without RSIm setup. Run `/intake`.

**"Есть незакрытый reflection"**
`~/.claude/reflection.md` exists from a previous session. Run `/improve` to process it,
or delete it manually if it's stale.

**`/improve` says "Строка коррекции пуста"**
Open `~/.claude/reflection.md`, find the correction field, and fill it in.
Without your correction, improve has nothing to act on.

**Skills seem stale / not updated after /improve**
Check `~/.claude/skills/changelog.md` — each improvement is logged there.
If an entry is missing, the improvement didn't apply.

**`/rsim-export` fails with "gh CLI не установлен"**
Install gh CLI: https://cli.github.com/ then run `gh auth login`.

**Memory not surfacing at session start**
Tags in your memory files must match tags in your project CLAUDE.md.
Check `**Tags:**` fields in `memory/episodic/*.md` — they use format `stack / type / domain`.
