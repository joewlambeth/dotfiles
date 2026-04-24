local function next_pane()
	if vim.fn.winnr() == vim.fn.winnr("$") then
		vim.fn.system({ "wezterm", "cli", "activate-pane-direction", "Next" })
	end
	vim.cmd("wincmd w")
end

vim.keymap.set("n", require("jlambeth.system").super_key("j"), next_pane)
