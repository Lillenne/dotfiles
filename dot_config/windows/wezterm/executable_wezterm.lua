local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "OneDark (base16)"
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular", italic = false })
config.font_size = 14.0
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.launch_menu = {
	{
		label = "nvim",
		args = { "arch", "run", "nvim" },
	},
	{
		label = "emacs",
		args = { "arch", "run", "emacsclient", "-c" },
	},
	{
		label = "arch",
		args = { "arch" },
	},
	{
		label = "pwsh",
		args = { "powershell.exe", "-NoLogo" },
		cwd = "c:/Users/austin.kearns/",
	},
}
config.keys = {
	{
		key = "b",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "l", mods = "LEADER", action = wezterm.action.ShowLauncher },
	-- {
	-- 	key = "2",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action.({ domain = pwsh }),
	-- },
}
-- Notesto self
-- csx copy mode
-- move with c-hjkl, close pane cq
-- csn spawn new window

-- config.default_cursor_style = 'BlinkingBlock'
config.default_prog = { "arch" } -- Spawn a arch wsl shell on login
return config
