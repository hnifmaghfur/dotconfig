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
