local M = {}

local av = require("avasile.utils")

M.telescope = {
	setup = function()
		local builtin = require('telescope.builtin')

		av.nmap({
			'<leader>pf',
			require("avasile.config.plugins").search_project_files,
			{ desc = 'Search [P]roject [F]iles' }
		})

		av.nmap({
			'<leader>sh',
			builtin.help_tags,
			{ desc = '[S]earch [H]elp' }
		})
		av.nmap({
			'<leader>sk',
			builtin.keymaps,
			{ desc = '[S]earch [K]eymaps' }
		})
		-- -- searches only files tracked by git
		av.nmap({
			"<C-p>",
			builtin.git_files,
			{ desc = "Search Git Files" }
		})

		av.nmap({
			'<leader><leader>',
			builtin.buffers,
			{ desc = '[ ][ ] search open buffers' }
		})

		av.nmap({
			'<leader>sb',
			builtin.builtin,
			{ desc = '[S]earch [B]uiltin Telescope' }
		})

		av.nmap({
			'<leader>sw',
			builtin.grep_string,
			{ desc = '[S]earch current [W]ord' }
		})

		-- INFO: Maybe replace with Trouble?
		-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

		av.nmap({
			'<leader>sr',
			builtin.resume,
			{ desc = '[S]earch [R]esume' }
		})

		-- NOTE: Don't think I've ever used this one
		-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

		-- searches all available commands that can be summoned by `:`
		av.nmap({
			"<leader>sc",
			builtin.commands,
			{ desc = "[S]earch [C]ommands" }
		})

		-- -- Slightly advanced example of overriding default behavior and theme
		av.nmap({
			'<leader>/',
			function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end,
			{ desc = '[/] Fuzzily search in current buffer' }
		})

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		av.nmap({
			'<leader>s/',
			function()
				builtin.live_grep {
					grep_open_files = false,
					prompt_title = 'Live grep in cwd',
				}
			end,
			{ desc = 'Grep CWD' }
		})

		-- -- Shortcut for searching your neovim configuration files
		av.nmap({
			'<leader>sn',
			function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end,
			{ desc = '[S]earch [N]eovim files' }
		})
	end
}

M.fugitive = {
	setup = function()
		av.nmap({
			"<leader>go",
			function() av.open_fugitive() end,
			{ desc = "[O]pen fugitive" }
		})
	end
}

M.conform = {
	setup = function()
		av.nmap({
			"<leader>f",
			function() require("conform").format() end,
			{ desc = "Format Conform" }
		})
	end
}

-- List of keybinds that apply specifically to buffers
M.lsp = function(client)
	local vlb = vim.lsp.buf
	local keybinds = {
		["hoverProvider"] = { "K", vlb.hover, { desc = "Hover" } },
		-- ["documentFormattingProvider"] = { "<leader>f", vlb.format, { desc = "[F]ormat buffer" } },
		["renameProvider"] = { "<leader>rn", vlb.rename, { desc = "[R]e[n]ame" } },
		["codeActionProvider"] = { "<leader>ca", vlb.code_action, { desc = "[C]ode [A]ction" } },
		-- ["declarationProvider"] = { "gD", vlb.declaration, { desc = "[G]oto [D]eclaration" } },

		-- WARN: the following SHOULD use telescope
		["definitionProvider"] = { "gd", function() require("telescope.builtin").lsp_definitions() end, { desc = "[G]oto Definition" } },
		["referencesProvider"] = { "gr", function() require("telescope.builtin").lsp_references() end, { desc = "[G]oto References" } },
		["implementationProvider"] = { "gr", function() require("telescope.builtin").lsp_implementations() end, { desc = "[G]oto Implementation" } },
		["typeDefinitionProvider"] = { "gD", function() require("telescope.builtin").lsp_type_definitions() end, { desc = "[G]oto Type Definition" } },
		["documentSymbolProvider"] = { "<leader>lw", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document Symbols" } },
		["workspaceSymbolProvider"] = { "<leader>ws", function()
			require("telescope.builtin")
				.lsp_dynamic_workspace_symbols()
		end, { desc = "Workspace Symbols" } },
	}

	for key, v in pairs(keybinds) do
		if client.server_capabilities[key] then
			av.nmap({ v[1], v[2], v[3] })
		else
			av.nmap({ v[1], function() vim.notify("" .. key .. " not Supported by " .. client.name) end, v[3] })
		end
	end

	av.nmap({ "<leader>th", function()
		local new_state = not vim.lsp.inlay_hint.is_enabled()
		require("fidget").notify(string.format("Toggle Inlay Hints (%s)", tostring(new_state)))
		vim.lsp.inlay_hint.enable(new_state)
	end
	, { desc = "Toggle Inlay Hints" } })
	av.nmap({
		"<leader>cd",
		vim.diagnostic.open_float,
		{ desc = "[C]ode [D]iagnostics" }
	})

	-- range formatting
	vim.keymap.set("v", "<leader>f",
		function()
			local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
			local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
			vim.lsp.buf.format({
				range = {
					["start"] = { start_row, 0 },
					["end"] = { end_row, 0 },
				},
				async = true,
			})
		end)
end
return M
