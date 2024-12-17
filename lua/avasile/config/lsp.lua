local M = {}
-- -- Function to remove all keybindings for the current buffer
-- -- INFO: To be used on LspDetach
-- local function remove_lsp_keybinds(bufnr)
-- 	bufnr = bufnr or 0                                   -- Default to the current buffer
-- 	local keymaps = vim.api.nvim_buf_get_keymap(bufnr, 'n') -- Get normal mode mappings
-- 	for _, keymap in pairs(keymaps) do
-- 		-- Only delete keymaps that have been set by LSP
-- 		if keymap.desc and keymap.desc:match("^LSP") then
-- 			vim.api.nvim_buf_del_keymap(bufnr, 'n', keymap.lhs)
-- 		end
-- 	end
-- end

local server_config = {
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
}

function M.mason_setup()
	local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
	local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
	lsp_capabilities = vim.tbl_deep_extend('force', lsp_capabilities, cmp_capabilities)

	require('mason').setup()
	require('mason-lspconfig').setup {
		handlers = {
			function(server_name)
				local server = server_config[server_name] or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for tsserver)

				-- use configured capabilities (if they exist) or create
				server.capabilities = server.capabilities or lsp_capabilities

				require('lspconfig')[server_name].setup(server)
			end,
		},
	}
end

return M

-- M.setup = function()
-- 	-- vim.diagnostic.config({ virtual_text = true })
-- 	vim.lsp.inlay_hint.enable() -- new, 0.10
--
-- 	-- Enable the following language servers
-- 	--  Add any additional override configuration in the following tables. Available keys are:
-- 	--  - cmd (table): Override the default command used to start the server
-- 	--  - filetypes (table): Override the default list of associated filetypes for the server
-- 	--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
-- 	--  - settings (table): Override the default settings passed when initializing the server.
-- 	--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--
-- 	-- LSP servers and clients are able to communicate to each other what features they support.
-- 	--  By default, Neovim doesn't support everything that is in the LSP Specification.
-- 	--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- 	--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--
-- 	-- local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 	-- local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
-- 	-- lsp_capabilities = vim.tbl_deep_extend('force', lsp_capabilities, cmp_capabilities)
--
-- 	--  You can press `g?` for help in this menu
--
-- 	require 'lspconfig'.lua_ls.setup {
-- 		settings = {
-- 			Lua = {
-- 				runtime = {
-- 					-- Specify that you're working with Neovim
-- 					version = 'LuaJIT', -- Neovim uses LuaJIT
-- 					path = vim.split(package.path, ';'),
-- 				},
-- 				diagnostics = {
-- 					-- Make sure to recognize Neovim globals like 'vim'
-- 					globals = { 'vim' },
-- 				},
-- 				workspace = {
-- 					-- Set workspace to recognize Neovim's runtime path
-- 					library = {
-- 						[vim.fn.expand('$VIMRUNTIME/lua')] = true,
-- 						[vim.fn.expand('$VIMRUNTIME/lua/vim')] = true,
-- 					},
-- 				},
-- 				telemetry = {
-- 					enable = false, -- Disable telemetry if you want
-- 				},
-- 			},
-- 		},
-- 	}
-- end
