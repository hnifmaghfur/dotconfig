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