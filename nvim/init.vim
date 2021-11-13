" Set s:home to current directory and add to runtimepath
" This will -- and should -- eventually be removed (...) as configs are moved
" into vim standard dirs. 
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set runtimepath+='.s:home
exec 'set runtimepath+='.s:home.'/lua'

command! -nargs=1 VimLoad exec 'source '.s:home.'/config/'.'<args>'.'.vim'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/config/'.'<args>'.'.lua'

VimLoad basic
VimLoad plugs
VimLoad autocmds
VimLoad colors

" Mappings need to be last to ensure that ours take priority
VimLoad mappings

" let g:coq_settings = { 'auto_start': v:true | 'shut-up' }
let g:coq_settings = { 'auto_start': v:true }

LuaLoad init
LuaLoad mappings.ctrlo


" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
