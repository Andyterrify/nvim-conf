local M = {}

M.setup = function()
	-- LspAttach autocmd for setting up LSP keymaps and features
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local clients = vim.lsp.get_clients({ id = event.data.client_id })
			local client = clients[1]
			if not client then
				return
			end

			vim.notify("LspAttach AutoCmd by (" .. client.name .. ")")

			-- Setup keybinds for LSP
			require("avasile.plugins.lsp.keymaps").setup(client, event.buf)

			-- Document highlight on cursor hold
			if client and client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})

	-- Remove trailing whitespace on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		desc = "Automatically remove EOL whitespace",
		pattern = "*",
		callback = function()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			vim.cmd([[%s/\s\+$//e]])
			vim.api.nvim_win_set_cursor(0, { row, col })
		end,
	})

	-- Highlight on yank
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank()
		end,
	})

	-- Treesitter highlighting
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'rust', 'go', 'javascript' },
		callback = function()
			-- syntax highlighting, provided by Neovim
			vim.treesitter.start()
			-- folds, provided by Neovim
			vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.wo.foldmethod = 'expr'
			-- indentation, provided by nvim-treesitter
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

return M
