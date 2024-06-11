local wezterm = require 'wezterm'
local config = {}
config = wezterm.config_builder()
config.color_scheme = 'OneDark (base16)'
config.font = wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Regular', italic = false })
config.font_size = 14.0
-- config.default_cursor_style = 'BlinkingBlock'
-- config.default_prog = { 'arch' } -- Spawn a arch wsl shell on login
return config
