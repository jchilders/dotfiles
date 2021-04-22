set expandtab
set softtabstop=2
set shiftwidth=2
set tabstop=4
set smarttab

set nobackup
set noswapfile
set undodir=~/.local/share/nvim/backups
set undofile

set ai
set fileformat=unix
set grepprg=rg\ --vimgrep\ --no-heading\ --hidden
set hidden
set hlsearch				" highlight current search
set inccommand=nosplit
set invnumber				" show current line number in gutter
set relativenumber			" on by default
set scrolloff=5
set signcolumn=yes
set smartcase

set scrolloff=8
set sidescrolloff=15
set sidescroll=5

" Restore cursor to where it was when the file was closed
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
au FileType text setlocal textwidth=80

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
