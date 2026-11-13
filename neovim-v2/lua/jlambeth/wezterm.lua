local function wezterm_call(input)
	local cmd = { "wezterm", "cli" }
	for i = 1, #input do
		cmd[2 + i] = input[i]
	end
	vim.fn.system(cmd)
end

local function lazy_wincmd()
	vim.schedule(function()
		vim.cmd("wincmd =")
	end)
end

local zoom_state = 0

local function unzoom()
	zoom_state = 0
	vim.o.winminheight, vim.o.winminwidth = 1, 1
	wezterm_call({ "zoom-pane", "--unzoom" })
	lazy_wincmd()
end

local function toggle_zoom()
	if zoom_state == 0 then
		-- stage 1: zoom wezterm first
		wezterm_call({ "zoom-pane", "--zoom" })

		if vim.fn.winnr("$") == 1 then
			zoom_state = 2
		else
			zoom_state = 1
			lazy_wincmd()
		end
	elseif zoom_state == 1 then
		-- stage 2: maximize the current window within the pane
		vim.o.winminheight, vim.o.winminwidth = 0, 0
		vim.cmd("wincmd _")
		vim.cmd("wincmd |")
		zoom_state = 2
	else
		unzoom()
	end
	vim.notify(tostring(zoom_state))
end

local function next_pane()
	if vim.fn.winnr() == vim.fn.winnr("$") then
		wezterm_call({ "activate-pane-direction", "Next" })
	elseif zoom_state == 2 and vim.fn.winnr("$") ~= 1 then
		zoom_state = 1
	end
	vim.cmd("wincmd w")
	lazy_wincmd()
end

vim.api.nvim_create_autocmd("FocusLost", {
	callback = function()
		unzoom()
	end,
})

vim.keymap.set("n", require("jlambeth.system").super_key("j"), next_pane)
vim.keymap.set("n", require("jlambeth.system").super_key("k"), toggle_zoom)
