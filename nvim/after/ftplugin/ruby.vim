set softtabstop=2
set shiftwidth=2

nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>
nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>rp oputs "-=-=> ##{__method__} -> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> ##{__method__} -> "<ESC>i

" run most recently modified file in spec/ directory in tmux pane to the left
nnoremap <silent> <Leader>rt <cmd>call RunMostRecentlyModifiedSpec()<CR>

" TODO: make it look for *_spec.rb files to make sure it doesn't try and run
" non-spec files, e.g. spec_helper.rb
" TODO: Save current buffer if modified
function! g:RunMostRecentlyModifiedSpec()
  let find_str = "find spec -type f -exec stat -f '%a %N' {} \\\; | sort -r | head -1 | awk \'{print \\$NF}'"
  let cmd_str = "rspec \\$(".find_str.")"
  let send_cmd_str = "tmux send-keys -t left -l \"".cmd_str."\""
  call system(send_cmd_str)
  let send_ctrlm_str = "tmux send-keys -t left 'C-m'"
  call system(send_ctrlm_str)
endfunction
" delfunction g:RunMostRecentlyModifiedSpec

" augroup ruby
  " autocmd!
  " TODO: Add ability to toggle on/off
  " autocmd BufWritePost *.rb call RunMostRecentlyModifiedSpec()
" augroup END
