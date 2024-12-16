local M = {}

M.lsp = {
	setup = function()
		vim.api.nvim_create_autocmd('LspAttach', {
			group = AndyterrifyGroup,
			callback = function(event)
				local c = vim.lsp.get_client_by_id(event.data.client_id)
				-- setup keybinds

				require("avasile.config.keymaps").lsp.setup(event)

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
}
return M
