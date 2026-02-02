local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

local workspace_table = {}
local workspace_counter = 0

local function init()
	wezterm.on("switch-workspace", function(window, pane, workspace)
		local tabs = mux.get_tabs(workspace)

		if #tabs > 0 then
			wezterm.log_info("I'm already created")
			return
		end

		local tab, first_pane, window = mux.spawn_window({
			workspace = workspace,
		})
		wezterm.log_info("I made a window")

		local callback = workspace_table[workspace]
		if callback then
			wezterm.log_info("I'm executing some work!")
			callback(tab, first_pane, window)
		end
	end)

	wezterm.on("update-status", function(window, pane)
		local workspace = window:active_workspace()
		wezterm.log_info("i'm updating " .. workspace)
		window:set_right_status(wezterm.format({ Text = " " .. workspace .. " " }))
	end)
end

function M.bind_workspace(name, path, mux_callback)
	if workspace_counter == 0 then
		M.first_workspace = name
		init()
	end

	workspace_counter = workspace_counter + 1
	if mux_callback then
		workspace_table[name] = mux_callback
	end
	wezterm.log_info("I'm binding " .. name .. " to " .. tostring(workspace_counter))
	return {
		key = tostring(workspace_counter),
		mods = "CTRL|SHIFT|ALT",
		action = actions.SwitchToWorkspace({
			name = name,
			spawn = {
				cwd = path,
			},
		}),
	}
end

function M.bind_wiki()
	local wiki_dir = wezterm.home_dir .. "/wiki"
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

return M
