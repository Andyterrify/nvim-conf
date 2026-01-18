# Multiple LSP Servers on Same Buffer

## Does Your Current Setup Work?

**Short answer: Yes, mostly! But there are edge cases.**

## What Actually Happens

### Scenario: TypeScript + Tailwind CSS on same buffer

```
1. Open file.tsx
2. ts_ls attaches → LspAttach fires
   → keymaps.setup(ts_ls, bufnr) runs
   → Sets: K, gd, gr, gi, <leader>rn, <leader>ca, etc.

3. tailwindcss attaches → LspAttach fires AGAIN
   → keymaps.setup(tailwindcss, bufnr) runs
   → Sets: K (overwrites!), maybe <leader>ca
   → Doesn't set: gd, gr (tailwind doesn't have these)
```

### The Good News

**Most LSP functions query ALL attached servers:**

```lua
-- When you press K (hover):
vim.lsp.buf.hover()
  → Queries ts_ls: "Do you have hover info?"
  → Queries tailwindcss: "Do you have hover info?"
  → Shows combined results!

-- When you press gd (definition):
vim.lsp.buf.definition()
  → Queries ts_ls: "Where is this defined?"
  → Queries tailwindcss: "Where is this defined?"
  → Shows results from whoever responds
```

So even though keymaps get overwritten, **they all call the same functions that query all servers**.

### The Bad News (Edge Cases)

**Problem 1: Last server wins**
```lua
-- ts_ls attaches first
if ts_ls.server_capabilities.hoverProvider then
  map("K", vim.lsp.buf.hover, "Hover Documentation")
end

-- tailwindcss attaches second
if tailwindcss.server_capabilities.hoverProvider then
  map("K", vim.lsp.buf.hover, "Hover Documentation")  -- OVERWRITES
end
```

The keymap gets set twice with the same function, so it works... but it's wasteful.

**Problem 2: Description changes**
```lua
-- ts_ls might set:
map("K", vim.lsp.buf.hover, "Hover Documentation")

-- tailwindcss overwrites with:
map("K", vim.lsp.buf.hover, "Hover Documentation")  -- Same desc

-- But if descriptions were different:
-- Which description shows in which-key? Last one wins.
```

**Problem 3: Server-specific actions**

What if you wanted:
- `K` → Show hover from ALL servers (current behavior)
- `<leader>K` → Show hover from ONLY ts_ls

Current setup doesn't support this.

## Solutions

### Solution 1: Set Keymaps Once (Recommended)

Only set keymaps when the FIRST server attaches:

```lua
-- In keymaps.lua
M.setup = function(client, bufnr)
	-- Check if keymaps already set for this buffer
	local already_setup = vim.b[bufnr].lsp_keymaps_setup

	if already_setup then
		-- Don't set keymaps again
		return
	end

	-- Mark as setup
	vim.b[bufnr].lsp_keymaps_setup = true

	-- Collect capabilities from ALL attached servers
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local has_capability = function(cap)
		for _, c in ipairs(clients) do
			if c.server_capabilities[cap] then
				return true
			end
		end
		return false
	end

	-- Now set keymaps based on ANY server having the capability
	if has_capability("hoverProvider") then
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	end

	if has_capability("definitionProvider") then
		map("n", "gd", require("telescope.builtin").lsp_definitions, "Go to Definition")
	end

	-- ... etc
end
```

**Pros:**
- Keymaps set exactly once
- No overwrites
- More efficient

**Cons:**
- If second server attaches LATER and has NEW capabilities, keymaps won't be added
- More complex logic

### Solution 2: Idempotent Keymaps (Simpler)

Just accept that keymaps get set multiple times, but ensure they're identical:

```lua
-- Current implementation already does this!
-- vim.lsp.buf.hover is the same regardless of which server set it
```

**Pros:**
- Simple
- Works in practice
- No complexity

**Cons:**
- Wasteful (sets keymaps multiple times)
- Descriptions might change

### Solution 3: Server-Specific Keymaps (Advanced)

Different keymaps for different servers:

