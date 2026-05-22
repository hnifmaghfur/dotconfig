#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect.sh"

install_rtk_binary() {
  echo "[rtk] Installing RTK binary..."
  if command -v rtk >/dev/null 2>&1; then
    echo "[rtk] rtk already installed: $(rtk --version)"
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "[rtk] Installing via Homebrew..."
    brew install rtk
  else
    # Security note: This downloads and executes a remote script.
    # Verify at https://github.com/rtk-ai/rtk/blob/master/install.sh before running.
    echo "[rtk] Installing via curl..."
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  fi
}

init_rtk_claude() {
  echo "[rtk] Initializing for Claude Code..."
  rtk init -g || true
}

init_rtk_gemini() {
  echo "[rtk] Initializing for Gemini CLI..."
  rtk init -g --gemini || true
}

init_rtk_codex() {
  echo "[rtk] Initializing for Codex..."
  rtk init -g --codex || true
}

init_rtk_cursor() {
  echo "[rtk] Initializing for Cursor..."
  rtk init -g --agent cursor || true
}

init_rtk_windsurf() {
  echo "[rtk] Initializing for Windsurf..."
  rtk init --agent windsurf || true
}

init_rtk_opencode() {
  echo "[rtk] Initializing for OpenCode..."
  rtk init -g --opencode || true
}

init_rtk_cline() {
  echo "[rtk] Initializing for Cline/Roo Code..."
  rtk init --agent cline || true
}

init_rtk_kilo() {
  echo "[rtk] Initializing for Kilo Code..."
  rtk init --agent kilocode || true
}

init_rtk_hermes() {
  echo "[rtk] Initializing for Hermes..."
  rtk init --agent hermes || true
}

install_rtk_all() {
  echo "=== Installing rtk ==="
  install_rtk_binary

  detect_claude && init_rtk_claude
  detect_gemini && init_rtk_gemini
  detect_codex && init_rtk_codex
  detect_cursor && init_rtk_cursor
  detect_windsurf && init_rtk_windsurf
  detect_opencode && init_rtk_opencode
  detect_cline && init_rtk_cline
  detect_kilo && init_rtk_kilo
  detect_hermes && init_rtk_hermes

  echo "=== rtk install complete ==="
  echo "Restart your AI agent tools to apply RTK hooks."
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  install_rtk_all
fi
