local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

local workspace_table = {}
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
	end

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

function M.bind_wiki()
	local wiki_dir = wezterm.home_dir
	local binding = M.bind_workspace("🧠 wiki", wiki_dir, function(tab, first_pane, window)
		first_pane:split({
			direction = "Left",
			size = 0.35,
			cwd = wiki_dir,
			args = { "nvim", "wiki/index.md" },
		})
	end)

	return binding
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

M.search_workspaces = wezterm.action_callback(function(window, pane)
	window:perform_action(actions.SetPaneZoomState(false), pane)
	wezterm.emit("joewlambeth:pane-change", window, pane)
	local summed_workspaces = {}
	for workspace, _ in pairs(workspace_table) do
		table.insert(summed_workspaces, { id = workspace, label = workspace })
	end

	window:perform_action(
		actions.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
				if not label then
					return
				end
				inner_window:perform_action(actions.SetActiveWorkspace(label), inner_pane)
			end),
			fuzzy = true,
		}),
		pane
	)
end)

return M
