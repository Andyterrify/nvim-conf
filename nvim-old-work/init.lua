vim = vim
local vim_opts = function()
    -- pip3 install black python-lsp-server pyright
    vim.o.directory = '/root/.tmp/'
    vim.cmd("autocmd FileType help wincmd L")
    -- set leader key
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '


    -- Clear search highlight when pressing <ESC> in normal mode
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- open netrw
    vim.keymap.set("n", "<leader>pv", ':Oil<CR>', {})

    -- faster line movement
    -- the `=` realigns given treesitter!
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})

    -- Remap for dealing with word wrap
    vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- quicker buffers
    vim.keymap.set('n', '<C-m>', ":bn<CR>", { noremap = true, desc = "Next Buffer" })
    vim.keymap.set('n', '<C-n>', ":bp<CR>", { noremap = true, desc = "Previous Buffer" })

    -- quicker buffers
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

    -- Faster exit
    vim.keymap.set("i", "jk", "<Esc>", { desc = "Esc" })

    vim.keymap.set("n", "J", "mzJ`z")

    vim.filetype.add({
        extension = {
            xs = "python"
        }
    }
    )

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function()
            vim.opt_local.shiftwidth = 2
            vim.opt_local.tabstop = 2
            vim.opt_local.expandtab = true
        end,
    })

    -- -- When moving up and down, center the cursor
    -- vim.keymap.set("n", "<C-d>", "<C-d>zz")
    -- vim.keymap.set("n", "<C-u>", "<C-u>zz")

    -- when working with searching, center the selection
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")

    -- greatest remap ever
    vim.keymap.set("x", "<leader>p", [["_dP]])

    -- next greatest remap ever : asbjornHaland
    -- yanks into system clipboard
    -- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
    -- vim.keymap.set("n", "<leader>Y", [["+Y]])

    vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

    vim.keymap.set("n", "Q", "<nop>")
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ timeout_ms = 30000 }) end)
    vim.keymap.set("v", "<leader>f",
        function()
            local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
            local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
            vim.lsp.buf.format({
                range = {
                    ["start"] = { start_row, 0 },
                    ["end"] = { end_row, 0 },
                },
                async = true,
            })
        end)
    -- next and previous diagnotic
    vim.keymap.set("n", "<C-]>", "<cmd>cnext<CR>zz")
    vim.keymap.set("n", "<C-[>", "<cmd>cprev<CR>zz")
    -- next and prev location list
    vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
    vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

    -- disable highlighting
    vim.keymap.set({ "n", "v" }, "<leader>x", "<cmd>nohlsearch<CR>")

    -- search and modify all occurendes of the word under cursor
    -- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
    -- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

    -- Open fugitive to the side
    vim.keymap.set("n", "<leader>G", "<cmd>vert Git<CR>", {})
    -- Toggle unfotree
    vim.keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", {})
    -- Search project TODOs
    vim.keymap.set('n', '<leader>sn', ":TodoTelescope<CR>", { noremap = true, desc = "[S]earch [N]otes" })

    -- Diagnostic keymaps
    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
    -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
    -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
    --
    -- terminal shortcut
    vim.keymap.set('t', '<ESC>', "<C-\\><C-n>")
    -- set default terminal to xonsh
    vim.opt.shell = "xonsh"



    -- Set highlight on search
    vim.o.hlsearch = true
    vim.opt.incsearch = true
    -- Preview substitutions live, as you type!
    vim.opt.inccommand = 'split'

    -- Set to true if you have a Nerd Font installed
    vim.g.have_nerd_font = true

    -- Make line numbers default
    vim.opt.number = true
    vim.opt.ruler = true
    vim.opt.relativenumber = true

    -- Display columns in buffer to indicate line length
    vim.opt.colorcolumn = "88,120"

    -- Don't show the mode, since it's already in status line
    vim.opt.showmode = false

    -- highlight the line the cursor is on
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = true

    -- Enable mouse mode
    vim.o.mouse = 'r'

    -- Sync clipboard between OS and Neovim.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    -- vim.o.clipboard = 'unnamedplus'

    -- Enable break indent
    vim.o.breakindent = true

    -- Save undo history
    vim.o.undofile = true

    -- Case-insensitive searching UNLESS \C or capital in search
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Keep signcolumn on by default
    vim.wo.signcolumn = 'yes'

    vim.o.updatetime = 4000
    vim.o.timeoutlen = 1000

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect'

    vim.o.termguicolors = true

    -- Disable wrap by default, preferred behavior
    vim.o.wrap = false

    -- Configure how new splits should be opened
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- Sets how neovim will display certain whitespace in the editor.
    --  See `:help 'list'`
    --  and `:help 'listchars'`
    vim.opt.list = false
    -- vim.opt.listchars = { tab = '» ', extends = '#', lead = '-', trail = '·', nbsp = '␣' }

    -- better folding behavior
    vim.o.foldmethod = 'indent'
    vim.o.foldlevel = 10

    -- how many lines to see when at the top or bottom of the buffer
    vim.o.scrolloff = 5

    -- Enable break indent
    vim.opt.breakindent = true
    -- don't break mid word
    vim.opt.linebreak = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.smartindent = true

    -- This will disable the vim swap and backup files and only use undotree,
    -- saving undo files to ~/.local/state/nvim/undotree
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.stdpath("state") .. "/undotree"

    vim.opt.isfname:append("@-@")

    vim.opt.updatetime = 50

    vim.g.netrw_browse_split = 0
    vim.g.netrw_banner = 0
    vim.g.netrw_winsize = 25
end


-- -- auto delete whitespace at the end of TextYankPostiens
vim.api.nvim_create_autocmd('BufWritePre', {
    group = AndyterrifyGroup,
    desc = "Automatically remove whitespace from the end of lines",
    pattern = "*",
    callback = function()
        vim.cmd([[%s/\s\+$//e]])
    end
})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


local lazy_fn = function()
    require("lazy").setup(
        {
            -- Just in case
            -- 'tpope/vim-sleuth',
            -- Lazy

            -- {
            --     "folke/tokyonight.nvim",
            --     lazy = false,    -- make sure we load this during startup if it is your main colorscheme
            --     priority = 1000, -- make sure to load this before all the other start plugins
            --     tag = "v3.0.1",
            --     -- config = function()
            --     --     -- load the colorscheme here
            --     --     vim.cmd([[colorscheme tokyonight-night]])
            --     -- end
            -- },
            {
                "rose-pine/neovim",
                lazy = false,    -- make sure we load this during startup if it is your main colorscheme
                priority = 1000, -- make sure to load this before all the other start plugins
            },

            -- {
            --     'ellisonleao/gruvbox.nvim',
            --     lazy = false,
            --     priority = 1000,
            --     config = function()
            --         vim.o.background = "dark" -- or "light" for light mode
            --         vim.cmd([[colorscheme gruvbox]])
            --     end
            -- },

            { "sindrets/diffview.nvim" },

            -- {
            --     "folke/trouble.nvim",
            --     opts = {
            --         icons = true
            --     },
            --     dependencies = {
            --         "nvim-tree/nvim-web-devicons",
            --     },
            --     config = function()
            --         require("trouble").setup({})
            --
            --         -- vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>")
            --
            --         vim.keymap.set("n", "]d", function()
            --             require("trouble").open()
            --             require("trouble").next({ skip_groups = true, jump = true });
            --         end)
            --
            --         vim.keymap.set("n", "[d", function()
            --             require("trouble").open()
            --             require("trouble").previous({ skip_groups = true, jump = true });
            --         end)
            --     end
            -- },

            {
                "folke/todo-comments.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                    require("todo-comments").setup({})
                end
            },
            "mbbill/undotree",

            {
                "tpope/vim-fugitive",
                -- event = "VeryLazy"
            },


            {
                -- Set lualine as statusline
                'nvim-lualine/lualine.nvim',
                -- See `:help lualine.txt`
                opts = {
                    options = {
                        icons_enabled = true,
                        theme = 'rose-pine',
                        component_separators = '|',
                        section_separators = '',
                    },
                    sections = {
                        lualine_a = { 'mode', },
                        lualine_b = { 'branch', 'diff', 'diagnostics' },
                        lualine_c = { 'filename' },
                        lualine_x = { 'encoding', 'fileformat', 'filetype' },
                        lualine_y = { 'progress', },
                        lualine_z = { { 'datetime', style = '%Y-%m-%dT%H:%M UTC' }, 'location' }
                    },
                },
            },

            -- {                       -- Useful plugin to show you pending keybinds.
            --     'folke/which-key.nvim',
            --     event = 'VimEnter', -- Sets the loading event to 'VimEnter'
            --     config = function() -- This is the function that runs, AFTER loading
            --         require('which-key').setup()
            --
            --         -- -- Document existing key chains
            --         -- require('which-key').register {
            --         --     ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
            --         --     ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
            --         --     ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
            --         --     ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
            --         --     ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            --         -- }
            --     end,
            -- },


            {
                'prichrd/netrw.nvim',
                config = function()
                    require("netrw").setup({
                        use_devicons = true
                    })
                end

            },


            -- {
            --     "lukas-reineke/indent-blankline.nvim",
            --     main = "ibl",
            --     opts = {},
            --     config = function()
            --         local highlight = {
            --             "RainbowRed",
            --             "RainbowYellow",
            --             "RainbowBlue",
            --             "RainbowOrange",
            --             "RainbowGreen",
            --             "RainbowViolet",
            --             "RainbowCyan",
            --         }
            --         local hooks = require "ibl.hooks"
            --         -- create the highlight groups in the highlight setup hook, so they are reset
            --         -- every time the colorscheme changes
            --         hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            --             vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            --             vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            --             vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            --             vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            --             vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            --             vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            --             vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            --         end)

            --         vim.g.rainbow_delimiters = { highlight = highlight }
            --         require("ibl").setup { scope = { highlight = highlight } }

            --         hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
            --     end
            -- },
            --{ -- Collection of various small independent plugins/modules
            --    'echasnovski/mini.nvim',
            --    config = function()
            --        -- Better Around/Inside textobjects
            --        --
            --        -- Examples:
            --        --  - va)  - [V]isually select [A]round [)]paren
            --        --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --        --  - ci'  - [C]hange [I]nside [']quote
            --        require('mini.ai').setup { n_lines = 500 }

            --        -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --        --
            --        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            --        -- - sd'   - [S]urround [D]elete [']quotes
            --        -- - sr)'  - [S]urround [R]eplace [)] [']
            --        require('mini.surround').setup()

            --        -- ... and there is more!
            --        --  Check out: https://github.com/echasnovski/mini.nvim
            --    end,
            --},
            -- {
            --     "laytan/cloak.nvim",
            --     config = function()
            --         require('cloak').setup({
            --             enabled = true,
            --             cloak_character = '*',
            --             -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
            --             highlight_group = 'Comment',
            --             -- Applies the length of the replacement characters for all matched
            --             -- patterns, defaults to the length of the matched pattern.
            --             cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
            --             -- Wether it should try every pattern to find the best fit or stop after the first.
            --             try_all_patterns = true,
            --             patterns = {
            --                 {
            --                     -- Match any file starting with '.env'.
            --                     -- This can be a table to match multiple file patterns.
            --                     file_pattern = { '.env*', '*.secret' },
            --                     -- Match an equals sign and any character after it.
            --                     -- This can also be a table of patterns to cloak,
            --                     -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
            --                     cloak_pattern = '=.+',
            --                     -- A function, table or string to generate the replacement.
            --                     -- The actual replacement will contain the 'cloak_character'
            --                     -- where it doesn't cover the original text.
            --                     -- If left emtpy the legacy behavior of keeping the first character is retained.
            --                     replace = nil,
            --                 },
            --             },
            --         })
            --     end
            -- },
            {
                "lewis6991/gitsigns.nvim",
                opts = {
                    signs = {
                        add = { text = '+' },
                        change = { text = '~' },
                        delete = { text = '_' },
                        topdelete = { text = '‾' },
                        changedelete = { text = '~' },
                    },
                },
                config = function()
                    require('gitsigns').setup {
                        on_attach = function(bufnr)
                            local gs = package.loaded.gitsigns

                            local function map(mode, l, r, opts)
                                opts = opts or {}
                                opts.buffer = bufnr
                                vim.keymap.set(mode, l, r, opts)
                            end

                            -- Navigation
                            map('n', ']c', function()
                                if vim.wo.diff then return ']c' end
                                vim.schedule(function() gs.next_hunk() end)
                                return '<Ignore>'
                            end, { expr = true })

                            map('n', '[c', function()
                                if vim.wo.diff then return '[c' end
                                vim.schedule(function() gs.prev_hunk() end)
                                return '<Ignore>'
                            end, { expr = true })

                            -- Actions
                            map('n', '<leader>hs', gs.stage_hunk)
                            map('n', '<leader>hr', gs.reset_hunk)
                            map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                            map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                            map('n', '<leader>hS', gs.stage_buffer)
                            map('n', '<leader>hu', gs.undo_stage_hunk)
                            map('n', '<leader>hR', gs.reset_buffer)
                            map('n', '<leader>hp', gs.preview_hunk)
                            map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                            map('n', '<leader>tb', gs.toggle_current_line_blame)
                            map('n', '<leader>hd', gs.diffthis)
                            map('n', '<leader>hD', function() gs.diffthis('~') end)
                            map('n', '<leader>td', gs.toggle_deleted)

                            -- Text object
                            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                        end
                    }
                end
            },
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
                dependencies = {
                    'nvim-lua/plenary.nvim'
                },
                -- event = "VeryLazy",
                config = function()
                    local harpoon = require("harpoon")
                    harpoon:setup({})

                    local conf = require("telescope.config").values
                    local function toggle_telescope(harpoon_files)
                        local file_paths = {}
                        for _, item in ipairs(harpoon_files.items) do
                            table.insert(file_paths, item.value)
                        end

                        require("telescope.pickers").new({}, {
                            prompt_title = "Harpoon",
                            finder = require("telescope.finders").new_table({
                                results = file_paths,
                            }),
                            previewer = conf.file_previewer({}),
                            sorter = conf.generic_sorter({}),
                        }):find()
                    end

                    -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
                    --     { desc = "Open harpoon window" })
                    vim.keymap.set("n", "<leader>th", function() harpoon:list():add() end)
                    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

                    -- vim.reymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
                    -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
                    -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
                    -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
                end
            },


            {
                "neovim/nvim-lspconfig",
                dependencies = {
                    "williamboman/mason.nvim",
                    "williamboman/mason-lspconfig.nvim",
                    'WhoIsSethDaniel/mason-tool-installer.nvim',
                    "onsails/lspkind.nvim",
                    "hrsh7th/cmp-nvim-lsp",
                    { "j-hui/fidget.nvim", opts = {} },
                },
                -- event = "VeryLazy",
                config = function()
                    vim.api.nvim_create_autocmd('LspAttach', {

                        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                        callback = function(event)
                            local map = function(keys, func, desc)
                                vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                            end
                            --map("<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                            map("<leader>vd", vim.diagnostic.open_float, '')
                            map("<leader>vc", vim.lsp.buf.code_action, '')
                            -- map("<leader>vrr", function() vim.lsp.buf.references() end, opts)
                            --map("<leader>vrn", function() vim.lsp.buf.rename() end, opts)

                            -- jump to definition
                            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                            -- Find references for the word under your cursor.
                            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                            -- Jump to the implementation of the word under your cursor.
                            --  Useful when your language has ways of declaring types without an actual implementation.
                            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                            -- Jump to the type of the word under your cursor.
                            --  Useful when you're not sure what type a variable is and you want to see
                            --  the definition of its *type*, not where it was *defined*.
                            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                            -- Fuzzy find all the symbols in your current document.
                            --  Symbols are things like variables, functions, types, etc.
                            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                            -- Fuzzy find all the symbols in your current workspace
                            --  Similar to document symbols, except searches over your whole project.
                            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                                '[W]orkspace [S]ymbols')

                            -- Rename the variable under your cursor
                            --  Most Language Servers support renaming across files, etc.
                            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                            -- Execute a code action, usually your cursor needs to be on top of an error
                            -- or a suggestion from your LSP for this to activate.
                            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                            -- Opens a popup that displays documentation about the word under your cursor
                            --  See `:help K` for why this keymap
                            map('K', vim.lsp.buf.hover, 'Hover Documentation')

                            -- WARN: This is not Goto Definition, this is Goto Declaration.
                            --  For example, in C this would take you to the header
                            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                            -- The following two autocommands are used to highlight references of the
                            -- word under your cursor when your cursor rests there for a little while.
                            --    See `:help CursorHold` for information about when this is executed
                            --
                            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                        end
                    })

                    -- LSP servers and clients are able to communicate to each other what features they support.
                    --  By default, Neovim doesn't support everything that is in the LSP Specification.
                    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
                    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
                    local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
                    local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

                    -- Enable the following language servers
                    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
                    --
                    --  Add any additional override configuration in the following tables. Available keys are:
                    --  - cmd (table): Override the default command used to start the server
                    --  - filetypes (table): Override the default list of associated filetypes for the server
                    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
                    --  - settings (table): Override the default settings passed when initializing the server.
                    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

                    -- Ensure the servers and tools above are installed
                    --  To check the current status of installed tools and/or manually install
                    --  other tools, you can run
                    --    :Mason
                    --
                    --  You can press `g?` for help in this menu
                    require('mason').setup()

                    -- You can add other tools here that you want Mason to install
                    -- for you, so that they are available from within Neovim.
                    local ensure_installed = vim.tbl_keys({})
                    vim.list_extend(ensure_installed, {
                        'stylua', -- Used to format lua code
                    })

                    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
                    require("lspconfig").pylsp.setup({
                        settings = {
                            pylsp = {
                                plugins = {
                                    autopep8 = {
                                        enabled = false
                                    },
                                    flake8 = {
                                        enabled = false,
                                        maxLineLength = 120,
                                        hangClosing = true,
                                        extendIgnore = { "E133" },
                                    },
                                    jedi_completion = {
                                        enabled = true,
                                        fuzzy = true,
                                        eager = true,
                                    },
                                    jedi_definition = {
                                        enabled = true,
                                    },
                                    jedi_symbols = {
                                        enabled = true,
                                    },
                                    pycodestyle = {
                                        enabled = false,
                                        maxLineLength = 120,
                                    },
                                    pydocstyle = {
                                        enabled = false,
                                    },
                                    pylint = {
                                        enabled = true,
                                    },
                                    rope_completion = {
                                        enabled = true,
                                    }
                                }
                            }
                        },
                        capabilities = vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities)
                    })

                    vim.lsp.inlay_hint.enable(true, {})
                    require("lspconfig").rust_analyzer.setup({
                        settings = {
                            ['rust-analyzer'] = {
                            }
                        },
                        capabilities = vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities)
                    })

                    -- require("lspconfig").pyright.setup({
                    --     settings = {
                    --         pyright = {
                    --             pythonPlatform = "Linux",
                    --             disableOrganizeImports = true,
                    --         },
                    --     },
                    --     capabilities = vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities)
                    -- })


                    require("lspconfig").marksman.setup({
                        settings = {
                        },
                        capabilities = vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities)
                    })

                    local on_attach = function(client, bufnr)
                        if client.name == 'ruff' then
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end
                    end

                    require("lspconfig").ruff.setup({
                        -- on_attach = on_attach,
                        -- cmd_env = { RUFF_TRACE = "messages" },
                        -- capabilities = vim.tbl_deep_extend('force', {}, lsp_capabilities, cmp_capabilities),
                        cmd = { "ruff", "server", "--config", "/root/.ruff.toml" },
                        init_options = {
                            settings = {
                                lineLength = 120,
                                lint = {
                                    enable = true,
                                    select = { "E", "F" },
                                    ignore = { "E115", "E501", },
                                }
                            }
                        },
                    })


                    require("lspconfig").lua_ls.setup({
                        capabilities = require('lspconfig').lua_ls.capabilities
                    })
                    -- require('mason-lspconfig').setup {
                    --     handlers = {
                    --         function(server_name)
                    --             local server = servers[server_name] or {}
                    --             -- This handles overriding only values explicitly passed
                    --             -- by the server configuration above. Useful when disabling
                    --             -- certain features of an LSP (for example, turning off formatting for tsserver)
                    --             server.capabilities = vim.tbl_deep_extend('force', server.capabilities or lsp_capabilities,
                    --                 cmp_capabilities)
                    --             require('lspconfig')[server_name].setup(server)
                    --         end,
                    --     },
                    -- }

                    vim.diagnostic.config({ virtual_text = true })
                    -- -- [[ Configure rust-tools ]]
                    -- local rt = require("")
                    -- rt.setup({
                    --     server = {
                    --         on_attach = function(_, bufnr)
                    --             on_attach(_, bufnr) -- This calls the global on_attach
                    --             -- Hhver Actions
                    --             vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                    --             vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    --         end,
                    --     }
                    -- })
                end
            },

            { -- Autocompletion
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
                dependencies = {
                    -- Snippet Engine & its associated nvim-cmp source
                    -- {
                    --     'L3MON4D3/LuaSnip',
                    --     build = (function()
                    --         -- Build Step is needed for regex support in snippets
                    --         -- This step is not supported in many windows environments
                    --         -- Remove the below condition to re-enable on windows
                    --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    --             return
                    --         end
                    --         return 'make install_jsregexp'
                    --     end)(),
                    -- },
                    'L3MON4D3/LuaSnip',
                    'saadparwaiz1/cmp_luasnip',

                    -- Adds other completion capabilities.
                    --  nvim-cmp does not ship with all sources by default. They are split
                    --  into multiple repos for maintenance purposes.
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-path',
                    "hrsh7th/cmp-cmdline",

                    -- If you want to add a bunch of pre-configured snippets,
                    --    you can use this plugin to help you. It even has snippets
                    --    for various frameworks/libraries/etc. but you will have to
                    --    set up the ones that are useful for you.
                    -- 'rafamadriz/friendly-snippets',
                },
                config = function()
                    -- See `:help cmp`
                    local cmp = require 'cmp'
                    local luasnip = require 'luasnip'
                    luasnip.config.setup {}

                    cmp.setup {
                        performance = {
                            throttle = 0,
                            fetching_timeout = 5,
                            max_view_entries = 16,
                        },
                        snippet = {
                            expand = function(args)
                                luasnip.lsp_expand(args.body)
                            end,
                        },
                        completion = { completeopt = 'menu,menuone,noinsert' },

                        -- For an understanding of why these mappings were
                        -- chosen, you will need to read `:help ins-completion`
                        --
                        -- No, but seriously. Please read `:help ins-completion`, it is really good!
                        mapping = cmp.mapping.preset.insert {
                            -- Select the [n]ext item
                            ['<C-n>'] = cmp.mapping.select_next_item(),
                            -- Select the [p]revious item
                            ['<C-p>'] = cmp.mapping.select_prev_item(),
                            -- Accept ([y]es) the completion.
                            ['<C-y>'] = cmp.mapping.confirm { select = true },
                            -- Manually trigger a completion from nvim-cmp.
                            ['<C-Space>'] = cmp.mapping.complete {},
                            -- escape
                            ['<C-e>'] = cmp.mapping.abort(),
                            -- <c-l> will move you to the right of each of the expansion locations.
                            -- <c-h> is similar, except moving you backwards.
                            ['<C-l>'] = cmp.mapping(function()
                                if luasnip.expand_or_locally_jumpable() then
                                    luasnip.expand_or_jump()
                                end
                            end, { 'i', 's' }),
                            ['<C-h>'] = cmp.mapping(function()
                                if luasnip.locally_jumpable(-1) then
                                    luasnip.jump(-1)
                                end
                            end, { 'i', 's' }),
                        },
                        sources = {
                            { name = 'nvim_lsp' },
                            { name = 'luasnip' },
                            { name = 'path' },

                        },
                    }

                    -- `/` cmdline setup.
                    cmp.setup.cmdline('/', {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = 'buffer' }
                        }
                    })

                    -- `:` cmdline setup.
                    cmp.setup.cmdline(':', {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = cmp.config.sources({
                            { name = 'path' },
                            {
                                name = 'cmdline',
                                option = {
                                    ignore_cmds = { 'Man', '!' }
                                }
                            },
                        })
                    })
                end,
            },

            {
                -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
                "nvimtools/none-ls.nvim",
                config = function()
                    local null_ls = require("null-ls")

                    null_ls.setup({
                        default_timeout = 30000,
                        sources = {
                            null_ls.builtins.formatting.yamlfmt,
                            -- null_ls.builtins.formatting.prettierd,
                            -- null_ls.builtins.formatting.black.with({
                            --     extra_args = { "-t", "py36", "-l", "120"},
                            -- }),
                            -- null_ls.builtins.diagnostics.selene,
                            -- null_ls.builtins.completion.spell,
                        }
                    })
                end
            },
            {
                "nvim-telescope/telescope.nvim",
                event = 'VimEnter',
                tag = "0.1.8",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    { 'nvim-telescope/telescope-ui-select.nvim' },


                    -- Useful for getting pretty icons, but requires a Nerd Font.
                    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
                    { -- If encountering errors, see telescope-fzf-native README for install instructions
                        'nvim-telescope/telescope-fzf-native.nvim',

                        -- cond = function()
                        --     return vim.fn.executable 'make' == 1
                        -- end,
                    },
                },
                config = function()
                    require("telescope").setup({
                        extensions = {
                            ['ui-select'] = {
                                require('telescope.themes').get_dropdown(),
                            },
                            fzf = {
                                fuzzy = true,                   -- false will only do exact matching
                                override_generic_sorter = true, -- override the generic sorter
                                override_file_sorter = true,    -- override the file sorter
                                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                            }
                        },
                        pickers = {
                            buffers = {
                                soft_lastused = true,
                                sort_mru = true,
                                ignore_current_buffer = true,
                            }
                        },
                        defaults = {
                            sorting_strategy = "ascending"
                        }
                    })
                    -- Enable telescope extensions, if they are installed
                    pcall(require('telescope').load_extension, 'fzf')
                    pcall(require('telescope').load_extension, 'ui-select')

                    local builtin = require("telescope.builtin")

                    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
                    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
                    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Search [P]roject [F]iles' })
                    -- searches only files tracked by git
                    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
                    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
                    vim.keymap.set('n', '<leader>sww', builtin.grep_string, { desc = '[S]earch current [W]ord' })
                    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
                    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
                    vim.keymap.set('n', '<leader>s.', builtin.oldfiles,
                        { desc = '[S]earch Recent Files ("." for repeat)' })
                    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
                    -- searches all available commands that can be summoned by `:`
                    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [c]ommands" })

                    vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
                    vim.keymap.set("n", "<leader>/c", builtin.git_bcommits, {})
                    vim.keymap.set("n", "<leader>gs", builtin.git_stash, {})
                    vim.keymap.set("n", "<leader>gS", builtin.git_status, {})

                    vim.keymap.set("n", "<leader>swg", function()
                        builtin.live_grep {
                            search_dirs = {
                                "/home/tron/repos/jakaa/npm",
                            },
                            type_filter = "js",
                            max_results = 300
                        }
                    end, { desc = "[S]earch NPM grep", })

                    vim.keymap.set("n", "<leader>swG", function()
                        builtin.live_grep {
                            search_dirs = {
                                "/home/tron/repos/jakaa/npm",
                            },
                        }
                    end, { desc = "[S]earch NPM grep", })

                    vim.keymap.set("n", "<leader>swf", function()
                        builtin.find_files {
                            search_dirs = {
                                "/home/tron/repos/jakaa/npm",
                            }
                        }
                    end, { desc = "[S]earch [W]ebapp [F]iles", })

                    vim.keymap.set("n", "<leader>sjf", function()
                        builtin.find_files {
                            search_dirs = {
                                "/home/tron/repos/jakaa/jakaa",
                            }
                        }
                    end, { desc = "[S]earch [J]akaa [F]iles", })

                    vim.keymap.set("n", "<leader>kd", function()
                        builtin.fd {
                            search_dirs = {
                                "/home/tron/repos/dev-platform/ediphy-dev",
                            },
                            max_results = 300
                        }
                    end, { desc = "Search [Dev] Kube", })

                    vim.keymap.set("n", "<leader>kp", function()
                        builtin.fd {
                            search_dirs = {
                                "/home/tron/repos/ediphy-k8s-platforms",
                            },
                            max_results = 300
                        }
                    end, { desc = "Search [PROD] Kube", })

                    -- Slightly advanced example of overriding default behavior and theme
                    vim.keymap.set('n', '<leader>//', function()
                        -- You can pass additional configuration to telescope to change theme, layout, etc.
                        builtin.current_buffer_fuzzy_find()
                    end, { desc = '[/] Fuzzily search in current buffer' })

                    -- Search documentation
                    vim.keymap.set('n', '<leader>swh', function()
                        -- You can pass additional configuration to telescope to change theme, layout, etc.
                        builtin.find_files({
                            search_dirs = {
                                "/home/tron/repos/jakaa/jakaa/scratch/avasile/docs/",
                                "/home/tron/repos/jakaa/jakaa/scratch/docsify/docs/",
                            }
                        })
                    end, { desc = '[swd] Search workspace documentation' })

                    -- Also possible to pass additional configuration options.
                    --  See `:help telescope.builtin.live_grep()` for information about particular keys
                    vim.keymap.set('n', '<leader>s/', function()
                        if vim.fn.getcwd() ~= "/root/xonsh_env" then
                            builtin.live_grep {
                                grep_open_files = false,
                                prompt_title = 'Live Grep in Workspace',
                                max_results = 100,
                            }
                        else
                            builtin.live_grep {
                                grep_open_files = false,
                                prompt_title = 'Live Grep in Xonsh',
                                max_results = 100,
                                additional_args = {
                                    "--no-ignore-vcs"
                                }
                            }
                        end
                    end, { desc = '[S]earch [/]' })

                    -- -- Shortcut for searching your neovim configuration files
                    -- vim.keymap.set('n', '<leader>sn', function()
                    --     builtin.find_files { cwd = "/home/tron/.config/nvim-bak" }
                    -- end, { desc = '[S]earch [N]eovim files' })
                end
            }, {
            "nvim-treesitter/nvim-treesitter",
            tag = "v0.9.2",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "c",
                        "lua",
                        "rust",
                        "bash",
                        "diff",
                        "html",
                        "javascript",
                        "jsdoc",
                        "json",
                        "jsonc",
                        "luadoc",
                        "luap",
                        -- "markdown",
                        -- "markdown_inline",
                        "python",
                        -- "query",
                        -- "regex",
                        -- "toml",
                        -- "tsx",
                        -- "typescript",
                        "vim",
                        "vimdoc",
                        "yaml",
                    },

                    auto_install = false,

                    highlight = {
                        enable = true,
                    },

                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = 'gnn',
                            node_incremental = 'grn',
                            scope_incrementml = 'grc',
                            node_decremental = 'grm',
                        },
                    },
                })
            end
        }

        })
end


-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


vim_opts()
lazy_fn()

require("rose-pine").setup({
    variant = "auto",      -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true,        -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.cmd("colorscheme rose-pine")
