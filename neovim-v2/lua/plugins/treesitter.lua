local filetypes = {
	"bash",
	"diff",
	"html",
	"java",
	"javascript",
	"kotlin",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"kotlin",
	"python",
	"typescript",
}

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").install(filetypes)
vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function()
		vim.treesitter.start()
	end,
})
