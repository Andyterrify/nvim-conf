return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "neovim/nvim-lspconfig",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    "onsails/lspkind.nvim",
  },
  config = function()
    -- See `:help cmp`
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup {
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',               -- show only symbol annotations
          maxwidth = 50,                      -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...',                  -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true,               -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(entry, vim_item)
            return vim_item
          end
        })
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- read docs
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        -- read docs
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Accept ([y]es) the completion.
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        -- escape
        ['<C-e>'] = cmp.mapping.abort(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
      }),
    }

    -- `/` cmdline setup.
    cmp.setup.cmdline({ '/', '?' }, {
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
}
