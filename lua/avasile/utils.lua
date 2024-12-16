local M = {}

M.conf = {
	fugitive = {
		width = 80
	}
}

local function nmap(keys, func, opts)
	local o = { desc = 'DEFAULT: No Command Desc' }
	vim.keymap.set("n", keys, func, vim.tbl_deep_extend('force', o, opts or {}))
end
M.nmap = nmap

-- -- WARN: TESTING
-- local bufnr = vim.api.nvim_get_current_buf()
-- local buf_clients = vim.lsp.get_clients({bufnr = bufnr})
-- if buf_clients then
-- 	for i=1, #buf_clients do
-- 		print("Index:", i, "Value:", vim.inspect(buf_clients[i].capabilities))
-- 	end
-- end
-- -- WARN: END

-- global config to share
M.open_fugitive = function()
	vim.cmd('vert Git\n')

	local width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, math.min(M.conf.fugitive.width, width))
end

-- Example usage:
-- pretty_print_table({ key1 = "value1", key2 = { nested_key = "nested_value" }, key3 = 42 })
return M
