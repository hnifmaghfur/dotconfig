# WezTerm Tmux-like Features Design

**Date:** 2026-04-17
**Status:** Approved

## Overview

Add tmux-like features to WezTerm: a Powerline status bar, pane layout presets, and an enhanced copy mode. The existing `config.lua` will be split into modular Lua files for maintainability.

## File Structure

```
wezterm/
  config.lua        # entry point — base config (font, color, etc.) + require modules
  statusbar.lua     # status bar (powerline, leader/layout indicators)
  keybindings.lua   # all keys & key_tables
  layouts.lua       # pane layout preset functions
```

Each module returns a table that is merged into the main `config` object in `config.lua`.

## Status Bar

### Layout

```
Left:  [ LEADER ]▶[ workspace ]▶[ pane title ]
Right:            ◀[ hostname ]◀[ battery ]◀[ date  time ]
```

### Behavior

- **LEADER indicator** — appears only when `Ctrl+Space` is active, disappears after timeout
- **LAYOUT indicator** — appears when `layout_mode` key table is active
- **Workspace** — active workspace name (default: `main`)
- **Pane title** — foreground process name (e.g. `zsh`, `nvim`, `git`)
- **Hostname** — machine hostname
- **Battery** — percentage + icon based on level (, , , , )
- **Date & Time** — format: `Thu 17 Apr  14:32`

### Colors (Catppuccin Mocha)

| Segment    | Background | Foreground |
|------------|------------|------------|
| LEADER     | `#f38ba8`  | `#1e1e2e`  |
| LAYOUT     | `#fab387`  | `#1e1e2e`  |
| Workspace  | `#89b4fa`  | `#1e1e2e`  |
| Pane title | `#313244`  | `#cdd6f4`  |
| Hostname   | `#45475a`  | `#cdd6f4`  |
| Battery    | `#a6e3a1`  | `#1e1e2e`  |
| Date/time  | `#313244`  | `#cdd6f4`  |

### Powerline Separators

- Left side: `\u{e0b0}` (▶ filled triangle)
- Right side: `\u{e0b2}` (◀ filled triangle)

## Pane Layout Presets

### Trigger

`LEADER` + `Space` → enters `layout_mode` key table. Status bar shows LAYOUT indicator while active.

### Presets

| Key      | Layout          | Description                                      |
|----------|-----------------|--------------------------------------------------|
| `h`      | main-horizontal | 1 large pane top, remaining panes split below    |
| `v`      | main-vertical   | 1 large pane left, remaining panes split right   |
| `t`      | tiled           | 2x2 grid                                         |
| `Escape` | —               | exit layout mode                                 |

### Behavior

- If only 1 pane exists: split automatically to form the layout
- If multiple panes exist: resize existing panes to match the layout proportions
- Main pane takes ~65% of available space; secondary panes split the remaining ~35% equally

## Copy Mode

Activated with `LEADER + y`. Extends existing vim-like navigation.

### Additional Keys

| Key      | Action                              |
|----------|-------------------------------------|
| `/`      | Search forward in scrollback        |
| `n`      | Next search result                  |
| `N`      | Previous search result              |
| `Ctrl+V` | Visual block mode                   |
| `Ctrl+D` | Scroll down half page               |
| `Ctrl+U` | Scroll up half page                 |
| `g`      | Jump to top of scrollback           |
| `G`      | Jump to bottom                      |
| `M`      | Jump to middle of viewport          |
| `%`      | Toggle between start/end of selection |
| `q`      | Exit copy mode                      |

### Existing Keys (retained)

| Key | Action |
|-----|--------|
| `v` | Cell selection mode |
| `V` | Line selection mode |
| `y` | Copy to clipboard |
| `h/j/k/l` | Move left/down/up/right |
| `w` | Move forward word |
| `b` | Move backward word |
| `0` | Move to start of line |
| `$` | Move to end of line content |
| `Escape` | Exit copy mode |

> **Note:** Jump to character (`f`/`F` vim style) is not natively supported in WezTerm copy mode and is excluded from this design.

## Out of Scope

- Session persistence across reboots
- Named pane titles (manual rename)
- Mouse resize for pane layout presets
