" Run specs/tests
nmap <silent> <leader>tf <Plug>(ultest-run-file)
nmap <silent> <leader>tF <Plug>(ultest-stop-file)
nmap <silent> <leader>tn <Plug>(ultest-run-nearest)
nmap <silent> <leader>tN <Plug>(ultest-stop-nearest)
nmap <silent> <leader>to <Plug>(ultest-output-show)
nmap <silent> <leader>ts :TestSuite<CR>
" test results
nmap <silent> <leader>tr <Plug>(ultest-summary-toggle)

" Next failure
nmap ]t <Plug>(ultest-next-fail)
" Previous failure
nmap [t <Plug>(ultest-prev-fail)

