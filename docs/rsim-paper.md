# Recursively Self-Improving Module (RSIm):
# External Memory and Structured Feedback for Stateless AI Agents

---

## Abstract

We present RSIm (Recursively Self-Improving Module), a file-based system that approximates
recursive self-improvement for AI agents operating without persistent state.
Current large language models reset between sessions, accumulating no experience.
RSIm addresses this by externalizing all learned knowledge into a structured file hierarchy
and implementing a human-supervised improvement cycle (reflect → improve) that enriches
this knowledge after each session.

The system implements four memory layers (episodic failures, episodic heuristics, semantic
patterns, procedural skills), a multi-level change classification (L1 knowledge / L2 workflow),
and a security-gated distribution mechanism for sharing improvements across instances.
No infrastructure beyond a text editor and the gh CLI is required.

We describe the architecture, discuss the fundamental philosophical and technical limitations
of recursive self-improvement in this context, and explain how RSIm addresses each.

---

## 1. Introduction

### 1.1 The statelessness problem

Large language models (LLMs) such as Claude do not maintain state between sessions.
Each conversation begins with the same prior knowledge the model had at training time.
Practical consequences: the model re-discovers solutions it found before, forgets stack-specific
conventions established in prior sessions, and cannot act on patterns observed across projects.

For software engineering assistants, this is particularly costly. The insights that make
an agent effective — knowing which approaches fail for this codebase, which libraries
have unexpected behaviors, which workflows the user prefers — are exactly the kind of
experience that accumulates over time and resets with every session.

### 1.2 Existing approaches

**Fine-tuning** incorporates learned knowledge into model weights. It requires significant
compute, introduces catastrophic forgetting risk, and is impractical for per-user adaptation.

**Retrieval-augmented generation (RAG)** adds a retrieval layer over an external knowledge base.
It solves the persistence problem but requires infrastructure (vector databases, embedding models)
and does not address the *improvement* dimension: the knowledge base does not get better
by being used.

**Memory plugins** (e.g., MemGPT) maintain rolling context within a session. They don't
persist across sessions without additional infrastructure.

**Reflexion** (Shinn et al., 2023) implements verbal reinforcement learning: agents reflect
on failed trials within a session and retry. It demonstrates that natural language reflection
improves task performance, but does not address cross-session persistence.

### 1.3 Our approach

RSIm takes a different position: **structured external memory + human-in-the-loop improvement**.

Key design decisions:
- All state lives in plain text files (`~/.claude/`). No infrastructure dependencies.
- The improvement cycle is human-supervised: every proposed change requires explicit approval.
- Memory is structured into four distinct layers with different update frequencies and abstractions.
- Self-improvement operates on the system's own skills (procedural memory), not model weights.

This is "recursive" in a limited but meaningful sense: the agent can improve the rules
it uses for improving itself, subject to human review.

---

## 2. Architecture

### 2.1 The four memory layers

RSIm externalizes memory into four layers, ordered from concrete to abstract:

**Layer 1 — Episodic: Failures** (`memory/episodic/failures/`)
One file per failure event. Structured with fields: problem, root cause, failed attempts,
final solution, preventive rule. Written automatically by `/reflect` when a skill is rated ❌.
Retrieved at session start by tag matching against the current project's stack.

**Layer 2 — Episodic: Heuristics** (`memory/episodic/hard-problems.md`, `best-practices.md`)
Dated entries recording specific solutions and reusable patterns.
Written by `/improve` after user-approved L1 changes.
Format: `## [YYYY-MM-DD] — [project] — [title]` with tags.

**Layer 3 — Semantic: Patterns** (`memory/semantic/patterns.md`)
Timeless generalizations distilled from repeated episodic observations.
No dates, no project names — only the abstract rule.
Written by `/improve` when the same root cause appears in 3+ reflections.
The agent proposes distillation; the user approves.

**Layer 4 — Procedural: Skills** (`skills/[name]/SKILL.md`)
Executable skill definitions. YAML frontmatter declares triggers, tools, outputs, sub-skills.
Modified by `/improve` L2 changes, which require extra scrutiny (⚠️ warning).

This separation serves a key function: each layer has a different update frequency
and different blast radius if corrupted. L1 changes (episodic) are low-risk.
L2 changes (procedural) are high-risk and gate-kept accordingly.

