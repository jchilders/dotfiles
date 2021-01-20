let mapleader = ","

" use jk for esc
imap jk <Esc>
vmap jk <Esc>

nnoremap <silent> <Leader>w :wa<CR>
nnoremap <silent> <Leader>W :wqa<CR>

" Ctrl-C to copy visual selection to pasteboard
vmap <silent> <C-c> "+y

" Change all occurences of the current word
nnoremap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cw y:%s/<C-r>"/<C-r>"

" use <Leader>L to toggle the displaying relative line number
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc
nnoremap <Leader>l :call g:ToggleNuMode()<cr>

" Clear previously highlighted search ("clear find")
nnoremap <silent> <Leader>cf :let @/ = ''<CR>

" Toggle next/previous buffers
nnoremap <silent> <Leader><Leader> :b#<CR>

" Replace single quotes with doubles
nnoremap <Leader>rq :s/'/"/g<CR>:let @/ = ''<CR>

" LSP

" Show attached LSP clients for current buffer
nnoremap <silent> <leader>gc :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

" Change (rename) symbol under cursor ('change current symbol')
nnoremap <silent> <Leader>ccs :lua vim.lsp.buf.rename()<cr>

nnoremap <C-o>f <cmd>Telescope find_files<cr>
nnoremap <C-o>b <cmd>Telescope buffers<cr>
nnoremap <C-o>t <cmd>Telescope current_buffer_tags<cr>
nnoremap <C-o>s <cmd>Telescope git_status<cr>
" 'find symbol'
nnoremap <C-o>r <cmd>Telescope lsp_references<cr>
nnoremap <leader>sit <cmd>Telescope treesitter<cr>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <silent> <c-p> <Plug>(completion_trigger)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
