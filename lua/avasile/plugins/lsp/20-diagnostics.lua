local M = {}

M.setup = function()
	-- Configure diagnostic signs
	local signs = {
		Error = "✘",
		Warn = "▲",
		Hint = "⚑",
		Info = "»",
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Configure diagnostic display
	vim.diagnostic.config({
		virtual_text = {
			spacing = 4,
			prefix = "●",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
	})

	-- Configure hover windows with rounded borders
	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

return M
