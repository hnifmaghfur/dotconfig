# WezTerm Tmux-like Features Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split WezTerm config into modular Lua files and add a Powerline status bar, pane layout presets, and enhanced copy mode.

**Architecture:** `config.lua` becomes an entry point that `require`s three modules — `statusbar.lua`, `keybindings.lua`, `layouts.lua`. Each module is symlinked from `~/dotconfig/wezterm/` to `~/.config/wezterm/` so WezTerm's Lua runtime can resolve them. The status bar uses `wezterm.on('update-status', ...)`. Layout presets use `wezterm.action_callback`. Copy mode extensions are added to the `copy_mode` key table.

**Tech Stack:** WezTerm Lua API, Catppuccin Mocha color palette, Nerd Fonts powerline glyphs (U+E0B0, U+E0B2).

---

### Task 1: Fix install.sh symlinks

**Files:**
- Modify: `install.sh:84`

- [ ] **Step 1: Update wezterm symlink in install.sh to use correct filename**

Replace line 84 in `install.sh`:
```bash
# Before:
ln -sf "$DOTDIR/wezterm/config.lua" ~/.config/wezterm/config.lua

# After:
ln -sf "$DOTDIR/wezterm/config.lua" ~/.config/wezterm/wezterm.lua
ln -sf "$DOTDIR/wezterm/statusbar.lua" ~/.config/wezterm/statusbar.lua
ln -sf "$DOTDIR/wezterm/keybindings.lua" ~/.config/wezterm/keybindings.lua
ln -sf "$DOTDIR/wezterm/layouts.lua" ~/.config/wezterm/layouts.lua
```

- [ ] **Step 2: Create symlinks for new module files now (for this session)**

```bash
ln -sf /home/hanif/dotconfig/wezterm/statusbar.lua ~/.config/wezterm/statusbar.lua
ln -sf /home/hanif/dotconfig/wezterm/keybindings.lua ~/.config/wezterm/keybindings.lua
ln -sf /home/hanif/dotconfig/wezterm/layouts.lua ~/.config/wezterm/layouts.lua
```

- [ ] **Step 3: Verify symlinks**

Run: `ls -la ~/.config/wezterm/`

Expected output:
```
wezterm.lua -> /home/hanif/dotconfig/wezterm/config.lua
statusbar.lua -> /home/hanif/dotconfig/wezterm/statusbar.lua
keybindings.lua -> /home/hanif/dotconfig/wezterm/keybindings.lua
layouts.lua -> /home/hanif/dotconfig/wezterm/layouts.lua
```

- [ ] **Step 4: Commit**

```bash
git add install.sh
git commit -m "fix: update wezterm symlinks to use wezterm.lua and add module symlinks"
```

---

### Task 2: Create keybindings.lua

**Files:**
- Create: `wezterm/keybindings.lua`
- Modify: `wezterm/config.lua` (remove keys/key_tables, add require)

- [ ] **Step 1: Create `wezterm/keybindings.lua` with all existing keys and key_tables**

