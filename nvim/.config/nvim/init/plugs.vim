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
Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'bash install.sh',
	\ }
" Plug 'benmills/vimux'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'           " fish syntax highlighting
Plug 'darfink/vim-plist'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'kassio/neoterm'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'TaDaa/vimade'           " fade inactive windows
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
call plug#end()
