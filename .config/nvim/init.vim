set nocompatible
set fileformat=unix
" use spaces instead of tabs
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

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

" always display status line
set laststatus=2

" Keep backups in separate directory from current
set backupdir=~/.vimbak
set directory=~/.vimbak

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
"set background=dark
set hlsearch
set incsearch
set ai

set scrolloff=5

set inccommand=nosplit

set hidden

source $VIMRUNTIME/macros/matchit.vim

set background=dark
colorscheme ron

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin indent on
filetype plugin on

au FileType text setlocal textwidth=80
au BufNewFile,BufRead *.json set ft=javascript 
au BufNewFile,BufRead *.gradle set ft=groovy 
au BufNewFile,BufRead *.axlsx set ft=ruby 
set shiftwidth=2
set softtabstop=2
set tabstop=2
au BufRead,BufNewFile *.rb,*.rhtml,*.erb,*.rake,*.yml,Gemfile,*.jbuilder set ft=ruby
" Restore cursor to where it was when the file was closed
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" For commenting a line in HTML/XML format
" map <F8> :set nohls<Return>:s/\S.*$/<!--&-->/g<Return>

" Change HTML form elements to their struts equivalent
"map <F8> :s/<.\{-}"\(.\{-}\)" name="\(.\{-}\)"\(.\{-}\)>/<html:\1 property="\2"\3 \/>/g
" For quoting attributes in HTML/XML
"map <F9> :%s/\([^&^?]\)\(\<[[:alnum:]-]\{-}\)=\([[:alnum:]-#%]\+\)/\1\2="\3"/g<Return>

" Custom mappings
let mapleader = ","

" Allows you to easily change the current word and all occurrences to
" something else. 
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" Ctrl-C to auto-close XML-ish tags
imap <silent> <C-c> </<C-X><C-O><C-X>

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

nnoremap <Leader>w :wa<CR>
nnoremap <Leader>W :wqa<CR>

nnoremap <Leader>p :set invpaste paste?<CR>
imap <Leader>p <C-O>:set invpaste paste?<CR>
set pastetoggle=<Leader>p

" Auto jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Clear previously highlighted search
nnoremap <Leader>cs :let @/ = ""<CR>

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>GG

" https://github.com/junegunn/vim-plug
" :PlugInstall to refresh
call plug#begin('~/.config/nvim/plugs')
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'ervandew/supertab'
Plug 'kien/ctrlp.vim'
Plug 'mhartington/vim-angular2-snippets'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-fugitive'
call plug#end()

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <Leader>vs "vy :call VimuxSlime()<CR>

" Select current paragraph and send it to tmux
nmap <Leader>vs vip<Leader>vs<CR>

" ctrl-p stuff
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
set wildignore+=*/node_modules/*

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Load nerdtree if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeShowHidden = 1    " show hidden files
let NERDTreeQuitOnOpen = 1    " Hide NERDTree when opening a file
let NERDTreeShowLineNumbers=1 " enable line numbers

map <C-n> :NERDTreeToggle<CR>

" Run neomake linters on everything except what is in the blacklist
let blacklist = ['scratch.rb', 'routes.rb']
autocmd! BufWritePost * if index(blacklist, expand("%:t")) < 0 | Neomake

let g:neomake_open_list = 2
" let g:neomake_typescript_nglint_maker = {
    " \ 'exe': 'ng',
    " \ 'args': ['lint'],
    " \ 'errorformat': '%f[%l\, %c]: %m',
    " \ }
" let g:neomake_typescript_ngbuild_maker = {
    " \ 'exe': 'ng',
    " \ 'args': ['build', '--base-href', '/ng2/', '--progress', 'false'],
    " \ 'errorformat': '%f (%l\,%c): %m)',
    " \ }
" let g:neomake_typescript_enabled_makers = ['nglint']
" let g:neomake_typescript_enabled_makers = ['nglint', 'ngbuild']

" let g:neomake_list_height=5
if filereadable("rubocop")
  let g:neomake_ruby_enabled_makers = ['rubocop']
endif

