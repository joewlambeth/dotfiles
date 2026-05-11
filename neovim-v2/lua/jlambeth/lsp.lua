local servers = {
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	},
	pyright = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
	},
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
	},
	kotlin_lsp = {
		cmd = { "kotlin-lsp" },
		filetypes = { "kotlin" },
	},
}

for name, config in pairs(servers) do
	config.capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

local map = function(key, command, desc)
	vim.keymap.set("n", key, command, { desc = desc })
end

map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction")
