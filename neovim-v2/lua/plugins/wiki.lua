vim.pack.add({
	gh("nvim-tree/nvim-web-devicons"),
	gh("lervag/lists.vim"),
	gh("lervag/wiki.vim"),
})

vim.g.wiki_root = "~/wiki"

vim.keymap.set("n", "<leader>wt", ":WikiJournal<CR>")
vim.keymap.set("n", "<leader>fw", function()
	require("telescope.builtin").live_grep({
		cwd = "~/wiki",
	})
end, { desc = "[F]ind [W]iki" })
vim.keymap.set("n", "<leader>fa", function()
	require("wiki.telescope").pages({
		file_ignore_patterns = {
			"%journal/*",
		},
	})
end, { desc = "[F]ind [A]rticles" })

-- this should try for wiki style links FIRST
vim.keymap.set("n", "<leader>lw", function()
	require("wiki.telescope").links("insert", {
		file_ignore_patterns = {
			"%journal/*",
		},
	})
end, { desc = "[L]ink [W]iki", remap = true })
