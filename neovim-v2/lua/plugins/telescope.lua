return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
