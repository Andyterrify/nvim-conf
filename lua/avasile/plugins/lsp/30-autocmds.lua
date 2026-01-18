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

			-- Hover on cursor hold
			if client and client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.hover,
				})
			end
		end,
	})
end

return M
