local wezterm = require 'wezterm'
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
config.hide_tab_bar_if_only_one_tab = true

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.use_ime = false

config.scrollback_lines = 10000

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

config.window_background_opacity = 0.95
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

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
    action = action.CompleteSelection 'ClipboardOrPrimarySelection',
  },
}

config.keys = {
  { key = 'c', mods = 'CTRL|SHIFT', action = action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = action.PasteFrom 'Clipboard' },
  { key = 't', mods = 'CTRL|SHIFT', action = action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = action.CloseCurrentTab { confirm = false } },
  { key = 'n', mods = 'CTRL|SHIFT', action = action.SpawnWindow },

  { key = 'Tab', mods = 'CTRL', action = action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = action.ActivateTabRelative(-1) },
  { key = '-', mods = 'LEADER', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'LEADER|SHIFT', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },
  { key = 'Left', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
  { key = 'Down', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
  { key = 'Up', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
  { key = 'Right', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },

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

  { key = '[', mods = 'LEADER', count = 1, action = action.ActivateKeyTable 'resize_pane' },
}

config.key_tables = {
  resize_pane = {
    { key = 'h', action = action.AdjustPaneSize { 'Left', 1 } },
    { key = 'j', action = action.AdjustPaneSize { 'Down', 1 } },
    { key = 'k', action = action.AdjustPaneSize { 'Up', 1 } },
    { key = 'l', action = action.AdjustPaneSize { 'Right', 1 } },
    { key = 'Left', action = action.AdjustPaneSize { 'Left', 1 } },
    { key = 'Down', action = action.AdjustPaneSize { 'Down', 1 } },
    { key = 'Up', action = action.AdjustPaneSize { 'Up', 1 } },
    { key = 'Right', action = action.AdjustPaneSize { 'Right', 1 } },
    { key = 'Escape', action = 'PopKeyTable' },
  },
  copy_mode = {
    { key = 'q', action = action.PopKeyTable },
    { key = 'Escape', action = action.PopKeyTable },
    { key = 'v', action = action.CopyMode 'Visual' },
    { key = 'V', action = action.CopyMode 'VisualLine' },
    { key = 'y', action = action.CopyTo 'Clipboard' },
    { key = 'h', action = action.CopyMode 'MoveLeft' },
    { key = 'j', action = action.CopyMode 'MoveDown' },
    { key = 'k', action = action.CopyMode 'MoveUp' },
    { key = 'l', action = action.CopyMode 'MoveRight' },
    { key = 'w', action = action.CopyMode 'MoveForwardWord' },
    { key = 'b', action = action.CopyMode 'MoveBackwardWord' },
    { key = '0', action = action.CopyMode 'MoveToLineStart' },
    { key = '$', action = action.CopyMode 'MoveToLineEnd' },
    { key = 'g', action = action.CopyMode 'MoveToBufferTop' },
    { key = 'G', action = action.CopyMode 'MoveToBufferBottom' },
    { key = 'PageUp', action = action.CopyMode 'PageUp' },
    { key = 'PageDown', action = action.CopyMode 'PageDown' },
    { key = 'f', action = action.CopyMode 'Find' },
    { key = '/', action = action.CopyMode 'Find' },
    { key = 'n', action = action.CopyMode 'FindNext' },
    { key = 'N', action = action.CopyMode 'FindPrevious' },
  },
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover)
  local title = tab.tab_title
  if not title or title == '' then
    title = tab.active and '~' or tostring(tab.tab_index + 1)
  end
  local bg = tab.is_active and '#89b4fa' or '#45475a'
  local fg = tab.is_active and '#1e1e2e' or '#cdd6f4'
  return {
    { Text = ' ' },
    { Text = title, foreground = fg, background = bg, bold = tab.is_active },
    { Text = ' ' },
  }
end)

wezterm.on('window-resized', function(window, pane)
  window:print_info('Window resized to ' .. window:get_dimensions().pixel_width .. 'x' .. window:get_dimensions().pixel_height)
end)

return config