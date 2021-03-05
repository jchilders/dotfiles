" Start terminal windows in insert mode
autocmd TermOpen * startinsert

" Send visually selected text to terminal
vmap <silent> <Leader>vs :TREPLSendSelection<CR>

" Send current line to terminal
nmap <silent> <Leader>vs :TREPLSendLine<CR>

" gxip to send current paragraph/block to terminal
nmap gx <Plug>(neoterm-repl-send)

let g:neoterm_callbacks = {}
function! g:neoterm_callbacks.before_new()
	if winwidth('.') > 100
		let g:neoterm_default_mod = 'botright vertical'
	else
		let g:neoterm_default_mod = 'botright'
	end
endfunction