```lua
local wezterm = require 'wezterm'
local action = wezterm.action
local M = {}

function M.keys(layouts)
  return {
    { key = 'c', mods = 'CTRL|SHIFT', action = action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = action.PasteFrom 'Clipboard' },
    { key = 't', mods = 'CTRL|SHIFT', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CTRL|SHIFT', action = action.CloseCurrentTab { confirm = false } },
    { key = 'n', mods = 'CTRL|SHIFT', action = action.SpawnWindow },

    { key = '-', mods = 'LEADER', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER|SHIFT', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },

    { key = 'x', mods = 'LEADER', action = action.CloseCurrentPane { confirm = false } },
    { key = 'o', mods = 'LEADER', action = action.RotatePanes 'Clockwise' },
    { key = 'O', mods = 'LEADER', action = action.RotatePanes 'CounterClockwise' },

    { key = '1', mods = 'CTRL', action = action.ActivateTab(0) },
    { key = '2', mods = 'CTRL', action = action.ActivateTab(1) },
    { key = '3', mods = 'CTRL', action = action.ActivateTab(2) },
    { key = '4', mods = 'CTRL', action = action.ActivateTab(3) },
    { key = '5', mods = 'CTRL', action = action.ActivateTab(4) },
    { key = '6', mods = 'CTRL', action = action.ActivateTab(5) },
    { key = '7', mods = 'CTRL', action = action.ActivateTab(6) },
    { key = '8', mods = 'CTRL', action = action.ActivateTab(7) },
    { key = '9', mods = 'CTRL', action = action.ActivateTab(8) },

    { key = 'f', mods = 'LEADER', action = action.Search 'CurrentSelectionOrEmptyString' },
    { key = 'p', mods = 'CTRL|SHIFT', action = action.ActivateTabRelative(-1) },
    { key = 'n', mods = 'CTRL|SHIFT', action = action.ActivateTabRelative(1) },
    { key = '[', mods = 'LEADER', action = action.ActivateKeyTable { name = 'resize_pane' } },
    { key = 'r', mods = 'LEADER', action = action.ActivateKeyTable { name = 'resize_pane' } },
    { key = 's', mods = 'LEADER', action = action.ActivateKeyTable { name = 'scroll_mode' } },
    { key = 'g', mods = 'LEADER', action = action.ActivateKeyTable { name = 'search_mode' } },
    { key = 'Tab', mods = 'LEADER', action = action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'LEADER|SHIFT', action = action.ActivateTabRelative(-1) },
    { key = 't', mods = 'LEADER', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'LEADER', action = action.CloseCurrentTab { confirm = false } },
    { key = 'f', mods = 'LEADER|SHIFT', action = action.SpawnCommandInNewWindow { label = 'Floating Terminal' } },
    { key = 'Enter', mods = 'LEADER', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'm', mods = 'LEADER', action = action.TogglePaneZoomState },
    { key = 'y', mods = 'LEADER', action = action.ActivateCopyMode },
    { key = 'u', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
    { key = 'd', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
    { key = '0', mods = 'LEADER', action = action.ActivateKeyTable { name = 'number_tab' } },
    { key = ',', mods = 'LEADER', action = action.ActivateKeyTable { name = 'quick_switch' } },

    -- Layout presets
    { key = 'Space', mods = 'LEADER', action = action.ActivateKeyTable { name = 'layout_mode', one_shot = false } },
  }
end

function M.key_tables(layouts)
  return {
    resize_pane = {
      { key = 'h', action = action.AdjustPaneSize { 'Left', 1 } },
      { key = 'j', action = action.AdjustPaneSize { 'Down', 1 } },
      { key = 'k', action = action.AdjustPaneSize { 'Up', 1 } },
      { key = 'l', action = action.AdjustPaneSize { 'Right', 1 } },
      { key = 'H', action = action.AdjustPaneSize { 'Left', 5 } },
      { key = 'J', action = action.AdjustPaneSize { 'Down', 5 } },
      { key = 'K', action = action.AdjustPaneSize { 'Up', 5 } },
      { key = 'L', action = action.AdjustPaneSize { 'Right', 5 } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    scroll_mode = {
      { key = 'j', action = action.ScrollByPage(0.5) },
      { key = 'k', action = action.ScrollByPage(-0.5) },
      { key = 'd', action = action.ScrollByPage(0.5) },
      { key = 'u', action = action.ScrollByPage(-0.5) },
      { key = 'g', action = action.ScrollToTop },
      { key = 'G', action = action.ScrollToBottom },
      { key = 'h', action = action.ScrollByPage(-0.5) },
      { key = 'l', action = action.ScrollByPage(0.5) },
      { key = '/', action = action.ActivateKeyTable { name = 'search_mode' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    search_mode = {
      { key = 'Enter', action = action.Search 'CurrentSelectionOrEmptyString' },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    copy_mode = {
      { key = 'v', action = action.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'V', action = action.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'y', action = action.CopyMode 'CopyToClipboard' },
      { key = 'q', action = action.CopyMode 'Close' },
      { key = 'Escape', action = action.CopyMode 'Close' },
      { key = 'h', action = action.CopyMode 'MoveLeft' },
      { key = 'l', action = action.CopyMode 'MoveRight' },
      { key = 'j', action = action.CopyMode 'MoveDown' },
      { key = 'k', action = action.CopyMode 'MoveUp' },
      { key = 'w', action = action.CopyMode 'MoveForwardWord' },
      { key = 'b', action = action.CopyMode 'MoveBackwardWord' },
      { key = '0', action = action.CopyMode 'MoveToStartOfLine' },
      { key = '$', action = action.CopyMode 'MoveToEndOfLineContent' },
      -- Enhanced copy mode
      { key = '/', action = action.Search { CaseInSensitiveString = '' } },
      { key = 'n', action = action.CopyMode 'NextMatch' },
      { key = 'N', action = action.CopyMode 'PriorMatch' },
      { key = 'v', mods = 'CTRL', action = action.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'd', mods = 'CTRL', action = action.CopyMode 'MoveToViewportBottom' },
      { key = 'u', mods = 'CTRL', action = action.CopyMode 'MoveToViewportTop' },
      { key = 'g', action = action.CopyMode 'MoveToScrollbackTop' },
      { key = 'G', action = action.CopyMode 'MoveToScrollbackBottom' },
      { key = 'M', action = action.CopyMode 'MoveToViewportMiddle' },
      { key = '%', action = action.CopyMode 'MoveToSelectionOtherEnd' },
    },

    layout_mode = {
      { key = 'h', action = action.EmitEvent 'layout-main-horizontal' },
      { key = 'v', action = action.EmitEvent 'layout-main-vertical' },
      { key = 't', action = action.EmitEvent 'layout-tiled' },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    number_tab = {
      { key = '0', action = action.ActivateTab(0) },
      { key = '1', action = action.ActivateTab(1) },
      { key = '2', action = action.ActivateTab(2) },
      { key = '3', action = action.ActivateTab(3) },
      { key = '4', action = action.ActivateTab(4) },
      { key = '5', action = action.ActivateTab(5) },
      { key = '6', action = action.ActivateTab(6) },
      { key = '7', action = action.ActivateTab(7) },
      { key = '8', action = action.ActivateTab(8) },
      { key = '9', action = action.ActivateTab(9) },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    quick_switch = {
      { key = 'a', action = action.ActivateKeyTable { name = 'quick_select_a' } },
      { key = 'b', action = action.ActivateKeyTable { name = 'quick_select_b' } },
      { key = 'c', action = action.ActivateKeyTable { name = 'quick_select_c' } },
      { key = 'd', action = action.ActivateKeyTable { name = 'quick_select_d' } },
      { key = 'e', action = action.ActivateKeyTable { name = 'quick_select_e' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    quick_select_a = {
      { key = '1', action = action.SwitchToWorkspace { name = '1' } },
      { key = '2', action = action.SwitchToWorkspace { name = '2' } },
      { key = '3', action = action.SwitchToWorkspace { name = '3' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },
  }
end

return M
```

