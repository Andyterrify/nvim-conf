return {
	-- File explorer with buffer-like editing
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
				"permissions",
				"mtime",
			},
			delete_to_trash = true,
			watch_for_changes = true,
		},
	},

	-- Visualize undo tree
	{
		"mbbill/undotree",
	},

	-- Keymap hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
			{
				"<leader>s_",
				group = "[S]earch",
			},
		},
	},

	-- Hide secrets in .env files
	{
		"laytan/cloak.nvim",
		opts = {
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			cloak_length = nil,
			try_all_patterns = true,
			patterns = {
				{
					file_pattern = { ".env*", ".*secret*" },
					cloak_pattern = "=.+",
					replace = nil,
				},
			},
		},
	},

	-- Distraction-free writing
	{
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
		},
		opts = {
			width = 80,
		},
	},

	-- Snacks explorer and other utilities
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = { enabled = true },
			indent = { enabled = false },
			input = { enabled = false },
			picker = { enabled = false },
			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
		},
		keys = {
			{ "<leader>e", ":lua Snacks.explorer.open({})<CR>", desc = "Snacks Explorer" },
		},
	},

	-- Alternative file tree explorer
	{
		"nvim-tree/nvim-tree.lua",
		opts = {},
	},
}
