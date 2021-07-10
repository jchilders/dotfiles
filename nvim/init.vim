" Much inspiration/outright theft of this was taken from:
"   https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/init.lua
"
" We use tjdevries/astronauta.nvim to load plugin-specific configurations.
" This allows configurations to be automatically loaded from the following
" locations:
"
"   ./ftplugin/*.lua
"   ./after/ftplugin/*.lua
"   ./lua/plugin/*.lua - most things are here
"   ./after/plugin/*.vim

" Set s:home to current directory and add to runtimepath
" This will -- and should -- eventually be removed (...) as configs are moved
" into vim standard dirs. 
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

command! -nargs=1 VimLoad exec 'source '.s:home.'/config/'.'<args>'.'.vim'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/config/'.'<args>'.'.lua'

VimLoad basic
VimLoad plugs
VimLoad autocmds
VimLoad colors

" Mappings need to be last to ensure that ours take priority
VimLoad mappings
VimLoad mappings.ctrlo

" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
