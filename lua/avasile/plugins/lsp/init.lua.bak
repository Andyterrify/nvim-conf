return {
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
		},
		init = function()
			vim.opt.signcolumn = "yes"
		end,
		config = function()
			-- Setup common LSP configuration
			require("avasile.plugins.lsp.autocmds").setup()
			require("avasile.plugins.lsp.diagnostics").setup()
			require("avasile.plugins.lsp.mason").setup()

			-- Setup capabilities with nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- List of servers to configure
			local servers = {
				-- "lua_ls",
				-- "ts_ls",
				"gopls",
				-- "rust_analyzer",
				-- "pyright",
				-- "tailwindcss",
			}

			-- Configure and enable each server
			for _, server in ipairs(servers) do
				local config = require("avasile.plugins.lsp.servers." .. server)
				config.capabilities = capabilities
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
				vim.notify("Enabled LSP server " .. server)
			end

			-- Enable inlay hints globally
			vim.lsp.inlay_hint.enable()
		end,
	},
}
