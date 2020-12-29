" LSP Begin
"
" Test that LSP is attached to current buffer:
"   :lua print(vim.inspect(vim.lsp.buf_get_clients()))
"
" Restart LSP & reload buffer:
"   :lua vim.lsp.stop_client(vim.lsp.get_active_clients())
"   :edit
"
" Show omnifunc:
"   :verbose set omnifunc?
"
" let g:solargraph_location = system("which solargraph")
" let g:LanguageClient_serverCommands = {
    " \ 'ruby': ['/Users/jchilders/.rvm/rubies/ruby-2.6.5/bin/solargraph', 'stdio'],
    " \ }
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_virtualTextPrefix = ''
" let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

" function LC_maps()
	" if has_key(g:LanguageClient_serverCommands, &filetype)
		" nmap <silent><C-l> <Plug>(lcn-menu)
		" " nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
		" nmap <silent>K <Plug>(lcn-hover)
		" " nnoremap <silent> gd :call uanguageClient#textDocument_definition()<CR>
		" nmap <silent> gd <Plug>(lcn-definition)
		" nnoremap <silent> lcr :call LanguageClient#textDocument_rename()<CR>
	" endif
" endfunction
" autocmd FileType * call LC_maps()

" lua vim.api.nvim_command [[autocmd CursorHold   * lua require'utils'.blameVirtText()]]
" lua vim.api.nvim_command [[autocmd CursorMoved  * lua require'utils'.clearBlameVirtText()]]
" lua vim.api.nvim_command [[autocmd CursorMovedI * lua require'utils'.clearBlameVirtText()]]

nnoremap <silent> lgc :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>

" nvim/lua/lsp/init.lua
" lua require("lsp")

" setlocal omnifunc=v:lua.vim.lsp.omnifunc
