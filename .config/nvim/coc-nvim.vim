" BEGIN coc-nvim stuff

" Currently, it takes some work to get coc to work with vim. This is what I
" did:
"
" 1. :CocInstall coc-solargraph
" 2. :CocInstall coc-lists
" 3. :CocInstall coc-git
" 4. solargraph bundle (from shell)
" 5. :CocConfig " edit coc-settings.json
" 6. add:
"    "git.enableGutters": true,
"    "git.addGBlameToBufferVar": true
" 7. :CocInstall coc-json

" :help coc-interface
"
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window
nnoremap <silent> <space>K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use <leader>C to open coc config
nnoremap <silent> <space>C :CocConfig<CR>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol (function, instance var, etc.) in current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" git status
nnoremap <silent> <space>gs  :<C-u>CocList --normal gstatus<CR>
" add (stage) current chuck
nnoremap <silent> <space>ga  :<C-u>CocCommand git.chunkStage<CR>
" reset current chuck to stage cache
nnoremap <silent> <space>gu  :<C-u>CocCommand git.chunkUndo<CR>
" show chunk diff at current position
nmap <space>gd <Plug>(coc-git-chunkinfo)

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

nmap <space>cw  <Plug>(coc-rename)
nmap <space>dn  <Plug>(coc-diagnostic-next)
nmap <space>dp  <Plug>(coc-diagnostic-prev)
