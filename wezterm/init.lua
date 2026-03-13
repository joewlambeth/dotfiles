local module = {}
local wezterm = require("wezterm")
local layout = require("layout")
local action = wezterm.action

module.apply_to_config = function(config, super)
	config.harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
	}
	config.use_fancy_tab_bar = false
	config.enable_tab_bar = true

	config.inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.5,
	}

	config.keys = {
		{
			key = "k",
			mods = super,
			action = layout.focus_pane,
		},
		{
			key = "j",
			mods = super,
			action = layout.navigate_pane("Next"),
		},
		{
			key = ";",
			mods = super,
			action = layout.search_workspaces,
		},
		{
			key = "s",
			mods = super,
			action = layout.split_pane,
		},
		{
			key = "e",
			mods = super,
			action = require("scrollback").clear_scrollback,
		},
		-- https://www.nerdfonts.com/cheat-sheet
		layout.bind_wiki(),
		layout.bind_workspace(" dotfiles", wezterm.home_dir .. "/dotfiles"),
	}
	wezterm.default_workspace = "🧠 wiki"

	wezterm.action.SwitchToWorkspace({ name = layout.first_workspace })
end

return module
