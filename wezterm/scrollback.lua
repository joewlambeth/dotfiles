local wezterm = require("wezterm")
local action = wezterm.action

local M = {}

M.clear_scrollback = wezterm.action_callback(function(window, pane)
	if pane:is_alt_screen_active() then
		return
	end

	window:perform_action(action.ClearScrollback("ScrollbackAndViewport"), pane)
end)

M.edit_command = wezterm.action_callback(function(window, pane)
	if pane:is_alt_screen_active() then
		window:perform_action(action.SendKey({ key = "g", mods = "CTRL" }), pane)
	else
		window:perform_action(action.SendString("\x18\x05"), pane)
	end
end)

return M
