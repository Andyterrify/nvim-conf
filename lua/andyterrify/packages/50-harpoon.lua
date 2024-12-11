return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})
    -- add a file to harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    -- quick list view harpoon
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
  end
}
