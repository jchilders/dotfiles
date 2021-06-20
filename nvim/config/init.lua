-- numb.nvim is a Neovim plugin that peeks lines of the buffer in non-obtrusive way.
require('numb').setup()

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

require('surround').setup{}

-- Supposedly improves startup time. Since we don't need the provider anyway,
-- can't hurt.
vim.g.loaded_ruby_provider = 0
vim.g.lexima_no_default_rules = true
