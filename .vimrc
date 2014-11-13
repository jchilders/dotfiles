set nocompatible
set fileformat=unix
set shiftwidth=4
" use spaces instead of tabs
set expandtab
set smarttab
set tabstop=4
" Statusline stuff
set statusline =%#identifier#
set statusline+=[%t]    "tail of the filename
set statusline+=%*
set statusline+=%y      "filetype

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

"modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

set statusline+=%=      "left/right separator

set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

" always display status line
set laststatus=2

set incsearch

" Keep backups in separate directory from current
set backupdir=~/vimbak
set directory=~/vimbak

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set background=dark
set hlsearch
set ai

set scrolloff=5

" Pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()

set background=dark
colorscheme elflord

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin indent on
filetype plugin on

au FileType text setlocal textwidth=80
au BufNewFile,BufRead *.json set ft=javascript 
au BufNewFile,BufRead *.gradle set ft=groovy 
au BufRead,BufNewFile *.js,*.rb,*.rhtml,*.erb,*.rake,*.yml,Gemfile,*.gradle set shiftwidth=2
au BufRead,BufNewFile *.js,*.rb,*.rhtml,*.erb,*.rake,*.yml,Gemfile,*.gradle set softtabstop=2
au BufRead,BufNewFile *.js,*.rb,*.rhtml,*.erb,*.rake,*.yml,Gemfile,*.gradle set tabstop=2
au BufRead,BufNewFile *.rb,*.rhtml,*.erb,*.rake,*.yml,Gemfile set ft=ruby

" For commenting a line in HTML/XML format
" map <F8> :set nohls<Return>:s/\S.*$/<!--&-->/g<Return>

" Change HTML form elements to their struts equivalent
"map <F8> :s/<.\{-}"\(.\{-}\)" name="\(.\{-}\)"\(.\{-}\)>/<html:\1 property="\2"\3 \/>/g
" For quoting attributes in HTML/XML
"map <F9> :%s/\([^&^?]\)\(\<[[:alnum:]-]\{-}\)=\([[:alnum:]-#%]\+\)/\1\2="\3"/g<Return>

" Custom mappings
let mapleader = ","

" Relative line numbering goodness
" use <Leader>L to toggle the line number counting method
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc
nnoremap <Leader>l :call g:ToggleNuMode()<cr>

set rnu " on by default

nnoremap <Leader>w :w<CR>

nnoremap <Leader>p :set invpaste paste?<CR>
imap <Leader>p <C-O>:set invpaste paste?<CR>
set pastetoggle=<Leader>p

" Auto jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

 " If text is selected, save it in the v buffer and send that buffer it to tmux
 vmap <Leader>vs "vy :call VimuxSlime()<CR>

 " Select current paragraph and send it to tmux
 nmap <Leader>vs vip<Leader>vs<CR>

