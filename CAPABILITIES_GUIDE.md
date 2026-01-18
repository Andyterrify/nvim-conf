# LSP Capabilities Guide

## Quick Answer to Your Questions

### Is capability checking needed?
**Yes, but only to decide whether to set up the keymap at all.**

- ✅ **GOOD**: Only set keymap if capability exists
- ❌ **BAD**: Set keymap anyway but show error message when used

### How do capabilities work?

```
     NEOVIM                        LSP SERVER
        │                              │
        │  1. "Here's what I support"  │
        │────────────────────────────>│
        │    (client_capabilities)     │
        │                              │
        │  2. "Here's what I provide"  │
        │<────────────────────────────│
        │   (server_capabilities)      │
        │                              │
        │  3. Set up keymaps based on  │
        │     what server provides     │
        └──────────────────────────────┘
```

## The Two Types of Capabilities

### 1. Client Capabilities (Neovim → Server)
**"Here's what Neovim can do"**

```lua
-- Created by Neovim:
local base_capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enhanced by nvim-cmp:
local enhanced = require("cmp_nvim_lsp").default_capabilities()

-- What's being added?
{
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,        -- "I can handle snippets"
        resolveSupport = { ... },     -- "I can resolve details"
        labelDetailsSupport = true,   -- "I can show extra info"
      }
    },
    hover = {
      contentFormat = { "markdown", "plaintext" }  -- "I can render markdown"
    }
  }
}
```

**Why enhance with nvim-cmp?**
- Tells servers: "I support snippet completion"
- Tells servers: "I can show detailed completion info"
- Without this, servers might send simpler completions

### 2. Server Capabilities (Server → Neovim)
**"Here's what the LSP server can do"**

```lua
-- What lua_ls might send back:
{
  hoverProvider = true,
  definitionProvider = true,
  renameProvider = true,
  completionProvider = {
    triggerCharacters = { ".", ":" },
    resolveProvider = true
  },
  inlayHintProvider = {
    resolveProvider = true
  }
}

-- What a simpler server might send:
{
  hoverProvider = true,
  definitionProvider = true,
  -- No rename, no inlay hints, etc.
}
```

## Real Example Flow

### gopls (Go Language Server)

```lua
-- 1. You configure gopls in your config:
{
  settings = {
    gopls = {
      hints = {                     -- You REQUEST these features
        assignVariableTypes = true,
        parameterNames = true,
      }
    }
  }
}

-- 2. Neovim sends client_capabilities:
{
  textDocument = {
    inlayHint = {                   -- "I support showing inlay hints"
      dynamicRegistration = true,
      resolveSupport = { ... }
    }
  }
}

-- 3. gopls responds with server_capabilities:
{
  inlayHintProvider = {             -- "I can provide them!"
    resolveProvider = true
  },
  hoverProvider = true,
  definitionProvider = true,
  -- ... etc
}

-- 4. Your keymaps.lua checks:
if client.server_capabilities.inlayHintProvider then
  -- Set up <leader>th to toggle hints ✅
end
```

## Why Each Server is Different

Different servers have different capabilities based on:

1. **Language features**
   - Python doesn't have "go to implementation" (not a compiled language)
   - TypeScript has type definitions, Lua doesn't

2. **Server maturity**
   - rust-analyzer: Very mature, tons of features
   - Some servers: Basic hover + definition only

3. **Configuration**
   - You can ENABLE features in server settings
   - But server must SUPPORT them first

## Debugging Capabilities

### See what a server supports:
```lua
:lua require("avasile.plugins.lsp.keymaps").show_capabilities()
```

### Or manually inspect:
```lua
:lua vim.print(vim.lsp.get_clients()[1].server_capabilities)
```

### See what Neovim sends:
```lua
:lua vim.print(vim.lsp.protocol.make_client_capabilities())
:lua vim.print(require("cmp_nvim_lsp").default_capabilities())
```

## Common Capability Patterns

### Boolean capabilities:
```lua
hoverProvider = true          -- Simple: yes or no
```

### Object capabilities:
```lua
completionProvider = {        -- Complex: yes with options
  triggerCharacters = { ".", ":" },
  resolveProvider = true
}
```

### Checking both:
```lua
if caps.completionProvider then
  -- Works for both true and { ... }
  -- Because { ... } is truthy in Lua
end
```

## Your New Setup

**Before (❌ Problem)**:
```lua
-- Set ALL keymaps, show error if not supported
if not caps.hoverProvider then
  map("K", function() vim.notify("Not supported!") end)
end
-- This wastes the K key!
```

**After (✅ Better)**:
```lua
-- Only set keymap if supported
if caps.hoverProvider then
  map("K", vim.lsp.buf.hover)
end
-- If not supported, K remains unbound (available for other uses)
```

## Testing Your Setup

1. Open a Go file:
```bash
nvim test.go
```

2. Check what's available:
```vim
:lua require("avasile.plugins.lsp.keymaps").show_capabilities()
```

3. Try keymaps:
- `K` - Hover (should work if hoverProvider exists)
- `gd` - Go to definition (should work if definitionProvider exists)
- `<leader>th` - Toggle inlay hints (should always work, it's a Neovim feature)

4. Compare different servers:
```bash
nvim test.lua    # lua_ls capabilities
nvim test.go     # gopls capabilities
nvim test.py     # pyright capabilities
```

Each will have different keymaps based on what the server supports!
