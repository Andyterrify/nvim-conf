local M = {}

M.lsp = {
	setup = function()

		vim.api.nvim_create_autocmd('LspDetach', {
			callback = function(event)
				local c = vim.lsp.get_client_by_id(event.data.client_id)
				if not c then return end

				require "avasile.config.lsp".teardown(event)
			end
		})

		-- -- Create local buffer opts when a new buffer is opened
		-- vim.api.nvim_create_autocmd('BufReadPost', {
		-- 	callback = function(event)
		-- 		require "avasile.utils".get_buffer_opts(event.buffer)
		-- 	end
		-- })

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

		-- Delete local buffer opts when a new buffer is closed
		-- vim.api.nvim_create_autocmd('BufDelete', {
		-- 	callback = function(event)
		-- 		require "avasile.utils".delete_buffer_opts(event.buffer)
		-- 	end
		-- })
	end
}
return M
