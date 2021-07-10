local map = require('cartographer')

-- `:unmap` 'zfo' in `x` mode
-- map.x['zfo'] = nil

map.n.nore.silent['gd'] = '<cmd>lua vim.lsp.buf.definition()<CR>'
map.n.nore.silent['K'] = '<cmd>lua require(\'lspsaga.hover\').render_hover_doc()<CR>'
map.n.nore.silent['wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'
map.n.nore.silent['wr'] = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'
map.n.nore.silent['wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'
map.n.nore.silent['rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>'
map.n.nore.silent['gr'] = '<cmd>lua vim.lsp.buf.references()<CR>'
map.n.nore.silent['la'] = '<cmd>lua vim.lsp.buf.code_action()<CR>'
map.n.nore.silent['<leader>sit'] = '<cmd>Telescope treesitter<CR>'

map.n.nore.silent['e'] = "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>"
map.n.nore.silent['[['] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>"
map.n.nore.silent[']]'] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>"

-- <leader>ccs - change (rename) current symbol
map.n.nore.silent['ccs'] = "<cmd>lua require('lspsaga.rename').rename()<CR>"

-- Format current document
map.n.nore.silent['fmt'] = '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>'

-- Show attached LSP clients for current buffer
map.n.nore.silent['lc'] = '<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>'
