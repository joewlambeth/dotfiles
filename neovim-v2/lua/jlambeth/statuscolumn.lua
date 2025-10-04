-- https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/

_G.MY_STATUS = function()
	-- TODO: hide RNU's for inactive buffers
	local screen_height = math.max(2, #tostring(vim.api.nvim_win_get_height(0)))
	local buffer_height = math.max(3, #tostring(vim.api.nvim_buf_line_count(0)))
	local border = function()
		return "│"
	end

	local rnu = function()
		if vim.v.relnum == 0 then
			return string.rep("-", screen_height)
		end
		return string.format("%" .. screen_height .. "d", vim.v.relnum)
	end

	local text = table.concat({
		"",
		rnu(),
		string.format("%" .. buffer_height .. "d", vim.v.lnum),
		border(),
	}, " ")
	return text
end

vim.o.statuscolumn = "%!v:lua.MY_STATUS()"
