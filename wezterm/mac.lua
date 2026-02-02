local module = {}

module.apply_to_config = function(config)
	require("init").apply_to_config(config)
	config.font_size = 16
	config.macos_window_background_blur = 20
	config.window_decorations = "RESIZE"
	config.window_background_opacity = 0.9
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