- [ ] **Step 2: Commit**

```bash
git add wezterm/keybindings.lua
git commit -m "feat: extract keybindings to keybindings.lua module"
```

---

### Task 3: Create stub statusbar.lua and layouts.lua

**Files:**
- Create: `wezterm/statusbar.lua`
- Create: `wezterm/layouts.lua`

- [ ] **Step 1: Create stub `wezterm/statusbar.lua`**

```lua
local wezterm = require 'wezterm'
local M = {}

function M.apply()
  wezterm.on('update-status', function(window, pane)
    window:set_left_status('')
    window:set_right_status('')
  end)
end

return M
```

- [ ] **Step 2: Create stub `wezterm/layouts.lua`**

```lua
local wezterm = require 'wezterm'
local M = {}

function M.apply()
  wezterm.on('layout-main-horizontal', function(window, pane)
  end)

  wezterm.on('layout-main-vertical', function(window, pane)
  end)

  wezterm.on('layout-tiled', function(window, pane)
  end)
end

return M
```

- [ ] **Step 3: Commit**

```bash
git add wezterm/statusbar.lua wezterm/layouts.lua
git commit -m "feat: add stub statusbar and layouts modules"
```

---

### Task 4: Rewrite config.lua to use modules

**Files:**
- Modify: `wezterm/config.lua`

