let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

command! -nargs=1 VimLoad exec 'source '.s:home.'/'.'<args>'
command! -nargs=1 LuaLoad exec 'luafile '.s:home.'/'.'<args>'

exec 'set rtp+='.s:home

" see: https://github.com/vim-ruby/vim-ruby/issues/33
" let g:ruby_host_prog = '/usr/bin/ruby'
let g:ruby_host_prog = '/Users/jchilders/.rvm/rubies/ruby-2.6.5/bin/ruby'
let g:ruby_path = join(split(glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".glob($MY_RUBY_HOME.'/lib/rubysite_ruby/*'),"\n"),',')

VimLoad init/basic.vim
VimLoad init/plugs.vim
VimLoad init/statusline.vim
VimLoad init/mappings.vim
VimLoad init/fzf.vim
" LuaLoad init/treesitter.lua

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <C-o> :call LanguageClient_contextMenu()<CR>

let g:LanguageClient_serverCommands = {
	\ 'ruby': ['~/.rvm/gems/jruby-1.7.27/bin/solargraph', 'stdio'],
	\ }
 
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
 
" Set completeopt to have a better completion experience
" set completeopt=menuone,noinsert,noselect
 
" Avoid showing extra message when using completion
" set shortmess+=c
" 
" lua vim.api.nvim_command [[autocmd CursorHold   * lua require'utils'.blameVirtText()]]
" lua vim.api.nvim_command [[autocmd CursorMoved  * lua require'utils'.clearBlameVirtText()]]
" lua vim.api.nvim_command [[autocmd CursorMovedI * lua require'utils'.clearBlameVirtText()]]
" 
" `vim --cmd 'profile start initvim-profiling.result' --cmd 'profile! file
