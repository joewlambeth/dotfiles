local M = {}

M.filetypes = {
	"bash",
	"diff",
	"html",
	"java",
	"javascript",
	"jsx",
	"kotlin",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"kotlin",
	"python",
	"typescript",
	"tsx",
	"go",
}

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").install(M.filetypes)
vim.api.nvim_create_autocmd("FileType", {
	pattern = M.filetypes,
	callback = function()
		vim.treesitter.start()
	end,
})

return M
