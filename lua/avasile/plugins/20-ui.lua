return {
	{ -- nicer status line
		-- +-------------------------------------------------+
		-- | A | B | C                             X | Y | Z |
		-- +-------------------------------------------------+
		-- available components: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components

		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				icons_enabled = true,
				theme = 'auto',
				-- component_separators = '|',
				-- section_separators = '',
			},
		  sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch', 'diff', 'diagnostics'},
			lualine_c = {'filename'},
			lualine_x = {'encoding', 'fileformat', 'filetype'},
			lualine_y = {'lsp_status'},
			lualine_z = {'location', 'progress'}
		  },
		},
	},

	{ -- nicer indents
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{ -- keybinds viewer
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			-- ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
			-- ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
			-- ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
			-- ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
			-- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
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
		}
	},

	{ -- pretty todo
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			sign_priority = 1, -- I find 8 to be too aggresive, it overwrites LSP
		},
		setup = function ()
			local nmapd = require("avasile.utils").nmapd

			nmapd("]t", function() require("todo-comments").jump_next() end, "Jump to next TODO")
			nmapd("[t", function() require("todo-comments").jump_prev() end, "Jump to previous TODO")
		end
	},

	{ -- notifications window
		"j-hui/fidget.nvim",
		version = "*",
		opts = {
		},
	},

-- 	{
-- 		"folke/trouble.nvim",
-- 		opts = {}, -- for default options, refer to the configuration section for custom setup.
-- 		cmd = "Trouble",
-- 		keys = {
-- 			{
-- 				"<leader>xx",
-- 				"<cmd>Trouble diagnostics toggle<cr>",
-- 				desc = "Diagnostics (Trouble)",
-- 			},
-- 			{
-- 				"<leader>xX",
-- 				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
-- 				desc = "Buffer Diagnostics (Trouble)",
-- 			},
-- 			{
-- 				"<leader>cs",
-- 				"<cmd>Trouble symbols toggle focus=false<cr>",
-- 				desc = "Symbols (Trouble)",
-- 			},
-- 			{
-- 				"<leader>cl",
-- 				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
-- 				desc = "LSP Definitions / references / ... (Trouble)",
-- 			},
-- 			{
-- 				"<leader>xL",
-- 				"<cmd>Trouble loclist toggle<cr>",
-- 				desc = "Location List (Trouble)",
-- 			},
-- 			{
-- 				"<leader>xQ",
-- 				"<cmd>Trouble qflist toggle<cr>",
-- 				desc = "Quickfix List (Trouble)",
-- 			},
-- 		},
-- 	},
-- 	{
-- 		"folke/snacks.nvim",
-- 		priority = 1000,
-- 		lazy = false,
-- 		---@type snacks.Config
-- 		opts = {
-- 			-- your configuration comes here
-- 			-- or leave it empty to use the default settings
-- 			-- refer to the configuration section below
-- 			bigfile = { enabled = true },
-- 			dashboard = { enabled = false },
-- 			explorer = { enabled = true },
-- 			indent = { enabled = false },
-- 			input = { enabled = false },
-- 			picker = { enabled = false },
-- 			notifier = { enabled = false },
-- 			quickfile = { enabled = false },
-- 			scope = { enabled = false },
-- 			scroll = { enabled = false },
-- 			statuscolumn = { enabled = false },
-- 			words = { enabled = false },
-- 		},
-- 		keys = {
-- 		    { "<leader>e", ":lua Snacks.explorer.open({})<CR>", desc = "Snacks Explorer" }
-- 		}
-- 	},
-- 	{
-- 		"folke/zen-mode.nvim",
-- 		keys = {
-- 			{"<leader>z", "<cmd>ZenMode<CR>"},
-- 		},
-- 		opts = {
-- 			width = 80,
-- 		}
-- 	},
-- 	{
-- 		"nvim-tree/nvim-tree.lua",
-- 		opts = {}
-- 	},
-- 	{
-- 	  'stevearc/oil.nvim',
-- 	  ---@module 'oil'
-- 	  ---@type oil.SetupOpts
-- 	  opts = {
-- 		  default_file_explorer = true,
-- 		  columns = {
-- 			  "icon", "size", "permissions", "mtime",
-- 		  },
-- 		  delete_to_trash = true,
-- 		  watch_for_changes = true,
-- 	  },
-- 	  -- Optional dependencies
-- 	  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
-- 	  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
-- 	  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
-- 	  lazy = false,
-- 	},
}