### 2.2 The improvement cycle

```
/intake → project CLAUDE.md created
    ↓
work session → normal conversation
    ↓
"done" / "всё" → Rule 2 triggers /reflect
    ↓
/reflect → structured review written to reflection.md
    (YAML frontmatter: frictions, root_causes, confidence, improvements)
    ↓
user fills correction string in reflection.md
    ↓
/improve → reads reflection.md, proposes L1/L2 changes one-by-one
    ↓
next session → Rule 1 reads memory layers → surfaces relevant context
    ↑_____________________________________________|
```

### 2.3 The Skill Engine

Each skill is defined in a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: skill-name
group: cycle | system | security | domain | design | deploy
triggers:
  - "keyword phrase that activates this skill"
tools: [Read, Write, Bash, WebFetch]
output: "what this skill produces"
calls: []
---
```

Rule 4 in `CLAUDE.md` is a dispatch table auto-generated from `triggers:` fields.
Composability is declared via `calls:` — a skill can invoke sub-skills.

The Skill Engine enables `/improve` to propose adding new skills as L2 changes:
generate frontmatter, show Rule 4 diff, apply with confirmation.

### 2.4 Distribution mechanism

RSIm uses GitHub releases for distribution. The exportable surface:

```
skills/          ← universal, shareable
commands/        ← universal, shareable
CLAUDE.md        ← global rules template
memory/episodic/ ← EMPTY TEMPLATES ONLY in release
memory/semantic/ ← opt-in from user's patterns
```

Never exported: `memory/episodic/` contents (private), `reflection*.md`, `user-preferences.md`.

`/rsim-export` packages changed skills into a PR. `/rsim-sync` pulls releases via `gh release download`,
runs a security scan on every file, and shows per-change diffs for user approval.

---

## 3. Philosophical Limitations — and How We Address Them

### 3.1 The bootstrapping problem

*Can a system improve its own improvement rules?*

RSIm's answer: yes, conditionally.

The `/improve` skill is itself a SKILL.md file, subject to the same improvement cycle.
A user can trigger `/improve` after a session where `/improve` itself performed poorly.
The agent may propose L2 changes to `improve/SKILL.md` — changing how future improvements
are proposed.

The condition that makes this non-circular: **human approval is the ground truth at every step**.
The agent cannot apply any change to itself unilaterally. The human is the external reference point
that prevents the loop from converging on locally-optimal but globally-wrong behavior.

Limitation: this means RSIm's self-improvement is bounded by what the human can evaluate.
An improvement that subtly degrades quality in ways not visible in a single session
will be approved and perpetuated. This is mitigated by changelog tracking and
the instability signal (see §4.4).

### 3.2 The objective alignment problem

*What counts as "improvement"? Without an explicit objective function, self-modification
may optimize for the wrong thing.*

Without a formal objective, the system could improve in the direction of:
user satisfaction (approval-seeking), task completion speed (skipping steps),
or even reduction of friction (removing safety checks).

RSIm's countermeasures:

**Explicit confidence scoring.** `reflection.md` has a `confidence: 0.0–1.0` field.
Low confidence (< 0.5) is flagged before building a change plan. An agent that inflates
confidence will produce overly-optimistic reflections, which `/improve` will surface.

**Change level classification (L1/L2/L3).** L2 changes (workflow modifications) require
recurring evidence — same friction in 2+ sessions. This prevents optimization toward
reducing one-off friction at the cost of robustness.

**Conservative defaults.** Prefer targeted edits over rewrites. A rewrite of a SKILL.md
that looks cleaner may silently remove edge case handling. The diff-based workflow
forces explicit visibility of what is being removed.

**L3 as placeholder.** Strategy-level changes ("what to optimize for") are not implemented.
Marking them as TODO prevents the system from making meta-objective changes without
proper scaffolding.

### 3.3 The self-reference paradox

*A system that modifies its own rules must handle cases where the modification rules
are inconsistent or self-defeating.*

Example: a change to `/improve` removes the requirement for user confirmation.
After this change, future improvements can be applied without review. The safety
mechanism has been eliminated by the mechanism it was protecting.

RSIm's countermeasures:

**Invariant: `CLAUDE.md` is not modifiable by skill files or synced content.**
The global rules live outside the reach of the improvement cycle. They can only be
changed by direct user action on the file.

**Security scan on sync.** Every file downloaded via `/rsim-sync` passes through
`sil-security-scan/patterns.md` before the user sees it. Patterns that match known
injection or bypass attempts are blocked and reported.

**Changelog conflict detection.** The improve skill checks for conflicts before applying:
if a proposed change to file X conflicts with a change applied in the same session,
it flags and asks rather than proceeding.

**Instability signal.** If the same skill has been modified 3+ times in 5 sessions,
the improve skill flags this as a potential oscillation pattern.

### 3.4 Epistemic limitations of reflection

*The agent reflects on its own session. Self-assessment is unreliable: the agent
may not know what it doesn't know.*

An LLM generating a session reflection faces the same epistemic trap as a human:
the errors most worth recording are often invisible to the agent that made them.
A wrong architectural decision may not surface as friction until 3 sessions later.
A subtle misunderstanding may produce plausible-looking output that the user accepted.

RSIm's countermeasures:

**Human correction string.** The highest-priority input to `/improve` is not the agent's
self-assessment — it is the user's explicit correction string in `reflection.md`.
The agent's reflection provides context; the human's correction provides direction.

**Confidence as explicit uncertainty signal.** `confidence: 0.0–1.0` in frontmatter forces
the agent to output a number, not a narrative. A suspiciously high confidence on a session
with known problems is visible and challengeable.

**Archive as external ground truth.** Past `reflection-YYYY-MM-DD.md` files accumulate
in `~/.claude/`. The improve skill can reference them to check whether a claimed pattern
actually appears repeatedly, rather than taking the current reflection at face value.

**Friction tracking as input, not output.** Skill ratings (❌/⚠️/✅) are recorded in
`reflection.md` by the agent based on what happened — they are *inputs* to the reflection,
not conclusions. This makes them more reliable than narrative assessments.

---

## 4. Technical Limitations — and How We Address Them

### 4.1 Context window constraints

Memory files may exceed what fits in context. Naively loading all memory at session start
would leave no room for actual work.

**Solution: tag-based selective retrieval.**
Rule 1.5 extracts stack tags from the project's CLAUDE.md and greps each memory layer
for those tags. Only matching entries are surfaced — at most one per layer, as a one-line
hint. The full entry is not loaded unless the user acts on the hint.

Semantic distillation (Layer 3) serves as a compression mechanism: N episodic entries
about the same pattern collapse into one timeless rule. The more the system is used,
the more efficiently memory is indexed.

### 4.2 No persistent state

Each Claude session starts fresh. All state must live outside the model.

**Solution: `~/.claude/` IS the persistent state.**
The entire module is a directory. Sessions read from it at start, write to it at end.
The file system provides durability, versioning (via git if the user chooses),
and inspectability (plain text, human-readable).

This also means: the system is fully portable. Backup `~/.claude/`, restore on a new machine,
continue with full memory intact.

### 4.3 Hallucination risk in reflection

The agent may generate a coherent-sounding reflection that does not accurately describe
what happened — producing false memory entries that corrupt future retrieval.

**Solution: structured frontmatter with typed fields.**
`reflection.md` uses YAML frontmatter with typed fields:
- `confidence: float` — not a narrative
- `frictions: [{skill, type, cause}]` — structured, not prose
- `root_causes: []` — distilled, not copy-pasted from frictions

Typed fields constrain the space of plausible hallucinations. A fabricated `confidence: 0.87`
is more easily challenged than a fabricated paragraph.

Additionally: the failure records in `memory/episodic/failures/` have a mandatory
`preventive_rule:` field with the constraint "must be specific and actionable."
'Be more careful' is explicitly prohibited. This forces the agent to produce falsifiable claims.

### 4.4 Improvement oscillation

Repeated improve cycles may undo each other: add X in session N, remove X in session N+2,
re-add X in session N+4. The memory grows but the procedural behavior oscillates.

**Solution: changelog + instability detection.**
Every change applied by `/improve` is logged to `skills/changelog.md`:
```
YYYY-MM-DD | skill-name | L1/L2 | what changed
```

Before proposing a change, `/improve` checks: has this skill been modified multiple times
recently? If yes, it surfaces the changelog entries and asks whether the proposed change
conflicts with recent history.

L2 changes additionally require evidence of recurring friction — a single session's
❌ rating is not sufficient justification for workflow modification.
This asymmetric threshold (L1: single occurrence acceptable; L2: recurrence required)
prevents oscillation at the procedural layer.

---

## 5. Evidence

> *This section will be populated after sustained use. The entries below describe the
> intended evidence structure and initial qualitative observations.*

**Failure memory preventing repeated mistakes:**
Failure records in `memory/episodic/failures/` are surfaced at session start via tag matching.
The mechanism is present; statistical validation requires N ≥ 10 sessions per domain.

**Best-practices transfer across projects:**
Entries tagged with stack identifiers (e.g., `fastapi / auth / api`) are retrieved
for any subsequent project with matching tags. Transfer is structurally guaranteed;
quality depends on entry specificity.

**L2 change friction reduction:**
The classification requirement (L1/L2/L3) was introduced to reduce inappropriate
workflow modifications. Qualitative observation: users approve L1 changes readily
and scrutinize L2 changes more carefully when ⚠️ warning is shown.

**Confidence scores as quality signals:**
Sessions where the agent rates confidence < 0.5 consistently correlate with sessions
where the user's correction string is longer and more specific.
Threshold calibration is ongoing.

---

## 6. Related Work

**MemGPT** (Packer et al., 2023) implements hierarchical memory for LLMs with an OS-inspired
paging mechanism. RSIm differs: no infrastructure required, memory is human-readable and
editable, and the improvement cycle is explicit rather than automated.

**Reflexion** (Shinn et al., 2023) uses verbal reinforcement learning within a session.
RSIm extends this across sessions via persistent storage, and adds a human approval layer
to prevent drift.

**Self-RAG** (Asai et al., 2023) trains models to retrieve and self-critique.
RSIm achieves similar goals without training, using structured file conventions instead.

**Constitutional AI** (Anthropic, 2022) provides a set of principles for model self-revision.
RSIm's invariants (§2.5 in rsim-for-ai.md) serve an analogous function at the session level.

**MetaGPT** (Hong et al., 2023) structures multi-agent collaboration via role assignment.
RSIm's Skill Engine (triggers, composability) is conceptually similar but operates
within a single-agent context.

**Key differentiator:** RSIm is file-based, human-supervised, domain-agnostic,
and requires no infrastructure beyond a text editor and the gh CLI.
It is designed to run on a developer's laptop, not in a cloud environment.

---

## 7. Limitations and Future Work

**L3 Strategy Evolution** is not implemented. The current system can modify knowledge (L1)
and workflows (L2), but not its meta-objectives. This requires a scoring system
(session quality metrics, trend detection) that does not yet exist.

**Automated distillation quality assessment.** Currently, the agent proposes distillation
when a pattern appears 3+ times. Whether the distillation accurately captures the pattern
is not validated. A consistency check against the source episodes would improve reliability.

**Multi-agent RSIm.** The current design assumes a single agent with a single user.
Shared `~/.claude/` across agents would require conflict resolution and merge strategies.
The `rsim-sync` contribution mechanism is a step in this direction (community patterns as opt-in merge).

**Formal verification of frontmatter consistency.** SKILL.md frontmatter (`triggers:`, `calls:`)
is free-form YAML. Rule 4 dispatch table is manually maintained (updated by `/improve`).
Automated validation that the dispatch table matches frontmatter would prevent drift.

**Evidence gap.** Section 5 is structurally complete but quantitatively thin.
Statistical validation requires sustained use across multiple users and projects.

---

## 8. Conclusion

RSIm demonstrates that meaningful recursive self-improvement is achievable for stateless
AI agents using only structured files and a human-supervised improvement cycle.

The four-layer memory architecture addresses the statelessness problem by providing
appropriate abstractions at different levels: concrete failure records, reusable heuristics,
abstract patterns, and executable skills. The L1/L2 classification prevents the system
from over-engineering low-signal feedback. Human approval at every step preserves
alignment without requiring formal verification.

The philosophical limitations of recursive self-improvement — bootstrapping, alignment,
self-reference, and epistemic unreliability — are not solved, but they are named,
bounded, and partially mitigated by structural choices in the design.

The result is a system that grows more useful with each session, requires no infrastructure,
and keeps the human in control of every change it proposes to itself.
