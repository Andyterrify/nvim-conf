-- makes working with config much easier
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.lua" },
	desc = "Add eval as Lua keymaps for config work",
	callback = function(ev)
		local search_str = ".config/nvim"
		if string.find(ev.file, search_str) then
			vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
			vim.keymap.set("n", "<space>x", ":.lua <CR>")
			vim.keymap.set("v", "<space>x", ":lua <CR>")
			-- print("Loaded Lua eval maps")
			return true
		end
		return false
	end
})



-- setup neovim opts and keymaps
require("avasile.opts")
require("avasile.keymaps")

-- setup plugin manager
require("avasile.lazy")

vim.cmd("colorscheme vague")

-- setup personal LSP prefs
-- require("avasile.config.lsp").mason_setup()



-- Custom command to open man page in a read-only buffer
-- vim.api.nvim_create_user_command('ManPage', function(opts)
-- 	local package = opts.args
-- 	if not package or package == '' then
-- 		vim.notify('Please provide a package name (e.g., :ManPage curl)', vim.log.levels.WARN)
-- 		return
-- 	end
--
-- 	local cmd = 'man ' .. package .. ' | col -b'
--
-- 	local stdout = vim.uv.new_pipe()
-- 	vim.uv.spawn("man curl", {stdio = {stdout, stdout, stdout}})
-- 	print(stdout)
--
-- 	local job = vim.uv.spawn(
-- 		'bash',
-- 		{
-- 			args = { '-c', cmd },
-- 			stdio = { 'pipe', 'pipe', 'pipe' },
-- 		},
-- 		function(err, stdout, stderr)
-- 			if err then
-- 				vim.notify('Error running man: ' .. tostring(err), vim.log.levels.ERROR)
-- 				return
-- 			end
--
-- 			if stderr and #stderr > 0 then
-- 				vim.notify('Stderr from man: ' .. stderr, vim.log.levels.WARN)
-- 			end
--
-- 			if stdout and #stdout > 0 then
-- 				vim.api.nvim_create_buf(false, true, function(err, buf)
-- 					if err then
-- 						vim.notify('Error creating buffer: ' .. tostring(err), vim.log.levels.ERROR)
-- 						return
-- 					end
--
-- 					vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(stdout, '\n'))
-- 					vim.api.nvim_win_set_buf(0, buf)     -- Open in current window
-- 					vim.api.nvim_buf_set_option(buf, 'readonly', true)
-- 					vim.api.nvim_buf_set_option(buf, 'filetype', 'man') -- Optional: Set filetype for syntax highlighting
-- 					vim.api.nvim_buf_set_name(buf, 'man:' .. package) -- Set buffer name
-- 				end)
-- 			else
-- 				vim.notify('No output from man command.', vim.log.levels.WARN)
-- 			end
-- 		end
-- 	)
-- end, {
-- 	desc = 'Open man page in a read-only buffer',
-- 	nargs = 1, -- Expects one argument (the package name)
-- })
