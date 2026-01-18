-- ============================================================================
-- ALTERNATIVE IMPLEMENTATION: Handles Multiple Servers Efficiently
-- ============================================================================
-- This version only sets keymaps ONCE per buffer, checking ALL attached
-- servers for capabilities. Use this if you frequently have multiple servers
-- on the same buffer and want to avoid redundant keymap setting.
--
-- To use this version, replace the require in autocmds.lua:
-- require("avasile.plugins.lsp.keymaps_multi_server").setup(client, event.buf)
-- ============================================================================

local M = {}

M.setup = function(client, bufnr)
	-- Check if we've already set up keymaps for this buffer
	if vim.b[bufnr].lsp_keymaps_setup then
		-- Keymaps already set, just mark this client as handled
		vim.b[bufnr].lsp_clients_handled = vim.b[bufnr].lsp_clients_handled or {}
		vim.b[bufnr].lsp_clients_handled[client.name] = true
		return
	end

	-- Mark as setup to prevent duplicate setup
	vim.b[bufnr].lsp_keymaps_setup = true
	vim.b[bufnr].lsp_clients_handled = { [client.name] = true }

	-- Helper to set buffer-local keymaps
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	-- Helper to check if ANY attached server has a capability
	local function any_client_has(capability)
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		for _, c in ipairs(clients) do
			local cap_value = c.server_capabilities[capability]
			if cap_value == true or type(cap_value) == "table" then
				return true
			end
		end
		return false
	end

	-- ============================================================================
	-- ALWAYS AVAILABLE KEYMAPS
	-- ============================================================================

	map("n", "<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
	map("n", "[d", vim.diagnostic.jump({ count = -1, float = true }), "Previous Diagnostic")
	map("n", "]d", vim.diagnostic.jump({ count = 1, float = true }), "Next Diagnostic")

	map("n", "<leader>th", function()
		local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(new_state, { bufnr = bufnr })
		vim.notify(string.format("Inlay Hints: %s", new_state and "ON" or "OFF"))
	end, "Toggle Inlay Hints")

	-- ============================================================================
	-- CAPABILITY-DEPENDENT KEYMAPS
	-- Set based on ANY attached server having the capability
	-- ============================================================================

	if any_client_has("hoverProvider") then
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	end

	if any_client_has("definitionProvider") then
		map("n", "gd", function()
			require("telescope.builtin").lsp_definitions()
		end, "[G]oto Definition")
	end

	if any_client_has("declarationProvider") then
		map("n", "gD", vim.lsp.buf.declaration, "[G]oto Declaration")
	end

	if any_client_has("referencesProvider") then
		map("n", "gr", function()
			require("telescope.builtin").lsp_references()
		end, "[G]oto References")
	end

	if any_client_has("implementationProvider") then
		map("n", "gi", function()
			require("telescope.builtin").lsp_implementations()
		end, "[G]oto Implementation")
	end

	if any_client_has("typeDefinitionProvider") then
		map("n", "<leader>D", function()
			require("telescope.builtin").lsp_type_definitions()
		end, "Type Definition")
	end

	if any_client_has("renameProvider") then
		map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	end

	if any_client_has("codeActionProvider") then
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	end

	if any_client_has("documentSymbolProvider") then
		map("n", "<leader>ds", function()
			require("telescope.builtin").lsp_document_symbols()
		end, "[D]ocument [S]ymbols")
	end

	if any_client_has("workspaceSymbolProvider") then
		map("n", "<leader>ws", function()
			require("telescope.builtin").lsp_dynamic_workspace_symbols()
		end, "[W]orkspace [S]ymbols")
	end

	if any_client_has("signatureHelpProvider") then
		map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
	end

	if any_client_has("documentFormattingProvider") then
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, "Format Document")
	end

	if any_client_has("documentRangeFormattingProvider") then
		map("v", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, "Format Selection")
	end

	-- Notify which clients are attached
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local client_names = {}
	for _, c in ipairs(clients) do
		table.insert(client_names, c.name)
	end
	vim.notify(
		string.format("LSP keymaps set for buffer %d (%s)", bufnr, table.concat(client_names, ", ")),
		vim.log.levels.INFO
	)
end

-- ============================================================================
-- HELPER: Update keymaps when new server attaches
-- ============================================================================
-- If you want to dynamically add keymaps when a new server attaches later,
-- call this function. It will check for new capabilities and add keymaps.
M.update = function(bufnr)
	-- Reset the setup flag
	vim.b[bufnr].lsp_keymaps_setup = nil

	-- Get the first client (we just need one to trigger setup)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients > 0 then
		M.setup(clients[1], bufnr)
	end
end

return M
