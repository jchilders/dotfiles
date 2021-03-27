" Set s:home to current directory and add to runtimepath
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

command! -nargs=1 VimLoad exec 'source '.s:home.'/config/'.'<args>'.'.vim'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/config/'.'<args>'.'.lua'

VimLoad basic
VimLoad plugs
VimLoad airline
VimLoad colors
VimLoad autocmds

LuaLoad nvim-lspconfig
LuaLoad nvim-lspinstall

LuaLoad telescope.nvim
LuaLoad nvim-completion
LuaLoad startify

LuaLoad nvim-treesitter

" Mappings need to be last to ensure that ours take priority
VimLoad mappings
VimLoad mappings.ctrlo
LuaLoad mappings.lsp
" VimLoad mappings.ultest

" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
