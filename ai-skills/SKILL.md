# AI Skills Installation Guide

> **System Prompt / Skill Reference**: Give this file to any AI Agent to bootstrap the productivity skills listed below for the detected coding agent.

## Overview

This repository installs four AI productivity skills across any detected coding agent. When asked to "install AI skills" or "set up my agent tools", read this file, detect which agent is running, and execute only the relevant sections.

## Skills Summary

| Skill | Repo | What it does |
|-------|------|-------------|
| **superpowers** | [obra/superpowers](https://github.com/obra/superpowers) | Agentic skills framework & dev methodology |
| **gstack** | [garrytan/gstack](https://github.com/garrytan/gstack) | 23 opinionated tools for AI-assisted development |
| **get-shit-done** | [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | Meta-prompting & spec-driven development |
| **rtk** | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | CLI proxy that reduces LLM token usage 60-90% |

## Detect Active Agent

Determine which agent is running this session. Use the first match:

1. **Claude Code** — environment has `claude` command and `$HOME/.claude` exists.
2. **OpenCode** — environment has `opencode` command and `$HOME/.config/opencode` exists.
3. **Codex** — environment has `codex` command and `$HOME/.codex` exists.
4. **Gemini CLI** — environment has `gemini` command and `$HOME/.config/gemini` exists.
5. **Cursor** — environment has `cursor` command and `$HOME/.cursor` exists.
6. **Windsurf** — environment has `windsurf` command.
7. **Aider** — environment has `aider` command and `$HOME/.aider` exists.
8. **Cline / Roo Code** — environment has `cline` or `roo` command.
9. **Hermes** — environment has `hermes` command and `$HOME/.hermes` exists.
10. **Kilo Code** — environment has `kilo` command and `$HOME/.kilocode` exists.
11. **GitHub Copilot CLI** — environment has `copilot` command.

If none match, report: "No supported AI agent detected. Please install Claude Code, OpenCode, Codex, Gemini CLI, Cursor, Windsurf, Cline, Hermes, Kilo Code, or Copilot CLI first."

## Install Per Skill

Execute only the skills requested by the user (default: install all).

---

### 1. Superpowers

**Claude Code**
```
/plugin install superpowers@claude-plugins-official
```
Or:
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**Codex**
```
/plugins
# Search "superpowers" → Install Plugin
```

**Gemini CLI**
```bash
gemini extensions install https://github.com/obra/superpowers
```

**OpenCode**
Fetch and follow: `https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md`

**Cursor**
```
/add-plugin superpowers
```

**GitHub Copilot CLI**
```bash
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace
```

**Other agents**: Install manually per agent's plugin system if supported, or skip with a note.

---

### 2. gstack

Requires `git` and optionally `bun` (for setup).

**Claude Code**
```bash
mkdir -p ~/.claude/skills
if [ -d ~/.claude/skills/gstack/.git ]; then
  cd ~/.claude/skills/gstack && git pull --ff-only
else
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
fi
cd ~/.claude/skills/gstack && ./setup
```

**Other agents** (OpenCode, Codex, Cursor, Windsurf, Cline, Hermes, Kilo, Gemini, Aider, Copilot):
```bash
if [ -d ~/gstack/.git ]; then
  cd ~/gstack && git pull --ff-only
else
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
fi
cd ~/gstack && ./setup --host <AGENT_NAME>
```
Replace `<AGENT_NAME>` with the detected agent: `opencode`, `codex`, `cursor`, `windsurf`, `cline`, `hermes`, `kilocode`, `gemini`, `aider`, `copilot`.

---

### 3. get-shit-done

Requires `npx` (Node.js/npm).

```bash
if command -v npx >/dev/null 2>&1; then
  npx get-shit-done-cc@latest --profile=standard --global --yes
else
  echo "npx not found. Install Node.js first: https://nodejs.org/"
fi
```

---

### 4. rtk

Optional. Skip if user says `--skip-rtk`.

**Install binary:**
```bash
if command -v rtk >/dev/null 2>&1; then
  echo "rtk already installed: $(rtk --version)"
elif command -v brew >/dev/null 2>&1; then
  brew install rtk
else
  # Security note: verify at https://github.com/rtk-ai/rtk/blob/master/install.sh before running
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
fi
```

**Initialize per detected agent:**

| Agent | Command |
|-------|---------|
| Claude Code | `rtk init -g` |
| Gemini CLI | `rtk init -g --gemini` |
| Codex | `rtk init -g --codex` |
| Cursor | `rtk init -g --agent cursor` |
| Windsurf | `rtk init --agent windsurf` |
| OpenCode | `rtk init -g --opencode` |
| Cline / Roo | `rtk init --agent cline` |
| Kilo Code | `rtk init --agent kilocode` |
| Hermes | `rtk init --agent hermes` |

**Note:** Restart the AI agent after rtk initialization to apply hooks.

---

## Full Install Workflow

When the user says "install my AI skills", run this workflow:

1. **Detect** the active agent (see "Detect Active Agent").
2. **Report** which agent was detected and which skills will be installed.
3. **Execute** the install commands for superpowers → gstack → get-shit-done → rtk (unless skipped).
4. **Run the integration auto-activation bootstrap**: `bash ai-skills/install-integration.sh` (see "Auto-activation" below).
5. **Summarize** what was installed and note any manual steps or restarts required.

## Auto-activation (integration-router)

After installing the three systems above, run the bootstrap to make the GStack × GSD × Superpower integration auto-activate per-prompt:

```bash
bash ai-skills/install-integration.sh
```

What it does:
- Installs `integration-router` SKILL into `~/.claude/skills/` (and references it from `AGENTS.md`/`GEMINI.md` for non-Claude agents).
- Installs a `UserPromptSubmit` hook into Claude Code that detects dev-workflow intents (build/fix/ship/refactor in Indonesian or English) and injects a short routing hint into the prompt context — analogous to how RTK transparently rewrites Bash commands.
- Adds `~/.claude/skills/gstack/bin` to `PATH` via `~/.zshrc`.
- Idempotent — safe to re-run.

After install: `source ~/.zshrc` then **restart the AI agent** so hooks/skills load. Test by typing "buat fitur X" — the hook should inject a routing hint that points to `/gsd-plan-phase`.

Source files:
- Skill: `ai-skills/skills/integration-router/SKILL.md`
- Hook : `ai-skills/hooks/integration-router-hook.sh`
- Spec : `docs/superpowers/specs/2026-05-24-integration-router-design.md`

### Multi-device setup

The integration is **globally installed per device** (writes to `~/.claude/`, `~/.config/`, `~/.codeium/`, etc.), not per-project. To replicate on a new device:

```bash
# 1. Clone this dotconfig repo
git clone git@github.com:hnifmaghfur/dotconfig.git ~/dotconfig

# 2. Install supported AI agents you want to use
#    (Claude Code, OpenCode, Codex, Gemini, Cursor, Windsurf, ...)

# 3. Install the underlying skills first (one-time per device)
#    See "Install Per Skill" section above.

# 4. Run integration bootstrap — auto-detects all installed agents
bash ~/dotconfig/ai-skills/install-integration.sh

# 5. Reload shell + restart your AI agent
source ~/.zshrc
```

Detected agents on this device get the integration installed automatically. Re-run after installing a new agent — the installer is idempotent.

## Dependencies Check

Before installing, ensure the following are available. If missing, tell the user to install them first.

- `git`
- `curl`
- `npx` (Node.js/npm) — required only for get-shit-done
- `bun` — required for gstack setup (auto-installed by gstack setup if missing)

## Integration: GStack + GSD + Superpower

These three systems are designed to work together. Here is how they divide responsibility and how an AI agent should orchestrate them.

### Responsibility Split

| System | Role | Question it answers |
|--------|------|--------------------|
| **GSD (get-shit-done)** | Project manager & workflow engine | "What must be done, in what order, and what is the current progress?" |
| **Superpower** | Execution engine | "How do I implement this task concretely, step by step?" |
| **GStack** | Quality gate & technical toolkit | "Does this work correctly? Is it ready to ship?" |

### Golden Rule

**GSD decides WHAT and WHEN. Superpower executes HOW. GStack verifies IF IT IS CORRECT.**
Never let Superpower run without a GSD plan. Never ship without a GStack gate.

### Ideal Workflow

```
GSD: /gsd-new-project          → Initialize ROADMAP.md + PROJECT.md
GSD: /gsd-plan-phase            → Create PLAN.md for the active phase

     ↓ (handoff to execution)

Superpower: subagent-driven-development
            → Execute PLAN.md task-by-task
            → Update checkboxes & STATE.md per task

     ↓ (every milestone or completed task)

GStack: /qa                     → Verify behavioral correctness
GStack: /review                 → Code review the diff
GStack: /design-review          → (if UI/UX involved)

     ↓ (all gates passed)

GSD: /gsd-verify-work           → Conversational UAT
GStack: /ship                   → PR, CHANGELOG, VERSION bump
GStack: /land-and-deploy        → Merge & production verification

     ↓ (before session ends)

GStack: /context-save           → Save full working state
```

### Skill Routing: When to Trigger What

Append this section to the project's `AGENTS.md` after installing skills:

```markdown
## Skill Routing — Superpower + GStack + GSD

### GSD (Planning & Tracking)
- Initialize new project               → /gsd-new-project
- Check progress & next step           → /gsd-progress --next
- Add/edit phase in roadmap            → /gsd-phase
- Create detailed phase plan           → /gsd-plan-phase
- Execute structured plan              → /gsd-execute-phase
- Pause work & handoff context         → /gsd-pause-work

### Superpower (Execution)
- Execute PLAN.md task-by-task       → superpowers:subagent-driven-development
- Quick execution (skip review)        → superpowers:executing-plans

### GStack (Quality Gates)
- Bug / unexpected behavior          → /investigate
- Test site / app behavior             → /qa (test + fix loop)
- Report bugs only (no fix)          → /qa-only
- Code review before merge             → /review
- Visual QA / polish                   → /design-review
- Auto-review pipeline                 → /autoplan
- Deploy to production                 → /ship or /land-and-deploy

### Bridge (Session Management)
- Save progress session              → /context-save
- Resume previous session            → /context-restore
```

### Handoff Patterns

#### Pattern 1: Phase Gate (Recommended)
Every GSD phase has a quality gate before advancing to the next phase.

```markdown
## Phase X: [Name]

### Pre-execution
- [ ] /gsd-plan-phase → generate PLAN.md
- [ ] /autoplan → review plan from CEO + Eng + Design + DX perspective

### Execution
- [ ] superpowers:subagent-driven-development → execute PLAN.md

### Quality Gates (per milestone)
- [ ] /qa → behavioral testing
- [ ] /review → diff review
- [ ] /gsd-verify-work → UAT confirmation

### Exit Gate
- [ ] /ship → create PR
- [ ] /context-save → archive session
```

#### Pattern 2: Continuous Checkpoint
Use when a phase spans multiple sessions.

```
Task A done → /context-save "feat/auth-login done"
Task B done → /context-save "feat/auth-logout done"
...
Phase done  → /ship + /context-save "phase-3-complete"
```

#### Pattern 3: Context Recovery
When starting a new session:

```
/context-restore              → Load last saved state
/gsd-progress --forensic      → Run integrity audit
/gsd-progress --next           → Advance to next task
```

### Anti-Patterns to Avoid

| Anti-Pattern | Risk | Fix |
|--------------|------|-----|
| Superpower executes without GSD plan | Scope creep, untracked work | Always run /gsd-plan-phase first |
| Skip /qa because "I am sure" | Production regression | /qa is a mandatory pre-ship gate |
| No /context-save before ending session | Lost context, duplicate work | /context-save at every session end |
| GSD phase without exit criteria | Phase never finishes | Define /gsd-verify-work criteria in PLAN.md |
| Mix planning & execution in one session | Cognitive overload, unsaved plan | Separate: plan session → save → execute session |

### Integration Checklist for New Repos

- [ ] Create `AGENTS.md` with skill routing rules (copy from above)
- [ ] Create `ROADMAP.md` via /gsd-new-project
- [ ] Configure continuous checkpoint: `gstack-config set checkpoint_mode continuous`
- [ ] Test end-to-end: create one small phase → plan → execute → qa → ship

---

## Quick Reference

| Agent | Superpowers | gstack Dir | rtk Init Flag |
|-------|-------------|------------|---------------|
| Claude Code | `/plugin install ...` | `~/.claude/skills/gstack` | `-g` |
| OpenCode | Fetch `.opencode/INSTALL.md` | `~/gstack --host opencode` | `-g --opencode` |
| Codex | `/plugins` UI | `~/gstack --host codex` | `-g --codex` |
| Gemini CLI | `gemini extensions install ...` | `~/gstack --host gemini` | `-g --gemini` |
| Cursor | `/add-plugin superpowers` | `~/gstack --host cursor` | `-g --agent cursor` |
| Windsurf | Manual / unsupported | `~/gstack --host windsurf` | `--agent windsurf` |
| Cline / Roo | Manual / unsupported | `~/gstack --host cline` | `--agent cline` |
| Hermes | Manual / unsupported | `~/gstack --host hermes` | `--agent hermes` |
| Kilo Code | Manual / unsupported | `~/gstack --host kilocode` | `--agent kilocode` |
| Copilot CLI | `copilot plugin install ...` | `~/gstack --host copilot` | Manual / unsupported |
| Aider | Manual / unsupported | `~/gstack --host aider` | Manual / unsupported |
