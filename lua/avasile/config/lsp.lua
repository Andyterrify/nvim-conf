local M = {}

local av = require("avasile.utils")
local config_map = require("avasile.config.plugins")

local function lsp_nmap(keys, func, opts, desc)
	av.nmap(keys, func, { buffer = opts.buf, desc = "LSP: " .. desc })
end

-- Useful to quickly map an LSP keybind only if the server supports it
local function client_nmap(keys, server, feat, func, opts, desc)
	local req = ""
	if string.sub(feat, 1, 1) == "-" then
		req = string.sub(feat, 2)
	else
		req = "textDocument/" .. feat
	end

	if server and server:supports_method(req) then
		lsp_nmap(keys, func, opts, desc)
	else
		lsp_nmap(keys, function() print("Feat 'textDocument/" .. feat .. "'Not supported") end, opts,
			"Server Not Implemented")
	end
end

-- gets capabilities of all servers on buffer
local function get_buf_client_capabilities(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local capabilities = {}

	for _, obj in ipairs(clients) do
		table.insert(capabilities, obj.server_capabilities)
	end

	return vim.tbl_deep_extend('force', {}, table.unpack(capabilities))
end

local function clients_have_feat(feat_table, feat)
	vim.tbl_contains(vim.tbl_keys(feat_table.textDocument), feat)
end

-- Function to remove all keybindings for the current buffer
-- INFO: To be used on LspDetach
local function remove_lsp_keybinds(bufnr)
	bufnr = bufnr or 0                                   -- Default to the current buffer
	local keymaps = vim.api.nvim_buf_get_keymap(bufnr, 'n') -- Get normal mode mappings
	for _, keymap in pairs(keymaps) do
		-- Only delete keymaps that have been set by LSP
		if keymap.desc and keymap.desc:match("^LSP") then
			vim.api.nvim_buf_del_keymap(bufnr, 'n', keymap.lhs)
		end
	end
end

M.setup = function()
	vim.api.nvim_create_autocmd('LspAttach', {
		group = AndyterrifyGroup,
		callback = function(ev)
			-- DEFAULTS
			-- grr gra grn gri i_CTRL-S Some keymaps are created unconditionally when Nvim starts:
			-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
			-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
			-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
			-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
			-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
			-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()

			local c = vim.lsp.get_client_by_id(ev.data.client_id)
			local buf_client_cap = get_buf_client_capabilities(ev.buf)
			-- local opts = { buffer = e.buf }
			-- vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
			-- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
			-- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			-- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			-- vim.keymap.set("n", "<leader>vc", function() vim.lsp.buf.code_action() end, opts)
			-- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
			-- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
			-- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)


			-- INFO: textDocument
			-- Opens a popup that displays documentation about the word under your cursor
			--  See `:help K` for why this keymap
			client_nmap("K", c, "hover", vim.lsp.buf.hover, ev, 'Hover')
			-- <leader>f	Format
			client_nmap("<leader>f", c, "formatting", vim.lsp.buf.format, ev, '[F]ormat buffer')
			-- <leader>rn	Rename the variable under your cursor
			client_nmap('<leader>rn', c, "rename", vim.lsp.buf.rename, ev, '[R]e[n]ame')
			-- <leader>ca	Execute a code action
			client_nmap('<leader>ca', c, "codeAction", vim.lsp.buf.code_action, ev, '[C]ode [A]ction')
			-- WARN: This is not Goto Definition, this is Goto Declaration. For example, in C this would take you to the header
			client_nmap('gD', c, "declaration", vim.lsp.buf.declaration, ev, '[G]oto [D]eclaration')

			if config_map.telescope.enabled then
				-- gd	view definitions
				client_nmap('gd', c, "definition", require('telescope.builtin').lsp_definitions, ev,
					'[G]oto [D]efinition')
				-- gr	Find references for the word under your cursor.
				client_nmap('gr', c, "references", require('telescope.builtin').lsp_references, ev,
					'[G]oto [R]eferences')
				-- gI	Jump to the implementation of the word under your cursor.
				client_nmap('gI', c, "implementation", require('telescope.builtin').lsp_implementations, ev,
					'[G]oto [I]mplementation')
				-- <leader>D	Jump to the type of the word under your cursor.
				client_nmap('<leader>D', c, "typeDefinition", require('telescope.builtin').lsp_type_definitions, ev,
					'Type [D]efinition')
				-- <leader>ds	Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
				client_nmap('<leader>ds', c, "documentSymbol", require('telescope.builtin').lsp_document_symbols, ev,
					'[D]ocument [S]ymbols')
				-- INFO: workspace
				-- Fuzzy find all the symbols in your current workspace
				--  Similar to document symbols, except searches over your whole project.
				client_nmap('<leader>ws', c, "-workspace.symbol",
					require('telescope.builtin').lsp_dynamic_workspace_symbols,
					ev,
					'[W]orkspace [S]ymbols')
			else
				lsp_nmap('gd', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
				lsp_nmap('gr', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
				lsp_nmap('gI', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
				lsp_nmap('<leader>D', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
				lsp_nmap('<leader>ds', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
				lsp_nmap('<leader>ws', function() print("Telescope not Enabled") end, ev, "Telescope Disabled")
			end


			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared
			if c and c.server_capabilities.documentHighlightProvider then
				-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				--   buffer = event.buf,
				--   callback = vim.lsp.buf.document_highlight,
				-- })

				vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					buffer = ev.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end
	})
end

return M
