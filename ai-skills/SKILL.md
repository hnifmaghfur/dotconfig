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
4. **Summarize** what was installed and note any manual steps or restarts required.

## Dependencies Check

Before installing, ensure the following are available. If missing, tell the user to install them first.

- `git`
- `curl`
- `npx` (Node.js/npm) — required only for get-shit-done
- `bun` — required for gstack setup (auto-installed by gstack setup if missing)

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
