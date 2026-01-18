return {
	-- most important
	{"nvim-lua/plenary.nvim",lazy=true},
	{"nvim-tree/nvim-web-devicons", lazy=true},

	{
		"ayu-theme/ayu-vim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins

		config = function()
			vim.cmd("let ayucolor='dark'")
			vim.cmd("colorscheme ayu")
		end
	},
	{
		"https://github.com/vague2k/vague.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		  priority = 1000, -- make sure to load this before all the other plugins

	}
}
