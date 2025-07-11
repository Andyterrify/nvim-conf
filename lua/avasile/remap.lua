-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local nmap = require("avasile.utils").nmap

-- Clear search highlight when pressing <ESC> in normal mode
nmap({ '<Esc>', '<cmd>nohlsearch<CR>' })

-- open netrw
nmap({
    "<leader>pv",
    ':Oil<CR>',
    { desc = '[P]roject [V]iew' }
})

-- faster line movement
-- the `=` realigns given treesitter!
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})


-- different from j/k, mostly useful with wrap
-- when linewrap it will navigate the entire wrapped line rather than the visual
-- lines, easier/faster to navigate
nmap({ 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = false } })
nmap({ 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = false } })

-- quicker buffers
-- NOTE: don't really use this but hit it often
-- nmap({
--     '<C-m>',
--     ":bn<CR>",
--     { noremap = true, desc = "Next Buffer" }
-- })
-- nmap({
--     '<C-n>',
--     ":bp<CR>",
--     { noremap = true, desc = "Previous Buffer" }
-- })

-- this on the other hand is really useful, didn't know this existed
nmap({ '<C-,>', ":tabnext<CR>", { noremap = true, desc = "Next Tab" } })
nmap({ '<C-.>', ":tabprevious<CR>", { noremap = true, desc = "Previous Tab" } })

-- quicker window navigation, like Alt+<hjkl> on tmux
nmap({ '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' } })
nmap({ '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' } })
nmap({ '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' } })
nmap({ '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' } })

-- Faster exit
vim.keymap.set("i", "jk", "<Esc>", { desc = "Esc" })

-- when joining a line with J it sets a mark where the cursor is at,
-- joins, then jumps back to prev position. tldr doesn't move cursor to end of line
-- when splitting
nmap({ "J", "mzJ`z" })

-- when searching, center the selection
nmap({ "n", "nzz" })
nmap({ "N", "Nzz" })
-- highlight current word with search without moving current line
nmap({ '<C-8>', [[m`:%s/\<<C-r><C-w>\>//n<CR>``]], { desc = 'Do `*` but stay on current match and preserve window scroll position' } })

-- greatest remap ever
-- allows to select text and paste what's in " reg and deleting what's
-- selected
vim.keymap.set("x", "<leader>p", [["_dP]])

-- -- next greatest remap ever : asbjornHaland
-- -- yanks into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
nmap({ "<leader>Y", [["+Y]] })

-- to avoid EX mode?
nmap({ "Q", "<nop>" })

-- search and modify all occurendes of the word under cursor
-- respects case I believe
nmap({ "<leader>ra", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { desc = "[R]eplace [A]ll occurences under cursor" }
})

-- terminal shortcut
-- makes exiting terminal easier
vim.keymap.set('t', '<ESC>', "<C-\\><C-n>")

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- added by default in 0.10
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
