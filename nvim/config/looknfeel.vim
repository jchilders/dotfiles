" Some helpful commands when working with colors:
"
" Shows info about the CursorLine,highlight  including where its value was last set
"   :verbose hi CursorLine
"
" Show all curently active higghligh groups:
"   :so $VIMRUNTIME/syntax/hitest.vim

colorscheme dogrun

let g:airline_theme='violet'
let g:airline_powerline_fonts = 1
let g:airline_section_b = ''
let g:airline_section_y = ''
let g:airline_section_z = "%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#:%c"

hi Normal ctermbg=Black
hi Search ctermfg=White ctermbg=12 guisp=Blue
hi IncSearch ctermfg=White ctermbg=12 guisp=Blue

hi Visual ctermbg=240 ctermfg=White

hi CursorLineNr cterm=underline ctermbg=Black gui=underline guibg=#000000
hi CursorLine cterm=underline ctermbg=Black gui=underline guibg=#000000
