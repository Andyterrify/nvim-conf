-- lazy.nvim plugin entries
return {
	-- nvim-tree (sidebar)
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			hijack_netrw = false, -- don't fight netrw/Oil
			open_on_tab = false,
			update_focused_file = {
				enable = false, -- avoid surprise focus changes
			},
			view = {
				width = 30,
				side = "left",
				preserve_window_proportions = true,
			},
			renderer = {
				icons = { show = { file = true, folder = true, git = true } },
			},
			actions = { open_file = { quit_on_open = false } }, -- keep tree open if desired
		},
		keys = {
			{
				"<leader>T",
				":NvimTreeToggle<CR>",
				noremap = true,
				silent = true,
				desc = "Toggle nvim-tree sidebar",
			},
		},
	},

	-- Oil (directory-as-buffer)
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				columns = { "icon", "size", "mtime", "permissions" },
				delete_to_trash = true,
				watch_for_changes = true,
				use_default_keymaps = true, -- we'll set our own to avoid collisions
				view_options = { show_hidden = true },
			})

			-- dedicated keymap to open Oil (explicit action)
			vim.keymap.set(
				"n",
				"<leader>e",
				"<cmd>Oil<CR>",
				{ noremap = true, silent = true, desc = "Open Oil (dir buffer)" }
			)

			-- Buffer-local mappings for Oil buffers (safer than global maps)
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "oil",
			-- 	callback = function()
			-- 		local opts = { buffer = true, noremap = true, silent = true }
			-- 		local oil = require("oil")
			-- 		-- navigation like a file explorer
			-- 		-- vim.keymap.set("n", "h", oil.open_parent, opts)
			-- 		-- vim.keymap.set("n", "l", oil.open, opts)
			-- 		-- vim.keymap.set("n", "<CR>", oil.open, opts)
			-- 		-- vim.keymap.set("n", "r", oil.refresh, opts)
			-- 		-- vim.keymap.set("n", "d", oil.remove, opts)
			-- 	end,
			-- })
		end,
	},
}
