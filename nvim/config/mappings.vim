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
    " TODO: Get this to work with virutal text not added by the LSP.
    " See :h nvim_buf_set_virtual_text
    lua vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = false})
  else
    set number
    set relativenumber
    set signcolumn=yes
    lua vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = true})
  endif
endfunc
nmap <leader>g <cmd>call g:ToggleGutter()<cr>

command GitBlame call GitBlameToggle()

" Remap * to search word under cursor, but do not immediately advance to next match
nnoremap <silent>*
    \ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <silent> <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

" Quickly toggle next/previous buffers
nmap <silent> <leader><leader> <cmd>b#<CR>

" For moving quickly up and down,
" Goes to the first line above/below that isn't whitespace
" Thanks to: http://vi.stackexchange.com/a/213
nnoremap gj :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
nnoremap gk :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

nmap <leader>rv <cmd>source $MYVIMRC<CR><cmd>echo 'Reloaded!'<CR>

" Replace single quotes with doubles
nmap <leader>rq <cmd>s/'/"/g<CR><cmd>let @/ = ''<CR>
nmap <leader>rq2 <cmd>s/"/'/g<CR><cmd>let @/ = ''<CR>

" Show attached LSP clients for current buffer
nmap <silent> <leader>lc <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

nmap <leader>sit <cmd>Telescope treesitter<cr>

" Format current document
nmap <leader>fmt <cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<cr>

" Change (rename) symbol under cursor ('change current symbol')
nmap <silent> <leader>ccs <cmd>lua vim.lsp.buf.rename()<cr>

map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
