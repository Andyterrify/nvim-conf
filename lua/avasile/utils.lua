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
		args.opts or {}
	)

	vim.keymap.set("n", args.keys, args.func, o)
end

-- Useful to quickly map an LSP keybind only if the server supports it
-- args: { keybind, buf_clients, feat, fn, buffer, desc }
M.lsp_nmap = function(args)
	local supports = false

	if args.buf_clients then
		for _, server in ipairs(args.buf_clients) do
			if server:supports_method(args.feat) then
				supports = true
				break
			end
		end
	end


	if supports then
		M.nmap({
			keys = args.keybind,
			func = args.fn,
			opts = {
				buffer = args.buffer,
				desc = args.desc
			}
		})
	else
		M.nmap({
			keys = args.keybind,
			func = function() print("Feat '" .. args.feat .. "'Not supported") end,
			opts = {
				buffer = args.buffer,
				desc = "Server Not Implemented"
			}
		})
	end
end

-- global config to share
M.open_fugitive = function()
	vim.cmd('vert Git\n')

	local width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, math.min(M.conf.fugitive.width, width))
end

-- Example usage:
-- pretty_print_table({ key1 = "value1", key2 = { nested_key = "nested_value" }, key3 = 42 })
return M
