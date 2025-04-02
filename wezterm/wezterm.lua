-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Solarized (dark) (terminal.sexy)'

-- auto reload
config.automatically_reload_config = true

-- font
config.font = wezterm.font_with_fallback {
  { family = "Cica" },
  { family = "Cica", assume_emoji_presentation = true },
}
config.font_size = 15

config.use_ime = true

config.window_background_opacity = 0.65

config.macos_window_background_blur = 20

-- and finally, return the configuration to wezterm
return config
