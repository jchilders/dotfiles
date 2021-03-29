" Some helpful commands when working with colors:
"
" Shows info about the CursorLine,highlight  including where its value was last set
"   :verbose hi CursorLine
"
" Show all curently active higghligh groups:
"   :so $VIMRUNTIME/syntax/hitest.vim

colorscheme dogrun

if has("nvim")
  set termguicolors
end

hi Normal ctermbg=Black guibg=#000000
hi Search guifg=#eeeeee ctermfg=White ctermbg=60
hi IncSearch guibg=#cccccc ctermfg=63 ctermbg=12

hi Visual ctermbg=240 ctermfg=White

set cursorline
hi CursorLineNr cterm=underline ctermbg=Black gui=underline guibg=#000000
hi CursorLine cterm=underline ctermbg=Black gui=underline guibg=#000000

hi link TSPunctDelimiter SpecialChar
hi link TSVariable FernLeafSymbol

sign define LspDiagnosticsSignInformation text=! texthl=Todo
