local vim = vim
local M = {}

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
M.telescope = {
	enabled = false,
	setup = function()
		require("telescope").setup({
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
				fzf = {
					fuzzy = true,    -- false will only do exact matching
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
}

-- [[ CMP ]]
M.cmp = {
	setup = function()
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
}

-- [[ Treesitter ]]
M.treesitter = {
	enabled = false,
	setup = function()
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
}

-- [[ Harpoon ]]
M.harpoon = {
	enabled = false,
	setup = function()
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
}

-- [[ Fugitive ]]
M.fugitive = {
	enabled = false,
	setup = function()
		keymaps.fugitive.setup()
	end
}

-- [[ Fidget ]]
M.fidget = {
	enabled = false,
	setup = function()
		local opts = {
			notification = {
				override_vim_notify = true, -- Automatically override vim.notify() with Fidget
			},
		}
		require "fidget".setup(opts)
	end
}


local function nmap(kb, fn, opts)
	vim.keymap.set('n', kb, fn, opts)
end

local function setup_lsp_keybinds(client)
	local keybinds = {
		["hoverProvider"] = { "K", vim.lsp.buf.hover, { desc = "Hover" } },
		["documentFormattingProvider"] = { "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat buffer" } },
		["renameProvider"] = { "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" } },
		["codeActionProvider"] = { "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" } },
		-- ["declarationProvider"] = { "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" } },

		-- WARN: the following SHOULD use telescope
		["definitionProvider"] = { "gd", vim.lsp.buf.definition, { desc = "[G]oto Definition" } },
		["referencesProvider"] = { "gr", vim.lsp.buf.references, { desc = "[G]oto References" } },
		["implementationProvider"] = { "gr", vim.lsp.buf.implementation, { desc = "[G]oto Implementation" } },
		["typeDefinitionProvider"] = { "gD", vim.lsp.buf.type_definition, { desc = "[G]oto Type Definition" } },
		["documentSymbolProvider"] = { "<leader>lw", vim.lsp.buf.document_symbol, { desc = "Document Symbols" } },
		["workspaceSymbolProvider"] = { "<leader>ws", vim.lsp.buf.workspace_symbol, { desc = "Workspace Symbols" } },
	}

	for key, v in pairs(keybinds) do
		if client.server_capabilities[key] then
			nmap(v[1], v[2], v[3])
		else
			nmap(v[1], function() vim.notify("" .. key .. " not Supported by " .. client.name) end, v[3])
		end
	end

	nmap("<leader>th", function()
		local new_state = not vim.lsp.inlay_hint.is_enabled()
		require("fidget").notify(string.format("Toggle Inlay Hints (%s)", tostring(new_state)))
		vim.lsp.inlay_hint.enable(new_state)
	end
	, { desc = "Toggle Inlay Hints" })
end

-- ####################################
-- Table containing config for language servers
-- If you need more custom tuning refer to
-- https://lsp-zero.netlify.app/docs/guide/integrate-with-mason-nvim.html#configure-a-language-server
-- ####################################
local user_lsp_config = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Specify that you're working with Neovim
					version = 'LuaJIT', -- Neovim uses LuaJIT
					path = vim.split(package.path, ';'),
				},
				diagnostics = {
					-- Make sure to recognize Neovim globals like 'vim'
					globals = { 'vim' },
				},
				workspace = {
					-- Set workspace to recognize Neovim's runtime path
					library = {
						[vim.fn.expand('$VIMRUNTIME/lua')] = true,
						[vim.fn.expand('$VIMRUNTIME/lua/vim')] = true,
					},
				},
				telemetry = {
					enable = false, -- Disable telemetry if you want
				},
			},
		},
	},
	prettierd = {
		-- cmd = { .. },
		-- filetypes = { .. },
		-- capabilities = { .. },
		-- settings = { .. }
	},
	pyright = {},
	ruff_lsp = {},
	rust_analyzer = {},
	taplo = {},
	yamlls = {},
	quick_lint_js = {},
}

-- [[ Lsp ]]
M.lsp = {
	setup = function()
		vim.lsp.inlay_hint.enable() -- new, 0.10

		-- where servers are setup and configured
		local mason_setup = function()
			local lspconfig = require("lspconfig")
			local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
			lsp_capabilities = vim.tbl_deep_extend('force', lsp_capabilities, cmp_capabilities)

			local setup_lsp_server = function(server_name)
				local server_opts = user_lsp_config[server_name] or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for tsserver)

				-- use configured capabilities (if they exist) or create
				server_opts.capabilities = server_opts.capabilities or lsp_capabilities

				lspconfig[server_name].setup(server_opts)
			end

			require('mason').setup()
			require('mason-lspconfig').setup {
				-- LSP servers we 100% want available
				ensure_installed = { 'lua_ls', 'rust_analyzer' },
				-- default fn for servers
				automatic_installation = false,
				handlers = {
					-- could we have another fn to setup keybinds??
					function(server_name)
						setup_lsp_server(server_name)
					end,
				},
			}
			setup_lsp_server("pyright")
		end

		-- where server autoload is setup
		local autocmds = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)
					local c = vim.lsp.get_client_by_id(event.data.client_id)
					if not c then return end

					vim.notify("LspAttach AutoCmd by (" .. c.name .. ")")

					-- not needed anymore
					-- require "avasile.config.lsp".setup(event)

					-- setup keybinds for LSP
					setup_lsp_keybinds(c)

					-- nice hover functionality
					if c and c.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end
			})
		end

		mason_setup()
		autocmds()
	end
}

return M

-- local x = vim.lsp.get_client_by_id(1).server_capabilities
-- for key, value in pairs(x) do
-- 	print(key)
-- end

-- lua_ls
--
-- foldingRangeProvider
-- implementationProvider
-- referencesProvider
-- inlayHintProvider
-- definitionProvider
-- signatureHelpProvider
-- semanticTokensProvider
-- documentHighlightProvider
-- completionProvider
-- documentRangeFormattingProvider
-- executeCommandProvider
-- workspaceSymbolProvider
-- workspace
-- documentFormattingProvider
-- hoverProvider
-- textDocumentSync
-- colorProvider
-- documentOnTypeFormattingProvider
-- renameProvider
-- codeLensProvider
-- documentSymbolProvider
-- offsetEncoding
-- codeActionProvider
-- typeDefinitionProvider
