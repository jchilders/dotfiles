require'lspconfig'.solargraph.setup {
	on_attach = require'completion'.on_attach,
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby" }
}
