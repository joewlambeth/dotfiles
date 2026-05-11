local module = {}

module.apply_to_config = function(config)
	require("init").apply_to_config(config, "SUPER")
	config.font_size = 16
	config.macos_window_background_blur = 20
	config.window_decorations = "RESIZE"
	config.window_background_opacity = 0.9
end

return module
