-- https://github.com/Rishabh672003/Neovim/blob/main/lua/rj/extras/big-file.lua

local big_file = vim.api.nvim_create_augroup("BigFile", { clear = true })
vim.filetype.add({
	pattern = {
		[".*"] = {
			function(path, buf)
				return vim.bo[buf]
						and vim.bo[buf].filetype ~= "bigfile"
						and path
						and vim.fn.getfsize(path) > 1024 * 10000
						and "bigfile"
					or nil -- bigger than 10MB
			end,
		},
	},
})

-- vim.api.nvim_create_autocmd({ "FileType" }, {
-- 	group = big_file,
-- 	pattern = "bigfile",
-- 	callback = function(ev)
-- 		vim.cmd("syntax off")
-- 		vim.b.minicursorword_disable = true
-- 		vim.b.miniindentscope_disable = true
-- 		vim.opt_local.foldmethod = "manual"
-- 		vim.opt_local.spell = false
-- 		vim.schedule(function()
-- 			vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
-- 		end)
-- 	end,
-- })
