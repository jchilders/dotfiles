" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>

function! g:FuzzyGivenDir(dir)
  return luaeval("require('telescope.builtin').find_files({search_dirs = {_A.dir}})", {'dir': a:dir})
endfunc

nmap <silent> <C-o>b <cmd>Telescope buffers<cr>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>f <cmd>Telescope find_files theme=get_dropdown<cr>
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>r <cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>
nmap <silent> <C-o>s <cmd>Telescope git_status<cr>
nmap <silent> <C-o>t <cmd>Telescope current_buffer_tags theme=get_dropdown<cr>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

nmap <silent> <leader>[[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nmap <silent> <leader>]] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
