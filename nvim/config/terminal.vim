
let t:rails_console_winid = -1
function! s:rails_console() abort
  if t:rails_console_winid == -1
    new
    wincmd J
    call nvim_win_set_height(0, 15)
    set winfixheight
    set nonu
    set nornu
    terminal rails console
    let t:rails_console_winid = win_getid()
  else
    " let type = win_gettype(t:rails_console_winid)
    if win_gettype(t:rails_console_winid) == "unknown"
      let t:rails_console_winid = -1
      call <SID>rails_console()
    else
      call win_gotoid(t:rails_console_winid)
      execute ':normal! A'
    endif
  endif
endfunction

" Make a small terminal at the bottom of the screen.
" nmap <leader>rc <cmd>call <SID>open_rails_console()<cr>
nmap <leader>rc <cmd>call <SID>rails_console()<cr>

" Append current line to rails console
" :call append(0, g:some_var)

