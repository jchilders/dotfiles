" https://github.com/junegunn/vim-plug
"
"   :PlugInstall to install
"
" or from the shell:
"
"   nvim --headless +PlugInstall +qa

call plug#begin('~/.config/nvim/plugs')
  " {{{ syntax
  Plug 'cespare/vim-toml'
  Plug 'darfink/vim-plist'
  " syntax }}}
 
  " {{{ lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'glepnir/lspsaga.nvim'
  " adds vscode-like pictograms
  Plug 'onsails/lspkind-nvim'
  " lsp }}}

  " {{{ telescope.nvim
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  " telescope.nvim }}}

  " :<line number> 'peeks' the line before you hit enter
  Plug 'nacro90/numb.nvim'

  " astronauta provides:
  "   1) Keymaps in lua
  "     local nnoremap = vim.keymap.nnoremap
  "     nnoremap { '<leader>hello', function() print("Hello world, from lua") end }
  "   2) autoload lua cfgs from ftplugin/*.lua, after/ftplugin/*.lua, or
  " lua/plugin/*.lua
  Plug 'tjdevries/astronauta.nvim'

  " Smart split/join code blocks
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'andymass/vim-matchup'
  Plug 'scrooloose/nerdcommenter'

  Plug 'nvim-lua/completion-nvim'
  " Plug 'steelsojka/completion-buffers'

  " ::: to investigate :::
  " git add/status/discard. looks good.
  " Plug 'lambdalisue/gina.vim'
  " Plug 'romgrk/barbar.nvim'

  " {{{ treesitter
  " Problems?
  "   :checkhealth nvim_treesitter
  "   :TSHighlightCapturesUnderCursor
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  " treesitter }}}

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
  " colorscheme
  Plug 'wadackel/vim-dogrun'
  " statusline
  Plug 'famiu/feline.nvim'
call plug#end()
