" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>

function! g:FuzzyGivenDir(dir)
  return luaeval("require('telescope.builtin').find_files({search_dirs = {_A.dir}})", {'dir': a:dir})
endfunc

nmap <silent> <C-o>b <cmd>Telescope buffers<CR>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>f <cmd>Telescope git_files<CR>
" Big F -> ALLLLL files: don't respect .gitignore, search hidden files
nmap <silent> <C-o>F <cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files<CR>
nmap <silent> <C-o>gb <cmd>Telescope git_branches<CR>
" <g>rep <s>tring
nmap <silent> <C-o>gs <cmd>Telescope git_status<CR>
nmap <silent> <C-o>s <cmd>Telescope grep_string<CR>
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>q <cmd>Telescope quickfix<CR>
" Little r -> Current document symbols
nmap <silent> <C-o>r <cmd>Telescope lsp_document_symbols<CR>
nmap <silent> <C-o>s <cmd>Telescope grep_string<CR>
" Big R -> All workplace symbols
nmap <silent> <C-o>R <cmd>Telescope lsp_workspace_symbols<CR>
nmap <silent> <C-o>t <cmd>Telescope current_buffer_tags<CR>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

" Not currently used
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Telescope commands:
" lsp_document_symbols: lists methods and classes defined in current buffer
"   - works on controllers, not specs
" lsp_document_diagnostics: buffer linter results in telescope window
" lsp_dynamic_workspace_symbols: all symbols for entire workspace
" lsp_workspace_symbols: all symbols for entire workspace
" lsp_workspace_diagnostics: workspace linter results in telescope window
