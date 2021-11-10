setlocal textwidth=120

setlocal shiftwidth=2
setlocal formatoptions-=o

" override <Leader>sl to use the nvim-luadev plugin
nmap <leader>sl <Plug>(Luadev-RunLine)<cr>
" run lua code over a movement or text object
nmap <leader>ss <Plug>(Luadev-Run)
vmap <leader>ss <Plug>(Luadev-Run)<cr>
