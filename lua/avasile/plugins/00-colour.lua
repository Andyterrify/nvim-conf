return {
	-- colour scheme
	-- love gruvbox
	-- {
	--   "ellisonleao/gruvbox.nvim",
	--   priority = 1000,
	--   opts = {
	--     transparent_mode = true
	--   },
	--   config = function()
	--     vim.o.background = "dark"       -- or "light" for light mode
	--     vim.cmd([[colorscheme gruvbox]])
	--   end
	-- },

	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- },
	-- lua/plugins/rose-pine.lua
	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end
	-- },
	{
		"ayu-theme/ayu-vim",
		config = function()
			vim.cmd("let ayucolor='dark'")
			vim.cmd("colorscheme ayu")
		end
	}
}
