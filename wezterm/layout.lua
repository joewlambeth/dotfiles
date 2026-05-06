local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux
local os = require("os")

local shell = os.getenv("SHELL") or "/bin/bash"

local M = {}

local workspace_table = {}
local current_workspace = nil
local available_workspace_choices = {}
local available_workspaces = {}
local workspace_counter = 0

wezterm.on("update-status", function(window, pane)
	local workspace = window:active_workspace()
	window:set_left_status(wezterm.format({ { Text = " " .. workspace .. " " } }))
end)

wezterm.on("joewlambeth:pane-change", function(window, pane)
	local is_zoomed = false
	for _, item in ipairs(window:active_tab():panes_with_info()) do
		if item.is_zoomed then
			is_zoomed = true
		end
	end

	if is_zoomed then
		window:set_config_overrides({
			enable_tab_bar = false,
		})
	else
		window:set_config_overrides({
			enable_tab_bar = true,
		})
	end
end)

function M.bind_workspace(name, path, mux_callback)
	if workspace_counter == 0 then
		M.first_workspace = name
		wezterm.on("gui-startup", function(cmd)
			local tab, build_pane, window = mux.spawn_window({
				workspace = name,
				cwd = path,
			})
			window:gui_window():maximize()
			if mux_callback then
				mux_callback(tab, build_pane, window)
			end
			mux.set_active_workspace(name)
		end)
		current_workspace = { label = name }
	else
		table.insert(available_workspace_choices, { label = name })
	end

	available_workspaces[name] = { path = path }

	workspace_counter = workspace_counter + 1
	workspace_table[name] = { callback = mux_callback }
	return {
		key = tostring(workspace_counter),
		mods = "SUPER|SHIFT",
		action = actions.SwitchToWorkspace({
			name = name,
			spawn = {
				cwd = path,
			},
		}),
	}
end

M.navigate_pane = function(dir)
	return wezterm.action_callback(function(window, pane)
		window:perform_action(actions.ActivatePaneDirection(dir), pane)
		wezterm.emit("joewlambeth:pane-change", window, pane)
	end)
end

M.focus_pane = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.TogglePaneZoomState, pane)
	wezterm.emit("joewlambeth:pane-change", window, pane)
end)

local function switch_workspace(name, window, pane)
	table.insert(available_workspace_choices, 1, current_workspace)
	for i = 1, #available_workspace_choices do
		local ws = available_workspace_choices[i]
		if ws.label == name then
			current_workspace = table.remove(available_workspace_choices, i)
			break
		end
	end
	local entry = available_workspaces[name]
	window:perform_action(
		actions.SwitchToWorkspace({
			name = name,
			spawn = {
				cwd = entry.path,
			},
		}),
		pane
	)
end

M.search_workspaces = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.SetPaneZoomState(false), pane)
	wezterm.emit("joewlambeth:pane-change", window, pane)

	window:perform_action(
		actions.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
				if not label then
					return
				end
				switch_workspace(label, window, pane)
			end),
			choices = available_workspace_choices,
			fuzzy = true,
		}),
		pane
	)
end)

M.split_pane = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.SetPaneZoomState(false), pane)
	wezterm.emit("joewlambeth:pane-change", window, pane)
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
			-- pass the keys through to vim/nvim
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
