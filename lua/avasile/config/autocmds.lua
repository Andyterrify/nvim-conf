local M = {}

M.lsp = {
	setup = function()
		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(event)
				local c = vim.lsp.get_client_by_id(event.data.client_id)
				if not c then return end

				vim.notify("LspAttach AutoCmd by (" .. c.name .. ")")

				-- setup keybinds for LSP
				require("avasile.config.keymaps").lsp(c)

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


		-- deleted whitespace at the end of lines and moves cursor back
		-- where it was before the search replace
		vim.api.nvim_create_autocmd('BufWritePre', {
			desc = "Automatically remove EOL whitespace",
			pattern = "*",
			callback = function(ev)
				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				vim.cmd([[%s/\s\+$//e]])
				vim.api.nvim_win_set_cursor(0, { row, col })
			end
		})
	end
}
return M
