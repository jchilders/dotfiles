set nocompatible
set fileformat=unix
" use spaces instead of tabs
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

let mapleader = ","
imap jk <Esc>
imap jkw <Esc>:wa<CR>
imap kj <Esc>:wa<CR>

" Statusline stuff
set statusline =%#identifier#
set statusline+=[%t]    "tail of the filename
set statusline+=%*
set statusline+=%y      "filetype
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*
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
" Double trailing slashes prevents name collisions
set backupdir=~/.vimbak//
set directory=~/.vimbak//
set undodir=~/.vimback//

" set incsearch
set inccommand=nosplit
set ai
set scrolloff=5
set hidden
set background=dark

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on

colorscheme ron

set hlsearch
hi Search cterm=NONE ctermfg=grey
hi Search cterm=NONE ctermbg=blue
hi Folded ctermfg=Black
hi Folded ctermbg=DarkGrey

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin indent on
filetype plugin on

au FileType text setlocal textwidth=80
au BufNewFile,BufRead *.json set ft=javascript 
au BufNewFile,BufRead *.gradle set ft=groovy 
au BufNewFile,BufRead *.axlsx set ft=ruby 
au BufRead,BufNewFile *.rb,*.rhtml,*.rake,*.yml,Gemfile,*.jbuilder set ft=ruby
au BufRead,BufNewFile *.erb set ft=eruby
" Restore cursor to where it was when the file was closed
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" For commenting a line in HTML/XML format
" map <F8> :set nohls<Return>:s/\S.*$/<!--&-->/g<Return>

" Change HTML form elements to their struts equivalent
"map <F8> :s/<.\{-}"\(.\{-}\)" name="\(.\{-}\)"\(.\{-}\)>/<html:\1 property="\2"\3 \/>/g
" For quoting attributes in HTML/XML
"map <F9> :%s/\([^&^?]\)\(\<[[:alnum:]-]\{-}\)=\([[:alnum:]-#%]\+\)/\1\2="\3"/g<Return>

" Allows you to easily change the current word and all occurrences to
" something else. 
nnoremap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cw y:%s/<C-r>"/<C-r>"

" Ctrl-C to auto-close XML-ish tags
" imap <silent> <C-c> </<C-X><C-O><C-X>

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
endfunction

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <Leader>vs "vy :call VimuxSlime()<CR>

" Send current line (technicaly paragraph) to adjacent tmux pane
nmap <Leader>vs vip<Leader>vs<CR>

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

" Ruby-specific stuff
nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>

nnoremap <Leader>rp oputs "-=-=> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> "<ESC>i

set rnu " on by default. <Leader>l to turn off

nnoremap <Leader>w :wa<CR>
nnoremap <Leader>W :wqa<CR>

nnoremap <Leader>p :set invpaste paste?<CR>
imap <Leader>p <C-O>:set invpaste paste?<CR>
set pastetoggle=<Leader>p

" Auto jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Clear previously highlighted search ('clear find')
nnoremap <Leader>cf :let @/ = ''<CR>

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>

" https://github.com/junegunn/vim-plug
" :PlugInstall to refresh
call plug#begin('~/.config/nvim/plugs')
  Plug 'adelarsq/vim-matchit'
  Plug 'airblade/vim-gitgutter'
  Plug 'benmills/vimux' " Pipe to tmux
  Plug 'ervandew/supertab'
  Plug 'kien/ctrlp.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-fugitive' " :Gblame
  Plug 'neomake/neomake'
  Plug 'dag/vim-fish'
call plug#end()

" ctrlp stuff
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
set wildignore+=*/node_modules/*
nnoremap <silent> <C-c> :CtrlP ~/workspace/agency_gateway/ag_client<ENTER>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" vim-gitgutter: always show sign column
set signcolumn=yes

" Run neomake when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" Run neomake linters on everything except what is in the blacklist
let blacklist = ['scratch.rb', 'routes.rb']
autocmd! BufWritePost * if index(blacklist, expand("%:t")) < 0 | Neomake

let g:neomake_error_sign = {'texthl': 'Constant', }
let g:neomake_warning_sign = {'texthl': 'EndOfBuffer', }
highlight SignColumn ctermbg=black guibg=black
au VimEnter * highlight link NeomakeWarning NONE
au VimEnter * highlight link NeomakeError NONE

if filereadable("rubocop")
  let g:neomake_ruby_enabled_makers = ['rubocop']
endif

" Replace single quotes with doubles
nnoremap <Leader>rq :s/'/"/g<CR>:let @/ = ''<CR>

" Speed up startup time for vim-ruby
" https://github.com/vim-ruby/vim-ruby/issues/248
" let g:ruby_path = '/Users/jchilders/.rvm/rubies/ruby-2.3.0/'

" Use following command to profile vim startup time. Identify slow plugins, etc.
" vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file *.vim' app/controllers/api/v1/notifications_controller.rb

