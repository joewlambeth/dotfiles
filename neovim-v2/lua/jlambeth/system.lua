local M = {}

M.is_mac = vim.loop.os_uname().sysname == "Darwin"
-- M.super_key = M.is_mac and (function(key)
-- 	return "<D-" .. key .. ">"
-- end) or (function(key)
-- 	return "<C-" .. string.upper(key) .. ">"
-- end)
M.super_key = function(key)
	return "<C-S-" .. string.upper(key) .. ">"
end

return M
