let mapleader = ","

" use jk for esc
imap jk <Esc>
vmap jk <Esc>

" Fix slow startup when loading ruby files
nnoremap <silent> <Leader>w :wa<CR>
nnoremap <silent> <Leader>W :wqa<CR>

" Ctrl-C to copy visual selection to pasteboard
vmap <silent> <C-c> "+y

" Change all occurences of the current word
nnoremap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cw y:%s/<C-r>"/<C-r>"

function! VimuxSlime()
  call VimuxOpenRunner()
  call VimuxSendText(@v)
endfunction

" If text is selected, save it in the v buffer and send that buffer to tmux
vmap <silent> <Leader>vs "vy :call VimuxSlime()<CR>

" Send current line (technicaly paragraph) to adjacent tmux pane
nmap <silent> <Leader>vs vip<Leader>vs<CR>

" use <Leader>L to toggle the displaying relative line number
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc
nnoremap <Leader>l :call g:ToggleNuMode()<cr>

" Clear previously highlighted search ('clear find')
nnoremap <silent> <Leader>cf :let @/ = ''<CR>

" Toggle next/previous buffers
nnoremap <silent> <Leader><Leader> :b#<CR>

" Replace single quotes with doubles
nnoremap <Leader>rq :s/'/"/g<CR>:let @/ = ''<CR>

" lsp
imap <C-o> <Plug>(completion_trigger)

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
