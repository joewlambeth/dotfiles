return {
	{ -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		-- 'folke/tokyonight.nvim',
		"sainnhe/everforest",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "hard"

			vim.cmd.colorscheme("everforest")
		end,
	},
}
