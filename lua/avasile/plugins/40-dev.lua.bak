return {
	{
		"nvim-lua/plenary.nvim",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require("avasile.config.plugins").treesitter.setup
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			'nvim-tree/nvim-web-devicons',
		},
		config = require("avasile.config.plugins").telescope.setup
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			'nvim-lua/plenary.nvim',
			"nvim-telescope/telescope.nvim",
		},
		config = require("avasile.config.plugins").harpoon.setup
	},
	{
		"j-hui/fidget.nvim",
		config = require("avasile.config.plugins").fidget.setup
	},


	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = {}
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			"onsails/lspkind.nvim",
		},
		config = require("avasile.config.plugins").cmp.setup
	},

	{
		"neovim/nvim-lspconfig",
		cmp = { "LspInfo", "LspInstall", "LspStart" },
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
		config = require("avasile.config.plugins").lsp.setup
	},

	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- cond = vim.g.is_personal,
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
	},

	{
		'stevearc/conform.nvim',
		opts = {},
		config = function()
			require("conform").setup({
				formatters = {
				},
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- You can customize some of the format options for the filetype (:help conform.format)
					rust = { "rustfmt", lsp_format = "fallback" },
					json = { "prettierd" },
					typescript = { "prettierd" },
					-- Conform will run the first available formatter
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = {"prettier", },
					typescriptreact = {"prettier", },
					yaml = {"yq", },
					toml = {"yq", },
				},
			})
			require("avasile.config.keymaps").conform.setup()
		end
	},

	{ -- Linting
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require 'lint'
			lint.linters_by_ft = {
				markdown = { 'markdownlint' },
			}

			lint.linters_by_ft = {}
			lint.linters_by_ft["markdown"] = { 'markdownlint' }


			-- To allow other plugins to add linters to require('lint').linters_by_ft,
			-- instead set linters_by_ft like this:
			-- lint.linters_by_ft = lint.linters_by_ft or {}
			-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
			--
			-- However, note that this will enable a set of default linters,
			-- which will cause errors unless these tools are available:
			-- {
			--   clojure = { "clj-kondo" },
			--   dockerfile = { "hadolint" },
			--   inko = { "inko" },
			--   janet = { "janet" },
			--   json = { "jsonlint" },
			--   markdown = { "vale" },
			--   rst = { "vale" },
			--   ruby = { "ruby" },
			--   terraform = { "tflint" },
			--   text = { "vale" }
			-- }
			--
			-- You can disable the default linters by setting their filetypes to nil:
			-- lint.linters_by_ft['clojure'] = nil
			-- lint.linters_by_ft['dockerfile'] = nil
			-- lint.linters_by_ft['inko'] = nil
			-- lint.linters_by_ft['janet'] = nil
			-- lint.linters_by_ft['json'] = nil
			-- lint.linters_by_ft['markdown'] = nil
			-- lint.linters_by_ft['rst'] = nil
			-- lint.linters_by_ft['ruby'] = nil
			-- lint.linters_by_ft['terraform'] = nil
			-- lint.linters_by_ft['text'] = nil

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
				end,
			})
		end,
	},

}
