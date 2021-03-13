"   Plugin keymaps will all be found in `./after/plugin/*`

let mapleader = ","

" use jk for esc
imap jk <Esc>
vmap jk <Esc>

nmap <silent> <Leader>w <cmd>wa<CR>
nmap <silent> <Leader>W <cmd>wqa<CR>

" Ctrl-C to copy visual selection to pasteboard
vmap <silent> <C-c> "+y

" Change all occurences of the current word
nmap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vmap <Leader>cw y:%s/<C-r>"/<C-r>"

" <Leader>l - toggle gutter. Use when you need to copy text to pasteboard, but don't want
" extra stuff getting in the way
function! g:ToggleGutter()
  if(&rnu == 1)
    set nornu
    set nonu
    set signcolumn=no
  else
    set nu
    set rnu
    set signcolumn=yes
  endif
endfunc
nmap <Leader>l <cmd>call g:ToggleGutter()<cr>

" Remap * to search word under cursor, but do not immediately advance to next match
nnoremap <silent>*
    \ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

" Toggle next/previous buffers
nmap <silent> <Leader><Leader> <cmd>b#<CR>

" For moving quickly up and down,
" Goes to the first line above/below that isn't whitespace
" Thanks to: http://vi.stackexchange.com/a/213
nnoremap gj :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
nnoremap gk :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

" Replace single quotes with doubles
nmap <Leader>rq <cmd>s/'/"/g<CR><cmd>let @/ = ''<CR>
nmap <Leader>rq2 <cmd>s/"/'/g<CR><cmd>let @/ = ''<CR>

" Show attached LSP clients for current buffer
nmap <silent> <leader>gc <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

nmap <leader>sit <cmd>Telescope treesitter<cr>

" Format current document
nmap <leader>fmt <cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<cr>

" Change (rename) symbol under cursor ('change current symbol')
nmap <silent> <Leader>ccs <cmd>lua vim.lsp.buf.rename()<cr>

