function _G.gh(name)
	return "https://github.com/" .. name
end

require("plugins.colors")
require("plugins.conform")
require("plugins.git")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.wiki")

vim.pack.add({
	gh("tpope/vim-sleuth"),
	gh("folke/which-key.nvim"),
	gh("windwp/nvim-autopairs"),
	gh("lukas-reineke/indent-blankline.nvim"),
})

require("nvim-autopairs").setup({})
require("ibl").setup({
	indent = { char = "│" },
	whitespace = { highlight = { "Whitespace", "NonText" } },
})
