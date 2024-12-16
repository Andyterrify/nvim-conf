local M = {}

M.conf = {
	fugitive = {
		width = 80
	}
}

M.nmap = function(keys, func, opts)
	local o = { desc = 'DEFAULT: No Command Desc' }
	vim.keymap.set("n", keys, func, vim.tbl_deep_extend('force', o, opts or {}))
end

M.lsp_nmap = function(keys, func, opts, desc)
	M.nmap(keys, func, { buffer = opts.buf, desc = "LSP: " .. desc })
end

-- Useful to quickly map an LSP keybind only if the server supports it
M.client_nmap = function(args)
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
		M.lsp_nmap(args.keybind, args.fn, args.opts, args.desc)
	else
		M.lsp_nmap(args.keybind,
			function() print("Feat '" .. args.feat .. "'Not supported") end,
			args.opts, "Server Not Implemented"
		)
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
