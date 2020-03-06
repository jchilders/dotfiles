if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" :PlugInstall to install new
" :PlugUpdate to get lastest
" :PlugClean to remove old/unused plugins
call plug#begin('~/.config/nvim/plugs')
  Plug 'benmills/vimux' " Pipe to tmux
  Plug 'dag/vim-fish'
  Plug 'elzr/vim-json'
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release', 'do': { -> coc#util#install()}}
  Plug 'neovim/nvim-lsp'

  " Plug 'ctrlpvim/ctrlp.vim'
  Plug '/usr/local/opt/fzf'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tomasiser/vim-code-dark'
  Plug 'tpope/vim-markdown'
  " Plug 'vimlab/split-term.vim'
  Plug 'kassio/neoterm'
  Plug 'vim-ruby/vim-ruby'
  " Plug 'tpope/vim-fugitive' " :Gblame
call plug#end()

runtime **/configs/statusline.vim
runtime **/configs/coc-nvim.vim

let mapleader = ","

" Double trailing slashes prevents name collisions
" Keep backups in separate directory from current
set backupdir=~/.vimbak//
set directory=~/.vimbak//
set expandtab              " tab to spaces
set hlsearch
set inccommand=nosplit
set incsearch
set noswapfile
set rnu                   " relative line numbering on by default
set scrolloff=5
set shiftwidth=2
set smartindent
set tabstop=2
set undodir=~/.vimbak/undo
set undofile               " Persist undo history between sessions
set undolevels=100         " How many undos
set undoreload=1000        " number of lines to save for undo

filetype on               " Enable filetype detection
filetype indent on        " Enable filetype-specific indenting
filetype plugin indent on
filetype plugin on

au FileType text setlocal textwidth=80
au BufNewFile,BufRead *.gradle set ft=groovy 
au BufNewFile,BufRead *.axlsx set ft=ruby 
au BufRead,BufNewFile *.rb,*.rhtml,*.rake,*.yml,Gemfile,*.jbuilder set ft=ruby
au BufRead,BufNewFile *.erb set ft=eruby
au BufRead,BufNewFile *.yml set ft=yaml
au BufRead,BufNewFile .env.* set ft=sh

" Restore cursor to where it was when the file was closed
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" https://github.com/tomasiser/vim-code-dark
colorscheme codedark

highlight Normal ctermbg=Black
highlight Search cterm=NONE ctermfg=white
highlight Search cterm=NONE ctermbg=blue
highlight Folded ctermfg=Black
highlight Folded ctermbg=DarkGrey

let g:vim_json_syntax_conceal = 0

" Since new MBPs don't have an escape key except in that stupid Touch Bar...
imap jk <Esc>
imap jkw <Esc>:wa<CR>
imap kj <Esc>:wa<CR>

nnoremap <silent> <Leader>w :wa<CR>
nnoremap <silent> <Leader>W :wqa<CR>

" Copy visual selection to clipboard
vnoremap <C-c> "*y

" Clear previously highlighted search ('clear find')
nnoremap <silent> <Leader>cf :let @/ = ''<CR>

" Toggle single/double quotes
nnoremap <silent> <Leader>rq :call ReplaceQuotes()<CR>
function! ReplaceQuotes()
  let save_pos = getpos(".")
  set nohlsearch
  let curr_line = getline('.')

  if curr_line =~ "'"
    call setline(line('.'), substitute(getline('.'), "'", '\"', 'g'))
  end
  
  if curr_line =~ '"'
    call setline(line('.'), substitute(getline('.'), '\"', "'", 'g'))
  end

  set hlsearch
  call setpos('.', save_pos)
  let @/ = ''
endfunction

" Change all occurrences of current word
nnoremap <Leader>cw :call GlobalChangeCurrentWord()<CR>
function! GlobalChangeCurrentWord()
  let save_pos = getpos(".")
  let word = expand("<cword>")
  call inputsave()
  let replacement = input('Replace with: ')
  call inputrestore()

  execute "%s/\\<" . word . "\\>/" .replacement. "/g"

  call setpos('.', save_pos)
endfunction

" Run a given vim command on the results of alt from a given path.
" depends on `alt`: https://github.com/uptech/alt
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
endfunction

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <Leader>vs "vy :call VimuxSlime()<CR>

" Send current line (technicaly paragraph) to adjacent tmux pane
nmap <Leader>vs vip<Leader>vs<CR>

" Find the alternate file for the current buffer and open it
nnoremap <silent> <leader>. :w<cr>:call AltCommand(expand('%'), ':e')<cr>

" Tab to switch to next open buffer
nnoremap <silent> <Tab> :bnext<cr>
" Shift + Tab to switch to previous open buffer
nnoremap <silent> <S-Tab> :bprevious<cr>
" leader key twice to cycle between last two open buffers
nnoremap <leader><leader> <c-^>

" ctrlp stuff
" set wildignore+=*/node_modules/*
" set wildignore+=*/ng2-src/*
" set wildignore+=tags

" fzf

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <C-p> :Files<ENTER>
nnoremap <silent> <space>t :Tags<ENTER>
let g:fzf_layout = { 'down': '~20%' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
 \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use following command to profile vim startup time. Identify slow plugins, etc.
" vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file *.vim' app/controllers/api/v1/notifications_controller.rb
