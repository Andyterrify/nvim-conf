
--
-- Neovim config ~July 2025
--

-- default config, this is the required
require("avasile.init")

-- work config (if existent only)
pcall(require, "work.init")
