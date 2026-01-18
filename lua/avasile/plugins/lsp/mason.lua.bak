local M = {}

M.setup = function()
	require("mason").setup()

	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls" },
		automatic_installation = false,
	})
end

return M
