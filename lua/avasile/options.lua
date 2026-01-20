-- https://neovim.io/doc/user/quickref.html#option-list
--
-- inspired by https://github.com/Rishabh672003/Neovim/blob/main/lua/rj/options.lua

local options = {
	backup = false, -- create a backup file
	writebackup = false, -- if a file is already being used then don't allow to write
	autochdir = false, -- don't change vim CWD as you open files
	cmdheight = 1, -- more height in command line for messages
	conceallevel = 0, -- so that `` shows in markdown files
	-- fileencoding = "utf-8", -- defautl encoding used by files
	pumheight = 10, -- pop up menu height
	hlsearch = true, -- highlhight on search
	incsearch = true, -- highlhight on search
	inccommand = "split", -- preview substitution in split window
	number = true, -- show relative numbers
	relativenumber = true, -- show relative numbers
	numberwidth = 2, -- always show min 2 chars for line numbers. easily go over 9
	colorcolumn = "112", -- show a guide at 112 chars
	showmode = false, -- don't show mode on last list as its already shown in status line
	cursorline = true, -- highlight the line the cursor is on
	mouse = "a", -- enable mouse functions
	-- clipboard = "unnamedplus", -- Remove this option if you want your OS clipboard to remain independent. See `:help 'clipboard'`
	ignorecase = true, -- ignore case in search
	smartcase = true, -- account case if search patttern has upper case
	signcolumn = "yes:2", -- always show the sign column. keep 2 spaces for it
	timeoutlen = 500, -- time to wait for a mapped sequence to complete (in millis)
	completeopt = "menuone,noinsert,preview", -- something to do with comp opt
	termguicolors = true, -- enable term GUI colours
	wrap = false, -- don't wrap long lines
	splitbelow = true, -- force all horizontal splits to go below
	splitright = true, -- force all vertical splits to go right
	list = false, -- don't show meta chars
	listchars = { tab = "» ", trail = "·", nbsp = "␣" }, -- said meta chars to show
	foldmethod = "indent", -- auto fold on indent
	foldlevel = 8, -- auto hold deeper than 8 levels
	foldminlines = 1, -- how many lines a fold needs before it is folded
	scrolloff = 8, -- when scrolling how many lines to keep on screen
	sidescrolloff = 8, -- same as above but for horizontal
	virtualedit = "onemore", -- allow cursor to "move" past the end of a line
	breakindent = true, -- enable break indent
	linebreak = true, -- never split a line inside a word
	-- tabstop = 4, -- how many chars a tab takes up
	softtabstop = 4, -- how many chars a tab is shown as
	tabstop = 4, -- how many chars a shift moves by
	shiftwidth = 4, -- how many chars a shift moves by
	expandtab = true, -- always expand tab to spaces
	smartindent = true, --
	swapfile = false, -- don't hold a swap file
	undofile = true, -- keep an undo file
	updatetime = 300, -- faster complettion (4000ms default) also affects things like cursor hold to hover (autocmd)
	-- foldexpr = "v:lua.vim.treesitter.foldexpr()", -- specifies the expression used to calculate folds
	-- indentexpr = "nvim_treesitter#indent()", -- specifies the function used to calculate the indentation level
	wildoptions = { "fuzzy", "pum", "tagfile" }, -- unclear
	splitkeep = "cursor", -- when scaling horizontal splits keep the cursor in the same relative position
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- -- -- -- This will disable the vim swap and backup files and only use undotree,
-- -- -- -- saving undo files to ~/.local/state/nvim/undotree
-- -- vim.opt.swapfile = false
-- -- vim.opt.backup = false
-- -- vim.opt.undofile = true
-- -- vim.opt.undodir = vim.fn.stdpath("state") .. "/undotree"
--
-- -- NOTE: on idea
-- -- vim.opt.isfname:append("@-@")

-- netrw handy keys
-- ignored if using Oil
vim.g.netrw_banner = 1
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 1

vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.iskeyword:append("-")
-- vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.diffopt:append("linematch:60")
vim.opt.shortmess:append({ C = true, c = true, I = true })
-- vim.opt.cinkeys:remove(":")
vim.opt.indentkeys:remove(":")
vim.g.c_syntax_for_h = true
