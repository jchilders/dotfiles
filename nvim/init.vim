let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

command! -nargs=1 VimLoad exec 'source '.s:home.'/plug-configs/'.'<args>'.'.vim'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/plug-configs/'.'<args>'.'.lua'

VimLoad basic
VimLoad plugs
VimLoad statusline

VimLoad nvim-compe
VimLoad fzf

LuaLoad telescope.nvim
LuaLoad nvim-lspconfig

VimLoad neoterm

VimLoad treesitter
LuaLoad treesitter

" needs to be last to make sure ours take priority
VimLoad mappings

" https://youtu.be/YCy3wCyz4Vg?t=162
" set cot=menuone,noinsert,noselect shm+=c

" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
