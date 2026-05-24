#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

echo "Installing ai-skills integration..."

# Discover which AI agents are present. We don't install the underlying
# skills (superpowers / gstack / get-shit-done / rtk) here — those are
# installed via the agents themselves (slash commands like
# `/plugin install superpowers@...`) as documented in ai-skills/SKILL.md.
# This script only wires up the auto-activation integration.
DETECTED=()
[ -d "$HOME/.claude" ]            && DETECTED+=("claude")
[ -d "$HOME/.config/opencode" ]   && DETECTED+=("opencode")
[ -d "$HOME/.codex" ]             && DETECTED+=("codex")
[ -d "$HOME/.config/gemini" ]     && DETECTED+=("gemini")
[ -d "$HOME/.cursor" ]            && DETECTED+=("cursor")
[ -d "$HOME/.codeium/windsurf" ]  && DETECTED+=("windsurf")
[ -d "$HOME/.hermes" ]            && DETECTED+=("hermes")
[ -d "$HOME/.kilocode" ]          && DETECTED+=("kilocode")
[ -d "$HOME/.aider" ]             && DETECTED+=("aider")

if [ ${#DETECTED[@]} -eq 0 ]; then
  echo "No AI agent detected (~/.claude, ~/.config/opencode, etc.)."
  echo "Install at least one agent first, then re-run this component."
  echo "See ai-skills/SKILL.md for per-agent install instructions."
  exit 0
fi

echo "Detected agents: ${DETECTED[*]}"

# Delegate to the integration bootstrap — it's idempotent and handles all
# per-agent install paths (Claude hook + settings.json, AGENTS.md for the
# rest, windsurf global_rules.md, gstack PATH).
bash "$SCRIPT_DIR/install-integration.sh"

echo "ai-skills integration installed."
echo "Next: source ~/.zshrc and restart your AI agent."
