return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		opts = {
			extensions = {
				["ui-select"] = {},
			},
		},
		config = function()
			local telescope = require("telescope")
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")
			require("jlambeth.mappings").telescope()
		end,
	},
}
