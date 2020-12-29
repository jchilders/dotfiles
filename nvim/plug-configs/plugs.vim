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
	Plug 'dag/vim-fish'           " fish syntax highlighting
	Plug 'darfink/vim-plist'
	Plug 'ervandew/supertab'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'kassio/neoterm'
	Plug 'TaDaa/vimade'           " fade inactive windows
	Plug 'scrooloose/nerdcommenter'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rails'
	Plug 'RRethy/vim-illuminate'  " highlight word under cursor

	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-lua/diagnostic-nvim'

	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'etordera/deoplete-ruby'

	" Plug 'nvim-treesitter/nvim-treesitter'
	" Plug 'nvim-treesitter/nvim-treesitter-refactor'
call plug#end()
