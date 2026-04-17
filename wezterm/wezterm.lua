local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.font_size = 12.0

-- set basic color scheme
config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

-- add window transparency
config.window_background_opacity = 0.92
config.text_background_opacity = 1.0

-- Disable tab
config.enable_tab_bar = false

-- Cursor Style & Smoothness
config.default_cursor_style = "BlinkingBar"

return config