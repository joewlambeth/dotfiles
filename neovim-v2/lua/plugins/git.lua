vim.pack.add({
	gh("lewis6991/gitsigns.nvim"),
	gh("NeogitOrg/neogit"),
	gh("sindrets/diffview.nvim"),
})

require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
})

local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>gb", function()
	gitsigns.blame()
end, {
	desc = "[G]it [B]lame",
})

vim.keymap.set("n", "[c", function()
	gitsigns.nav_hunk("prev", {
		wrap = false,
		target = "all",
	}, function()
		gitsigns.preview_hunk_inline()
	end)
end, {
	desc = "Previous [C]hange",
})

vim.keymap.set("n", "]c", function()
	gitsigns.nav_hunk("next", {
		wrap = false,
		target = "all",
	}, function()
		gitsigns.preview_hunk_inline()
	end)
end, {
	desc = "Next [C]hange",
})

require("diffview").setup()

local neogit = require("neogit")

neogit.setup({
	telescope = true,
	diffview = true,
	commit_editor = {
		show_staged_diff = false,
	},
	disable_line_numbers = false,
})

vim.keymap.set("n", "<leader>gd", function()
	neogit.open({ "diff" })
end, {
	desc = "[G]it [D]iff",
})

vim.keymap.set("n", "<leader>gg", function()
	neogit.open({ kind = "floating" })
end, {
	desc = "[G]it [G]o",
})

vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { desc = "[G]it [V]iew" })
vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewClose<cr>", { desc = "[G]it [V]iew Close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "[G]it File [H]istory" })
