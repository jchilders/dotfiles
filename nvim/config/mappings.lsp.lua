local keymaps = {
  { 'gd', '<cmd>lua vim.lsp.buf.definition()' },
  { 'K', '<cmd>lua require(\'lspsaga.hover\').render_hover_doc()' },
  { '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()' },
  { '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()' },
  { '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))' },
  { '<leader>rn', '<cmd>lua vim.lsp.buf.rename()' },
  { 'gr', '<cmd>lua vim.lsp.buf.references()' },
  { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()' },
  { '<leader>sit', '<cmd>Telescope treesitter' },

  { '<leader>e', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()" },
  { '<leader>[[', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()" },
  { '<leader>]]', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()" },

  -- <leader>ccs - change (rename) current symbol
  { '<leader>ccs', "<cmd>lua require('lspsaga.rename').rename()" },

  -- Format current document
  { '<leader>fmt', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)' },

  -- Show attached LSP clients for current buffer
  { '<leader>lc', '<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))' },
}

require("utils").set_mappings(keymaps)
