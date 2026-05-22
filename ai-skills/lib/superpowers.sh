#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect.sh"

install_superpowers_claude() {
  echo "[superpowers] Installing for Claude Code..."
  echo "Run in Claude Code: /plugin install superpowers@claude-plugins-official"
  echo "Or: /plugin marketplace add obra/superpowers-marketplace"
  echo "Then: /plugin install superpowers@superpowers-marketplace"
  return 0
}

install_superpowers_codex() {
  echo "[superpowers] Installing for Codex CLI..."
  echo "Run in Codex: /plugins -> search 'superpowers' -> Install Plugin"
  return 0
}

# Gemini is the only agent that supports CLI extension install
install_superpowers_gemini() {
  echo "[superpowers] Installing for Gemini CLI..."
  if command -v gemini >/dev/null 2>&1; then
    gemini extensions install https://github.com/obra/superpowers || true
  else
    echo "Gemini CLI not found. Install it first."
  fi
  return 0
}

install_superpowers_opencode() {
  echo "[superpowers] Installing for OpenCode..."
  echo "Tell OpenCode: Fetch and follow instructions from https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md"
  return 0
}

install_superpowers_cursor() {
  echo "[superpowers] Installing for Cursor..."
  echo "In Cursor Agent chat: /add-plugin superpowers"
  return 0
}

install_superpowers_copilot() {
  echo "[superpowers] Installing for GitHub Copilot CLI..."
  echo "Run: copilot plugin marketplace add obra/superpowers-marketplace"
  echo "Then: copilot plugin install superpowers@superpowers-marketplace"
  return 0
}

# Superpowers officially supports 6 agents per https://github.com/obra/superpowers
install_superpowers_all() {
  echo "=== Installing Superpowers ==="
  detect_claude && install_superpowers_claude
  detect_codex && install_superpowers_codex
  detect_gemini && install_superpowers_gemini
  detect_opencode && install_superpowers_opencode
  detect_cursor && install_superpowers_cursor
  detect_copilot && install_superpowers_copilot
  echo "=== Superpowers install complete ==="
  return 0
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  install_superpowers_all
fi
