local wezterm = require("wezterm")
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

local workspace_table = {}
local workspace_counter = 0

wezterm.on("update-status", function(window, pane)
	window:set_right_status(wezterm.format({ Text = " " .. "something " .. " " }))
end)

wezterm.on("switch-workspace", function(window, pane, workspace)
	local tabs = mux.get_tabs(workspace)

	if #tabs > 0 then
		return
	end

	local tab, first_pane, window = mux.spawn_window({
		workspace = workspace,
	})

	local callback = workspace_table[workspace]
	if callback then
		callback(tab, first_pane, window)
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
		end)
	end

	workspace_counter = workspace_counter + 1
	if mux_callback then
		workspace_table[name] = mux_callback
	end
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

return M
