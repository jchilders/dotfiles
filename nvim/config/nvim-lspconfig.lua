require'lspconfig'.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  on_attach = function(client, bufnr)
    require'completion'.on_attach()
	print 'Attached to Solargraph'
  end
}
