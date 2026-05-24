---
name: integration-router
description: Use whenever user starts development work — building, implementing, fixing, debugging, shipping, deploying, or refactoring features. Orchestrates the GSD (planning) → Superpower (execution) → GStack (quality gates) workflow. Cross-agent compatible (Claude Code, Gemini, OpenCode, Codex, Cursor, Windsurf).
metadata:
  version: 1.0.0
  type: orchestration
---

# Integration Router — GStack × GSD × Superpower

> **Golden Rule:** GSD decides WHAT & WHEN. Superpower executes HOW. GStack verifies IF CORRECT.

When this skill activates, **do not just answer** — first decide which lane the work belongs to using the matrix below, then route to the appropriate command/skill. Announce briefly: `[integration-router] routing → <command>`.

## Decision Matrix

| User intent | Lane | First action |
|-------------|------|--------------|
| "buat fitur X" / "build feature X" / "implementasi X" | NEW_WORK | `/gsd-plan-phase` (or `/gsd-new-project` if no `ROADMAP.md`) |
| "fix bug" / "debug" / "perbaiki" | DEBUG | `superpowers:systematic-debugging` → `/qa` |
| "lanjutkan task" / "continue work" / "next step" | RESUME | `/gsd-progress --next` |
| "review code" / "audit" | REVIEW | `/review` or `/gsd-code-review` |
| "test" / "qa" / "verify behavior" | VERIFY | `/qa` (test+fix loop) or `/qa-only` (report only) |
| "ship" / "deploy" / "merge" / "rilis" | SHIP | `/ship` then `/land-and-deploy` |
| "save progress" / "pause" | CHECKPOINT | `/context-save` or `/gsd-pause-work` |
| "resume session" / "lanjut dari kemarin" | RESTORE | `/context-restore` → `/gsd-progress --forensic` |
| "quick task" (<30min, no plan needed) | QUICK | `/gsd-quick` |
| "what's the plan?" / "progress?" | STATUS | `/gsd-progress` |

If intent unclear → ask one short clarifying question before routing.

## Phase Gate (the canonical flow)

For any NEW_WORK lane, enforce this sequence. **Do not skip gates** unless user explicitly waives.

```
Pre-execution:
  [ ] /gsd-plan-phase            → generate PLAN.md
  [ ] /autoplan                  → multi-perspective review (optional but recommended)

Execution:
  [ ] superpowers:subagent-driven-development   → execute PLAN.md task-by-task
      (or superpowers:executing-plans for fast path)

Per-milestone gates:
  [ ] /qa                        → behavioral test
  [ ] /review                    → diff review
  [ ] /gsd-verify-work           → UAT confirmation

Exit gate:
  [ ] /ship                      → create PR + CHANGELOG
  [ ] /context-save              → archive session state
```

## Anti-Patterns (refuse or warn)

| Pattern | Why bad | Counter-move |
|---------|---------|--------------|
| Execute code without `PLAN.md` | Scope creep, untracked work | Run `/gsd-plan-phase` first |
| Skip `/qa` because "I'm sure" | Production regression risk | `/qa` is a mandatory pre-ship gate |
| End session without `/context-save` | Lost context, duplicate work next time | Always `/context-save` |
| Phase without exit criteria | Phase never finishes | Define `/gsd-verify-work` criteria in PLAN.md |
| Mix planning + execution in one session | Cognitive overload, plan unsaved | Plan session → save → execute session |

## Activation Hint

When the [integration-router] hook injects `[integration-router] Dev intent detected → recommended flow: ...` into the user's prompt, that is **deterministic** — treat it as a hard prompt to consult this matrix. Do not ignore it.

When you (the model) auto-invoke this skill via description matching, that is **judgment-based** — still consult the matrix.

## Skill Routing Cheatsheet (copy to AGENTS.md)

```markdown
## Skill Routing — Integration

### GSD (Planning & Tracking)
- New project              → /gsd-new-project
- Plan a phase             → /gsd-plan-phase
- Progress / next step     → /gsd-progress --next
- Quick task               → /gsd-quick
- Pause work               → /gsd-pause-work
- Resume                   → /gsd-resume-work

### Superpower (Execution)
- Execute PLAN.md          → superpowers:subagent-driven-development
- Fast execution           → superpowers:executing-plans
- Debug a bug              → superpowers:systematic-debugging
- Brainstorm new idea      → superpowers:brainstorming
- TDD                      → superpowers:test-driven-development

### GStack (Quality Gates)
- Investigate              → /investigate
- QA (test + fix)          → /qa
- QA only (report)         → /qa-only
- Code review              → /review
- Design review            → /design-review
- Auto-review              → /autoplan
- Ship                     → /ship
- Deploy                   → /land-and-deploy
- Save context             → /context-save
- Restore context          → /context-restore
```

## Self-Check Before Routing

Ask yourself:
1. Does a `ROADMAP.md` / `PLAN.md` exist in this repo? → if no and intent is NEW_WORK, start with `/gsd-new-project` or `/gsd-plan-phase`
2. Is there uncommitted work blocking the new task? → propose `/context-save` first
3. Is the user under time pressure / explicitly asking for quick? → route via `/gsd-quick`
4. Is this a multi-day project? → use Phase Gate pattern fully

When in doubt, prefer running the planning lane (`/gsd-plan-phase`) — cost is low, benefit is large.
