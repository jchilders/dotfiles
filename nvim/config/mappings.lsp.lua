local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua require(\'lspsaga.hover\').render_hover_doc()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>e', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>sit', "<cmd>Telescope treesitter<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>[[', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>]]', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

-- <leader>ccs - change (rename) current symbol
vim.api.nvim_set_keymap('n', '<leader>ccs', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)

-- Format current document
vim.api.nvim_set_keymap('n', '<leader>fmt', "<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>", opts)

-- Show attached LSP clients for current buffer
vim.api.nvim_set_keymap('n', '<leader>lc', "<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>", opts)

