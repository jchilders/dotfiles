set expandtab
set noet
set softtabstop=2
set sw=2
set ts=2

set noswapfile
set noundofile

" Keep backups in separate directory from current
" Double trailing slashes prevents name collisions
set backupdir=~/.vimbak//

set ai
set fileformat=unix
set hidden
set inccommand=nosplit
set relativenumber " on by default
set scrolloff=5
set signcolumn=yes
set hlsearch

hi Folded ctermfg=Black ctermbg=DarkGrey
hi Search cterm=NONE ctermfg=white ctermbg=DarkBlue
hi SignColumn ctermbg=black

" Restore cursor to where it was when the file was closed
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au FileType text setlocal textwidth=80

au BufNewFile,BufRead *.json set ft=javascript 

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
