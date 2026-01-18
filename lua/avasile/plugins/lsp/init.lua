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
			-- Setup common LSP configuration

			-- Setup capabilities with nvim-cmp
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- List of servers to configure
			local servers = {
				"lua_ls",
				"ts_ls",
				"gopls",
				"rust_analyzer",
				"pyright",
				"tailwindcss",
			}

			-- -- Configure and enable each server
			for _, server in ipairs(servers) do
				local config = require("avasile.plugins.lsp.servers." .. server)
				-- config.capabilities = capabilities
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			-- -- Enable inlay hints globally
			-- vim.lsp.inlay_hint.enable()

			-- require("avasile.plugins.lsp.10-mason").setup()
			-- require("avasile.plugins.lsp.20-diagnostics").setup()
			require("avasile.plugins.lsp.30-autocmds").setup()
		end,
	},
}
