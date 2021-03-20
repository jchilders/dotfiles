" https://github.com/junegunn/vim-plug
"
" :PlugInstall to install
"
" or from the shell:
"
" nvim --headless +PlugInstall +qa
call plug#begin('~/.config/nvim/plugs')
  " Syntax highlighters
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'
 
  Plug 'neovim/nvim-lspconfig'

  " Telescope
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-web-devicons'

  Plug 'nvim-lua/completion-nvim'
  Plug 'steelsojka/completion-buffers'

  " ::: to investigate :::
  " Plug 'nvim-lua/lsp-status.nvim'
  " Plug 'romgrk/barbar.nvim'

"  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"  Plug 'kassio/neoterm'
"  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'

  " K - jumps to appropriate location in man tmux
  " :make - invokes tmux source .tmux.conf and places all the errors (if any) in quicklist
  " g! - executes lines as tmux command
  " g!! - executes current line as tmux command
  Plug 'tmux-plugins/vim-tmux'

  Plug 'vim-test/vim-test'
  Plug 'rcarriga/vim-ultest'

  Plug 'mhinz/vim-startify'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'embark-theme/vim', { 'as': 'embark' }
  Plug 'wadackel/vim-dogrun'

  Plug 'scrooloose/nerdcommenter'
  Plug 'AndrewRadev/splitjoin.vim'      " Smart split/join code blocks
  Plug 'adelarsq/vim-matchit'
  Plug 'airblade/vim-gitgutter'
call plug#end()
