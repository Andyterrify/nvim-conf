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
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			'nvim-tree/nvim-web-devicons',
			-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
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
}
