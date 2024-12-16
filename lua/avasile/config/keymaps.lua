local M = {}

local av = require("avasile.utils")
local nmap = av.nmap

M.telescope = {
	setup = function()
		local builtin = require('telescope.builtin')

		nmap('<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		nmap('<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
		nmap('<leader>pf', require("avasile.config.plugins").search_project_files, { desc = 'Search [P]roject [F]iles' })
		-- -- searches only files tracked by git
		-- vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
		-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		-- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
		-- -- searches all available commands that can be summoned by `:`
		-- vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [c]ommands" })

		-- -- Slightly advanced example of overriding default behavior and theme
		-- vim.keymap.set('n', '<leader>/', function()
		--   -- You can pass additional configuration to telescope to change theme, layout, etc.
		--   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		--     winblend = 10,
		--     previewer = false,
		--   })
		-- end, { desc = '[/] Fuzzily search in current buffer' })

		-- -- Also possible to pass additional configuration options.
		-- --  See `:help telescope.builtin.live_grep()` for information about particular keys
		-- vim.keymap.set('n', '<leader>s/', function()
		--   builtin.live_grep {
		--     grep_open_files = false,
		--     prompt_title = 'Live Grep in Open Files',
		--   }
		-- end, { desc = '[S]earch [/] in Open Files' })

		-- -- Shortcut for searching your neovim configuration files
		-- vim.keymap.set('n', '<leader>sn', function()
		--   builtin.find_files { cwd = vim.fn.stdpath 'config' }
		-- end, { desc = '[S]earch [N]eovim files' })
	end
}

M.fugitive = {
	setup = function()
		nmap("<leader>G", function() av.open_fugitive() end)
	end
}

return M
