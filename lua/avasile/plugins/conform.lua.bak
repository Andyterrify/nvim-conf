return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters = {},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					go = { "goimports", "gofmt" },
					json = { "prettierd" },
					typescript = { "prettierd" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					yaml = { "yq" },
					toml = { "yq" },
				},
			})

			-- Keymap for formatting (normal and visual mode)
			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({
					lsp_format = "fallback",
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format buffer" })
		end,
	},
}
