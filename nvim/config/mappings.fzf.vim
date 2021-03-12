" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>
function! g:FuzzyGivenDir(dir)
  let find_cmd = 'fd --type=file . %s'
  let cmd = printf(find_cmd, shellescape(a:dir))
  call fzf#run({'source': cmd, 'sink': 'e', 'options': ['--preview', 'bat -f {-1}']})
endfunc

nmap <silent> <C-o>b <cmd>Buffers<cr>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>f <cmd>Files<cr>
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>r <cmd>lua vim.lsp.buf.references()<cr>
nmap <silent> <C-o>t <cmd>Tags<cr>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
