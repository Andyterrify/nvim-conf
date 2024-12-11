vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  spec = {
    { import = "andyterrify.packages" },
  },
  local_spec = false, -- project specific .lazy.lua will be added at the end
  install = {
    missing = true,   -- stop auto install missing on open
    colorscheme = { "gruvbox" }
  },
  checker = { enabled = false },
  change_detection = { enabled = false }, -- no reason
  pkg = { enabled = false },              -- some other package thing
  rocks = { enabled = false },
  performance = {
    cache = { enabled = true },
    disabled_plugins = {
      "tutor"
    },
  },
})
