# Dotfiles

Cross-device terminal configuration for wezterm and zsh.

## Structure

```
dotfiles/
├── wezterm/
│   └── config.lua      # WezTerm configuration
├── zsh/
│   ├── zshrc         # Main config (sources others)
│   ├── plugins.zsh    # Plugin list
│   └── aliases.zsh   # Alias definitions
├── nvim/             # Neovim config (future)
├── git/              # Git config (future)
├── install.sh        # Installation script
└── README.md
```

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's Included

### wezterm/config.lua
Cross-platform terminal emulator with:
- Tab management (Ctrl+1-9)
- Pane splitting & navigation
- Copy mode (vim-style)
- Catppuccin Mocha theme

### zsh/zshrc
Zsh configuration with Oh My Zsh and plugins for:
- Auto-suggestions & syntax highlighting
- Docker & Kubernetes completions
- Git aliases
- Node/Python environment support

### install.sh
Automatic installation script for:
- Linux (apt)
- macOS (brew)
- Windows (winget)

## Keybindings

### Wezterm

| Key | Action |
|-----|--------|
| `Ctrl+Shift+c` | Copy |
| `Ctrl+Shift+v` | Paste |
| `Ctrl+Shift+t` | New tab |
| `Ctrl+Shift+w` | Close tab |
| `Ctrl+1-9` | Switch to tab |
| `Ctrl+Shift+n` | New window |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |

**Leader Key**: `Ctrl+a`

| Key | Action |
|-----|--------|
| `Leader + -` | Split vertical |
| `Leader + \` | Split horizontal |
| `Leader + h/j/k/l` | Navigate panes |
| `Leader + x` | Close pane |
| `Leader + o` | Rotate panes |
| `Leader + [` | Resize mode |
| `Leader + f` | Search |

### Zsh

| Key | Action |
|-----|--------|
| `Esc + Esc` | Add sudo |
| `Ctrl+r` | History search (fzf) |
| `Ctrl+t` | List files (fzf) |
| `Ctrl+Arrow` | Word navigation |

## Aliases

```bash
# Git
g gs ga gc gp gl gco gb gd

# Docker
d dps dpsa di dex dlogs dclean
dc dcup dcdown dclogs

# Kubernetes
k kgp kgd kgs kga kaf kdesc klogs kexec

# Terraform
tf tfa tfd tfi tfp tfv

# Utilities
ll la lt
..  ...  ....  ~~~
```

## Requirements

- zsh 5.0+
- wezterm (latest)
- Git

## Optional

- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font
- [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts) fallback

## Customization

Add personal settings to:
- `~/.zsh_aliases` - Custom aliases
- `~/.zsh_env` - Environment variables
- `~/.zsh_local` - Local overrides

The config automatically sources these files if they exist.

## Push to GitHub

```bash
# Create new repository at https://github.com/new
git init
git add .
git commit -m "Initial commit: wezterm + zsh dotfiles"
git remote add origin https://github.com/username/repo-name.git
git push -u origin main
```

## Sync Across Devices

```bash
# On new device
git clone https://github.com/username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
mkdir -p ~/.config/fzf
ln -sf ~/.dotfiles/zsh/fzf.zsh ~/.config/fzf/fzf.zsh 2>/dev/null || true
```

## License

MIT