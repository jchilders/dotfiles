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
  " astronauta provides autoloading of lua configs from:
  "   ftplugin/*.lua
  "   after/ftplugin/*.lua
  "   lua/plugin/*.lua
  Plug 'tjdevries/astronauta.nvim'

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
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " telescope.nvim }}}

  Plug 'hrsh7th/nvim-compe'
  Plug 'cohama/lexima.vim'
  
  " adds vscode-like pictograms
  Plug 'onsails/lspkind-nvim'
  Plug 'kyazdani42/nvim-web-devicons'

  " ::: to investigate :::
  " Plug 'lambdalisue/gina.vim'
  " Plug 'romgrk/barbar.nvim'

  " Smart split/join code blocks
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'b3nj5m1n/kommentary'

  " {{{ ruby/rails
  " Plug 'tpope/vim-rails'
  " Plug 'vim-test/vim-test'
  " Plug 'rcarriga/vim-ultest'
  " ruby/rails }}}

  " {{{ syntax
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'
  Plug 'LnL7/vim-nix'
  " syntax }}}
 
  " {{{ git
  Plug 'airblade/vim-gitgutter'
  " ::: to investigate :::
  " " git add/status/discard. looks good.
  " git }}}

  " {{{ tmux
  " K - jumps to appropriate location in man tmux
  " :make - invokes tmux source .tmux.conf and places all the errors (if any) in quicklist
  " g! - executes lines as tmux command
  " g!! - executes current line as tmux command
  Plug 'tmux-plugins/vim-tmux'
  " tmux }}}

  " {{{ misc
  " :Bdelete/Bwipeout - remove buffers w/out affecting window layout
  Plug 'famiu/bufdelete.nvim'
  " :<line number> 'peeks' the line before you hit enter
  Plug 'nacro90/numb.nvim'
  Plug 'mhinz/vim-startify'
  " misc }}}

  " colorschemes/themes
  " Plug 'wadackel/vim-dogrun'
  Plug 'folke/tokyonight.nvim'

  " statusline
  Plug 'famiu/feline.nvim'

  " fix performance probs w/ CursorHold
  " can test is by holding down j/k while current buffer is connected to
  " Solargraph
  Plug 'antoinemadec/FixCursorHold.nvim'
call plug#end()
