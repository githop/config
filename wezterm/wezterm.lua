local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true

config.color_scheme = "Kanagawa Dragon"

config.font = wezterm.font("IosevkaTerm Nerd Font Mono", { weight = "Medium" })

config.font_size = 20.5

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.enable_scroll_bar = true

return config