```lua
M.setup = function(client, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	-- Generic keymaps (query all servers)
	local caps = client.server_capabilities

	if caps.hoverProvider then
		-- This queries ALL servers
		map("n", "K", vim.lsp.buf.hover, "Hover (all servers)")
	end

	-- Server-specific keymaps
	if client.name == "ts_ls" then
		map("n", "<leader>Kt", function()
			-- Only query TypeScript server
			vim.lsp.buf_request(bufnr, "textDocument/hover",
				vim.lsp.util.make_position_params(),
				function(err, result, ctx, config)
					-- Custom handler for ts_ls only
				end
			)
		end, "Hover (TypeScript only)")
	end

	if client.name == "tailwindcss" then
		map("n", "<leader>Kc", function()
			-- Only query Tailwind
		end, "Hover (Tailwind only)")
	end
end
```

**Pros:**
- Fine-grained control
- Can have server-specific behavior

**Cons:**
- Complex
- Rarely needed
- Lots of boilerplate

## Real-World Example

### Your Vue + TypeScript + Tailwind Setup

```lua
-- File: App.vue
-- Servers that attach:
-- 1. ts_ls (TypeScript/JavaScript/Vue)
-- 2. tailwindcss (CSS utilities)

-- Both have hoverProvider
-- ts_ls has: definition, references, rename, etc.
-- tailwindcss has: hover, completion (limited)

-- What happens:
-- 1. ts_ls attaches
--    → Sets: K, gd, gr, gi, <leader>rn, <leader>ca, etc.

-- 2. tailwindcss attaches
--    → Sets: K (overwrites, but same function)
--    → Doesn't set: gd, gr (doesn't have capability)

-- When you press K on "bg-red-500":
--    → vim.lsp.buf.hover() queries BOTH
--    → ts_ls: "No info for this CSS class"
--    → tailwindcss: "background-color: rgb(239 68 68)"
--    → Shows tailwind's info ✓

-- When you press K on "useState":
--    → vim.lsp.buf.hover() queries BOTH
--    → ts_ls: "Hook to manage state in React..."
--    → tailwindcss: "No info"
--    → Shows TypeScript's info ✓

-- When you press gd on "useState":
--    → vim.lsp.buf.definition() queries BOTH
--    → ts_ls: "node_modules/react/index.d.ts:123"
--    → tailwindcss: (doesn't respond, no definitionProvider)
--    → Jumps to definition ✓
```

**Everything just works!** 🎉

## Potential Issues

### Issue 1: Formatting Conflicts

```lua
-- Both ts_ls and some other formatter might provide formatting
if caps.documentFormattingProvider then
	map("n", "<leader>f", vim.lsp.buf.format, "Format")
end

-- Problem: vim.lsp.buf.format() will use ALL formatters!
-- Solution: Use conform.nvim (you already do) or specify which:
vim.lsp.buf.format({
	filter = function(client)
		return client.name == "ts_ls"  -- Only use TypeScript formatter
	end
})
```

### Issue 2: Code Actions Spam

```lua
-- Multiple servers might provide code actions
-- vim.lsp.buf.code_action() shows ALL of them
-- This is usually good, but can be overwhelming
```

### Issue 3: Duplicate Completions

```lua
-- If multiple servers provide completion for same items
-- You might see duplicates in completion menu
-- nvim-cmp handles this by deduplicating, so usually fine
```

## Recommended Approach

**Use Solution 2 (current implementation)** because:

1. **It's simple** - No complex logic
2. **It works** - vim.lsp.buf.* functions are smart
3. **It's standard** - Most Neovim configs do this
4. **It's flexible** - You can always add server-specific logic later

**When to use Solution 1:**
- You attach many servers (5+) and want efficiency
- You need precise control over which capabilities are available

**When to use Solution 3:**
- You need server-specific behavior
- You're building a plugin
- You want different keymaps for different servers

## Testing Your Setup

```lua
-- Open a Vue file with multiple servers
:e App.vue

-- Check which servers attached
:LspInfo

-- Check keymaps (which-key)
:WhichKey

-- Test hover on different things
-- Hover on "bg-red-500" → Should show Tailwind info
-- Hover on "useState" → Should show TypeScript info

-- Test definition
-- gd on a component → Should jump to definition (ts_ls)
-- gd on "bg-red-500" → Might not work (tailwind doesn't provide)
```

## The Bottom Line

**Your current setup works correctly!** The keymaps get overwritten, but they all use the same `vim.lsp.buf.*` functions that intelligently query all servers. This is the standard and recommended approach.

The only time you'd need a more complex solution is for advanced use cases like:
- Server-specific keymaps
- Excluding certain servers from certain actions
- Very precise control over server behavior

For 99% of use cases, what you have is perfect! 👍
