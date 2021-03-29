.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CONFIG_HOME := $$HOME/.config

# TODO: Use nix instead of make?
# TODO: Use jump instead of make?

##@ Install

.PHONY: install

install: -macos -homebrew -default-formula -fonts -ruby -python -cfg-all -neovim -tmux -zsh ## Install all the things

cwd := $(shell pwd)
cfg-all: -zsh-cfg -neovim-cfg ## Link configuration files
	stow --restow --target=$$HOME git
	stow --restow --target=$$HOME ruby
	stow --restow --target=$(XDG_CONFIG_HOME)/ alacritty
	stow --restow --target=$(XDG_CONFIG_HOME)/ starship

macos: ## Set macOS defaults and install command line developer tools
  ifeq ($(shell uname -s), Darwin)
	-xcode-select --install
	./macos
  endif

homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

default-formula: ## Install default homebrew formula
	-brew install bat exa fd fzf git git-delta gpg just python rg rust starship stow toilet
	-brew install olets/tap/zsh-abbr
	-brew install docker docker-compose

fonts: ## Install fonts
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip
	## We are using this font with toilet banner generator tool
	cp cosmic.flf /usr/local/Cellar/toilet/0.3/share/figlet

neovim: -neovim-install -neovim-cfg -neovim-plugins ## Install NeoVim & plugins

NEOVIM_SRC_DIR := "$$HOME/workspace/neovim"
NEOVIM_CFG_DIR := "$(XDG_CONFIG_HOME)/nvim"

# Have to build from source rather than just doing 'brew install neovim --HEAD`
# because of an issue with upstream luajit. See:
# https://github.com/neovim/neovim/issues/13529#issuecomment-744375133
neovim-install: ## Install neovim
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

neovim-plugins: neovim-cfg ## Install neovim plugins
	sh -c 'curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim --headless -u $(NEOVIM_CFG_DIR)/config/plugs.vim +PlugInstall +UpdateRemotePlugins +qa

ruby: -rvm-install -ruby-gems ## Install Ruby-related items

rvm-install: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

ruby-gems: ## Install default gems
	rvm gemset use global
	gem install solargraph neovim ripper-tags

python: -python-packages ## Install Python-related items

# The pynvim package is needed by the vim-ultest plugin
python-packages: ## Install Python packages
	-python3 -m pip install --user --upgrade pynvim

tmux: -tmux-cfg -tmux-plugins ## Install tmux
	brew install tmux

tmux-cfg: ## Link tmux configuration files
	@if [ ! -d $(XDG_CONFIG_HOME)/tmux ]; then \
	  mkdir $(XDG_CONFIG_HOME)/tmux; \
	fi; \
	stow --restow --target=$(XDG_CONFIG_HOME)/tmux tmux

tmux-plugins: ## Install plugin manager and other related items
	@if [ ! -d $$HOME/.tmux ]; then \
	  mkdir $$HOME/.tmux; \
	fi; \
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	brew install tmuxinator

zsh: -zsh-cfg ## Install zsh-related items

zsh-cfg: ## Link zsh configuration files
	ln -s $(cwd)/.zshenv $$HOME/.zshenv
	stow --restow --target=$(XDG_CONFIG_HOME)/zsh zsh

##@ Clean

.PHONY: clean

clean: -homebrew-clean -font-clean -rvm-clean -neovim-clean -misc-clean-cfg -tmux-clean -zsh-clean ## Uninstall all the things

clean-all-cfg: -misc-clean-cfg -neovim-clean-cfg -tmux-clean-cfg -zsh-clean-cfg ## Unlink all configuration files

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

rvm-clean: ## Uninstall rvm
	rvm implode
	rm -rf $HOME/.rvm

font-clean: ## Uninstall fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf
	rm /usr/local/Cellar/toilet/0.3/share/figlet/cosmic.flf

neovim-clean: -neovim-clean-cfg ## Uninstall neovim
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim
	-brew unlink neovim

neovim-clean-cfg: ## Unlink neovim configuration files
	stow --target=$(NEOVIM_CFG_DIR) --delete nvim
	
misc-clean-cfg: ## Unlink misc configs
	stow --target=$$HOME git --delete git
	stow --target=$(XDG_CONFIG_HOME) --delete starship
	stow --target=$(XDG_CONFIG_HOME) --delete alacritty

tmux-clean: -tmux-clean-cfg ## Uninstall tmux
	-brew uninstall tmux tmuxinator
	-rm -rf ~/.tmux

tmux-clean-cfg: ## Unlink tmux configuration files
	stow --target=$(XDG_CONFIG_HOME)/tmux --delete tmux

zsh-clean: -zsh-clean-cfg ## Uninstall zsh-related items
	-rm $$HOME/.zshenv

zsh-clean-cfg: ## Unlink zsh configuration files
	stow --target=$(XDG_CONFIG_HOME)/zsh --delete zsh

##@ Helpers

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
