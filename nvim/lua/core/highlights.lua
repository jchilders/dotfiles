local cmd = vim.cmd

-- cmd("autocmd ColorScheme * highlight Normal ctermbg=Black guibg=#000000")
cmd("autocmd ColorScheme * highlight normal ctermbg=NONE guibg=NONE")
cmd("autocmd ColorScheme * highlight CursorLineNr cterm=underline ctermbg=Black guibg=#18101f")
cmd("autocmd ColorScheme * highlight CursorLine cterm=underline ctermbg=Black guibg=#18101f")
cmd("autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight StatusLine ctermbg=Green guibg=#0044cc")
cmd("autocmd ColorScheme * highlight StatusLineNC ctermbg=White guibg=#1B3A59")
cmd("autocmd ColorScheme * highlight VertSplit guibg = none")

cmd("autocmd ColorScheme * highlight TelescopeBorder         guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopePromptBorder   guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopeResultsBorder  guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopePreviewBorder  guifg=#525865")

cmd("autocmd ColorScheme * highlight NormalFloat guifg=#fff guibg=none ctermbg=none")
cmd("autocmd ColorScheme * highlight FloatBorder guifg=#FF6111 guibg=none ctermbg=none")
cmd("autocmd ColorScheme * highlight PmenuSel guifg=#c14a4a guibg=#98c379")
