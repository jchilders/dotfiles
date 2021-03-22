
vim.api.nvim_exec([[
  sign define LspDiagnosticsSignInformation text=!
]], false)

require'lspconfig'.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby", "eruby" },
  on_attach = function(client, bufnr)
    require'completion'.on_attach()
    print 'Attached to Solargraph LSP'
  end,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text on file load
        -- Show with vim.lsp.diagnostic.show_line_diagnostics()
        virtual_text = false
      }
    ),
  }
}
