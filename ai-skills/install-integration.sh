#!/usr/bin/env bash
# install-integration.sh
# ----------------------------------------------------------------------------
# Bootstraps the GStack × GSD × Superpower auto-activation integration:
#   - Installs integration-router SKILL (cross-agent)
#   - Installs UserPromptSubmit hook (Claude Code only)
#   - Adds gstack/bin to PATH via ~/.zshrc (if not present)
#   - For non-Claude agents, appends an @-reference to AGENTS.md / GEMINI.md
#
# Idempotent. Safe to re-run.
# ----------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SKILL_SRC="$SCRIPT_DIR/skills/integration-router/SKILL.md"
HOOK_SRC="$SCRIPT_DIR/hooks/integration-router-hook.sh"

CLAUDE_SKILL_DIR="$HOME/.claude/skills/integration-router"
CLAUDE_HOOK_DEST="$HOME/.claude/hooks/integration-router-hook.sh"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

# --- color helpers -----------------------------------------------------------
if [ -t 1 ]; then
  CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; RESET='\033[0m'
else
  CYAN=''; GREEN=''; YELLOW=''; RED=''; DIM=''; RESET=''
fi

step()  { printf "${CYAN}▸ %s${RESET}\n" "$*"; }
ok()    { printf "${GREEN}✓ %s${RESET}\n" "$*"; }
warn()  { printf "${YELLOW}⚠ %s${RESET}\n" "$*"; }
err()   { printf "${RED}✗ %s${RESET}\n" "$*" >&2; }

# --- preflight ---------------------------------------------------------------
[ -f "$SKILL_SRC" ] || { err "missing $SKILL_SRC"; exit 1; }
[ -f "$HOOK_SRC" ]  || { err "missing $HOOK_SRC"; exit 1; }

step "Source files OK ($SKILL_SRC, $HOOK_SRC)"

# --- detect agents -----------------------------------------------------------
AGENTS=()
[ -d "$HOME/.claude" ] && AGENTS+=("claude")
[ -d "$HOME/.config/opencode" ] && AGENTS+=("opencode")
[ -d "$HOME/.codex" ] && AGENTS+=("codex")
[ -d "$HOME/.config/gemini" ] && AGENTS+=("gemini")
[ -d "$HOME/.cursor" ] && AGENTS+=("cursor")
[ -d "$HOME/.codeium/windsurf" ] && AGENTS+=("windsurf")
[ -d "$HOME/.hermes" ] && AGENTS+=("hermes")
[ -d "$HOME/.kilocode" ] && AGENTS+=("kilocode")
[ -d "$HOME/.aider" ] && AGENTS+=("aider")

