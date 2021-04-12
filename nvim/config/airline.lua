-- echo nvim_treesitter#statusline(90)

vim.g.airline_theme = 'violet'
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_b = ''
vim.g.airline_section_y = ''
vim.g.airline_section_z = "%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#:%c"
