nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>
nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>rp oputs "-=-=> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> "<ESC>i

autocmd BufWritePost *.rb silent! !ripper-tags -R
