# Dotfiles

Cross-device terminal configuration for wezterm, zsh, tmux, and eza.

## Structure

```
dotfiles/
├── eza/
│   └── install.sh      # eza installer (CLI ls replacement)
├── tmux/
│   ├── tmux.conf       # tmux configuration
│   └── install.sh
├── wezterm/
│   ├── wezterm.lua     # WezTerm configuration
│   └── install.sh
├── zsh/
│   ├── zshrc           # Main config (sources others)
│   ├── plugins.zsh     # Plugin list
│   ├── aliases.zsh     # Alias definitions
│   └── install.sh
├── tests/
│   ├── run_tests.sh    # Pure-bash test runner
│   └── test_install.sh # Tests for install.sh
├── install.sh          # Interactive installer
└── README.md
```

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer is fully interactive — it will show a menu and let you pick
which components to install.

## Interactive Installer

Running `./install.sh` displays a numbered menu of every installable
component discovered in the repository:

```
Available components:
  1) eza
  2) tmux
  3) wezterm
  4) zsh
  a) all
  q) quit

Select components [1-4, a=all, q=quit]:
```

Selection input accepts:

| Input     | Meaning                            |
|-----------|------------------------------------|
| `1`       | Install component #1 only          |
| `1 3`     | Install #1 and #3 (space separated)|
| `1,3`     | Install #1 and #3 (comma separated)|
| `1, 3`    | Same as above (extra spaces OK)    |
| `a`/`all` | Install every component           |
| `q`/`quit`| Cancel without installing          |

After a valid selection you'll see a summary and a `[y/N]` confirmation
before anything runs. If any component fails to install, the remaining
components still run and a final `Installation Summary` with ✓/✗ marks
shows which succeeded and which failed. The script exits with status `1`
if any component failed, `0` otherwise.

The base packages (`git`, `curl`, `wget`, `build-essential` on Linux or
their macOS equivalents) plus the `~/.dotfiles` symlink are always
installed before the menu — they are required prerequisites for the
individual component installers.

Pure-bash — no `fzf`, `whiptail`, or `dialog` required, so it works on
minimal servers, WSL, Git Bash, and headless environments.

## What's Included

### eza/install.sh
Standalone installer for [eza](https://eza.rocks) — a modern `ls`
replacement with icons, git integration, and tree view. Installed via
`webinstall.dev` on Linux and Homebrew on macOS.

### wezterm/wezterm.lua
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

(The zsh installer also installs eza/bat/delta as dependencies because
the aliases reference them.)

### tmux/tmux.conf
Tmux configuration with TPM plugin manager. Run `prefix + I` inside tmux
to install plugins.

### install.sh
Interactive installer for:
- Linux (apt + webinstall.dev)
- macOS (brew)

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

- bash 3.2+ (macOS default ships bash 3.2; Linux ships 4+)
- zsh 5.0+
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

## Testing

The installer has a pure-bash test suite that validates the menu
parsing, confirmation flow, component discovery, and error handling
without touching your system.

```bash
bash tests/run_tests.sh
```

Tests run in isolated subshells; no dependencies beyond bash and the
standard coreutils (`sort`, `tr`).

If you're adding a new component, drop a `install.sh` into a new
subdirectory — the interactive menu will pick it up automatically via
`discover_components`.

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
```

## License

MIT
