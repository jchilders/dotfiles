local cmd = vim.cmd

-- For Tokyonight this makes the background color black for the active pane and dark grey for the inactive one
cmd("autocmd ColorScheme * highlight normal ctermbg=NONE guibg=NONE")

cmd("autocmd ColorScheme * highlight CursorLineNr cterm=underline ctermbg=Black guibg=#18101f")
cmd("autocmd ColorScheme * highlight CursorLine cterm=underline ctermbg=Black guibg=#28102f")
cmd("autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight StatusLine ctermbg=Green guibg=#0044cc")
cmd("autocmd ColorScheme * highlight StatusLineNC ctermbg=White guibg=#1B3A59")

cmd("autocmd ColorScheme * highlight NormalFloat guifg=#fff guibg=none ctermbg=none")

cmd("autocmd ColorScheme * highlight FloatBorder guifg=#FF6111 guibg=none ctermbg=none")

cmd("autocmd ColorScheme * highlight DiagnosticFloatingHeader guifg=#f7ecff guibg=#4b2661 gui=bold")
cmd("autocmd ColorScheme * highlight DiagnosticFloatingError guifg=#ff98b2 guibg=#2b1127 gui=bold")
cmd("autocmd ColorScheme * highlight DiagnosticFloatingWarn guifg=#ffd78a guibg=#2b1c0f gui=bold")
cmd("autocmd ColorScheme * highlight DiagnosticFloatingInfo guifg=#a9dcff guibg=#0f2432 gui=bold")
cmd("autocmd ColorScheme * highlight DiagnosticFloatingHint guifg=#a5ffd6 guibg=#052721 gui=bold")