- [ ] **Step 1: Replace `config.lua` with modular version**

```lua
-- SYMLINK: ln -sf ~/dotconfig/wezterm/config.lua ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local keybindings = require 'keybindings'
local statusbar = require 'statusbar'
local layouts = require 'layouts'

local config = wezterm.config_builder()
local action = wezterm.action

config.color_scheme = 'Catppuccin Mocha'
config.color_scheme_dirs = { '~/.config/wezterm/colors' }

config.font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Medium' },
  { family = 'MesloLGS Nerd Font Mono' },
  'Noto Color Emoji',
}
config.font_size = 13.0
config.line_height = 1.1
config.cell_width = 1.0

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 24
config.hide_tab_bar_if_only_one_tab = false

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.use_ime = false

config.scrollback_lines = 10000

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

config.window_background_opacity = 0.95
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false

config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

config.front_end = 'WebGpu'
config.max_fps = 144
config.animation_fps = 1
config.cursor_blink_rate = 500
config.default_cursor_style = 'BlinkingBlock'

config.default_prog = { 'zsh' }
config.term = 'wezterm'

config.enable_scroll_bar = true
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
}

config.keys = keybindings.keys()
config.key_tables = keybindings.key_tables()

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover)
  local title = tab.tab_title
  if not title or title == '' then
    title = tab.is_active and '~' or tostring(tab.tab_index + 1)
  end
  local bg = tab.is_active and '#89b4fa' or '#45475a'
  local fg = tab.is_active and '#1e1e2e' or '#cdd6f4'
  return wezterm.format({
    { Text = ' ' },
    { Foreground = { Color = fg } },
    { Background = { Color = bg } },
    { Text = title },
    { Text = ' ' },
  })
end)

statusbar.apply()
layouts.apply()

return config
```

- [ ] **Step 2: Restart WezTerm and verify no errors**

WezTerm should load without any error overlay. Tab bar should still show at the bottom. Leader key (`Ctrl+Space`) should still work.

- [ ] **Step 3: Commit**

```bash
git add wezterm/config.lua
git commit -m "refactor: split config.lua into modular files"
```

---

### Task 5: Implement statusbar.lua — left status

**Files:**
- Modify: `wezterm/statusbar.lua`

- [ ] **Step 1: Implement left status (leader indicator + workspace + pane title)**

```lua
local wezterm = require 'wezterm'
local M = {}

local LEFT_SEP = '\u{e0b0}'
local RIGHT_SEP = '\u{e0b2}'

local C = {
  leader_bg   = '#f38ba8',
  layout_bg   = '#fab387',
  workspace_bg = '#89b4fa',
  pane_bg     = '#313244',
  hostname_bg = '#45475a',
  battery_bg  = '#a6e3a1',
  datetime_bg = '#313244',
  dark        = '#1e1e2e',
  light       = '#cdd6f4',
  bar_bg      = '#1e1e2e',
}

local function make_left(window, pane)
  local workspace = window:active_workspace()
  local process = pane:get_foreground_process_name()
  local basename = process:match('([^/\\]+)$') or process

  local leader_active = window:leader_is_active()
  local key_table = window:active_key_table()
  local layout_active = key_table == 'layout_mode'

  local e = {}

  if leader_active then
    table.insert(e, { Background = { Color = C.leader_bg } })
    table.insert(e, { Foreground = { Color = C.dark } })
    table.insert(e, { Text = '  LEADER  ' })
    table.insert(e, { Background = { Color = C.workspace_bg } })
    table.insert(e, { Foreground = { Color = C.leader_bg } })
    table.insert(e, { Text = LEFT_SEP })
  elseif layout_active then
    table.insert(e, { Background = { Color = C.layout_bg } })
    table.insert(e, { Foreground = { Color = C.dark } })
    table.insert(e, { Text = '  LAYOUT  ' })
    table.insert(e, { Background = { Color = C.workspace_bg } })
    table.insert(e, { Foreground = { Color = C.layout_bg } })
    table.insert(e, { Text = LEFT_SEP })
  else
    table.insert(e, { Background = { Color = C.workspace_bg } })
  end

  -- Workspace
  table.insert(e, { Background = { Color = C.workspace_bg } })
  table.insert(e, { Foreground = { Color = C.dark } })
  table.insert(e, { Text = '  ' .. workspace .. '  ' })

  -- Separator workspace → pane
  table.insert(e, { Background = { Color = C.pane_bg } })
  table.insert(e, { Foreground = { Color = C.workspace_bg } })
  table.insert(e, { Text = LEFT_SEP })

  -- Pane title
  table.insert(e, { Background = { Color = C.pane_bg } })
  table.insert(e, { Foreground = { Color = C.light } })
  table.insert(e, { Text = '  ' .. basename .. '  ' })

  -- Trailing separator
  table.insert(e, { Background = { Color = C.bar_bg } })
  table.insert(e, { Foreground = { Color = C.pane_bg } })
  table.insert(e, { Text = LEFT_SEP })

  return wezterm.format(e)
end

local function make_right(window, pane)
  return ''
end

function M.apply()
  wezterm.on('update-status', function(window, pane)
    window:set_left_status(make_left(window, pane))
    window:set_right_status(make_right(window, pane))
  end)
end

return M
```

