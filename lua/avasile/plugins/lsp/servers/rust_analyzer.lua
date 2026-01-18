return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = function(fname)
		return vim.fs.root(fname, { "Cargo.toml", ".git" })
	end,
}
