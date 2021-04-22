" Some helpful commands when working with colors:
"
" Show info about the CursorLine highlight group including where its value
" was last set:
"   :verbose hi CursorLine
"
" Show all curently active highlight groups:
"   :so $VIMRUNTIME/syntax/hitest.vim

if has("nvim")
  set termguicolors
end

colorscheme tokyonight

hi Normal ctermbg=Black guibg=#000000
hi Search guifg=#eeeeee ctermfg=White ctermbg=60
hi IncSearch guibg=#cccccc ctermfg=63 ctermbg=12

hi Visual ctermbg=240 ctermfg=White

set cursorline
hi CursorLineNr cterm=underline ctermbg=Black guibg=#18101f
hi CursorLine cterm=underline ctermbg=Black guibg=#18101f

hi link TSPunctDelimiter SpecialChar
hi link TSVariable FernLeafSymbol

" overrides of tokyonight
sign define LspDiagnosticsSignInformation text=! texthl=WarningMsg
hi SignColumn ctermbg=Black guibg=#000000
