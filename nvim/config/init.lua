-- numb.nvim is a Neovim plugin that peeks lines of the buffer in non-obtrusive way.
require('numb').setup()

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
