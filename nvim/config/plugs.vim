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

  " To investigate:::
  " Plug 'nvim-lua/lsp-status.nvim'
  " Plug 'romgrk/barbar.nvim'

"  Plug 'nvim-lua/diagnostic-nvim'
"  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"  Plug 'kassio/neoterm'
"  Plug 'tpope/vim-fugitive'
"  Plug 'tpope/vim-rails'

"  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"  Plug 'junegunn/fzf.vim'

  Plug 'vim-test/vim-test'
  Plug 'rcarriga/vim-ultest'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'embark-theme/vim', { 'as': 'embark' }

  Plug 'scrooloose/nerdcommenter'
  Plug 'AndrewRadev/splitjoin.vim'      " Smart split/join code blocks
  Plug 'adelarsq/vim-matchit'
  Plug 'airblade/vim-gitgutter'
call plug#end()
