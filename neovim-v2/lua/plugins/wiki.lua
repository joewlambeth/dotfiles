return {
	-- 'MeanderingProgrammer/render-markdown.nvim',
	-- 'qadzek/link.nvim',
	-- 'lervag/lists.vim',
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		config = function()
			require("markdown").setup({
				on_attach = function(bufnr)
					require("jlambeth.mappings").markdown(bufnr)
				end,
			})
		end,
	},
	{
		"lervag/wiki.vim",
		tag = "v0.10",
		init = function()
			vim.g.wiki_root = "~/wiki"
		end,
		config = function()
			require("jlambeth.mappings").wiki()
		end,
	},
}
