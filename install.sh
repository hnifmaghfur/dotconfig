#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

usage() {
  echo "Usage: $0 [component...]"
  echo ""
  echo "Components:"
  echo "  all      - Install everything (default)"
  for dir in "$DOTDIR"/*/; do
    if [ -f "${dir}install.sh" ]; then
      echo "  $(basename "$dir")"
    fi
  done
  echo ""
  echo "Examples:"
  echo "  $0              # install everything"
  echo "  $0 tmux         # install tmux only"
  echo "  $0 zsh tmux     # install zsh and tmux"
}

install_base_linux() {
  sudo apt update
  sudo apt install -y git curl wget build-essential
}

install_base_macos() {
  brew install git curl wget
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit 0
fi

COMPONENTS=("$@")
if [ ${#COMPONENTS[@]} -eq 0 ]; then
  COMPONENTS=("all")
fi

ln -sf "$DOTDIR" ~/.dotfiles

for component in "${COMPONENTS[@]}"; do
  case "$component" in
    all)
      if [ "$OS" = "Linux" ]; then install_base_linux; fi
      if [ "$OS" = "Darwin" ]; then install_base_macos; fi
      bash "$DOTDIR/zsh/install.sh"
      bash "$DOTDIR/tmux/install.sh"
      bash "$DOTDIR/wezterm/install.sh"
      ;;
    zsh)
      bash "$DOTDIR/zsh/install.sh"
      ;;
    tmux)
      bash "$DOTDIR/tmux/install.sh"
      ;;
    wezterm)
      bash "$DOTDIR/wezterm/install.sh"
      ;;
    *)
      echo "Unknown component: $component"
      usage
      exit 1
      ;;
  esac
done

echo "Done!"
