" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>

function! g:FuzzyGivenDir(dir)
  return luaeval("require('telescope.builtin').find_files({search_dirs = {_A.dir}})", {'dir': a:dir})
endfunc
" luaeval("require('telescope.builtin').find_files({ no_ignore = true })")

" {{{ opening files }}}
nmap <silent> <C-o>b <cmd>Telescope buffers<CR>
nmap <silent> <C-o>f <cmd>Telescope git_files<CR>
" Big F -> ALLLLL files: don't respect .gitignore, search hidden files
nmap <silent> <C-o>F <cmd>lua require('telescope.builtin').find_files({ no_ignore = true })<CR>

" rails
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

" {{{ git }}}
nmap <silent> <C-o>gb <cmd>Telescope git_branches<CR>
nmap <silent> <C-o>gh <cmd>Telescope git_bcommits<CR>
nmap <silent> <C-o>gs <cmd>Telescope git_status<CR>

" {{{ searching }}}
" little r -> Search for LSP references to word under cursor
nmap <silent> <C-o>r <cmd>Telescope lsp_references<CR>
" little s -> search workspace for string under cursor
nmap <silent> <C-o>s <cmd>Telescope grep_string<CR>
" little t -> Search list of symbols (tags) from current document
nmap <silent> <C-o>t <cmd>Telescope lsp_document_symbols<CR>
" Big T -> Search list of symbols (tags) from current workspace
nmap <silent> <C-o>T <cmd>Telescope lsp_workspace_symbols<CR>

" {{{ other }}}
nmap <silent> <C-o>q <cmd>Telescope quickfix<CR>
