#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

echo "Installing eza..."

if command -v eza &> /dev/null; then
  echo "eza already installed: $(eza --version | head -n 1)"
  exit 0
fi

if [ "$OS" = "Linux" ]; then
  curl -sS https://webinstall.dev/eza | bash
elif [ "$OS" = "Darwin" ]; then
  brew install eza
else
  echo "Unsupported OS: $OS" >&2
  exit 1
fi

echo "eza installed."
