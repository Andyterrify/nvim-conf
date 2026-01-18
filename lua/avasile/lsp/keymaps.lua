local M = {}

M.setup = function(bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end
	local function nmap(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end
	local diag = vim.diagnostic
	local lsp = vim.lsp

	-- Diagnostics (provided by Neovim, not the server)
	nmap("<leader>cd", diag.open_float, "[C]ode [D]iagnostics")
	nmap("[d", function() diag.jump({ count = -1, float = true }) end, "Previous Diagnostic")
	nmap("]d", function() diag.jump({ count = 1, float = true }) end, "Next Diagnostic")

	-- Toggle inlay hints (Neovim feature)
	nmap("<leader>th", function()
		local new_state = not lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		lsp.inlay_hint.enable(new_state, { bufnr = bufnr })
		vim.notify(string.format("Inlay Hints: %s", new_state and "ON" or "OFF"))
	end, "Toggle Inlay Hints")


	local defs = {
		["hover"] = lsp.buf.hover,
		["declaration"] = lsp.buf.declaration,
		["rename"] = lsp.buf.rename,
		["code_action"] = lsp.buf.code_action,
		["signature_help"] = lsp.buf.signature_help,
		["lsp_definitions"] = lsp.buf.definition,
		["lsp_references"] = lsp.buf.references,
		["lsp_implementations"] = lsp.buf.implementation,
		["lsp_type_definitions"] = lsp.buf.type_definition,
		["lsp_document_symbols"] = lsp.buf.document_symbol,
		["lsp_dynamic_workspace_symbols"] = lsp.buf.document_symbol,
	}
	local got_telescope, telsc = pcall(require, "telescope.builtin")
	if got_telescope then
		defs["lsp_definitions"] = telsc.lsp_definitions
		defs["lsp_references"] = telsc.lsp_references
		defs["lsp_implementations"] = telsc.lsp_implementations
		defs["lsp_type_definitions"] = telsc.lsp_type_definitions
		defs["lsp_document_symbols"] = telsc.lsp_document_symbols
		defs["lsp_dynamic_workspace_symbols"] = telsc.lsp_dynamic_workspace_symbols
	end

	nmap("K", defs.hover, "Hover Documentation")
	nmap("gd", defs.lsp_definitions, "[G]oto Definition")
	nmap("gD", defs.declaration, "[G]oto Declaration")
	nmap("gr", defs.lsp_references, "[G]oto References")
	nmap("gi", defs.lsp_implementations, "[G]oto Implementation")
	nmap("<leader>D", defs.lsp_type_definitions, "Type Definition")
	nmap("<leader>rn", defs.rename, "[R]e[n]ame")
	nmap("<leader>ds", defs.lsp_document_symbols, "[D]ocument [S]ymbols")
	map({ "n", "v" }, "<leader>ca", defs.code_action, "[C]ode [A]ction")
	nmap("<leader>ws", defs.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("i", "<C-k>", defs.signature_help, "Signature Help")

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
-- M.show_capabilities = function()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	local clients = vim.lsp.get_clients({ bufnr = bufnr })
--
-- 	if #clients == 0 then
-- 		vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
-- 		return
-- 	end
--
-- 	for _, client in ipairs(clients) do
-- 		print(string.format("\n=== %s ===", client.name))
-- 		local caps = client.server_capabilities
--
-- 		-- Print available capabilities
-- 		for cap, value in pairs(caps) do
-- 			if value == true or type(value) == "table" then
-- 				print(string.format("  ✓ %s", cap))
-- 			end
-- 		end
-- 	end
-- end

return M
