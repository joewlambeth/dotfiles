local wezterm = require("wezterm")
local action = wezterm.action

local M = {}

M.clear_scrollback = wezterm.action_callback(function(window, pane)
	if pane:is_alt_screen_active() then
		return
	end

	window:perform_action(action.ClearScrollback("ScrollbackAndViewport"), pane)
end)

return M
