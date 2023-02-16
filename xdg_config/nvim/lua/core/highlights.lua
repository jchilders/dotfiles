local cmd = vim.cmd

-- For Tokyonight this makes the background color black for the active pane and dark grey for the inactive one
cmd("autocmd ColorScheme * highlight normal ctermbg=NONE guibg=NONE")

cmd("autocmd ColorScheme * highlight CursorLineNr cterm=underline ctermbg=Black guibg=#18101f")
cmd("autocmd ColorScheme * highlight CursorLine cterm=underline ctermbg=Black guibg=#18101f")
cmd("autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight StatusLine ctermbg=Green guibg=#0044cc")
cmd("autocmd ColorScheme * highlight StatusLineNC ctermbg=White guibg=#1B3A59")

cmd("autocmd ColorScheme * highlight NormalFloat guifg=#fff guibg=none ctermbg=none")

cmd("autocmd ColorScheme * highlight FloatBorder guifg=#FF6111 guibg=none ctermbg=none")
