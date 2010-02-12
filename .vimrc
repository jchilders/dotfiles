version 4.0
set nocompatible
set textwidth=0
set formatoptions=tqcwna
set magic
set ignorecase
set autowrite
set joinspaces
set ruler
set showmode
set ww=b,s,[,],<,>
set bs=2
set autoindent
set smartindent
inoremap # X#
set expandtab
set smarttab
set softtabstop=4
set splitbelow
set nostartofline
set shiftwidth=4
set history=50
set scrolloff=5
filetype plugin on

hi Comment ctermfg=0 
hi Constant term=bold cterm=bold ctermfg=0
hi Identifier ctermfg=4 
hi Special ctermfg=7 term=bold
hi Search ctermfg=Yellow ctermbg=Blue

if &term =~ "xterm|screen"
if has("terminfo")
  set t_kb=
  set t_Co=8
  set t_Sf=[3%p1%dm
  set t_Sb=4%p1%dm
  set mouse=a
  set mousefocus
  syntax on
else
  set t_Co=8
  set t_kb=
  set t_Sf=[3%dm
  set t_Sb=[4%dm
  set mouse=a
  set mousefocus
  syntax on
endif
endif  

nmap ,ns :s/^\s*//
vmap ,ns :s/^\s*//

" trim everything from a block of headers except the basics
cab HEMAIL ^\(From\\|Cc\\|To\\|Date\\|Subject\)
nmap ,we vip:v/HEMAIL/d
vmap ,we    :v/HEMAIL/d   

" set folding by last-searched expression
if has("folding")
  set foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\|\|(getline(v:lnum+1)=~@/)?1:2
  map \z :set foldmethod=expr foldlevel=0 foldcolumn=2
endif

autocmd BufNewFile,BufRead /tmp/pico.*,.article.* set autoindent expandtab shiftwidth=8 tabstop=8 textwidth=70 wrapmargin=8

"
"
" ------------------------------------------------------------------------
set ts=8 sw=4 ic uc=0 nobackup icon notitle showbreak=$
"

" 3. Programming macros (must be loaded with keystrokes)
" ------------------------------------------------------
"
" Load Perl macros
map ]lp :so ~/.vim/perl.vi:"Loaded Perl macros
"
" Load C macros
map ]lc :so ~/.vim/c.vi:"Loaded C macros
"
" load debugger
map ]lg :so ~/.vim/vimDebug.vim:"Loaded vimDebug
" 4. Miscellaneous things
" -----------------------
"
" toggle line numbering (1 and shift-1)
map ]1 :set number
map ]! :set nonumber
" toggle line list (2 and shift-2)
map ]2 :set list
map ]@ :set nolist
" toggle wrap margin
map ]3 :set wm=8:" Wrap margin=8
map ]4 :set ai:" autoindent
map ]$ :set noai:" no autoindent
map ]# :set wm=0:" Wrap margin=0
" pound-comment out line, making a duplicate to edit
map ]y YP0i#
" pound-comment out line
map ]c 0i#
" un-pound-comment out line
map ]u :s/^#//
" insert  date and name
map ]d :set ai:r !dateA eric@transmeta.como	
" delete trailing gibberish from html tags
map ]f df>i>
"
" 5. HTML macros
"
let xml_use_xhtml=1
let mapleader=","

"
