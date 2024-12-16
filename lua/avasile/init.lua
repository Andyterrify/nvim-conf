-- makes working with config much easier
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = AvNvimConfig,
	pattern = { "*.lua" },
	desc = "Add eval as Lua keymaps for config work",
	callback = function(ev)
		local search_str = ".config/nvim"
		if string.find(ev.file, search_str) then
			vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
			vim.keymap.set("n", "<space>x", ":.lua <CR>")
			vim.keymap.set("v", "<space>x", ":lua <CR>")
			print("Loaded Lua eval maps")
			return true
		end
		return false
	end
})

-- deleted whitespace at the end of lines and moves cursor back
-- where it was before the search replace
vim.api.nvim_create_autocmd('BufWritePre', {
	group = AvWhitespace,
	desc = "Automatically remove EOL whitespace",
	pattern = "*",
	callback = function(ev)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, { row, col })
	end
})


-- setup neovim opts and keymaps
require("avasile.opts")
require("avasile.remap")

-- setup plugin
require("avasile.lazy")

-- setup personal LSP prefs
require("avasile.config.lsp").setup()
