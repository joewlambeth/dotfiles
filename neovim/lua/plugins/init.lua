return {
	"tpope/vim-sleuth",
	"folke/which-key.nvim",
	{
		"saxon1964/neovim-tips",
		lazy = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- TODO: markdown previewer?
		},
		opts = {
			daily_tip = 2,
		},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {
			duration_multiplier = 0.5,
		},
	},

	-- TODO: todo, ironically
	-- lines that show scopes
}
