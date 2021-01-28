" fzf stuff

let g:fzf_buffers_jump = 1

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_tags_command = 'ripper-tags --recursive --exclude=vendor'
" autocmd BufWritePost *.rb call system('ripper-tags -R --exclude=vendor')
