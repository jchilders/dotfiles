if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" :PlugInstall to install new
" :PlugUpdate to get lastest
" :PlugClean to remove old/unused plugins
call plug#begin('~/.config/nvim/plugs')
  Plug 'tomasiser/vim-code-dark'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release', 'do': { -> coc#util#install()}}
  Plug 'neovim/nvim-lsp'
  " Plug 'airblade/vim-gitgutter'
  Plug 'benmills/vimux' " Pipe to tmux
  " Plug 'ctrlpvim/ctrlp.vim'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'elzr/vim-json'
  " Plug 'ervandew/supertab'
  " Plug 'neomake/neomake'
  Plug 'scrooloose/nerdcommenter'
  Plug 'vim-ruby/vim-ruby'
  " Plug 'tpope/vim-fugitive' " :Gblame
call plug#end()
