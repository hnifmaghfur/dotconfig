#!/bin/bash

set -e

DOTDIR="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

echo "Installing zsh..."

if [ "$OS" = "Linux" ]; then
  sudo apt update
  sudo apt install -y zsh fzf

  for tool in eza bat delta; do
    if ! command -v "$tool" &> /dev/null; then
      curl -sS "https://webinstall.dev/$tool" | bash
    fi
  done
elif [ "$OS" = "Darwin" ]; then
  brew install zsh fzf eza bat delta
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

mkdir -p ~/.local/bin ~/.zsh

rm -f ~/.zshrc
ln -sf "$DOTDIR/zsh/zshrc" ~/.zshrc

if [ "$OS" != "MINGW"* ] && [ "$OS" != "MSYS"* ]; then
  if [ "$(grep -c '/zsh' /etc/shells)" -eq 0 ]; then
    echo "/bin/zsh" | sudo tee -a /etc/shells
  fi
  chsh -s /bin/zsh
fi

echo "zsh installed. Restart your terminal or run: exec zsh"
