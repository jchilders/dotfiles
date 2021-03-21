" https://github.com/junegunn/vim-plug
"
" :PlugInstall to install
"
" or from the shell:
"
" nvim --headless +PlugInstall +qa
call plug#begin('~/.config/nvim/plugs')
  " {{{ syntax
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'
  " syntax }}}
 
  Plug 'neovim/nvim-lspconfig'

  " {{{ telescope.nvim
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  " telescope.nvim }}}

  Plug 'nvim-lua/completion-nvim'
  Plug 'steelsojka/completion-buffers'

  " ::: to investigate :::
  " Plug 'nvim-lua/lsp-status.nvim'
  " Plug 'romgrk/barbar.nvim'

  "  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'scrooloose/nerdcommenter'
  Plug 'adelarsq/vim-matchit'
  Plug 'AndrewRadev/splitjoin.vim'      " Smart split/join code blocks
  Plug 'tpope/vim-rails'
  Plug 'vim-test/vim-test'
  " Plug 'rcarriga/vim-ultest'

  " {{{ git
  Plug 'airblade/vim-gitgutter'
  Plug 'f-person/git-blame.nvim'
  " git }}}

  " {{{ tmux

  " K - jumps to appropriate location in man tmux
  " :make - invokes tmux source .tmux.conf and places all the errors (if any) in quicklist
  " g! - executes lines as tmux command
  " g!! - executes current line as tmux command
  Plug 'tmux-plugins/vim-tmux'
  " tmux }}}

  Plug 'mhinz/vim-startify'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'embark-theme/vim', { 'as': 'embark' }
  Plug 'wadackel/vim-dogrun'
call plug#end()
