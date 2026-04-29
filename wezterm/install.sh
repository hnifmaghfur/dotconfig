#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

echo "Installing wezterm..."

if ! command -v wezterm &> /dev/null; then
  if [ "$OS" = "Linux" ]; then
    WEZTERM_VERSION=$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/wez/wezterm/releases/latest | sed 's|.*/tag/||')
    WEZTERM_DEB="/tmp/wezterm-${WEZTERM_VERSION}.Ubuntu22.04.deb"
    curl -fsSL -o "$WEZTERM_DEB" "https://github.com/wez/wezterm/releases/download/${WEZTERM_VERSION}/wezterm-${WEZTERM_VERSION}.Ubuntu22.04.deb"
    sudo apt install -y "$WEZTERM_DEB"
    rm -f "$WEZTERM_DEB"
  elif [ "$OS" = "Darwin" ]; then
    brew install --cask wezterm
  fi
else
  echo "WezTerm already installed: $(wezterm --version)"
fi

mkdir -p ~/.config/wezterm
ln -sf "$DOTDIR/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua

echo "wezterm installed and configured."
