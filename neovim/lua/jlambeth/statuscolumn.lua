-- https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/

_G.MY_STATUS = function()
	-- TODO: hide RNU's for inactive buffers
	local screen_height = math.max(2, #tostring(vim.api.nvim_win_get_height(0)))
	local buffer_height = math.max(3, #tostring(vim.api.nvim_buf_line_count(0)))
	local current_win_bufnr = vim.api.nvim_get_current_buf()
	local active_bufnr = vim.fn.bufnr(0)

	local border = function()
		return "│"
	end

	local show_wrap = function(var, repl)
		if vim.v.virtnum >= 1 then
			return repl
		else
			return tostring(var)
		end
	end

	local rnu = function()
		-- if current_win_bufnr ~= active_bufnr then
		-- 	return ""
		-- end
		if not vim.api.nvim_get_option_value(0, "winactive") then
			return ""
		end

		if vim.v.relnum == 0 then
			return string.rep("-", screen_height)
		end

		return string.format("%" .. screen_height .. "s", show_wrap(vim.v.relnum, " "))
	end

	local lnum = function()
		return string.format("%" .. buffer_height .. "s", show_wrap(vim.v.lnum, ".."))
	end

	local text = table.concat({
		"",
		rnu(),
		lnum(),
		border(),
	}, " ")
	return text
end

vim.o.statuscolumn = "%!v:lua.MY_STATUS()"
