# AI Skills Installer

Install AI agent productivity skills across all detected coding agents.

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

### Via main install.sh

The main installer auto-discovers `ai-skills` as a component:

```bash
# Install everything (interactive menu)
./install.sh

# Or select ai-skills from the menu
```

### Direct usage

```bash
# Auto-detect all agents and install skills
./ai-skills/install.sh

# Preview without making changes
./ai-skills/install.sh --dry-run

# List detected agents
./ai-skills/install.sh --list

# Skip rtk
./ai-skills/install.sh --skip-rtk
```

## Manual Steps

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

**Permission denied?**
Make sure the script is executable: `chmod +x ai-skills/install.sh`
