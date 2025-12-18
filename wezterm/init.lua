local module = {}

module.apply_to_config = function(config)
	config.harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
	}
	config.window_background_opacity = 0.8
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
