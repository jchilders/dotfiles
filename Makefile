.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CONFIG_HOME := $$HOME/.config

# TODO: Use nix instead of make?
# TODO: Use jump instead of make?

##@ Install
install: -macos -homebrew -homebrew-defaults -fonts -ruby -python -cfg -neovim -tmux -zsh -alacritty ## Install all the things

clean: -homebrew-clean -fonts-clean -rvm-clean -neovim-clean -misc-cfg-clean -tmux-clean -zsh-cfg-clean ## Uninstall all the things

cwd := $(shell pwd)
cfg: -git-cfg -zsh-cfg -neovim-cfg -tmux-cfg -alacritty-cfg ## Link configuration files
	stow --restow --target=$$HOME ruby
	stow --restow --target=$(XDG_CONFIG_HOME)/ alacritty
	stow --restow --target=$(XDG_CONFIG_HOME)/ starship

cfg-clean: -git-cfg-clean -misc-cfg-clean -neovim-cfg-clean -tmux-cfg-clean -zsh-cfg-clean -alacritty-cfg-clean ## Unlink all configuration files

##@ Homebrew
homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

homebrew-defaults: ## Install default homebrew formulae
	-brew install bat exa fd fzf git git-delta gpg just python rg rust starship stow tldr toilet
	-brew install olets/tap/zsh-abbr
	-brew install docker docker-compose

##@ Neovim
neovim: -neovim-bulid -neovim-cfg -neovim-plugins ## Install Neovim, configurations, & plugins

neovim-clean: -neovim-cfg-clean ## Uninstall Neovim, configurations, & plugins
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim
	-brew unlink neovim

# Have to build from source rather than just doing 'brew install neovim --HEAD`
# because of an issue with upstream luajit. See:
# https://github.com/neovim/neovim/issues/13529#issuecomment-744375133
neovim-bulid: ## Build and install neovim nightly from source
ifeq (, $(shell which cmake))
	$(shell brew install cmake)
endif
ifeq (, $(shell which automake))
	$(shell brew install automake)
endif
	@if [ -d $(NEOVIM_SRC_DIR) ]; then \
		git -C $(NEOVIM_SRC_DIR) pull; \
	else; \
	  git clone https://github.com/neovim/neovim.git $(NEOVIM_SRC_DIR); \
	fi; \
	$(MAKE) -C $(NEOVIM_SRC_DIR) distclean
	$(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo; \
	sudo $(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_INSTALL_PREFIX=/usr/local install; \

neovim-cfg: ## Link neovim configuration files
	@if [ ! -d $(NEOVIM_CFG_DIR) ]; then \
	  mkdir $(NEOVIM_CFG_DIR); \
	fi; \
	stow --restow --target=$(NEOVIM_CFG_DIR) nvim

neovim-cfg-clean: ## Unlink neovim configuration files
	stow --target=$(NEOVIM_CFG_DIR) --delete nvim

neovim-plugins: neovim-cfg ## Install neovim plugins
	sh -c 'curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim --headless -u $(NEOVIM_CFG_DIR)/config/plugs.vim +PlugInstall +UpdateRemotePlugins +qa

##@ Alacritty
alacritty: alacritty-cfg ## Install Alacritty terminal emulator
	brew install alacritty # fast
	stow --target=$(XDG_CONFIG_HOME)/ alacritty

alacritty-clean: alacritty-cfg-clean ## Remove Alacritty terminal emulator
	brew uninstall alacritty

alacritty-cfg: ## Link Alacritty configuration files
	stow --target=$(XDG_CONFIG_HOME)/ alacritty

alacritty-cfg-clean: ## Unlink Alacritty configuration files
	stow --target=$(XDG_CONFIG_HOME)/ --delete alacritty

NEOVIM_SRC_DIR := "$$HOME/workspace/neovim"
NEOVIM_CFG_DIR := "$(XDG_CONFIG_HOME)/nvim"

##@ Languages
ruby: -rvm ## Install Ruby-related items

rvm: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails ; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi
	if [[ ! -f $$HOME/.rvm/gemsets/default.gems ]]; then \
	  cp $(cwd)/default.gems $$HOME/.rvm/gemsets/default.gems; \
	else; \
	  cat $(cwd)/default.gems >> $$HOME/.rvm/gemsets/default.gems; \
	fi; \

rvm-clean: ## Uninstall Ruby Version Manager
	rvm implode

python: -python-packages ## Install Python-related items

# The pynvim package is needed by the vim-ultest plugin
python-packages: ## Install Python packages
	-python3 -m pip install --user --upgrade pynvim

##@ tmux
tmux: -tmux-cfg -tmux-plugins ## Install & configure tmux
	brew install tmux

tmux-clean: -tmux-cfg-clean ## Uninstall tmux & configuration files
	-brew uninstall tmux tmuxinator
	-rm -rf ~/.tmux

tmux-cfg: ## Link tmux configuration files
	@if [ ! -d $(XDG_CONFIG_HOME)/tmux ]; then \
	  mkdir $(XDG_CONFIG_HOME)/tmux; \
	fi; \
	stow --restow --target=$(XDG_CONFIG_HOME)/tmux tmux

tmux-cfg-clean: ## Unlink tmux configuration files
	stow --target=$(XDG_CONFIG_HOME)/tmux --delete tmux

tmux-plugins: ## Install plugin manager and other related items
	@if [ ! -d $$HOME/.tmux ]; then \
	  mkdir $$HOME/.tmux; \
	fi; \
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	brew install tmuxinator

##@ zsh
zsh: -zsh-cfg ## Install zsh-related items

zsh-cfg: ## Link zsh configuration files
	ln -s $(cwd)/.zshenv $$HOME/.zshenv
	stow --restow --target=$(XDG_CONFIG_HOME)/zsh zsh

zsh-cfg-clean: ## Unlink zsh configuration files
	stow --target=$(XDG_CONFIG_HOME)/zsh --delete zsh
	-rm $$HOME/.zshenv

##@ Misc
macos: ## Set macOS defaults and install command line developer tools
  ifeq ($(shell uname -s), Darwin)
	-xcode-select --install
	./macos
  endif

fonts: ## Install fonts
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip
	## We are using this font with toilet banner generator tool
	cp cosmic.flf /usr/local/Cellar/toilet/0.3/share/figlet

fonts-clean: ## Uninstall fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf
	rm /usr/local/Cellar/toilet/0.3/share/figlet/cosmic.flf

git-cfg: ## Link git configuration files
	stow --restow --target=$$HOME git

git-cfg-clean: ## Unlink git configuration files
	-stow --target=$$HOME --delete git

misc-cfg-clean: ## Unlink misc configs
	stow --target=$$HOME --delete ruby
	stow --target=$(XDG_CONFIG_HOME) --delete starship
	stow --target=$(XDG_CONFIG_HOME) --delete alacritty

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
