return {
	{ -- nicer status line
		-- +-------------------------------------------------+
		-- | A | B | C                             X | Y | Z |
		-- +-------------------------------------------------+
		-- available components: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components

		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				-- component_separators = '|',
				-- section_separators = '',
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "lsp_status" },
				lualine_z = { "location", "progress" },
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

	{ -- pretty todo
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			sign_priority = 1, -- I find 8 to be too aggresive, it overwrites LSP
		},
		setup = function()
			local nmapd = require("avasile.utils").nmapd

			nmapd("]t", function()
				require("todo-comments").jump_next()
			end, "Jump to next TODO")
			nmapd("[t", function()
				require("todo-comments").jump_prev()
			end, "Jump to previous TODO")
		end,
	},

	{ -- notifications window
		"j-hui/fidget.nvim",
		version = "*",
		opts = {},
	},

	{ -- nicer/easier quickfix lists like thing
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
	{ -- zen
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
		},
		opts = {
			width = 100,
		},
	},
}
