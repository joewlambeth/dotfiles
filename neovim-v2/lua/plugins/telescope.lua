vim.pack.add({
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-lua/plenary.nvim"),
	-- gh("nvim-telescope/telescope-fzf-native.nvim"),
})

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ft", telescope.builtin, { desc = "[F]ind [T]elescopes" })
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>fs", telescope.builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", telescope.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>f.", telescope.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", telescope.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>fo", telescope.vim_options, { desc = "[F]ind Vim [O]ptions" })

vim.keymap.set("n", "grr", telescope.lsp_references, { desc = "[G]oto [R]eferences" })
vim.keymap.set("n", "grd", telescope.lsp_definitions, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gp", telescope.diagnostics, { desc = "[G]oto [D]iagnostics" })
vim.keymap.set("n", "<leader>fs", function()
	telescope.lsp_dynamic_workspace_symbols({
		ignore_symbols = { "variable" },
	})
end, { desc = "[F]ind [S]ymbols" })
