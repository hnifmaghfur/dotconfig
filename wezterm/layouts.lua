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
