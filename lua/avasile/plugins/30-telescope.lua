return {
	-- FZF native for better performance
	{ 'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make' 
	},
	{
		-- requires telescope-fzf-native
		-- recommends fd binary
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		-- gets passed to setup
		opts = {
				extensions = {
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
			},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			-- Load extensions
			local ok, result_or_err = pcall(telescope.load_extension, "fzf")
			if not ok then
				vim.notify("Failed to load telescope-fzf-native, did it setup correctly?", vim.log.levels.WARN)
			end
			
			-- keybinds
			local nmapd = require("avasile.utils").nmapd
			nmapd("<leader>pf", builtin.find_files, "Search [P]roject [F]iles")
			nmapd("<C-p>", builtin.git_files, "Search Git Files")
			nmapd("<leader><leader>", builtin.buffers, "[ ][ ] search open buffers")
			nmapd("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
			nmapd("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
			nmapd("<leader>sb", builtin.builtin, "[S]earch [B]uiltin Telescope")
			nmapd("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
			nmapd("<leader>sr", builtin.resume, "[S]earch [R]esume")
			nmapd("<leader>sc", builtin.commands, "[S]earch [C]ommands")
			nmapd("<leader>sn", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, "[S]earch [N]eovim files")

			-- Fuzzy search in current buffer
			nmapd("<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, "[/] Fuzzily search in current buffer")

			-- Live grep in CWD
			nmapd("<leader>s/", function()
				builtin.live_grep({
					grep_open_files = false,
					prompt_title = "Live grep in cwd",
				})
			end, "Grep CWD")

			-- setup fidget integration 
			require("telescope").load_extension("fidget")
		end,
	},
}
