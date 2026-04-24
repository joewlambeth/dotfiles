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
		filetypes = { "py" },
	},
}

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

local map = function(key, command, desc)
	vim.keymap.set("n", key, command, { desc = desc })
end

map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction")
