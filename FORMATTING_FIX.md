# Formatting Fix - Why `<leader>f` Wasn't Working

## The Problem

You had **TWO competing formatters** trying to bind the same key:

### Before the Fix

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Neovim starts, plugins load                              │
│    conform.nvim sets: <leader>f → conform.format() (global) │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Open a file with LSP (e.g., main.go)                     │
│    gopls attaches                                            │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. LspAttach autocmd fires                                  │
│    LSP keymaps sets: <leader>f → vim.lsp.buf.format()       │
│    (buffer-local, OVERWRITES conform!)                      │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. You press <leader>f                                      │
│    ❌ LSP formatting runs (not conform!)                     │
│    ❌ Might fail or behave unexpectedly                      │
│    ❌ Your goimports/prettier config ignored                 │
└─────────────────────────────────────────────────────────────┘
```

### Why It Failed Sometimes

The LSP formatting (`vim.lsp.buf.format()`) might fail because:
1. Server doesn't support formatting for that filetype
2. No LSP server attached yet
3. Timeout issues
4. Server configuration issues

Meanwhile, you had carefully configured **conform.nvim** with:
- Go: `goimports` → `gofmt`
- JavaScript: `prettierd` → `prettier`
- Python: `isort` → `black`
- etc.

**But conform never ran** because the LSP keymap overwrote it!

## The Fix

### After the Fix

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Neovim starts, plugins load                              │
│    conform.nvim sets: <leader>f → conform.format() (global) │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Open a file with LSP (e.g., main.go)                     │
│    gopls attaches                                            │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. LspAttach autocmd fires                                  │
│    LSP keymaps: SKIPS formatting (commented out)            │
│    conform.nvim keymap remains active ✓                     │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. You press <leader>f                                      │
│    ✓ conform.format() runs                                  │
│    ✓ Uses your configured formatters                        │
│    ✓ Falls back to LSP if no formatter available            │
└─────────────────────────────────────────────────────────────┘
```

## Changes Made

### 1. Removed LSP Formatting Keymaps
**File:** `lua/avasile/plugins/lsp/keymaps.lua`

```lua
-- BEFORE (caused conflict):
if caps.documentFormattingProvider then
  map("n", "<leader>f", vim.lsp.buf.format, "Format Document")
end

-- AFTER (removed):
-- NOTE: Formatting is handled by conform.nvim (see plugins/conform.lua)
-- We don't set LSP formatting keymaps here to avoid conflicts
```

### 2. Enhanced conform.nvim Keymap
**File:** `lua/avasile/plugins/conform.lua`

```lua
-- BEFORE (only normal mode, no options):
vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end)

-- AFTER (normal + visual, with fallback and timeout):
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({
    lsp_format = "fallback",   -- Use LSP if no formatter available
    async = false,              -- Wait for completion
    timeout_ms = 500,           -- Don't hang forever
  })
end, { desc = "Format buffer" })
```

## How It Works Now

### Normal Mode: `<leader>f`

```lua
-- In a Go file:
1. conform checks: "Do I have formatters for 'go'?"
2. Yes! Run: goimports → gofmt
3. Done ✓

-- In a Rust file:
1. conform checks: "Do I have formatters for 'rust'?"
2. Yes! Run: rustfmt
3. If rustfmt fails, fallback to LSP (rust-analyzer)
4. Done ✓

-- In a random file type with no formatters:
1. conform checks: "Do I have formatters for this?"
2. No! Use lsp_format = "fallback"
3. Calls vim.lsp.buf.format() as fallback
4. Done ✓
```

### Visual Mode: `<leader>f`

```lua
-- Select some lines in visual mode, press <leader>f
1. conform formats only the selected range
2. Uses same formatters as normal mode
3. Works with gofmt, prettier, black, etc.
```

## Why This Is Better

### ✅ Consistent Behavior
- `<leader>f` always uses conform.nvim
- No conflicts, no overwrites
- Predictable formatting

### ✅ Your Configuration Respected
- Uses goimports + gofmt for Go
- Uses prettier for JavaScript/TypeScript
- Uses your exact formatter chain

### ✅ Smart Fallback
- If no formatter configured, falls back to LSP
- Best of both worlds
- No manual intervention needed

### ✅ Visual Mode Support
- Format selection works now
- Range formatting support
- Consistent with normal mode

## Testing the Fix

### 1. Restart Neovim
```bash
nvim
```

### 2. Open a Go file
```go
// test.go
package main
import "fmt"
func main(){fmt.Println("hello")}
```

### 3. Press `<leader>f`
```go
// Should format to:
package main

import "fmt"

func main() {
	fmt.Println("hello")
}
```

### 4. Check which formatter ran
```vim
:messages
" Should see conform.nvim messages, not LSP
```

### 5. Test visual mode
```go
// Select these lines in visual mode:
func main(){
fmt.Println("hello")
}

// Press <leader>f in visual mode
// Should format just the selection
```

## Debugging Formatting Issues

### If formatting still doesn't work:

1. **Check if formatter is installed:**
```bash
which gofmt
which goimports
which prettier
which black
```

2. **Check conform.nvim status:**
```vim
:ConformInfo
" Shows available formatters for current filetype
```

3. **Try formatting manually:**
```vim
:lua require("conform").format({ lsp_format = "fallback" })
```

4. **Check for errors:**
```vim
:messages
```

5. **Verify keymap is set:**
```vim
:nmap <leader>f
" Should show: Format buffer
```

## Common Issues Resolved

### ❌ Before: "Formatting randomly works/fails"
- **Cause:** LSP formatting conflicted with conform
- **Fixed:** Only conform.nvim handles formatting now

### ❌ Before: "goimports doesn't run"
- **Cause:** LSP formatting used instead of conform
- **Fixed:** conform runs goimports → gofmt chain

### ❌ Before: "Visual mode formatting doesn't work"
- **Cause:** LSP keymap only set for normal mode
- **Fixed:** conform keymap works in both n and v modes

### ❌ Before: "Have to manually run :lua vim.lsp.buf.format()"
- **Cause:** Keymap conflict, wrong formatter running
- **Fixed:** Keymap always uses conform with LSP fallback

## Summary

**The issue:** LSP formatting keymaps were overwriting conform.nvim keymaps in buffers with LSP servers attached.

**The fix:** Removed LSP formatting keymaps, letting conform.nvim handle all formatting with LSP as a fallback.

**The result:** Consistent, reliable formatting using your configured formatters (goimports, prettier, etc.) with automatic LSP fallback when needed.

Your formatting should work reliably now! 🎉
