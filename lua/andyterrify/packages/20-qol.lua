return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "j-hui/fidget.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
    }
  },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "mbbill/undotree",
    -- keys = {
    --     { "<leader>tt", ":UndotreeToggle<cr>", desc = "Toggle Undo Tree" }
    -- }
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        -- theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
}
