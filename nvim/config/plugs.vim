" The configurations for these are in lua/plugin.
"
" Uses vim-plug: https://github.com/junegunn/vim-plug
"
"   :PlugInstall to install
"
" or from the shell:
"
"   nvim --headless +PlugInstall +qa
call plug#begin('~/.local/share/nvim/plugins')
  " {{{ syntax
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'
  " syntax }}}
 
  " {{{ lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'glepnir/lspsaga.nvim'
  " lsp }}}

  " {{{ treesitter
  " Problems?
  "   :checkhealth nvim_treesitter
  "   :TSHighlightCapturesUnderCursor
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  " treesitter }}}

  " {{{ telescope.nvim
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " telescope.nvim }}}

  " :<line number> 'peeks' the line before you hit enter
  Plug 'nacro90/numb.nvim'

  " astronauta provides autoloading of lua configs from:
  "   ftplugin/*.lua
  "   after/ftplugin/*.lua
  "   lua/plugin/*.lua
  Plug 'tjdevries/astronauta.nvim'

  " Smart split/join code blocks
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'scrooloose/nerdcommenter'

  Plug 'nvim-lua/completion-nvim'
  Plug 'steelsojka/completion-buffers'

  " adds vscode-like pictograms
  Plug 'onsails/lspkind-nvim'
  Plug 'kyazdani42/nvim-web-devicons'

  " ::: to investigate :::
  " " git add/status/discard. looks good.
  " Plug 'lambdalisue/gina.vim'
  " Plug 'romgrk/barbar.nvim'

  " {{{ ruby/rails
  " Plug 'tpope/vim-rails'
  " Plug 'vim-test/vim-test'
  " Plug 'rcarriga/vim-ultest'
  " ruby/rails }}}

  " {{{ git
  Plug 'airblade/vim-gitgutter'
  " git }}}

  " {{{ tmux
  " K - jumps to appropriate location in man tmux
  " :make - invokes tmux source .tmux.conf and places all the errors (if any) in quicklist
  " g! - executes lines as tmux command
  " g!! - executes current line as tmux command
  Plug 'tmux-plugins/vim-tmux'
  " tmux }}}

  Plug 'mhinz/vim-startify'
  " colorschemes/themes
  Plug 'wadackel/vim-dogrun'
  Plug 'folke/tokyonight.nvim'
  " statusline
  Plug 'famiu/feline.nvim'
call plug#end()
