local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

-- https://www.nerdfonts.com/cheat-sheet
local glyph_choices = {
	{ id = "none", label = "(none)" },
	{ id = "󰋜 ", label = "󰋜 home" },
	{ id = "󰏫 ", label = "󰏫 edit" },
	{ id = "󰣪 ", label = "󰣪 dotfiles" },
	{ id = " ", label = " python" },
	{ id = " ", label = " node" },
}

local ZOOM_PREFIX = ""

wezterm.on("format-tab-title", function(tab, _, panes, _, _, _)
	local title = (tab.tab_title or ""):gsub("^" .. ZOOM_PREFIX, "")
	if title == "" then
		title = tab.active_pane.title
	end

	local zoomed = false
	for _, p in ipairs(panes) do
		if p.is_zoomed then
			zoomed = true
			break
		end
	end

	local bg = tab.is_active and "#2b2042" or "#1b1032"
	local fg = tab.is_active and "#c0c0c0" or "#808080"
	local text
	if not zoomed then
		text = (tab.tab_index + 1) .. ": " .. title
	elseif tab.is_active then
		bg, fg = fg, bg
		text = ZOOM_PREFIX .. " " .. title
	else
		text = (tab.tab_index + 1)
	end

	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. text .. " " },
	}
end)

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

M.focus_pane = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.TogglePaneZoomState, pane)
end)

M.activate_tab = function(index)
	return wezterm.action_callback(function(window, pane)
		window:perform_action(actions.SetPaneZoomState(false), pane)
		window:perform_action(actions.ActivateTab(index), pane)
	end)
end

M.rename_tab = wezterm.action_callback(function(window, pane)
	local current_title = window:active_tab():get_title()
	local current_name = current_title
	for _, choice in ipairs(glyph_choices) do
		if choice.id ~= "none" and current_title:sub(1, #choice.id) == choice.id then
			current_name = current_title:sub(#choice.id + 1)
			break
		end
	end

	window:perform_action(
		actions.PromptInputLine({
			description = "Tab name:",
			-- TODO: this will be good later
			-- initial_value = current_name,
			action = wezterm.action_callback(function(inner_window, inner_pane, line)
				if not line or line == "" then
					return
				end
				inner_window:perform_action(
					actions.InputSelector({
						title = "Tab Icon",
						choices = glyph_choices,
						fuzzy = true,
						action = wezterm.action_callback(function(prompt_window, _, id, _)
							if not id then
								return
							end
							local glyph = id ~= "none" and id or nil
							local title = glyph and (glyph .. line) or line
							prompt_window:active_tab():set_title(title)
						end),
					}),
					inner_pane
				)
			end),
		}),
		pane
	)
end)

M.split_pane = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.SetPaneZoomState(false), pane)
	window:perform_action(
		actions.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
				local action
				if id == "vertical" then
					action = actions.SplitHorizontal({ domain = "CurrentPaneDomain" })
				elseif id == "horizontal" then
					action = actions.SplitVertical({ domain = "CurrentPaneDomain" })
				end
				inner_window:perform_action(action, inner_pane)
			end),
			choices = {
				{ id = "vertical", label = "│  vertical" },
				{ id = "horizontal", label = "─  horizontal" },
			},
		}),
		pane
	)
end)

local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name
	return process_name == "nvim" or process_name == "vim"
end

function M.bind_next_pane(mod, key)
	local callback = wezterm.action_callback(function(window, pane)
		if is_vim(pane) then
			window:perform_action({
				SendKey = { key = key, mods = "CTRL|SHIFT" },
			}, pane)
		else
			window:perform_action({ ActivatePaneDirection = "Next" }, pane)
		end
	end)

	return { key = key, mods = mod, action = callback }
end

return M
