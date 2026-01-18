return {
	{
		-- require tar & curl in PATH
		-- also require tree-sitter-cli https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			-- require("nvim-treesitter.configs").setup({
			-- 	ensure_installed = {
			-- 		"lua",
			-- 		"rust",
			-- 		"go",
			-- 		"diff",
			-- 		"html",
			-- 		"javascript",
			-- 		"json",
			-- 		"jsonc",
			-- 		"luadoc",
			-- 		"luap",
			-- 		"markdown",
			-- 		"markdown_inline",
			-- 		"python",
			-- 		"vim",
			-- 		"vimdoc",
			-- 		"yaml",
			-- 	},
			-- 	sync_install = true,
			-- 	auto_install = true,
			-- 	highlight = {
			-- 		enable = true,
			-- 	},
			-- 	incremental_selection = {
			-- 		enable = true,
			-- 		keymaps = {
			-- 			init_selection = "gnn",
			-- 			node_incremental = "grn",
			-- 			scope_incremental = "grc",
			-- 			node_decremental = "grm",
			-- 		},
			-- 	},
			-- })
		},
		config = function()
			require("nvim-treesitter").install(
				{
					"lua",
					"rust",
					"go",
					"diff",
					"html",
					"javascript",
					"json",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"vim",
					"vimdoc",
					"yaml",
					"go",
				}
			):wait(300000)
		end
	},
}
