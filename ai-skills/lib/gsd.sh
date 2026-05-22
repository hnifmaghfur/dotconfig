#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect.sh"

install_gsd() {
  echo "=== Installing get-shit-done ==="

  if command -v npx >/dev/null 2>&1; then
    echo "[gsd] Running npx get-shit-done-cc@latest --profile=standard --global --yes"
    npx get-shit-done-cc@latest --profile=standard --global --yes || {
      echo "[gsd] npx install failed. You may need to run interactively:"
      echo "      npx get-shit-done-cc@latest"
    }
  else
    echo "[gsd] npx not found. Please install Node.js/npm first."
    echo "      Then run: npx get-shit-done-cc@latest"
  fi

  echo "=== get-shit-done install complete ==="
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  install_gsd
fi
