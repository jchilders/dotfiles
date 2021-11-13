local nnoremap = vim.keymap.nnoremap

-- `:unmap` 'zfo' in `x` mode
-- map.x['<leader>zfo'] = nil

nnoremap { '<leader>gd', function() require('telescope.builtin').lsp_definitions() end }

nnoremap { '<leader>K', function() require('lspsaga.hover').render_hover_doc() end }
nnoremap { '<leader>wa', function() vim.lsp.buf.add_workspace_folder() end }
nnoremap { '<leader>wr', function() vim.lsp.buf.remove_workspace_folder() end }
nnoremap { '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end }
nnoremap { '<leader>rn', function() vim.lsp.buf.rename() end }
nnoremap { '<leader>gr', function() vim.lsp.buf.references() end }
nnoremap { '<leader>la', function() vim.lsp.buf.code_action() end }
-- nnoremap { '<leader><leader>sit', function() Telescope treesitter end }
nnoremap { '<leader>sit', function() require('telescope.builtin').treesitter() end }

nnoremap { '<leader>e', function() require('lspsaga.diagnostic').show_line_diagnostics() end }
nnoremap { '<leader>[[', function() require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev() end }
nnoremap { '<leader>]]', function() require'lspsaga.diagnostic'.lsp_jump_diagnostic_next() end }

-- <leader>ccs - change (rename) current symbol
nnoremap { '<leader>ccs', function() require('lspsaga.rename').rename() end }

-- Format current document
nnoremap { '<leader>fmt', function() vim.lsp.buf.formatting_sync(nil, 1000) end }

-- Show attached LSP clients for current buffer
nnoremap { '<leader>lc', function() print(vim.inspect(vim.lsp.buf_get_clients())) end }
