local map = require('cartographer')

-- `:unmap` 'zfo' in `x` mode
-- map.x['<leader>zfo'] = nil

map.n.nore.silent['<leader>gd'] = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>"

map.n.nore.silent['<leader>K'] = '<cmd>lua require(\'lspsaga.hover\').render_hover_doc()<CR>'
map.n.nore.silent['<leader>wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'
map.n.nore.silent['<leader>wr'] = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'
map.n.nore.silent['<leader>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'
map.n.nore.silent['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>'
map.n.nore.silent['<leader>gr'] = '<cmd>lua vim.lsp.buf.references()<CR>'
map.n.nore.silent['<leader>la'] = '<cmd>lua vim.lsp.buf.code_action()<CR>'
map.n.nore.silent['<leader><leader>sit'] = '<cmd>Telescope treesitter<CR>'

map.n.nore.silent['<leader>e'] = "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>"
map.n.nore.silent['<leader>[['] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>"
map.n.nore.silent['<leader>]]'] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>"

-- <leader>ccs - change (rename) current symbol
map.n.nore.silent['<leader>ccs'] = "<cmd>lua require('lspsaga.rename').rename()<CR>"

-- Format current document
map.n.nore.silent['<leader>fmt'] = '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>'

-- Show attached LSP clients for current buffer
map.n.nore.silent['<leader>lc'] = '<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>'
