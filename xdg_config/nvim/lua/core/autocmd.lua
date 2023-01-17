-- When opening a file, restore cursor position (`g'"`) to where it was when
-- that file was last edited
-- utils.autocmd(
--   "BufReadPost",
--   "*",
--   [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
-- )

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
   pattern = { "*" },
   command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "Brewfile", "*.jbuilder", "*.arb", "*.rbi" },
  command = "set filetype=ruby",
})
