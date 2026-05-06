local module = {}
local wezterm = require("wezterm")
local layout = require("layout")

module.apply_to_config = function(config, super)
	config.harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
	}
	config.use_fancy_tab_bar = false
	config.enable_tab_bar = true
	config.tab_max_width = 100

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
		layout.bind_next_pane(super, "j"),
		{
			key = "r",
			mods = super,
			action = layout.rename_tab,
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
		{
			key = "o",
			mods = super,
			action = require("scrollback").edit_command,
		},
	}
	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = super,
			action = layout.activate_tab(i - 1),
		})
	end
end

return module
