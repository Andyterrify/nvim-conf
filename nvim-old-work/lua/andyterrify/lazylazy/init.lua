-- standard plugins to always have

return {
    -- Just in case
    -- 'tpope/vim-sleuth',
    -- Lazy

    {
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight-night]])
        end
    },

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

    -- {
    --   'jinh0/eyeliner.nvim',
    --   -- event = "InsertEnter",
    --   config = function()
    --     require 'eyeliner'.setup {
    --       highlight_on_key = true, -- show highlights only after keypress
    --       dim = true               -- dim all other characters if set to true (recommended!)
    --     }
    --   end
    -- },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {                   -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            -- Document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
        end,
    },

    -- {
    --     "epwalsh/obsidian.nvim",
    --     version = "*", -- recommended, use latest release instead of latest commit
    --     -- lazy = true,
    --     -- ft = "markdown",
    --     -- event = "VeryLazy",
    --     -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    --     -- event = {
    --     --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --     --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --     --   "BufReadPre /home/avasile/Documents/obsidian/personal-vault/**.md",
    --     --   "BufNewFile /home/avasile/Documents/Obsidian/General Vault/**.md",
    --     -- },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         -- "hrsh7th/nvim-cmp",
    --     },
    --     opts = {
    --         workspaces = {
    --             {
    --                 name = "personal",
    --                 path = "/home/avasile/Documents/obsidian/personal-vault",
    --             }
    --         },
    --         notes_subdir = "notes",

    --         -- copletion = {
    --         --   nvim_cmp = true,
    --         --   min_chars = 2,
    --         --   new_notes_location = "notes_subdir"
    --         -- }
    --     }
    -- },

    -- {
    --     'Bekaboo/dropbar.nvim',
    --     -- optional, but required for fuzzy finder support
    --     dependencies = {
    --         'nvim-telescope/telescope-fzf-native.nvim'
    --     },
    --     keys = {
    --         { "<leader>.", function() require("dropbar.api").pick() end, {} }
    --     },
    --     config = function()
    --         require("dropbar").setup()
    --     end
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
    --   "folke/flash.nvim",
    --   event = "VeryLazy",
    --   ---@type Flash.Config
    --   opts = {},
    --   -- stylua: ignore
    --   keys = {
    --     -- { "<c-s>", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
    --     { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    --     { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
    --   },
    -- },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require "ibl.hooks"
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require("ibl").setup { scope = { highlight = highlight } }

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end
    },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    }
}
