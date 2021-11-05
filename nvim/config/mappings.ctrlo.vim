" This file defines the mappings used to open files based upon fuzzy finding
" by directory prefix, content search, or symbol search.
"
" All are prefixed by <C-o>

function! g:FuzzyGivenDir(dir)
  return luaeval("require('telescope.builtin').find_files({search_dirs = {_A.dir}})", {'dir': a:dir})
endfunc

nmap <silent> <C-o>b <cmd>Telescope buffers<CR>

" rails
nmap <silent> <C-o>m <cmd>call FuzzyGivenDir('app/models')<CR>
nmap <silent> <C-o>c <cmd>call FuzzyGivenDir('app/controllers')<CR>
nmap <silent> <C-o>v <cmd>call FuzzyGivenDir('app/views')<CR>

" little f -> find string under cursor in workspace
nmap <silent> <C-o>f <cmd>Telescope grep_string<CR>
" big F ->  find user entered string in project
nmap <silent> <C-o>F <cmd>Telescope live_grep<CR>

" {{{ git }}}
nmap <silent> <C-o>gb <cmd>Telescope git_branches<CR>
nmap <silent> <C-o>gh <cmd>Telescope git_bcommits<CR>
nmap <silent> <C-o>gs <cmd>Telescope git_status<CR>

" {{{ opening files }}}
" little o -> open workspace file
nmap <silent> <C-o>o <cmd>Telescope git_files<CR>
" Big O -> ALLLLL files: don't respect .gitignore, search hidden files
nmap <silent> <C-o>O <cmd>lua require('telescope.builtin').find_files({ no_ignore = true })<CR>

" {{ navigation }}
" little r -> Search for LSP references to word under cursor
nmap <silent> <C-o>r <cmd>Telescope lsp_references<CR>
" little t -> Search list of symbols (tags) for current document
nmap <silent> <C-o>t <cmd>Telescope lsp_document_symbols<CR>
" Big T -> Search list of symbols (tags) from entire workspace
nmap <silent> <C-o>T <cmd>Telescope lsp_workspace_symbols<CR>

" {{{ other }}}
nmap <silent> <C-o>q <cmd>Telescope quickfix<CR>
