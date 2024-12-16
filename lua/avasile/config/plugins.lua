local M = {}

local av = require("avasile.utils")
local nmap = av.nmap

local keymaps = require("avasile.config.keymaps")

M.search_project_files = function()
	if not M.telescope.enabled then
		print("telescope is not enabled")
		return
	end

	local builtin = require("telescope.builtin")
	builtin.find_files()
end

-- [[ Telescope ]]
local function telescope_setup()
	require("telescope").setup({
		extensions = {
			['ui-select'] = {
				require('telescope.themes').get_dropdown(),
			},
			fzf = {
				fuzzy = true,       -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			}
		},
		pickers = {
			buffers = {
				soft_lastused = true,
				sort_mru = true,
				ignore_current_buffer = true,
			},
			find_files = {
				hidden = false,
			},
		},
		defaults = {
			layout_strategy = "vertical",
			layout_config = {
				vertical = {
					width = 0.8,
					height = 0.98,
					preview_height = 0.45,
					mirror = true
				}
			},
			sorting_strategy = "ascending"
		},
	})
	-- mark telescope as enabled in local conf
	M.telescope.enabled = true

	-- Enable telescope extensions, if they are installed
	pcall(require('telescope').load_extension, 'fzf')
	pcall(require('telescope').load_extension, 'ui-select')

	keymaps.telescope.setup()
end

-- [[ Lsp ]]
local function lsp_setup()
	M.lsp.enabled = true

	require("avasile.config.lsp").setup()
	require("avasile.config.autocmds").lsp.setup()
end

-- [[ CMP ]]
local function cmp_setup()
	-- See `:help cmp`
	local cmp = require("cmp")
	local lspkind = require("lspkind")

	cmp.setup {
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol_text', -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- can also be a function to dynamically calculate max width such as
				-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
				ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				show_labelDetails = true, -- show labelDetails in menu. Disabled by default

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function(entry, vim_item)
					return vim_item
				end
			})
		},
		completion = { completeopt = 'menu,menuone,noinsert' },
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},

		-- For an understanding of why these mappings were
		-- chosen, you will need to read `:help ins-completion`
		-- No, but seriously. Please read `:help ins-completion`, it is really good!
		mapping = cmp.mapping.preset.insert {
			-- Select the [n]ext item
			['<C-n>'] = cmp.mapping.select_next_item(),
			-- Select the [p]revious item
			['<C-p>'] = cmp.mapping.select_prev_item(),
			-- read docs
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			-- read docs
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			-- Accept ([y]es) the completion.
			['<C-y>'] = cmp.mapping.confirm { select = true },
			-- escape
			['<C-e>'] = cmp.mapping.abort(),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			-- { name = 'luasnip' },
			{ name = 'path' },
			{ name = 'buffer' },
		}),
	}

	-- `/` cmdline setup.
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' },
			{
				name = 'cmdline',
				option = {
					ignore_cmds = { 'Man', '!' }
				}
			},
		})
	})
end

-- [[ Treesitter ]]
local function treesitter_setup()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"c",
			"lua",
			"rust",
			"bash",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},

		auto_install = true,

		highlight = {
			enable = true,
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn", -- set to `false` to disable one of the mappings
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	})
end

-- TODO: Moveto
-- [[ Harpoon ]]
local function harpoon_setup()
	local harpoon = require("harpoon")
	harpoon:setup({})
	-- add a file to harpoon
	vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end)
	-- quick list view harpoon
	vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
	vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end

-- [[ Fugitive ]]
local function fugitive_setup()
	keymaps.fugitive.setup()
end

M.telescope = {
	enabled = false,
	setup = telescope_setup
}
M.lsp = {
	enabled = false,
	setup = lsp_setup
}
M.cmp = {
	enabled = false,
	setup = cmp_setup
}
M.treesitter = {
	enabled = false,
	setup = treesitter_setup
}
M.harpoon = {
	enabled = false,
	setup = harpoon_setup
}
M.fugitive = {
	enabled = false,
	setup = fugitive_setup
}

return M
