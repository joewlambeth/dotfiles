vim.pack.add({
	gh("nvim-tree/nvim-web-devicons"),
	gh("lervag/lists.vim"),
	gh("lervag/wiki.vim"),
	gh("MeanderingProgrammer/render-markdown.nvim"),
})

vim.g.wiki_root = "~/wiki"

vim.keymap.set("n", "<leader>wt", function()
	vim.cmd("WikiJournal")
end, { desc = "[W]iki [T]oday" })
vim.keymap.set("n", "<leader>fw", function()
	require("telescope.builtin").live_grep({
		cwd = "~/wiki",
		file_ignore_patterns = {
			"%private/*",
		},
	})
end, { desc = "[F]ind [W]iki" })
vim.keymap.set("n", "<leader>fa", function()
	require("wiki.telescope").pages({
		file_ignore_patterns = {
			"%journal/*",
		},
	})
end, { desc = "[F]ind [A]rticles" })

vim.keymap.set("n", "<leader>mh", function()
	vim.cmd([[silent write !pandoc -f markdown -t html -o /tmp/x.html && open /tmpp/x.html]])
end, { desc = "[M]arkdwon [H]TML" })

local M = {}

local function heading_level(line)
	local indent, hashes = line:match("^(%s*)(#+)%s+")
	if not hashes then
		return nil
	end
	if #indent > 3 then
		return nil
	end
	return #hashes
end

function M.fold(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local ranges = {}
	local stack = {}

	local function add_range(start_line, end_line)
		if start_line and end_line and end_line > start_line then
			ranges[#ranges + 1] = {
				startLine = start_line,
				endLine = end_line,
			}
		end
	end

	for i, line in ipairs(lines) do
		local level = heading_level(line)
		if level and level > 1 then
			local line0 = i - 1
			while #stack > 0 and stack[#stack].level >= level do
				local prev = table.remove(stack)
				add_range(prev.line, line0 - 1)
			end

			stack[#stack + 1] = { line = line0, level = level }
		end
	end

	local last = math.max(#lines - 1, 0)
	while #stack > 0 do
		local prev = table.remove(stack)
		add_range(prev.line, last)
	end

	return ranges
end

return M