- [ ] **Step 2: Restart WezTerm and verify left status**

Expected: left status shows `  main  ` (workspace) `  zsh  ` (or current process) with blue and dark powerline segments. When `Ctrl+Space` is pressed, `LEADER` indicator appears in red/pink.

- [ ] **Step 3: Commit**

```bash
git add wezterm/statusbar.lua
git commit -m "feat: implement left status bar with leader/layout indicator"
```

---

### Task 6: Implement statusbar.lua — right status

**Files:**
- Modify: `wezterm/statusbar.lua`

- [ ] **Step 1: Replace `make_right` function with full implementation**

Replace the `make_right` function in `wezterm/statusbar.lua`:

```lua
local function make_right(window, pane)
  local hostname = wezterm.hostname()
  local time_str = wezterm.time.now():format('%a %d %b  %H:%M')

  local bat_text = ''
  local ok, bat_info = pcall(wezterm.battery_info)
  if ok and bat_info and #bat_info > 0 then
    local bat = bat_info[1]
    local level = bat.state_of_charge
    local icon = level >= 0.9 and ''
      or level >= 0.7 and ''
      or level >= 0.4 and ''
      or level >= 0.1 and ''
      or ''
    bat_text = icon .. ' ' .. math.floor(level * 100) .. '%'
  end

  local e = {}

  -- Hostname segment
  table.insert(e, { Background = { Color = C.bar_bg } })
  table.insert(e, { Foreground = { Color = C.hostname_bg } })
  table.insert(e, { Text = RIGHT_SEP })
  table.insert(e, { Background = { Color = C.hostname_bg } })
  table.insert(e, { Foreground = { Color = C.light } })
  table.insert(e, { Text = '  ' .. hostname .. '  ' })

  -- Battery segment (only if battery present)
  if bat_text ~= '' then
    table.insert(e, { Background = { Color = C.hostname_bg } })
    table.insert(e, { Foreground = { Color = C.battery_bg } })
    table.insert(e, { Text = RIGHT_SEP })
    table.insert(e, { Background = { Color = C.battery_bg } })
    table.insert(e, { Foreground = { Color = C.dark } })
    table.insert(e, { Text = '  ' .. bat_text .. '  ' })
    -- Datetime following battery
    table.insert(e, { Background = { Color = C.battery_bg } })
    table.insert(e, { Foreground = { Color = C.datetime_bg } })
    table.insert(e, { Text = RIGHT_SEP })
  else
    -- Datetime following hostname (no battery)
    table.insert(e, { Background = { Color = C.hostname_bg } })
    table.insert(e, { Foreground = { Color = C.datetime_bg } })
    table.insert(e, { Text = RIGHT_SEP })
  end

  -- Datetime segment
  table.insert(e, { Background = { Color = C.datetime_bg } })
  table.insert(e, { Foreground = { Color = C.light } })
  table.insert(e, { Text = '  ' .. time_str .. '  ' })

  return wezterm.format(e)
end
```

- [ ] **Step 2: Restart WezTerm and verify right status**

