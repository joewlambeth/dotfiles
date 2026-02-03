local module = {}

module.apply_to_config = function(config)
	require("init").apply_to_config(config, "CTRL|SHIFT")
	config.font_size = 16
	config.window_decorations = "RESIZE"
	-- config.kde_window_background_blur = true
	config.window_background_opacity = 1
	config.window_background_gradient = {
		colors = {
			"#000000",
			"#1A1A1A",
		},
		noise = 128,
		orientation = {
			Linear = {
				angle = -45.0,
			},
		},
	}
end

return module
