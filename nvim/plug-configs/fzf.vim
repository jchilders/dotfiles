" fzf stuff

let g:fzf_buffers_jump = 1

nnoremap <C-p> :Files<CR>
nnoremap <silent> <Leader>b  :Buffers<CR>
nnoremap <silent> <Leader>st :GFiles?<CR>
nnoremap <silent> <Leader>h  :History<CR>

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ripper-tags --recursive --exclude=vendor'
" autocmd BufWritePost *.rb call system('ripper-tags -R --exclude=vendor')
