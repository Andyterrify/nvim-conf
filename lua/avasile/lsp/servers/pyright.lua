return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(fname)
		return vim.fs.root(fname, {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		})
	end,
}
