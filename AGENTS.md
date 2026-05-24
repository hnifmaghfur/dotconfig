# AGENTS.md — dotconfig

Repository: personal dotfiles + AI agent integration skills.

## Active Integration

GStack × GSD × Superpower auto-routing is **enabled** for this repo.

<!-- integration-router:auto -->
- **Router skill**: [`ai-skills/skills/integration-router/SKILL.md`](ai-skills/skills/integration-router/SKILL.md)
- **Installer**: `bash ai-skills/install-integration.sh` (idempotent)
- **Spec**: [`docs/superpowers/specs/2026-05-24-integration-router-design.md`](docs/superpowers/specs/2026-05-24-integration-router-design.md)

When the user starts dev work (build / fix / ship / refactor), consult the router matrix in the skill above before answering. For Claude Code sessions, the `UserPromptSubmit` hook will inject a routing hint automatically.

## Skill Routing — Quick Reference

| Lane | First action |
|------|--------------|
| New feature | `/gsd-plan-phase` then `superpowers:subagent-driven-development` |
| Bug fix | `superpowers:systematic-debugging` then `/qa` |
| Quick task (<30min) | `/gsd-quick` |
| Resume work | `/gsd-progress --next` |
| Code review | `/review` or `/gsd-code-review` |
| Ship to prod | `/qa` → `/review` → `/ship` → `/land-and-deploy` |
| Save / restore session | `/context-save` / `/context-restore` |

Full matrix: see [integration-router SKILL](ai-skills/skills/integration-router/SKILL.md#decision-matrix).

## Repo Conventions

- This repo's primary working dir is `/home/nadhifa/dotconfig`
- `~/.zshrc` is a symlink to `zsh/zshrc` — edit the symlink target, never the link
- `ai-skills/` holds cross-agent skills + installer; treat as source-of-truth, hooks are copied to `~/.claude/hooks/` by the installer
- Specs live in `docs/superpowers/specs/`, plans in `docs/superpowers/plans/`
