set nocompatible
set fileformat=unix
" use spaces instead of tabs
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

let mapleader = ","

" use jk for esc
imap jk <Esc>
vmap jk <Esc>

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

" Ctrl-C to copy visual selection to pasteboard
vmap <silent> <C-c> "+y

" Change all occurences of the current word
nnoremap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cw y:%s/<C-r>"/<C-r>"

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
endfunction

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <silent> <Leader>vs "vy :call VimuxSlime()<CR>

" Send current line (technicaly paragraph) to adjacent tmux pane
nmap <silent> <Leader>vs vip<Leader>vs<CR>

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

set rnu " on by default

nnoremap <silent> <Leader>w :wa<CR>
nnoremap <silent> <Leader>W :wqa<CR>

nnoremap <Leader>p :set invpaste paste?<CR>
imap <Leader>p <C-O>:set invpaste paste?<CR>
set pastetoggle=<Leader>p

" Auto jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>

" https://github.com/junegunn/vim-plug
" :PlugInstall to refresh
call plug#begin('~/.config/nvim/plugs')
  Plug 'adelarsq/vim-matchit'
  Plug 'airblade/vim-gitgutter'
  Plug 'benmills/vimux'
  Plug 'darfink/vim-plist'
  Plug 'ervandew/supertab'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'leafgarland/typescript-vim'
  Plug 'neomake/neomake'
  Plug 'dag/vim-fish'           " fish syntax highlighting
  " Plug 'slim-template/vim-slim' " slim syntax highlighting
  " Plug 'talek/vorax4'           " Oracle IDE
call plug#end()

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" ruby stuff
" `gem install neovim` having been previously run
let g:ruby_host_prog = '~/.rvm/rubies/ruby-2.6.5/bin/ruby'
nnoremap <C-p> :Files<CR>
nnoremap <silent> <Leader>ac :Files app/controllers<CR>
nnoremap <silent> <Leader>am :Files app/models<CR>
nnoremap <silent> <Leader>b  :Buffers<CR>
nnoremap <silent> <Leader>st :GFiles?<CR>
nnoremap <silent> <Leader>h  :History<CR>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" vim-gitgutter: always show sign column
set signcolumn=yes

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

" Clear previously highlighted search ('clear find')
nnoremap <silent> <Leader>cf :let @/ = ''<CR>

" Replace single quotes with doubles
nnoremap <Leader>rq :s/'/"/g<CR>:let @/ = ''<CR>

" vim-airline stuff
let g:airline_powerline_fonts = 1

" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
" *.vim' app/models/budget.rb`
