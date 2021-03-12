" https://github.com/junegunn/vim-plug
"
" :PlugInstall to install
"
" or from the shell:
"
" nvim --headless +PlugInstall +qa
call plug#begin('~/.config/nvim/plugs')
  Plug 'adelarsq/vim-matchit'
  Plug 'airblade/vim-gitgutter'
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'

  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/diagnostic-nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'kassio/neoterm'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'vim-test/vim-test'
  Plug 'rcarriga/vim-ultest'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'embark-theme/vim', { 'as': 'embark' }

  Plug 'AndrewRadev/splitjoin.vim'      " Smart split/join code blocks
call plug#end()
