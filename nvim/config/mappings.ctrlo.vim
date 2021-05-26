" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>

function! g:FuzzyGivenDir(dir)
  return luaeval("require('telescope.builtin').find_files({search_dirs = {_A.dir}})", {'dir': a:dir})
endfunc

" {{{ opening files }}}
nmap <silent> <C-o>b <cmd>Telescope buffers<CR>
nmap <silent> <C-o>f <cmd>Telescope git_files<CR>
" Big F -> ALLLLL files: don't respect .gitignore, search hidden files
nmap <silent> <C-o>F <cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files<CR>
" rails
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

" {{{ git }}}
nmap <silent> <C-o>gb <cmd>Telescope git_branches<CR>
nmap <silent> <C-o>gh <cmd>Telescope git_bcommits<CR>
nmap <silent> <C-o>gs <cmd>Telescope git_status<CR>

" {{{ searching }}}
" little r -> LSP references to word under cursor
nmap <silent> <C-o>r <cmd>Telescope lsp_references<CR>
" Big R -> All workplace symbols
nmap <silent> <C-o>R <cmd>Telescope lsp_workspace_symbols<CR>
" little s -> search buffer for (LSP) references to symbol under cursor
nmap <silent> <C-o>s <cmd>Telescope grep_string<CR>
" Big S -> search workspace for word under cursor
nmap <silent> <C-o>S <cmd>Telescope grep_string<CR>
nmap <silent> <C-o>t <cmd>Telescope current_buffer_tags<CR>

" {{{ other }}}
nmap <silent> <C-o>q <cmd>Telescope quickfix<CR>
