set expandtab
set softtabstop=2
set shiftwidth=2
set tabstop=4
set smarttab

set noswapfile
set noundofile
set nobackup

set ai
set cursorline				" highlight current line
set fileformat=unix
set hidden
set hlsearch				" highlight current search
set inccommand=nosplit
set invnumber				" show current line number in gutter
set relativenumber			" on by default
set scrolloff=5
set signcolumn=yes
set termguicolors

" Restore cursor to where it was when the file was closed
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au FileType text setlocal textwidth=80

au BufNewFile,BufRead *.json set ft=javascript 

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" https://github.com/vim-test/vim-test#strategies
" let test#strategy = "neovim"
