vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("jlambeth.statuscolumn")
require("jlambeth.wezterm")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

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

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected in the terminal

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus,unnamed"
end)

vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "nosplit"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4

vim.opt.colorcolumn = "120"
vim.o.winborder = "rounded"

vim.diagnostic.config({
	virtual_text = { current_line = false },
	virtual_lines = {
		current_line = true,
		format = function(diagnostic)
			local max_width = 80
			local msg = diagnostic.message
			if #msg <= max_width then
				return msg
			end
			local lines = {}
			local current = ""
			for word in msg:gmatch("%S+") do
				if current == "" then
					if #word > max_width then
						table.insert(lines, word:sub(1, max_width))
						current = word:sub(max_width + 1)
					else
						current = word
					end
				elseif #current + 1 + #word <= max_width then
					current = current .. " " .. word
				else
					table.insert(lines, current)
					current = word
				end
			end
			if current ~= "" then
				table.insert(lines, current)
			end
			return table.concat(lines, "\n")
		end,
	},
})
