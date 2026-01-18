local M = {}

M.conf = {
	fugitive = {
		width = 80
	}
}

-- { keys, func, opts }
-- where opts = { desc = "<some default>", ** }
---@param args table
function M.nmap(args)
	-- local o = { desc = 'DEFAULT: No Command Desc' }
	local o = vim.tbl_deep_extend(
		'force',
		{ desc = 'DEFAULT: No Command Desc' },
		args[3] or {}
	)

	vim.keymap.set("n", args[1], args[2], o)
end

-- global config to share
M.open_fugitive = function()
	vim.cmd('vert Git\n')

	local width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, math.min(M.conf.fugitive.width, width))
end

-- function config_root()
-- 	return vim.g.avasile
-- end
--
-- function set_root(tbl)
-- 	vim.g.avasile = tbl
-- end
--
-- function buf_clients(bufnr)
-- 	return vim.lsp.get_clients({ bufnr = bufnr })
-- end

-- function make_default_buffer_opts(bufnr)
-- 	local tmp = config_root()
-- 	local key = "" .. bufnr .. ""
--
-- 	vim.notify("No buffer " .. bufnr .. " found, creating")
-- 	tmp.buffer_opts[key] = {
-- 		-- INFO: quickly get names of attached LSP clients
-- 		clients_quick = function()
-- 			local names = vim.tbl_keys(buf_clients(bufnr))
-- 			return names
-- 		end,
--
-- 		-- INFO: get all attached lsp servers capabilities easily
-- 		lsp_feats = function()
-- 			local feats = {}
--
-- 			for _, client in pairs(buf_clients(bufnr)) do
-- 				for k, v in pairs(client.capabilities) do
-- 					for i, _ in pairs(v) do
-- 						-- nicely format lsp cap to work with down the line
-- 						local lsp_key = k .. "/" .. i
--
-- 						-- if it doesn't already exist create it
-- 						local x = vim.tbl_get(feats, key)
-- 						if x == nil then
-- 							feats[lsp_key] = {}
-- 						end
--
-- 						-- add this LSP client as a mapping to this feature
-- 						table.insert(feats[lsp_key], client.name)
-- 					end
-- 				end
-- 			end
-- 			return feats
-- 		end,
--
-- 		-- INFO: key:value of all buffer specific keybinds
-- 		-- Might be redundant if we keep track of all feats we setup with lsp
-- 		-- might be worth keeping a track of "active" feats enabled so we can
-- 		-- filter "active" and "current servers" features and delete the missing?
-- 		keybinds = {},
-- 	}
--
-- 	set_root(tmp)
-- end
--
-- M.get_buffer_opts = function(bufnr)
-- 	print("Buffer Opts for " .. bufnr)
-- 	if type(bufnr) ~= "number" then
-- 		print("Val " .. bufnr .. " is not numeric")
-- 		return nil
-- 	end
--
-- 	local key = "" .. bufnr .. ""
-- 	if vim.g.avasile.buffer_opts[bufnr] == nil then
-- 		vim.notify("buf " .. bufnr .. " doesn't have opts, creating")
-- 		make_default_buffer_opts(bufnr)
-- 	else
-- 		vim.notify("buf " .. bufnr .. " existed already")
-- 	end
-- 	return vim.g.avasile.buffer_opts[key]
-- end
--
-- M.delete_buffer_opts = function(bufnr)
-- 	print("Deleting Buffer Opts for " .. bufnr)
-- 	if type(bufnr) ~= "number" then
-- 		print("Val " .. bufnr .. " is not numeric")
-- 		return nil
-- 	end
--
-- 	local key = "" .. bufnr .. ""
-- 	local tmp = config_root()
-- 	tmp.buffer_opts[key] = nil
-- 	set_root(tmp)
-- end

return M