if [ ${#AGENTS[@]} -eq 0 ]; then
  err "No supported AI agent detected (looked for ~/.claude, ~/.config/opencode, etc.)"
  exit 1
fi

step "Detected agents: ${AGENTS[*]}"

# --- 1. fix gstack PATH ------------------------------------------------------
ZSHRC="$(readlink -f "$HOME/.zshrc" 2>/dev/null || echo "$HOME/.zshrc")"
if [ -f "$ZSHRC" ]; then
  if grep -q '/.claude/skills/gstack/bin' "$ZSHRC"; then
    ok "gstack PATH already in $ZSHRC"
  else
    {
      echo ""
      echo "# gstack (added by ai-skills/install-integration.sh)"
      echo '[ -d "$HOME/.claude/skills/gstack/bin" ] && export PATH="$HOME/.claude/skills/gstack/bin:$PATH"'
    } >> "$ZSHRC"
    ok "Appended gstack PATH to $ZSHRC"
  fi
else
  warn "No ~/.zshrc found — skipping PATH setup"
fi

# --- 2. claude code: skill + hook -------------------------------------------
install_claude() {
  step "Installing for Claude Code …"

  # skill
  mkdir -p "$CLAUDE_SKILL_DIR"
  cp -f "$SKILL_SRC" "$CLAUDE_SKILL_DIR/SKILL.md"
  ok "Skill → $CLAUDE_SKILL_DIR/SKILL.md"

  # hook script
  mkdir -p "$(dirname "$CLAUDE_HOOK_DEST")"
  cp -f "$HOOK_SRC" "$CLAUDE_HOOK_DEST"
  chmod +x "$CLAUDE_HOOK_DEST"
  ok "Hook → $CLAUDE_HOOK_DEST"

  # settings.json merge
  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    warn "$CLAUDE_SETTINGS not found — creating new"
    echo '{"hooks":{}}' > "$CLAUDE_SETTINGS"
  fi

  # Merge UserPromptSubmit hook into settings.json. Prefer jq, fall back to
  # node (always available because other GSD hooks rely on it), then python3.
  merge_settings() {
    local settings="$1" hook="$2"
    if command -v jq >/dev/null 2>&1; then
      local entry tmp
      entry=$(jq -n --arg cmd "bash \"$hook\"" '{hooks:[{type:"command",command:$cmd,timeout:5}]}')
      tmp=$(mktemp)
      jq --argjson entry "$entry" --arg path "$hook" '
        .hooks = (.hooks // {}) |
        .hooks.UserPromptSubmit = (
          ((.hooks.UserPromptSubmit // []) | map(
            select(any(.hooks[]?; .command | tostring | contains($path)) | not)
          )) + [$entry]
        )
      ' "$settings" > "$tmp" && mv "$tmp" "$settings"
      return $?
    fi

    if command -v node >/dev/null 2>&1; then
      node - "$settings" "$hook" <<'NODE_EOF'
const fs = require('fs');
const [settingsPath, hookPath] = process.argv.slice(2);
const data = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
data.hooks ??= {};
const list = data.hooks.UserPromptSubmit ?? [];
const filtered = list.filter(entry =>
  !((entry.hooks ?? []).some(h => String(h.command || '').includes(hookPath)))
);
filtered.push({ hooks: [{ type: 'command', command: `bash "${hookPath}"`, timeout: 5 }] });
data.hooks.UserPromptSubmit = filtered;
fs.writeFileSync(settingsPath, JSON.stringify(data, null, 2) + '\n');
NODE_EOF
      return $?
    fi

    if command -v python3 >/dev/null 2>&1; then
      python3 - "$settings" "$hook" <<'PY_EOF'
import json, sys
settings_path, hook_path = sys.argv[1], sys.argv[2]
with open(settings_path) as f: data = json.load(f)
hooks = data.setdefault("hooks", {})
ups = [e for e in hooks.get("UserPromptSubmit", [])
       if not any(hook_path in str(h.get("command", "")) for h in e.get("hooks", []))]
ups.append({"hooks": [{"type": "command", "command": f'bash "{hook_path}"', "timeout": 5}]})
hooks["UserPromptSubmit"] = ups
with open(settings_path, "w") as f: json.dump(data, f, indent=2); f.write("\n")
PY_EOF
      return $?
    fi

    err "Need jq, node, or python3 for settings.json merge — none found"
    return 1
  }

  if ! merge_settings "$CLAUDE_SETTINGS" "$CLAUDE_HOOK_DEST"; then
    exit 1
  fi

  ok "Merged UserPromptSubmit hook into $CLAUDE_SETTINGS"
}

# --- 3. non-claude agents: append @-reference -------------------------------
install_agents_md() {
  local target="$1"  # path to AGENTS.md or GEMINI.md
  local marker="<!-- integration-router:auto -->"
  local ref_line="@$SKILL_SRC"
  local block

  if [ -f "$target" ] && grep -q "$marker" "$target"; then
    ok "$target already references integration-router"
    return
  fi

  block=$(cat <<EOF

$marker
> **Active integration**: GStack × GSD × Superpower auto-routing
> See: $ref_line
EOF
)
  printf "%s\n" "$block" >> "$target"
  ok "Appended integration-router reference to $target"
}

# --- run per-agent installs --------------------------------------------------
for agent in "${AGENTS[@]}"; do
  case "$agent" in
    claude)   install_claude ;;
    opencode) install_agents_md "$HOME/.config/opencode/AGENTS.md" ;;
    codex)    install_agents_md "$HOME/.codex/AGENTS.md" ;;
    gemini)   install_agents_md "$HOME/.config/gemini/GEMINI.md" ;;
    cursor)   install_agents_md "$HOME/.cursor/AGENTS.md" ;;
    windsurf)
      mkdir -p "$HOME/.codeium/windsurf/memories"
      install_agents_md "$HOME/.codeium/windsurf/memories/global_rules.md"
      ;;
    hermes)   install_agents_md "$HOME/.hermes/AGENTS.md" ;;
    kilocode) install_agents_md "$HOME/.kilocode/AGENTS.md" ;;
    aider)    install_agents_md "$HOME/.aider/AGENTS.md" ;;
  esac
done

# --- summary ----------------------------------------------------------------
echo
printf "${GREEN}━━━ Integration installed ━━━${RESET}\n"
printf "${DIM}Agents:${RESET} %s\n" "${AGENTS[*]}"
printf "${DIM}Skill :${RESET} $SKILL_SRC\n"
printf "${DIM}Hook  :${RESET} $HOOK_SRC\n"
echo
echo "Next steps:"
echo "  • source ~/.zshrc       (to pick up gstack PATH)"
echo "  • restart your AI agent (to load the new hook + skill)"
echo "  • try a prompt like 'buat fitur login' → hook should inject a routing hint"
echo
