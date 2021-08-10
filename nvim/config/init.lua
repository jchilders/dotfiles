-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- Supposedly improves startup time. Since we don't need the provider anyway,
-- can't hurt.
vim.g.loaded_ruby_provider = 0
