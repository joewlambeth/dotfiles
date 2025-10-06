-- lsp and treesitter are the same to me
-- nerds cry about it

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
			},
		},
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {}
			},
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp"
		},
		config = function()
			require("mason-lspconfig").setup({
				vim.api.nvim_create_autocmd('LspAttach', {

					callback = function(args)
						-- https://github.com/neovim/neovim/issues/30644
						vim.o.completeopt = 'noinsert,fuzzy,menu'
						local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
						vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true})
						require("jlambeth.mappings").lsp()
					end
				})
			})

		end
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
