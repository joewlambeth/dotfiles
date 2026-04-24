vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettier", "injected" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "jq" },
		python = { "autopep8" },
	},
})

vim.keymap.set("n", "<leader>cc", conform.format, { desc = "[C]onform [C]ode" })

local on_save = true
_G.conform_toggle = function()
	return on_save and "ON" or "OFF"
end

vim.keymap.set("n", "<leader>ca", function()
	on_save = not on_save
	vim.cmd("redrawstatus")
	print("Automatic formatting turned " .. conform_toggle())
end, { desc = "[C]onform [A]utomatic Toggle" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if on_save then
			require("conform").format({ bufnr = args.buf })
		end
	end,
})
