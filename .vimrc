set nocompatible
set fileformat=unix

" use spaces instead of tabs
set expandtab
set smarttab

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

source $VIMRUNTIME/macros/matchit.vim

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
au BufNewFile,BufRead *.axlsx set ft=ruby 
set shiftwidth=2
set softtabstop=2
set tabstop=2
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

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

" Clear previously highlighted search
nnoremap <Leader>ch :let @/ = ""<CR>

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <Leader>vs "vy :call VimuxSlime()<CR>

" Select current paragraph and send it to tmux
nmap <Leader>vs vip<Leader>vs<CR>

" https://github.com/jonas/tig
function! s:tig_status()
  !tig status
endfunction

map <Leader>s :TigStatus<CR><CR>
command! TigStatus call s:tig_status()

nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>GG

" ctrl-p stuff
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
set wildignore+=*/node_modules/*

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


" requires ack.vim plugin
" git clone https://github.com/mileszs/ack.vim.git ~/.vim/bundle/ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
end
cnoreabbrev Ag Ack
cnoreabbrev ag Ack

