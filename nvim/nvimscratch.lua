-- print vim global named 'coq_settings'
lua print(vim.inspect(vim.g.coq_settings))

:lua print(vim.inspect(vim.api.nvim_win_get_cursor(0)))

:lua local row, col = unpack(vim.api.nvim_win_get_cursor(0))
:lua print(row)

:lua print(vim.api.nvim_win_get_cursor(0))
vim.api.nvim_win_get_cursor(0)

:lua vim.api.nvim_win_set_cursor(0, {1,0})

