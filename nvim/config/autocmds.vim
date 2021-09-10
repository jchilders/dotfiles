augroup Autogroup
  autocmd!

  autocmd BufRead,BufNewFile *.jbuilder set ft=ruby 
  autocmd BufRead,BufNewFile *.tmux set filetype=tmux
  autocmd BufRead,BufNewFile *.json set ft=javascript 
  autocmd BufRead,BufNewFile *.jsx.erb set ft=javascript 
  autocmd BufRead,BufNewFile Brewfile set ft=ruby 
augroup END

" speed up scrolling
augroup syntaxSyncMinLines
  autocmd!
  autocmd Syntax * syntax sync minlines=2000
augroup END
