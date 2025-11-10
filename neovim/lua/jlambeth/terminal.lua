local M = {}
-- Function to toggle a floating terminal
local float_term = {
	buffer = nil,
	window = nil,
}

M.close_term = function()
	local is_open = float_term.window and vim.api.nvim_win_is_valid(float_term.window)
	if is_open then
		pcall(vim.api.nvim_win_close, float_term.window, true)
		float_term.window = nil
	end
	return is_open
end

local get_terminal_buffer = function()
	if float_term.buffer and vim.api.nvim_buf_is_valid(float_term.buffer) then
		return float_term.buffer
	elseif float_term.buffer then
		-- deallocate the current buffer, terminal was closed
		float_term.buffer = nil
	end

	local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
	-- Important: keep the buffer hidden instead of unloading when the window is closed

	vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
	-- Optional: make buffer listed so you can see it in :ls if you want
	return buf
end

M.toggle_term = function()
	if M.close_term() then
		return
	end
	local buf = get_terminal_buffer()
	-- Create a new floating terminal
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- Start terminal
	vim.cmd("startinsert")

	if not float_term.buffer then
		vim.api.nvim_set_current_buf(buf)
		vim.fn.jobstart(vim.o.shell, { term = true })
	end

	float_term = { buffer = buf, window = win }
end

return M
