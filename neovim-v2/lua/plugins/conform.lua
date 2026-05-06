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

local auto_format = true
_G.conform_toggle = function()
	return auto_format and "ON" or "OFF"
end

vim.keymap.set("n", "<leader>ca", function()
	auto_format = not auto_format
	vim.cmd("redrawstatus")
	print("Automatic formatting turned " .. conform_toggle())
end, { desc = "[C]onform [A]utomatic Toggle" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if auto_format then
			require("conform").format({ bufnr = args.buf })
		end
	end,
})
