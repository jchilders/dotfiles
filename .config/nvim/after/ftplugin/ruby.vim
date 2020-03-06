" Run current spec in adjacent tmux pane
nnoremap <Leader>rt :w<CR>:call RunSpec()<CR> " run current line
nnoremap <Leader>rT :w<CR>:call RunSpec()<CR> " run entire spec
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

" Ruby-specific stuff
nnoremap <Leader>rs :sp ~/temp/scratch.rb<CR>
nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>rp oputs "-=-=> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> "<ESC>i

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ripper-tags --recursive'
