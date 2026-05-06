local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

-- https://www.nerdfonts.com/cheat-sheet
local icon_choices = {
	{ id = "󰋜 home", label = "󰋜  home" },
	{ id = " dotfiles", label = "  dotfiles" },
	{ id = "󰣪 skill-tools", label = "󰣪  skill-tools" },
	{ id = "󰏫 scratch", label = "󰏫  scratch" },
}

local ZOOM_PREFIX = ""
local is_zoomed = false

local function toggle_zoom(window, pane, state)
	if state == nil then
		is_zoomed = not is_zoomed
	else
		is_zoomed = state
	end
	window:perform_action(actions.SetPaneZoomState(is_zoomed), pane)
end

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
	toggle_zoom(window, pane)
end)

M.activate_tab = function(index)
	return wezterm.action_callback(function(window, pane)
		toggle_zoom(window, pane, false)
		window:perform_action(actions.ActivateTab(index), pane)
	end)
end

M.rename_tab = wezterm.action_callback(function(window, pane)
	local choices = { { id = "__custom__", label = "[ Custom name... ]" } }
	for _, choice in ipairs(icon_choices) do
		table.insert(choices, choice)
	end

	window:perform_action(
		actions.InputSelector({
			title = "Rename Tab",
			choices = choices,
			fuzzy = true,
			action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
				if not id then
					return
				end
				if id == "__custom__" then
					inner_window:perform_action(
						actions.PromptInputLine({
							description = "Tab name:",
							action = wezterm.action_callback(function(prompt_window, _, line)
								if line and line ~= "" then
									prompt_window:active_tab():set_title(line)
								end
							end),
						}),
						inner_pane
					)
				else
					inner_window:active_tab():set_title(id)
				end
			end),
		}),
		pane
	)
end)

M.split_pane = wezterm.action_callback(function(window, pane)
	toggle_zoom(window, pane, false)
	window:perform_action(
		actions.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
				local action
				-- i know these are backwards. This is to be consistent with VIM
				if label == "horizontal" then
					action = actions.SplitVertical({ domain = "CurrentPaneDomain" })
				elseif label == "vertical" then
					action = actions.SplitHorizontal({ domain = "CurrentPaneDomain" })
				end
				inner_window:perform_action(action, inner_pane)
			end),
			choices = {
				{ label = "vertical" },
				{ label = "horizontal" },
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
