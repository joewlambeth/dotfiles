return {
	{ -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		-- 'folke/tokyonight.nvim',
		"sainnhe/everforest",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "hard"
			vim.cmd.colorscheme("everforest")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatFooter", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
		end,
	},
}
