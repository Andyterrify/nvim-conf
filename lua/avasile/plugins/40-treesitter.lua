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
			local wanted = {
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
			}

			require("nvim-treesitter").install(wanted):wait(300000)

			-- treesitter highlight for filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = wanted,
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim
					-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					-- vim.wo.foldmethod = "expr"
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
