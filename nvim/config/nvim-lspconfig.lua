require'lspconfig'.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  on_attach = function(client, bufnr)
	print 'Attached to Solargraph'
  end
}
