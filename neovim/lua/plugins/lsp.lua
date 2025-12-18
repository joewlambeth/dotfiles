-- lsp and treesitter are the same to me
-- nerds cry about it

local servers = {
	lua_ls = {},
	kotlin_lsp = {},
}

local on_attach = function(_, bufnr)
	require("jlambeth.mappings").lsp()
end

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
				"kotlin",
				"python",
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
		"saghen/blink.cmp",
		opts = {
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},

				-- Do not preselect items
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},

				documentation = {
					auto_show = true,
				},
				ghost_text = { enabled = true },
			},
			signature = { enabled = true },
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {},
			},
			{
				"mason-org/mason-lspconfig.nvim",
				opts = {
					ensure_installed = vim.tbl_keys(servers),
					automatic_enable = true,
				},
			},
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for server_name, config in pairs(servers) do
				config.on_attach = on_attach
				config.capabilities = capabilities
				vim.lsp.config(server_name, config)
			end
		end,
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
