return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			-- Setup Telescope
			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				pickers = {
					buffers = {
						soft_lastused = true,
						sort_mru = true,
						ignore_current_buffer = true,
					},
					find_files = {
						hidden = false,
					},
				},
				defaults = {
					layout_config = {
						vertical = {
							width = 0.8,
							height = 0.98,
							preview_height = 0.45,
							mirror = true,
						},
					},
					sorting_strategy = "ascending",
				},
			})

			-- Load extensions
			pcall(telescope.load_extension, "fzf")

			-- Keymaps
			local nmap = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = desc })
			end

			nmap("<leader>pf", builtin.find_files, "Search [P]roject [F]iles")
			nmap("<C-p>", builtin.git_files, "Search Git Files")
			nmap("<leader><leader>", builtin.buffers, "[ ][ ] search open buffers")
			nmap("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
			nmap("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
			nmap("<leader>sb", builtin.builtin, "[S]earch [B]uiltin Telescope")
			nmap("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
			nmap("<leader>sr", builtin.resume, "[S]earch [R]esume")
			nmap("<leader>sc", builtin.commands, "[S]earch [C]ommands")
			nmap("<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, "[S]earch [N]eovim files")

			-- Fuzzy search in current buffer
			nmap("<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, "[/] Fuzzily search in current buffer")

			-- Live grep in CWD
			nmap("<leader>s/", function()
				builtin.live_grep({
					grep_open_files = false,
					prompt_title = "Live grep in cwd",
				})
			end, "Grep CWD")
		end,
	},

	-- FZF native for better performance
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}
