set nocompatible
set fileformat=unix
set shiftwidth=2
" use spaces instead of tabs
set expandtab
set smarttab
set tabstop=4
" always display status line
set laststatus=2
"set statusline=%F%m%r%h%w\ [%Y]\ %04l,%04v\ (%p%%)
"set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*
" Broken down into easily includeable segments
set statusline=%<%f\   " Filename
set statusline+=%w%h%m%r " Options
set statusline+=%{fugitive#statusline()} "  Git Hotness
"set statusline+=\ [%{&ff}/%Y]            " filetype
set statusline+=\ [%{getcwd()}]          " current dir
"set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info

" Keep backups in separate directory from current
set backupdir=~/backup
set directory=~/backup

colorscheme elflord
source $VIMRUNTIME/vimrc_example.vim
if has("gui_running")
  set lines=70 columns=110
endif
set incsearch		" do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set background=dark
set hlsearch
set ai
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin indent on
filetype plugin on

autocmd FileType text setlocal textwidth=80

" Default to Ruby for new files
" I use this for scratch buffers
autocmd BufEnter * if &filetype == "" | setlocal ft=ruby | endif

" Disable paste mode when leaving insert mode
au InsertLeave * set nopaste

augroup Binary
    au!
    au BufReadPre  *.localstorage,*.sk let &bin=1
    au BufReadPost *.localstorage,*.sk if &bin | %!xxd
    au BufReadPost *.localstorage,*.sk set ft=xxd | endif
    au BufWritePre *.localstorage,*.sk if &bin | %!xxd -r
    au BufWritePre *.localstorage,*.sk endif
    au BufWritePost *.localstorage,*.sk if &bin | %!xxd
    au BufWritePost *.localstorage,*.sk set nomod | endif
augroup END

" Use tab for autocompletion
function! SuperTab()
    if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-n>"
endfunction
imap <Tab> <C-R>=SuperTab()<CR>


" Autoident after pasting
nnoremap <leader>p p                                                               
nnoremap <leader>P P                                                               
nnoremap p p'[v']=                                                                 
nnoremap P P'[v']=

" Save/load folds on document close/open
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

au BufRead,BufNewFile *.rb,*.rhtml,*.erb,*.rake,*.yml,*.ru,Capfile set shiftwidth=2
au BufRead,BufNewFile *.rb,*.rhtml,*.erb,*.rake,*.yml,*.ru,Capfile set softtabstop=2
au BufRead,BufNewFile *.rb,*.rhtml,*.erb,*.rake,*.yml,*.ru,Capfile set tabstop=2

" Rack config files
au BufRead,BufNewFile *.ru,Capfile set filetype=ruby

au BufRead,BufNewFile *.js set shiftwidth=2
au BufRead,BufNewFile *.js set softtabstop=2
au BufRead,BufNewFile *.js set tabstop=2

augroup END

" If autotest is running then the following will allow \fd to jump
" to the last test failure
" compiler rubyunit
" nmap <Leader>fd :cf /tmp/autotest.txt<cr> :compiler rubyunit<cr>

" For commenting a line in HTML/XML format
" map <F8> :set nohls<Return>:s/\S.*$/<!--&-->/g<Return>

" Change HTML form elements to their struts equivalent
"map <F8> :s/<.\{-}"\(.\{-}\)" name="\(.\{-}\)"\(.\{-}\)>/<html:\1 property="\2"\3 \/>/g
" For quoting attributes in HTML/XML
"map <F9> :%s/\([^&^?]\)\(\<[[:alnum:]-]\{-}\)=\([[:alnum:]-#%]\+\)/\1\2="\3"/g<Return>

" map <F6> :s/\(<[A-Za-z]\s*.\{-}%\@<!>\)\(.\{-}\)\(<\/\)/\1<%= t('\2') -%>\3<Return>
" let g:surround_{char2nr('=')} = "<%= t('\r') -%>" " Surround with ERB <%= %>

" Line numbering goodness
set rnu
au InsertEnter * :set nu
au InsertLeave * :set rnu
au FocusLost * :set nu
au FocusGained * :set rnu

