#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect.sh"

GSTACK_DIR="$HOME/.claude/skills/gstack"
GSTACK_REPO="https://github.com/garrytan/gstack.git"

install_gstack_claude() {
  echo "[gstack] Installing for Claude Code..."
  if [ -d "$GSTACK_DIR/.git" ]; then
    echo "gstack already cloned. Pulling latest..."
    (cd "$GSTACK_DIR" && git pull --ff-only)
  else
    mkdir -p "$HOME/.claude/skills"
    git clone --single-branch --depth 1 "$GSTACK_REPO" "$GSTACK_DIR"
  fi
  if [ ! -x "$GSTACK_DIR/setup" ]; then
    echo "Error: $GSTACK_DIR/setup not found or not executable"
    return 1
  fi
  (cd "$GSTACK_DIR" && ./setup)
}

install_gstack_other() {
  local host="$1"
  local dir="$HOME/gstack"
  echo "[gstack] Installing for $host..."
  if [ -d "$dir/.git" ]; then
    echo "gstack already cloned. Pulling latest..."
    (cd "$dir" && git pull --ff-only)
  else
    git clone --single-branch --depth 1 "$GSTACK_REPO" "$dir"
  fi
  if [ ! -x "$dir/setup" ]; then
    echo "Error: $dir/setup not found or not executable"
    return 1
  fi
  (cd "$dir" && ./setup --host "$host")
}

install_gstack_all() {
  echo "=== Installing gstack ==="
  if detect_claude; then
    install_gstack_claude
  else
    # Install to generic location if no claude
    local dir="$HOME/gstack"
    if [ ! -d "$dir/.git" ]; then
      git clone --single-branch --depth 1 "$GSTACK_REPO" "$dir"
    fi
  fi

  # For other detected agents, setup with --host
  detect_opencode && install_gstack_other "opencode"
  detect_codex && install_gstack_other "codex"
  detect_cursor && install_gstack_other "cursor"
  echo "=== gstack install complete ==="
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  install_gstack_all
fi
