return {
	{ -- fugitive
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>go", ":Git<CR>" },
		},
	},
	{ -- intuitive GIT interactivity
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr) -- gets called on buffer attach
					local gs = package.loaded.gitsigns
					local bnmapd = require("avasile.utils").bnmapd

					-- Navigation
					bnmapd("]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, "Next Chunk", bufnr)

					bnmapd("[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, "Prev chunk", bufnr)

					-- Actions
					bnmapd("<leader>hs", gs.stage_hunk, "Stage Chunk", bufnr)
					bnmapd("<leader>hr", gs.reset_hunk, "Reset Chunk", bufnr)

					vim.keymap.set("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage Selection", buffer = bufnr })

					vim.keymap.set("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset Selection", buffer = bufnr })

					bnmapd("<leader>hS", gs.stage_buffer, "Stage Buffer", bufnr)
					bnmapd("<leader>hu", gs.undo_stage_hunk, "Undo Stage Chunk", bufnr)
					bnmapd("<leader>hR", gs.reset_buffer, "Reset Buffer", bufnr)
					bnmapd("<leader>hp", gs.preview_hunk, "Preview Chunk", bufnr)
					bnmapd("<leader>hb", function()
						gs.blame_line({ full = true })
					end, "View Blame", bufnr)
					bnmapd("<leader>tb", gs.toggle_current_line_blame, "Toggle Line Blame", bufnr)
					-- bnmapd("<leader>hd", gs.diffthis, "Git Diff This", bufnr)
					-- bnmapd("<leader>hD", function() gs.diffthis("~") end, "", bufnr)
					bnmapd("<leader>td", gs.toggle_deleted, "Toggle Git Deleted", bufnr)

					-- Text object
					vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
}
