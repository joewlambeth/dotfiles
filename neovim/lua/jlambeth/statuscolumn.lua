-- https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/statuscolumn.lua#L56-L72
--

local left_window = nil

vim.api.nvim_create_autocmd("WinEnter", {
	callback = function(ev)
		vim.schedule(function()
			if left_window and vim.api.nvim_win_is_valid(left_window) then
				vim.api.nvim__redraw({
					win = left_window,
					statuscolumn = true,
				})
			end
		end)
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	callback = function(ev)
		left_window = vim.api.nvim_get_current_win()
	end,
})

_G.MY_STATUS = function()
	local screen_height = math.max(2, #tostring(vim.api.nvim_win_get_height(0)))
	local buffer_height = math.max(3, #tostring(vim.api.nvim_buf_line_count(0)))
	local current_win_bufnr = vim.api.nvim_get_current_buf()

	local signs = vim.api.nvim_buf_get_extmarks(
		current_win_bufnr,
		-1,
		{ vim.v.lnum - 1, 0 },
		{ vim.v.lnum - 1, -1 },
		{ details = true, type = "sign" }
	)

	local git_border = nil
	local winner, priority = nil, 99999
	for _, v in pairs(signs) do
		local item = v[4]

		if item.sign_hl_group:match("^Git") then
			git_border = "%#" .. item.sign_hl_group .. "#" .. item.sign_text, 1, 2
		elseif priority >= item.priority then
			winner = "%#" .. item.sign_hl_group .. "#" .. string.sub(item.sign_text, 1, 1) .. "%#Normal#"
			priority = item.priority
		end
	end

	local drawn_win = vim.api.nvim_get_current_win()
	local focused = tonumber(vim.g.actual_curwin) == tonumber(drawn_win)

	local border = function()
		return git_border or "%#Normal#│"
		-- return "│"
	end

	local show_wrap = function(var, repl)
		if vim.v.virtnum >= 1 then
			return repl
		else
			return tostring(var)
		end
	end

	local rnu = function()
		if vim.v.relnum == 0 then
			return string.rep("-", screen_height)
		end

		return string.format("%" .. screen_height .. "s", show_wrap(vim.v.relnum, " "))
	end

	local lnum = function()
		return string.format("%" .. buffer_height .. "s", show_wrap(vim.v.lnum, ".."))
	end

	local text
	if focused then
		text = string.format("%s %s %s %s", winner or " ", rnu(), lnum(), border())
	else
		text = string.format("%s %s", lnum(), border())
	end
	return text
end

vim.o.statuscolumn = "%{%v:lua.MY_STATUS()%}"
