" Fix slow loading
" see: https://github.com/vim-ruby/vim-ruby/issues/33
" let g:ruby_host_prog = '/usr/bin/ruby'
" let g:ruby_host_prog = '/Users/jchilders/.rvm/rubies/ruby-2.6.5/bin/ruby'
" let g:ruby_path = join(split(glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".glob($MY_RUBY_HOME.'/lib/rubysite_ruby/*'),"\n"),',')

nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>
nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>rp oputs "-=-=> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> "<ESC>i

" Run current spec in adjacent tmux pane
nnoremap <Leader>rt <cmd>w<CR><cmd>call RunSpec()<CR> " run current line
nnoremap <Leader>rT <cmd>w<CR><cmd>call RunSpec()<CR> " run entire spec

" TODO: Fix. Not using Vimux any longer
function! RunSpec()
  let curr_line = line(".")
  let curr_file = bufname("%")
  if match(curr_file, '_spec.rb$') == -1 
    let curr_file = system("alt " . curr_file)
    call VimuxRunCommand("rspec " . curr_file)
  else
    call VimuxRunCommand("rspec " . curr_file . ":" . curr_line)
  endif
endfunction
