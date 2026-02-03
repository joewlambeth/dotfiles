local module = {}

local wezterm = require("wezterm")
local mux = wezterm.mux

module.apply_to_config = function(config)
	require("init").apply_to_config(config, "CTRL|SHIFT")
	config.default_prog = { "wsl.exe", "-d", "Ubuntu" }
	-- put this in your local, rename based on your username
	-- config.default_cwd = [[\\wsl$\Ubuntu\home\josep]]
	config.win32_system_backdrop = "Disable"
	config.window_background_opacity = 1
end

return module
