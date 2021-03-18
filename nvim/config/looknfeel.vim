colorscheme dogrun

let g:airline_theme='violet'
let g:airline_powerline_fonts = 1
let g:airline_section_b = ''
let g:airline_section_y = ''

let g:airline_section_z = "%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L"

" See where hi was last set:
"   :verbose :hi CursorLine

hi Normal ctermbg=Black
hi Search ctermfg=Black

hi CursorLineNr ctermbg=240 ctermfg=White
hi CursorLine cterm=underline ctermbg=Black gui=underline guibg=#000000
