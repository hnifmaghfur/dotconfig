local wezterm = require 'wezterm'
local M = {}

local LEFT_SEP = '\u{e0b0}'
local RIGHT_SEP = '\u{e0b2}'

local C = {
  leader_bg    = '#f38ba8',
  layout_bg    = '#fab387',
  workspace_bg = '#89b4fa',
  pane_bg      = '#313244',
  hostname_bg  = '#45475a',
  battery_bg   = '#a6e3a1',
  datetime_bg  = '#313244',
  dark         = '#1e1e2e',
  light        = '#cdd6f4',
  bar_bg       = '#1e1e2e',
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
