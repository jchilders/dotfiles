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

" <Leader>l - toggle showing relative line numbers in the gutter
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nornu
    set nonu
  else
    set nu
    set rnu
  endif
endfunc
nmap <Leader>l <cmd>call g:ToggleNuMode()<cr>

" Clear previously highlighted search ("clear find")
nmap <silent> <Leader>cf <cmd>let @/ = ''<CR>

" Toggle next/previous buffers
nmap <silent> <Leader><Leader> <cmd>b#<CR>

" Replace single quotes with doubles
nmap <Leader>rq <cmd>s/'/"/g<CR><cmd>let @/ = ''<CR>
nmap <Leader>rq2 <cmd>s/"/'/g<CR><cmd>let @/ = ''<CR>

" LSP

" Show attached LSP clients for current buffer
nmap <silent> <leader>gc <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

" Change (rename) symbol under cursor ('change current symbol')
nmap <silent> <Leader>ccs <cmd>lua vim.lsp.buf.rename()<cr>

nmap <C-o>b <cmd>Telescope buffers<cr>
nmap <C-o>f <cmd>Telescope find_files<cr>
nmap <C-o>t <cmd>Telescope current_buffer_tags<cr>
nmap <C-o>s <cmd>Telescope git_status<cr>
nmap <C-o>r <cmd>Telescope lsp_references<cr>
nmap <leader>sit <cmd>Telescope treesitter<cr>

nmap<Leader>rl <Plug>(Luadev-Runline)<cr>
vmap<Leader>rb <Plug>(Luadev-Run)<cr>
