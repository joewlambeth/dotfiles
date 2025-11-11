local M = {}

M.vanilla = function()
	vim.keymap.set("n", "<leader>e", "<Cmd>Ex<CR>", { desc = "[E]xplore" })
	vim.keymap.set("i", "kj", "<Esc>")
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	vim.keymap.set("x", "@", function()
		-- Save the visual-selection positions right away (before any prompts)
		local start_pos = tonumber(vim.fn.getpos("v")[2]) -- {bufnum, lnum, col, off}
		local end_pos = tonumber(vim.fn.getpos(".")[2])

		if start_pos > end_pos then
			start_pos, end_pos = end_pos, start_pos
		end

		local ok, reg = pcall(vim.fn.getcharstr)
		if not ok or reg == "" or reg == "\27" then
			print("Cancelled")
			return
		end
		reg = reg:sub(1, 1)
		vim.notify(string.format("recorded range is %s %s", start_pos, end_pos))
		vim.cmd(string.format("%d,%dnormal! @%s", tonumber(start_pos), tonumber(end_pos), reg))
	end, { desc = "Run macro over visual selection", noremap = true, silent = true })
	vim.keymap.set("n", "#", "@q", { desc = "Quick macro execute" })

	vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
	vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })

	vim.keymap.set("n", "Q", "<nop>")
end

M.wiki = function()
	vim.keymap.set("n", "<leader>wt", ":WikiJournal<CR>")
	vim.keymap.set("n", "<leader>sw", function()
		require("telescope.builtin").live_grep({
			cwd = "~/wiki",
		})
	end, { desc = "[S]earch [W]iki" })
	vim.keymap.set("n", "<leader>sa", function()
		require("wiki.telescope").pages({
			file_ignore_patterns = {
				"%journal/*",
			},
		})
	end, { desc = "[S]earch [A]rticles" })

	-- this should try for wiki style links FIRST
	vim.keymap.set("n", "<leader>lw", function()
		require("wiki.telescope").links("insert", {
			file_ignore_patterns = {
				"%journal/*",
			},
		})
	end, { desc = "[L]ink [W]iki", remap = true })
end

M.markdown = function(bufnr)
	local opts = { buffer = bufnr }

	local do_set = function(key, command)
		vim.keymap.set({ "n" }, key, function()
			if command() then
				return
			end

			local cnt = vim.v.count1
			vim.cmd("normal! " .. cnt .. key)
			vim.cmd("startinsert")
		end, opts)
	end

	do_set("o", require("markdown.list").insert_list_item_below)
	do_set("O", require("markdown.list").insert_list_item_above)
end

M.telescope = function()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "[S]earch Vim [O]ptions" })

	-- Slightly advanced example of overriding default behavior and theme
	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })
end

M.lsp = function()
	local map = function(key, command, desc)
		vim.keymap.set("n", key, command, { desc = desc })
	end

	map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction")

	local telescope = require("telescope.builtin")

	map("grr", telescope.lsp_references, "[G]oto [R]eferences")
	map("grd", telescope.lsp_definitions, "[G]oto [D]efinition")
	map("gp", telescope.diagnostics, "[G]oto [D]iagnostics")
end

M.term = function()
	vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>t", function()
		require("jlambeth.terminal").toggle_term()
	end, {
		desc = "Toggle [T]erminal",
		noremap = true,
		silent = true,
	})
	vim.keymap.set("t", "kj", function()
		require("jlambeth.terminal").toggle_term()
	end)
end

M.git = function()
	local gitsigns = require("gitsigns")
	vim.keymap.set("n", "<leader>gb", function()
		gitsigns.blame()
	end)

	vim.keymap.set("n", "<leader>gh", function()
		gitsigns.preview_hunk_inline()
	end)
	-- TODO: something nice for commit previewing
end

return M
