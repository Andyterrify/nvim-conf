return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	root_dir = function(fname)
		return vim.fs.root(fname, { "tailwind.config.js", "tailwind.config.ts", ".git" })
	end,
}
