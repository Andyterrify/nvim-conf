local M = {}

local av = require("avasile.utils")
local nmap = av.nmap

M.telescope = {
	setup = function()
		local builtin = require('telescope.builtin')

		nmap('<leader>pf', require("avasile.config.plugins").search_project_files, { desc = 'Search [P]roject [F]iles' })

		nmap('<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		nmap('<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
		-- -- searches only files tracked by git
		nmap("<C-p>", builtin.git_files, { desc = "Search Git Files" })
		-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
		-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		-- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
		-- -- searches all available commands that can be summoned by `:`
		-- vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [c]ommands" })

		-- -- Slightly advanced example of overriding default behavior and theme
		nmap('<leader>/', function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end,
			{
				desc = '[/] Fuzzily search in current buffer'
			})

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		nmap('<leader>s/', function()
				builtin.live_grep {
					grep_open_files = false,
					prompt_title = 'Live grep in cwd',
				}
			end,
			{
				desc = 'Grep CWD'
			})

		-- -- Shortcut for searching your neovim configuration files
		vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end,
			{
				desc = '[S]earch [N]eovim files'
			})
	end
}

M.lsp = {
	setup = function(event)
		local lsp_clients = vim.lsp.get_clients({ bufnr = event.buf })
		-- grr gra grn gri i_CTRL-S Some keymaps are created unconditionally when Nvim starts:
		-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
		-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
		-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
		-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
		-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
		-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()

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
		av.client_nmap({
			keybind     = "K",
			buf_clients = lsp_clients,
			feat        = "textDocument/hover",
			fn          = vim.lsp.buf.hover,
			opts        = event,
			desc        = 'Hover'
		})
		-- <leader>f	Format
		av.client_nmap({
			keybind     = "<leader>f",
			buf_clients = lsp_clients,
			feat        = "textDocument/formatting",
			fn          = vim.lsp.buf.format,
			opts        = event,
			desc        = '[F]ormat buffer'
		})
		-- <leader>rn	Rename the variable under your cursor
		av.client_nmap({
			keybind     = '<leader>rn',
			buf_clients = lsp_clients,
			feat        = "textDocument/rename",
			fn          = vim.lsp.buf.rename,
			opts        = event,
			desc        = '[R]e[n]ame'
		})
		-- <leader>ca	Execute a code action
		av.client_nmap({
			keybind     = '<leader>ca',
			buf_clients = lsp_clients,
			feat        = "textDocument/codeAction",
			fn          = vim.lsp.buf.code_action,
			opts        = event,
			desc        = '[C]ode [A]ction'
		})
		-- WARN: This is not Goto Definition, this is Goto Declaration. For example, in C this would take you to the header
		av.client_nmap({
			keybind     = 'gD',
			buf_clients = lsp_clients,
			feat        = "textDocument/declaration",
			fn          = vim.lsp.buf.declaration,
			opts        = event,
			desc        = '[G]oto [D]eclaration'
		})

		if require("avasile.config.plugins").telescope.enabled then
			-- gd	view definitions
			av.client_nmap({
				keybind     = 'gd',
				buf_clients = lsp_clients,
				feat        = "textDocument/definition",
				fn          = require('telescope.builtin').lsp_definitions,
				opts        = event,
				desc        = '[G]oto [D]efinition'
			})
			-- gr	Find references for the word under your cursor.
			av.client_nmap({
				keybind     = 'gr',
				buf_clients = lsp_clients,
				feat        = "textDocument/references",
				fn          = require('telescope.builtin').lsp_references,
				opts        = event,
				desc        = '[G]oto [R]eferences'
			})
			-- gI	Jump to the implementation of the word under your cursor.
			av.client_nmap({
				keybind     = 'gI',
				buf_clients = lsp_clients,
				feat        = "textDocument/implementation",
				fn          = require('telescope.builtin').lsp_implementations,
				opts        = event,
				desc        = '[G]oto [I]mplementation'
			})
			-- <leader>D	Jump to the type of the word under your cursor.
			av.client_nmap({
				keybind     = '<leader>D',
				buf_clients = lsp_clients,
				feat        = "textDocument/typeDefinition",
				fn          = require('telescope.builtin').lsp_type_definitions,
				opts        = event,
				desc        = 'Type [D]efinition'
			})
			-- <leader>ds	Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
			av.client_nmap({
				keybind     = '<leader>ds',
				buf_clients = lsp_clients,
				feat        = "textDocument/documentSymbol",
				fn          = require('telescope.builtin').lsp_document_symbols,
				opts        = event,
				desc        = '[D]ocument [S]ymbols'
			})

			-- INFO: workspace
			-- Fuzzy find all the symbols in your current workspace
			--  Similar to document symbols, except searches over your whole project.
			av.client_nmap({
				keybind     = '<leader>ws',
				buf_clients = lsp_clients,
				feat        = "workspace.symbol",
				fn          = require('telescope.builtin').lsp_dynamic_workspace_symbols,
				opts        = event,
				desc        = '[W]orkspace [S]ymbols'
			})
		else
			av.lsp_nmap('gd', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
			av.lsp_nmap('gr', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
			av.lsp_nmap('gI', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
			av.lsp_nmap('<leader>D', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
			av.lsp_nmap('<leader>ds', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
			av.lsp_nmap('<leader>ws', function() print("Telescope not Enabled") end, event, "Telescope Disabled")
		end


		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared
	end
}

M.fugitive = {
	setup = function()
		nmap("<leader>go", function() av.open_fugitive() end, { desc = "[O]pen fugitive" })
	end
}

return M
