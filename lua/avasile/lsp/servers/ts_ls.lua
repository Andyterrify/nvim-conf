return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	root_dir = function(fname)
		return vim.fs.root(fname, { "package.json", "tsconfig.json", "jsconfig.json", ".git" })
	end,
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = "/home/avasile/projects/silver-v003/node_modules/@vue/language-server",
				languages = { "vue" },
			},
		},
	},
}
