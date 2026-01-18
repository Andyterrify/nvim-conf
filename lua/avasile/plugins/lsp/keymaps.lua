local M = {}

M.setup = function(client, bufnr)
	-- Use buffer-local keymaps (requires bufnr parameter)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	-- ============================================================================
	-- ALWAYS AVAILABLE KEYMAPS
	-- These don't depend on server capabilities
	-- ============================================================================

	-- Diagnostics (provided by Neovim, not the server)
	map("n", "<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
	map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous Diagnostic")
	map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")

	-- Toggle inlay hints (Neovim feature)
	map("n", "<leader>th", function()
		local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(new_state, { bufnr = bufnr })
		vim.notify(string.format("Inlay Hints: %s", new_state and "ON" or "OFF"))
	end, "Toggle Inlay Hints")

	-- ============================================================================
	-- CAPABILITY-DEPENDENT KEYMAPS
	-- Only set these if the server supports them
	-- ============================================================================

	local caps = client.server_capabilities

	-- Hover documentation
	if caps.hoverProvider then
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	end

	-- Go to definition
	if caps.definitionProvider then
		map("n", "gd", function()
			require("telescope.builtin").lsp_definitions()
		end, "[G]oto Definition")
	end

	-- Go to declaration (less common, but some servers provide it)
	if caps.declarationProvider then
		map("n", "gD", vim.lsp.buf.declaration, "[G]oto Declaration")
	end

	-- Find references
	if caps.referencesProvider then
		map("n", "gr", function()
			require("telescope.builtin").lsp_references()
		end, "[G]oto References")
	end

	-- Go to implementation
	if caps.implementationProvider then
		map("n", "gi", function()
			require("telescope.builtin").lsp_implementations()
		end, "[G]oto Implementation")
	end

	-- Go to type definition
	if caps.typeDefinitionProvider then
		map("n", "<leader>D", function()
			require("telescope.builtin").lsp_type_definitions()
		end, "Type Definition")
	end

	-- Rename symbol
	if caps.renameProvider then
		map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	end

	-- Code actions
	if caps.codeActionProvider then
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	end

	-- Document symbols
	if caps.documentSymbolProvider then
		map("n", "<leader>ds", function()
			require("telescope.builtin").lsp_document_symbols()
		end, "[D]ocument [S]ymbols")
	end

	-- Workspace symbols
	if caps.workspaceSymbolProvider then
		map("n", "<leader>ws", function()
			require("telescope.builtin").lsp_dynamic_workspace_symbols()
		end, "[W]orkspace [S]ymbols")
	end

	-- Signature help
	if caps.signatureHelpProvider then
		map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
	end

	-- NOTE: Formatting is handled by conform.nvim (see plugins/conform.lua)
	-- We don't set LSP formatting keymaps here to avoid conflicts
	-- Conform can use LSP formatting as a fallback with lsp_format = "fallback"

	-- ============================================================================
	-- DEBUGGING: Print server capabilities
	-- ============================================================================
	-- Uncomment to see what capabilities your server actually provides:
	-- vim.notify(string.format("LSP %s attached with capabilities:", client.name))
	-- vim.print(vim.tbl_keys(caps))
end

-- ============================================================================
-- HELPER: Check if server supports a specific capability
-- ============================================================================
-- -- Usage: if M.has_capability(client, "hoverProvider") then ... end
-- M.has_capability = function(client, capability)
-- 	if not client or not client.server_capabilities then
-- 		return false
-- 	end
--
-- 	local value = client.server_capabilities[capability]
--
-- 	-- Capabilities can be:
-- 	-- - true (supported)
-- 	-- - false/nil (not supported)
-- 	-- - a table with options (supported with config)
-- 	if type(value) == "table" then
-- 		return true
-- 	end
--
-- 	return value == true
-- end

-- ============================================================================
-- HELPER: Get all available LSP commands for current buffer
-- ============================================================================
-- Usage: :lua require("avasile.plugins.lsp.keymaps").show_capabilities()
M.show_capabilities = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		print(string.format("\n=== %s ===", client.name))
		local caps = client.server_capabilities

		-- Print available capabilities
		for cap, value in pairs(caps) do
			if value == true or type(value) == "table" then
				print(string.format("  ✓ %s", cap))
			end
		end
	end
end

return M
