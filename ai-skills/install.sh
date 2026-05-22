#!/bin/bash

set -e

__INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$__INSTALLER_DIR/lib/detect.sh"
source "$__INSTALLER_DIR/lib/superpowers.sh"
source "$__INSTALLER_DIR/lib/gstack.sh"
source "$__INSTALLER_DIR/lib/gsd.sh"
source "$__INSTALLER_DIR/lib/rtk.sh"

DRY_RUN=false
SKIP_RTK=false

usage() {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Install AI agent skills (superpowers, gstack, get-shit-done, rtk)"
  echo ""
  echo "Options:"
  echo "  --dry-run          Preview commands without executing"
  echo "  --list             List detected agents and exit"
  echo "  --skip-rtk         Skip rtk installation"
  echo "  -h, --help         Show this help"
}

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --list)
      echo "Detected AI agents:"
      agents=$(detect_all_agents)
      if [ -z "$agents" ]; then
        echo "  (none detected)"
      else
        for agent in $agents; do
          echo "  - $agent"
        done
      fi
      exit 0
      ;;
    --skip-rtk)
      SKIP_RTK=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# Dependency checks
check_deps() {
  if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required. Please install git first."
    exit 1
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required. Please install curl first."
    exit 1
  fi
}

# Install bun if not present (required for gstack setup)
ensure_bun() {
  if command -v bun >/dev/null 2>&1; then
    echo "[deps] bun already installed: $(bun --version)"
    return 0
  fi

  echo "[deps] bun is required for gstack. Installing..."
  # Install with checksum verification as recommended by bun
  local BUN_VERSION="1.3.10"
  local tmpfile
  tmpfile=$(mktemp)
  curl -fsSL "https://bun.sh/install" -o "$tmpfile"
  echo "[deps] Verify checksum before running:"
  echo "       shasum -a 256 $tmpfile"
  BUN_INSTALL="$HOME/.bun" BUN_VERSION="$BUN_VERSION" bash "$tmpfile"
  rm -f "$tmpfile"

  # Add to PATH for current session
  export PATH="$HOME/.bun/bin:$PATH"

  if command -v bun >/dev/null 2>&1; then
    echo "[deps] bun installed successfully: $(bun --version)"
  else
    echo "[deps] Warning: bun installation may require shell restart."
    echo "       Add to your shell config: export PATH=\"\$HOME/.bun/bin:\$PATH\""
  fi
}

main() {
  echo "========================================="
  echo "  AI Skills Installer"
  echo "========================================="
  echo ""

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] No changes will be made."
    echo ""
  fi

  check_deps

  agents=$(detect_all_agents)
  if [ -z "$agents" ]; then
    echo "No AI agents detected on this system."
    echo "Please install Claude Code, OpenCode, Codex, Gemini CLI, Cursor, or others first."
    exit 0
  fi

  echo "Detected agents:"
  for agent in $agents; do
    echo "  - $agent"
  done
  echo ""

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would install superpowers..."
    echo "[DRY RUN] Would install gstack..."
    echo "[DRY RUN] Would install get-shit-done..."
    if [ "$SKIP_RTK" = false ]; then
      echo "[DRY RUN] Would install rtk..."
    fi
    echo ""
    echo "[DRY RUN] Complete. Run without --dry-run to execute."
    exit 0
  fi

  # Install skills
  install_superpowers_all
  echo ""

  ensure_bun
  echo ""

  install_gstack_all
  echo ""

  install_gsd
  echo ""

  if [ "$SKIP_RTK" = false ]; then
    install_rtk_all
    echo ""
  else
    echo "[rtk] Skipped (use --skip-rtk)"
  fi

  echo "========================================="
  echo "  AI Skills Installation Complete!"
  echo "========================================="
  echo ""
  echo "Installed skills:"
  echo "  - superpowers (follow manual steps printed above per agent)"
  echo "  - gstack"
  echo "  - get-shit-done"
  if [ "$SKIP_RTK" = false ]; then
    echo "  - rtk"
  fi
  echo ""
  echo "Note: Restart your AI agent tools to apply all changes."
}

main
