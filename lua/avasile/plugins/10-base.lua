return {
	"nvim-lua/plenary.nvim",
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = require("avasile.config.plugins").harpoon.setup
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
			"nvim-treesitter/nvim-treesitter",
			'nvim-telescope/telescope-ui-select.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
		},
		config = require("avasile.config.plugins").telescope.setup
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
		},
		-- event = "VeryLazy",
		config = require("avasile.config.plugins").lsp.setup
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			"onsails/lspkind.nvim",
		},
		config = require("avasile.config.plugins").cmp.setup
	},
}
