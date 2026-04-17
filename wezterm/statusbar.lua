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

  if bat_text ~= '' then
    -- Battery segment
    table.insert(e, { Background = { Color = C.hostname_bg } })
    table.insert(e, { Foreground = { Color = C.battery_bg } })
    table.insert(e, { Text = RIGHT_SEP })
    table.insert(e, { Background = { Color = C.battery_bg } })
    table.insert(e, { Foreground = { Color = C.dark } })
    table.insert(e, { Text = '  ' .. bat_text .. '  ' })
    -- Datetime follows battery
    table.insert(e, { Background = { Color = C.battery_bg } })
    table.insert(e, { Foreground = { Color = C.datetime_bg } })
    table.insert(e, { Text = RIGHT_SEP })
  else
    -- Datetime follows hostname (no battery)
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

function M.apply()
  wezterm.on('update-status', function(window, pane)
    window:set_left_status(make_left(window, pane))
    window:set_right_status(make_right(window, pane))
  end)
end

return M
