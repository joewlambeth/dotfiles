local module = {}

module.apply_to_config = function(config)
	require("init").apply_to_config(config)
	config.font_size = 16
	config.macos_window_background_blur = 20
	config.window_decorations = "RESIZE"
end

return module
