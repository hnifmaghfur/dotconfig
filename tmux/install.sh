#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

echo "Installing tmux..."

if [ "$OS" = "Linux" ]; then
  sudo apt update
  sudo apt install -y tmux
elif [ "$OS" = "Darwin" ]; then
  brew install tmux
fi

mkdir -p ~/.config/tmux
ln -sf "$DOTDIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "tmux installed. Run prefix + I inside tmux to install plugins."