Expected: right side shows `◀ hostname ◀ [battery] ◀ Thu 17 Apr  14:32` with correct powerline separators and Catppuccin Mocha colors. If no battery, battery segment is absent.

- [ ] **Step 3: Commit**

```bash
git add wezterm/statusbar.lua
git commit -m "feat: implement right status bar with hostname, battery, datetime"
```

---

### Task 7: Implement layouts.lua

**Files:**
- Modify: `wezterm/layouts.lua`

- [ ] **Step 1: Implement all three layout presets in `wezterm/layouts.lua`**

```lua
local wezterm = require 'wezterm'
local M = {}

local function layout_main_horizontal(window, pane)
  local tab = window:active_tab()
  local panes = tab:panes()
  if #panes == 1 then
    pane:split { direction = 'Bottom', size = 0.35 }
  end
  window:perform_action(wezterm.action.PopKeyTable, pane)
end

local function layout_main_vertical(window, pane)
  local tab = window:active_tab()
  local panes = tab:panes()
  if #panes == 1 then
    pane:split { direction = 'Right', size = 0.35 }
  end
  window:perform_action(wezterm.action.PopKeyTable, pane)
end

local function layout_tiled(window, pane)
  local tab = window:active_tab()
  local panes = tab:panes()
  if #panes == 1 then
    local right = pane:split { direction = 'Right', size = 0.5 }
    pane:split { direction = 'Bottom', size = 0.5 }
    right:split { direction = 'Bottom', size = 0.5 }
  end
  window:perform_action(wezterm.action.PopKeyTable, pane)
end

function M.apply()
  wezterm.on('layout-main-horizontal', layout_main_horizontal)
  wezterm.on('layout-main-vertical', layout_main_vertical)
  wezterm.on('layout-tiled', layout_tiled)
end

return M
```

- [ ] **Step 2: Restart WezTerm and test layout presets**

Test sequence:
1. Open WezTerm with a single pane
2. Press `Ctrl+Space` then `Space` → status bar should show `LAYOUT` indicator
3. Press `v` → pane should split vertically (1 large left, 1 right)
4. Open a new tab, press `Ctrl+Space Space t` → should create a 2x2 grid
5. Open a new tab, press `Ctrl+Space Space h` → should split horizontally (1 large top, 1 bottom)

- [ ] **Step 3: Commit**

```bash
git add wezterm/layouts.lua
git commit -m "feat: implement pane layout presets (main-horizontal, main-vertical, tiled)"
```

---

### Task 8: Verify copy mode enhancements

**Files:**
- No changes needed — copy mode was already updated in `keybindings.lua` (Task 2)

- [ ] **Step 1: Test copy mode**

Test sequence:
1. Press `Ctrl+Space` then `y` → enters copy mode (cursor appears)
2. Press `v` → start cell selection
3. Press `V` → switch to line selection
4. Press `Ctrl+V` → switch to block selection
5. Press `g` → jump to top of scrollback
6. Press `G` → jump to bottom
7. Press `M` → jump to middle of viewport
8. Press `/` → search prompt appears
9. Type a word, press Enter → first match highlighted
10. Press `n` → next match, `N` → previous match
11. Press `Ctrl+D` → scroll toward bottom
12. Press `Ctrl+U` → scroll toward top
13. Press `y` → copy selection to clipboard
14. Press `q` → exit copy mode

- [ ] **Step 2: Commit if any fixes were needed**

```bash
git add wezterm/keybindings.lua
git commit -m "fix: correct copy mode keybindings after manual testing"
```

---

### Task 9: Update install.sh wezterm symlink (fix old config.lua reference)

**Files:**
- Modify: `install.sh:84`

- [ ] **Step 1: Verify install.sh was updated in Task 1 and symlinks are correct**

Run: `cat install.sh | grep wezterm`

Expected: lines reference `wezterm.lua` (not `config.lua`) and include `statusbar.lua`, `keybindings.lua`, `layouts.lua`.

- [ ] **Step 2: Final commit**

```bash
git add -A
git status
git commit -m "feat: wezterm tmux-like features complete — status bar, layouts, copy mode"
```
