augroup Autogroup
  autocmd!

  autocmd BufRead,BufNewFile *.jbuilder set ft=ruby 
  autocmd BufRead,BufNewFile *.tmux set filetype=tmux
  autocmd BufRead,BufNewFile *.json set ft=javascript 
  autocmd BufRead,BufNewFile *.jsx.erb set ft=javascript 
augroup END
