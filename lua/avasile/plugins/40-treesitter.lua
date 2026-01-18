return {
	{
		-- require tar & curl in PATH
		-- tree-sitter-cli https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts = {},
		config = function()
			require("nvim-treesitter")
				.install({
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
				})
				:wait(300000)
		end,
	},
}
