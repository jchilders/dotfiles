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

" Toggle display of gutter and any virtual text
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
" Send the current line to the left tmux pane
nmap <leader>sl <cmd>lua require("jc.tmux").send_line_left()<CR>
" Send the selected text to the left tmux pane
vmap <leader>sl <cmd>lua require("jc.tmux").send_selection_left()<CR>

" Reload confiGuration
nmap <leader>rg <cmd>source $MYVIMRC<CR><cmd>echo 'Reloaded!'<CR>

" Send ^D UpArrow Enter to the left tmux pane
" Lets us Restart Rails console/server w/out switching panes
nmap <leader>rr <cmd>lua require("jc.tmux").send_keys_left({"C-d","Up","Enter"})<CR>

" lua require("jc.tmux").send_keys_left({"C-c","Up","Enter"})

" Toggle between single and double quotes for the string under the cursor
nmap <leader>rq <cmd>lua require("jc.quote-toggler").toggle_quotes()<CR>

" Run the most recently modified test
nmap <leader>rt <cmd>lua require("jc.tmux").run_mru_rails_test()<CR>

" Show tree-sitter highlight group(s) for current cursor position
map <leader>hi <cmd>TSHighlightCapturesUnderCursor<CR>

" Toggle treesitter highlighting
nmap <leader>tog <cmd>TSToggle highlight<CR>

" Execute this file
if !exists('#save_and_exec')
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
end

" save and resource current file
noremap <leader>xx :call <SID>save_and_exec()<CR>
