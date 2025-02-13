local M = {}

local av = require("avasile.utils")

M.telescope = {
	setup = function()
		local builtin = require('telescope.builtin')

		av.nmap({
			keys = '<leader>pf',
			func = require("avasile.config.plugins").search_project_files,
			opts = { desc = 'Search [P]roject [F]iles' }
		})

		av.nmap({
			keys = '<leader>sh',
			func = builtin.help_tags,
			opts = { desc = '[S]earch [H]elp' }
		})
		av.nmap({
			keys = '<leader>sk',
			func = builtin.keymaps,
			opts = { desc = '[S]earch [K]eymaps' }
		})
		-- -- searches only files tracked by git
		av.nmap({
			keys = "<C-p>",
			func = builtin.git_files,
			opts = { desc = "Search Git Files" }
		})

		av.nmap({
			keys = '<leader><leader>',
			func = builtin.buffers,
			opts = { desc = '[ ][ ] search open buffers' }
		})

		av.nmap({
			keys = '<leader>sb',
			func = builtin.builtin,
			opts = { desc = '[S]earch [B]uiltin Telescope' }
		})

		av.nmap({
			keys = '<leader>sw',
			func = builtin.grep_string,
			opts = { desc = '[S]earch current [W]ord' }
		})

		-- INFO: Maybe replace with Trouble?
		-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

		av.nmap({
			keys = '<leader>sr',
			func = builtin.resume,
			opts = { desc = '[S]earch [R]esume' }
		})

		-- NOTE: Don't think I've ever used this one
		-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

		-- searches all available commands that can be summoned by `:`
		av.nmap({
			keys = "<leader>sc",
			func = builtin.commands,
			opts = { desc = "[S]earch [C]ommands" }
		})

		-- -- Slightly advanced example of overriding default behavior and theme
		av.nmap({
			keys = '<leader>/',
			func = function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end,
			opts = { desc = '[/] Fuzzily search in current buffer' }
		})

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		av.nmap({
			keys = '<leader>s/',
			func = function()
				builtin.live_grep {
					grep_open_files = false,
					prompt_title = 'Live grep in cwd',
				}
			end,
			opts = { desc = 'Grep CWD' }
		})

		-- -- Shortcut for searching your neovim configuration files
		av.nmap({
			keys = '<leader>sn',
			func = function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end,
			opts = { desc = '[S]earch [N]eovim files' }
		})
	end
}

M.lsp = {
	setup = function(event)
		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared
		require "avasile.config.lsp".autocmd_keymap_config(event)
	end
}

M.fugitive = {
	setup = function()
		av.nmap({
			keys = "<leader>go",
			func = function() av.open_fugitive() end,
			opts = { desc = "[O]pen fugitive" }
		})
	end
}

M.diagnostics = {
	setup = function()
		av.nmap({
			keys = "<leader>cd",
			func = vim.diagnostic.open_float,
			opts = { desc = "[C]ode [D]iagnostics" }
		})
	end
}

-- List of keybinds that apply specifically to buffers
M.lsp_buffer_keybinds = function()
	return {
		-- grr gra grn gri i_CTRL-S Some keymaps are created unconditionally when Nvim starts:
		-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
		-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
		--
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

		-- LSP only keybinds. Server('s) must support the features [key] to enable the keybind [value]
		["textDocument/hover"] = {
			keybind = "K",
			fn      = vim.lsp.buf.hover,
			desc    = 'Hover',
			on      = "lsp"
		},
		["textDocument/formatting"] = {
			-- <leader>f	Format
			keybind = "<leader>f",
			fn      = vim.lsp.buf.format,
			desc    = '[F]ormat buffer',
			on      = "lsp"
		},
		["textDocument/rename"] = {
			-- <leader>rn	Rename the variable under your cursor
			keybind = '<leader>rn',
			fn      = vim.lsp.buf.rename,
			desc    = '[R]e[n]ame',
			on      = "lsp"
		},
		["textDocument/codeAction"] = {
			-- <leader>ca	Execute a code action
			keybind = '<leader>ca',
			fn      = vim.lsp.buf.code_action,
			desc    = '[C]ode [A]ction',
			on      = "lsp"
		},
		["textDocument/declaration"] = {
			-- WARN: This is not Goto Definition, this is Goto Declaration. For example, in C this would take you to the header
			keybind = 'gD',
			fn      = vim.lsp.buf.declaration,
			desc    = '[G]oto [D]eclaration',
			on      = "lsp"
		},
		-- WARN: the following use telescope
		["textDocument/definition"] = {
			keybind = 'gd',
			fn      = require('telescope.builtin').lsp_definitions,
			desc    = '[G]oto [D]efinition',
			on      = "telescope"
		},
		["textDocument/references"] = {
			keybind = 'gr',
			fn      = require('telescope.builtin').lsp_references,
			desc    = '[G]oto [R]eferences',
			on      = "telescope",
		},
		-- gI	Jump to the implementation of the word under your cursor.
		["textDocument/implementation"] = {
			keybind = 'gI',
			fn      = require('telescope.builtin').lsp_implementations,
			desc    = '[G]oto [I]mplementation',
			on      = "telescope",
		},
		-- <leader>D	Jump to the type of the word under your cursor.
		["textDocument/typeDefinition"] = {
			keybind = '<leader>D',
			fn      = require('telescope.builtin').lsp_type_definitions,
			desc    = 'Type [D]efinition',
			on      = "telescope",
		},
		-- <leader>ds	Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
		["textDocument/documentSymbol"] = {
			keybind = '<leader>ds',
			fn      = require('telescope.builtin').lsp_document_symbols,
			desc    = '[D]ocument [S]ymbols',
			on      = "telescope",
		},

		-- INFO: workspace
		-- Fuzzy find all the symbols in your current workspace
		--  Similar to document symbols, except searches over your whole project.
		["workspace/symbol"] = {
			keybind = '<leader>ws',
			fn      = require('telescope.builtin').lsp_dynamic_workspace_symbols,
			desc    = '[W]orkspace [S]ymbols',
			on      = "telescope",
		},
	}
end




return M
