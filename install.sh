#!/bin/bash

set -e

echo "Installing dotfiles..."

OS="$(uname -s)"
DOTDIR="$(cd "$(dirname "$0")" && pwd)"

install_linux() {
  sudo apt update
  sudo apt install -y git curl wget zsh fzf build-essential

  if ! command -v eza &> /dev/null; then
    curl -sS https://webinstall.dev/eza | bash
  fi

  if ! command -v bat &> /dev/null; then
    curl -sS https://webinstall.dev/bat | bash
  fi

  if ! command -v delta &> /dev/null; then
    curl -sS https://webinstall.dev/delta | bash
  fi
}

install_macos() {
  brew install git curl wget zsh fzf
  brew install eza bat delta
}

install_windows() {
  winget install -e --id Git.Git
  winget install -e --id ByronRaffles.Edge-Dev-Tools
}

if [ "$OS" = "Linux" ]; then
  install_linux
elif [ "$OS" = "Darwin" ]; then
  install_macos
elif [ "$OS" = "MINGW"* ] || [ "$OS" = "MSYS"* ]; then
  install_windows
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

mkdir -p ~/.local/bin
mkdir -p ~/.zsh

rm -f ~/.zshrc
ln -sf "$DOTDIR/zsh/zshrc" ~/.zshrc
ln -sf "$DOTDIR" ~/.dotfiles

ln -sf "$DOTDIR/wezterm/config.lua" ~/.config/wezterm/wezterm.lua

if ! command -v wezterm &> /dev/null; then
  echo "Installing WezTerm..."
  if [ "$OS" = "Linux" ]; then
    curl -sS https://webinstall.dev/wezterm | bash
  elif [ "$OS" = "Darwin" ]; then
    brew install --cask wezterm
  fi
fi

mkdir -p ~/.config/fzf
if [ ! -f ~/.config/fzf/fzf.zsh ]; then
  $(brew --prefix)/opt/fzf/install --zsh 2>/dev/null || true
fi

echo "Setting zsh as default shell..."
if [ "$OS" != "MINGW"* ] && [ "$OS" != "MSYS"* ]; then
  if [ "$(cat /etc/shells | grep -c '/zsh')" -eq 0 ]; then
    echo "/bin/zsh" | sudo tee -a /etc/shells
  fi
  chsh -s /bin/zsh
fi

echo "Installation complete!"
echo "Please restart your terminal or run: exec zsh"