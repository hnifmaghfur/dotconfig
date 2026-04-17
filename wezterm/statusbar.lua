local wezterm = require 'wezterm'
local M = {}

function M.apply()
  wezterm.on('update-status', function(window, pane)
    window:set_left_status('')
    window:set_right_status('')
  end)
end

return M
