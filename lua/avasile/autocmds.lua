-- auto remove whitespace from end of line
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Automatically remove EOL whitespace",
	pattern = "*",
	callback = function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, { row, col })
	end,
})

-- hightlight text yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
