return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					markdown = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					python = { "autopep8" },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
			require("conform.formatters").injected = {
				options = {
					ft_parsers = {},
					ext_parsers = {},
				},
			}
		end,
	},
}
