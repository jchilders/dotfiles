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

" <Leader>l - toggle gutter
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

" Clear previously highlighted search ("clear find")
nmap <silent> <Leader>cf <cmd>let @/ = ''<CR>

" Remap * to search word under cursor, but do not immediately advance to next match
nnoremap <silent>*
    \ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Toggle next/previous buffers
nmap <silent> <Leader><Leader> <cmd>b#<CR>

" Replace single quotes with doubles
nmap <Leader>rq <cmd>s/'/"/g<CR><cmd>let @/ = ''<CR>
nmap <Leader>rq2 <cmd>s/"/'/g<CR><cmd>let @/ = ''<CR>

" Exit terminal mode
tnoremap <Esc><Esc> <C-\><C-n>

" Show attached LSP clients for current buffer
nmap <silent> <leader>gc <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

nmap <leader>sit <cmd>Telescope treesitter<cr>

" Format current document
nmap <leader>fmt <cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<cr>

" Change (rename) symbol under cursor ('change current symbol')
nmap <silent> <Leader>ccs <cmd>lua vim.lsp.buf.rename()<cr>

