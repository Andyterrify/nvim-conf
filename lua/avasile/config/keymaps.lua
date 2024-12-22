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
		av.lsp_nmap({
			keybind     = "K",
			buf_clients = lsp_clients,
			feat        = "textDocument/hover",
			fn          = vim.lsp.buf.hover,
			buffer      = event.buf,
			desc        = 'Hover'
		})
		-- <leader>f	Format
		av.lsp_nmap({
			keybind     = "<leader>f",
			buf_clients = lsp_clients,
			feat        = "textDocument/formatting",
			fn          = vim.lsp.buf.format,
			buffer      = event.buf,
			desc        = '[F]ormat buffer'
		})
		-- <leader>rn	Rename the variable under your cursor
		av.lsp_nmap({
			keybind     = '<leader>rn',
			buf_clients = lsp_clients,
			feat        = "textDocument/rename",
			fn          = vim.lsp.buf.rename,
			buffer      = event.buf,
			desc        = '[R]e[n]ame'
		})
		-- <leader>ca	Execute a code action
		av.lsp_nmap({
			keybind     = '<leader>ca',
			buf_clients = lsp_clients,
			feat        = "textDocument/codeAction",
			fn          = vim.lsp.buf.code_action,
			buffer      = event.buf,
			desc        = '[C]ode [A]ction'
		})
		-- WARN: This is not Goto Definition, this is Goto Declaration. For example, in C this would take you to the header
		av.lsp_nmap({
			keybind     = 'gD',
			buf_clients = lsp_clients,
			feat        = "textDocument/declaration",
			fn          = vim.lsp.buf.declaration,
			buffer      = event.buf,
			desc        = '[G]oto [D]eclaration'
		})

		if require("avasile.config.plugins").telescope.enabled then
			-- gd	view definitions
			av.lsp_nmap({
				keybind     = 'gd',
				buf_clients = lsp_clients,
				feat        = "textDocument/definition",
				fn          = require('telescope.builtin').lsp_definitions,
				buffer      = event.buf,
				desc        = '[G]oto [D]efinition'
			})
			-- gr	Find references for the word under your cursor.
			av.lsp_nmap({
				keybind     = 'gr',
				buf_clients = lsp_clients,
				feat        = "textDocument/references",
				fn          = require('telescope.builtin').lsp_references,
				buffer      = event.buf,
				desc        = '[G]oto [R]eferences'
			})
			-- gI	Jump to the implementation of the word under your cursor.
			av.lsp_nmap({
				keybind     = 'gI',
				buf_clients = lsp_clients,
				feat        = "textDocument/implementation",
				fn          = require('telescope.builtin').lsp_implementations,
				buffer      = event.buf,
				desc        = '[G]oto [I]mplementation'
			})
			-- <leader>D	Jump to the type of the word under your cursor.
			av.lsp_nmap({
				keybind     = '<leader>D',
				buf_clients = lsp_clients,
				feat        = "textDocument/typeDefinition",
				fn          = require('telescope.builtin').lsp_type_definitions,
				buffer      = event.buf,
				desc        = 'Type [D]efinition'
			})
			-- <leader>ds	Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
			av.lsp_nmap({
				keybind     = '<leader>ds',
				buf_clients = lsp_clients,
				feat        = "textDocument/documentSymbol",
				fn          = require('telescope.builtin').lsp_document_symbols,
				buffer      = event.buf,
				desc        = '[D]ocument [S]ymbols'
			})

			-- INFO: workspace
			-- Fuzzy find all the symbols in your current workspace
			--  Similar to document symbols, except searches over your whole project.
			av.lsp_nmap({
				keybind     = '<leader>ws',
				buf_clients = lsp_clients,
				feat        = "workspace.symbol",
				fn          = require('telescope.builtin').lsp_dynamic_workspace_symbols,
				buffer      = event.buf,
				desc        = '[W]orkspace [S]ymbols'
			})
		else
			av.nmap({
				keys = 'gd',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
			av.nmap({
				keys = 'gr',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
			av.nmap({
				keys = 'gI',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
			av.nmap({
				keys = '<leader>D',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
			av.nmap({
				keys = '<leader>ds',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
			av.nmap({
				keys = '<leader>ws',
				func = function() print("Telescope not Enabled") end,
				opts = {
					buffer = event.buf,
					desc = "Telescope Disabled"
				}
			})
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

return M
