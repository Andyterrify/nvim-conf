return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},
	{
		"j-hui/fidget.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {
		}
	},

	-- if some code requires a module from an unloaded plugin, it will be automatically loaded.
	-- So for api plugins like devicons, we can always set lazy=true
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"mbbill/undotree",
		-- keys = {
		--     { "<leader>tt", ":UndotreeToggle<cr>", desc = "Toggle Undo Tree" }
		-- }
	},
	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				-- theme = 'tokyonight',
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
		},
	},
	{
		"laytan/cloak.nvim",
		opts = {
			enabled = true,
			cloak_character = '*',
			-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
			highlight_group = 'Comment',
			-- Applies the length of the replacement characters for all matched
			-- patterns, defaults to the length of the matched pattern.
			cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
			-- Wether it should try every pattern to find the best fit or stop after the first.
			try_all_patterns = true,
			patterns = {
				{
					-- Match any file starting with '.env'.
					-- This can be a table to match multiple file patterns.
					file_pattern = { '.env*', '.*secret*' },
					-- Match an equals sign and any character after it.
					-- This can also be a table of patterns to cloak,
					-- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
					cloak_pattern = '=.+',
					-- A function, table or string to generate the replacement.
					-- The actual replacement will contain the 'cloak_character'
					-- where it doesn't cover the original text.
					-- If left emtpy the legacy behavior of keeping the first character is retained.
					replace = nil,
				},
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require "ibl.hooks"
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup { scope = { highlight = highlight } }

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
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
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
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
		    { "<leader>e", ":lua Snacks.explorer.open({})<CR>", desc = "Snacks Explorer" }
		}
	},
	{
		"folke/zen-mode.nvim",
		keys = {
			{"<leader>z", "<cmd>ZenMode<CR>"},
		},
		opts = {
			width = 80,
		}
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {}
	},
	{
	  'stevearc/oil.nvim',
	  ---@module 'oil'
	  ---@type oil.SetupOpts
	  opts = {
		  default_file_explorer = true,
		  columns = {
			  "icon", "size", "permissions", "mtime",
		  },
		  delete_to_trash = true,
		  watch_for_changes = true,
	  },
	  -- Optional dependencies
	  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
	  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	  lazy = false,
	},
}
