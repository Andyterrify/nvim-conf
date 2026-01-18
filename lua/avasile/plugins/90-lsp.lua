return {
	{ "williamboman/mason.nvim", opts = {} },

	{ -- standard LSP config. not 100% needed but it can help to not manually setup servers
		"neovim/nvim-lspconfig",
		-- cmd = { "LspInfo", "LspInstall", "LspStart" },
		dependencies = {
			"williamboman/mason.nvim",
			"j-hui/fidget.nvim",
		},
		config = function()
			-- config for when an lsp server attaches
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local clients = vim.lsp.get_clients({ id = event.data.client_id })
					-- local client = clients[1]
					-- if not client then
					-- 	return
					-- end

					-- vim.notify("LspAttach AutoCmd by (" .. client.name .. ")")

					-- Setup keybinds for LSP
					require("avasile.lsp.keymaps").setup(event.buf)

					-- Hover on cursor hold
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.hover,
					})
				end,
			})

			-- Diagnostics {{{
			local config = {
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "single",
					source = "always",
					header = "",
					prefix = "",
					suffix = "",
				},
			}
			vim.diagnostic.config(config)
			-- }}}

			-- Improve LSPs UI {{{
			local icons = {
				Class = " ",
				Color = " ",
				Constant = " ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = "󰊕 ",
				Interface = " ",
				Keyword = " ",
				Method = "ƒ ",
				Module = "󰏗 ",
				Property = " ",
				Snippet = " ",
				Struct = " ",
				Text = " ",
				Unit = " ",
				Value = " ",
				Variable = " ",
			}

			local completion_kinds = vim.lsp.protocol.CompletionItemKind
			for i, kind in ipairs(completion_kinds) do
				completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
			end
			-- }}}

			-- Lsp capabilities and on_attach {{{
			-- Here we grab default Neovim capabilities and extend them with ones we want on top
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = true,
				lineFoldingOnly = true,
			}

			capabilities.textDocument.semanticTokens.multilineTokenSupport = true
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.config("*", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- local ok, diag = pcall(require, "rj.extras.workspace-diagnostic")
					-- if ok then
					-- 	diag.populate_workspace_diagnostics(client, bufnr)
					-- end

					-- diag.populate_workspace_diagnostics(client, bufnr)
				end,
			})
			-- }}}

			-- Disable the default keybinds {{{
			for _, bind in ipairs({ "grn", "gra", "gri", "grr", "grt" }) do
				pcall(vim.keymap.del, "n", bind)
			end
			-- }}}


			-- Servers {{{
			local lsp_servers = {
				"gopls",
				"rust_analyzer",
			}

			-- batch enable servers
			for _, server in ipairs(lsp_servers) do
				local ok, conf = pcall(require, "avasile.lsp.servers" .. server)
				if ok then
					vim.lsp.config(server, conf)
				end
				vim.lsp.enable(server)
			end

			-- }}}
		end,
	},
}
