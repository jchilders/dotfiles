" Set s:home to current directory and add to runtimepath
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

command! -nargs=1 VimLoad exec 'source '.s:home.'/config/'.'<args>'.'.vim'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/config/'.'<args>'.'.lua'

VimLoad basic
VimLoad plugs
VimLoad looknfeel
VimLoad autocmds

" git related
LuaLoad git-blame

" VimLoad neoterm
" LuaLoad neoterm
LuaLoad nvim-lspconfig
LuaLoad telescope.nvim
LuaLoad nvim-completion
LuaLoad startify

" VimLoad treesitter
" LuaLoad treesitter

" Mappings need to be last to ensure that ours take priority
VimLoad mappings
VimLoad mappings.fzf
VimLoad mappings.ultest

" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
