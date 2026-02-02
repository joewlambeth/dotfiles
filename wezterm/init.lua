local module = {}
local wezterm = require("wezterm")
local layout = require("layout")

module.apply_to_config = function(config)
	config.harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
	}
	config.use_fancy_tab_bar = false
	config.enable_tab_bar = true

	config.keys = {
		layout.bind_wiki(),
		layout.bind_workspace("python", wezterm.home_dir),
	}
	wezterm.default_workspace = "🧠 wiki"

	wezterm.action.SwitchToWorkspace({ name = layout.first_workspace })
end

return module
