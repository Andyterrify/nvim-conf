return {
  -- colour scheme
  -- love gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true
    },
    config = function()
      vim.o.background = "dark"       -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end
  },
}
