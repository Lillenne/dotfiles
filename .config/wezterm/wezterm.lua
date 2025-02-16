local wezterm = require 'wezterm'
local config = {}
config = wezterm.config_builder()
config.color_scheme = 'OneDark (base16)'
config.font = wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Regular', italic = false })
config.default_cursor_style = 'BlinkingBar'
-- config.default_prog = { 'arch' } -- Spawn a arch wsl shell on login
return config
