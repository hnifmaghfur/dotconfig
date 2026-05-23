# AI Skills

AI agent productivity skills reference for all supported coding agents.

## Included Skills

| Skill | Repo | What it does |
|-------|------|-------------|
| **superpowers** | [obra/superpowers](https://github.com/obra/superpowers) | Agentic skills framework & dev methodology |
| **gstack** | [garrytan/gstack](https://github.com/garrytan/gstack) | 23 opinionated tools for AI-assisted development |
| **get-shit-done** | [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | Meta-prompting & spec-driven development |
| **rtk** | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | CLI proxy that reduces LLM token usage 60-90% |

## Supported Agents

- Claude Code
- OpenCode
- Codex (OpenAI)
- Gemini CLI
- Cursor
- Windsurf
- Cline / Roo Code
- Hermes
- Kilo Code
- Aider

## Usage

### Via AI Agent Skill

Give the `SKILL.md` file to any AI Agent as a system prompt or skill reference:

```
Read ai-skills/SKILL.md and install the AI skills for the detected agent.
```

The AI Agent will auto-detect which coding agent is running and execute the relevant install instructions.

### Manual Steps

Some skills require manual interaction in the AI agent:

### superpowers

- **Claude Code**: Run `/plugin install superpowers@claude-plugins-official`
- **Codex**: Run `/plugins`, search "superpowers", select Install
- **Gemini**: Run `gemini extensions install https://github.com/obra/superpowers`
- **OpenCode**: Follow instructions from `.opencode/INSTALL.md`
- **Cursor**: Run `/add-plugin superpowers`

### gstack

Automatically cloned and set up via `./setup`. For team mode, run:
```bash
(cd ~/.claude/skills/gstack && ./setup --team)
```

### get-shit-done

Installed via `npx`. Restart your AI agent after install.

### rtk

Binary installed to `~/.local/bin`. Hooks initialized per agent. Restart agents to apply.

## Requirements

- `git`
- `curl`
- `npx` (Node.js/npm) — for get-shit-done

## Troubleshooting

**No agents detected?**
Install your preferred AI coding agent first, then re-run this installer.

**npx not found?**
Install Node.js: https://nodejs.org/

**No AI agent detected?**
Install your preferred AI coding agent first, then provide `SKILL.md` to the agent.
