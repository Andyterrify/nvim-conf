-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- local nmap = require("avasile.utils").nmap

-- local function nmap(lhs, rhs, opts)
-- 	vim.keymap.set('n', lhs, rhs, opts)
-- end

local nmap = require("avasile.utils").nmap
local nmapd = require("avasile.utils").nmapd

-- just amazing
-- swap : and ;, faster commands
vim.keymap.set({ "n", "v", "x" }, ";", ":")
vim.keymap.set({ "n", "v", "x" }, ":", ";")

-- Clear search highlight when pressing <ESC> in normal mode
nmap('<Esc>', '<cmd>nohlsearch<CR>')

-- TODO: move to Oil keybinds
nmapd(
	"<leader>pv",
	':Oil<CR>',
	'[P]roject [V]iew'
)

-- open netrw
nmapd(
	"<leader>pv",
	':Ex<CR>',
	'[P]roject [V]iew'
)

-- faster line movement
-- the `=` realigns given treesitter!
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- quick populate, can execute commands directly on selections
vim.keymap.set({ "n", "v" }, "<leader>n", ":norm ")

-- different from j/k, mostly useful with wrap
-- when linewrap it will navigate the entire wrapped line rather than the visual
-- lines, easier/faster to navigate
nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- quicker buffers
nmap( '<C-m>', ":bn<CR>", { noremap = true, desc = "Next Buffer" })
nmap( '<C-n>', ":bp<CR>", { noremap = true, desc = "Previous Buffer" })

-- quick tabs
nmap( '<C-,>', ":tabnext<CR>", { noremap = true, desc = "Next Tab" })
nmap( '<C-.>', ":tabprevious<CR>", { noremap = true, desc = "Previous Tab" })

-- quicker window navigation, like Alt+<hjkl> on tmux
nmapd( '<C-h>', '<C-w><C-h>', 'Move focus to the left window' )
nmapd( '<C-l>', '<C-w><C-l>', 'Move focus to the right window' )
nmapd( '<C-j>', '<C-w><C-j>', 'Move focus to the lower window' )
nmapd( '<C-k>', '<C-w><C-k>', 'Move focus to the upper window' )

-- Faster exit from input mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Esc" })

-- when joining a line with J it sets a mark where the cursor is at,
-- joins, then jumps back to prev position. tldr doesn't move cursor to end of line
-- when splitting
nmapd( "J", "mzJ`z", "Join Line Below")

-- when searching, center the selection
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

nmapd(
	'<C-8>', [[m`:%s/\<<C-r><C-w>\>//n<CR>``]],
	'Do `*` but stay on current match and preserve window scroll position'
)

-- greatest remap ever
-- allows to select text and paste what's in " reg and deleting what's selected
vim.keymap.set("x", "<leader>p", [["_dP]])

-- -- next greatest remap ever : asbjornHaland
-- -- yanks into system clipboard
vim.keymap.set("v", "<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])

-- to avoid EX mode?
nmap("Q", "<nop>")

-- search and modify all occurendes of the word under cursor
-- respects case I believe
nmapd(
	"<leader>ra",
	[[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
	"[R]eplace [A]ll occurences under cursor"
)

-- terminal shortcut
-- makes exiting terminal easier
vim.keymap.set('t', '<ESC>', "<C-\\><C-n>")
