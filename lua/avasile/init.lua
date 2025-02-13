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
require("avasile.remap")

-- setup plugin
require("avasile.lazy")

-- setup personal LSP prefs
-- require("avasile.config.lsp").mason_setup()

vim.g.avasile = {
	buffer_opts = {}
}
