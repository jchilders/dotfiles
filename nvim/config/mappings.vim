"   Plugin keymaps will all be found in `./after/plugin/*`

let mapleader = ","

" use jk for esc
imap jk <Esc>
vmap jk <Esc>

nmap <silent> <leader>w <cmd>wa<CR>
nmap <silent> <leader>W <cmd>wqa<CR>

" Ctrl-C to copy visual selection to pasteboard
vmap <silent> <C-c> "+y

" Change all occurences of the current word
nmap <leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vmap <leader>cw y:%s/<C-r>"/<C-r>"

" <leader>g - Toggles display of gutter and any virtual text. Use when you
" need to copy text to pasteboard, but don't want extra stuff getting in the
" way
function! g:ToggleGutter()
  if(&rnu == 1)
    set nonumber
    set norelativenumber
    set signcolumn=no
  else
    set number
    set relativenumber
    set signcolumn=yes
  endif
endfunc
nmap <leader>g <cmd>call g:ToggleGutter()<cr>

" Remap * to search word under cursor, but do not immediately advance to next match
nnoremap <silent>*
    \ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <silent> <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

" Quickly toggle next/previous buffers
nmap <silent> <leader><leader> <cmd>b#<CR>

nmap <leader>rv <cmd>source $MYVIMRC<CR><cmd>echo 'Reloaded!'<CR>

nnoremap <silent> <leader>t <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
tnoremap <silent> <esc><esc> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>

" Replace single quotes with doubles
nmap <leader>rq <cmd>s/'/"/g<CR><cmd>let @/ = ''<CR>
nmap <leader>rq2 <cmd>s/"/'/g<CR><cmd>let @/ = ''<CR>

" Show tree-sitter highlight group(s) for current cursor position
map <leader>hi <cmd>TSHighlightCapturesUnderCursor<CR>

" Toggle tree-sitter highlighting
nmap <leader>tog <cmd>TSToggle highlight<CR>

" Execute this file
function! s:save_and_exec() abort
  if &filetype == 'vim'
    :silent! write
    :source %
  elseif &filetype == 'lua'
    :silent! write
    :lua require("plenary.reload").reload_module'%'
    :luafile %
  endif

  return
endfunction

" save and resource current file
noremap <leader>xx :call <SID>save_and_exec()<CR>
