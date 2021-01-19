.DEFAULT_GOAL:=help
SHELL:=/bin/zsh

##@ Install

.PHONY: install

install: -macos -homebrew -default-formula -nerd -ruby -stow -neovim ## Install all the things

macos: ## macOS-specific pieces
	-xcode-select --install
	./macos

homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

default-formula: ## Install default homebrew formulae
	brew install bat exa git gpg fd fzf rg git-delta starship stow tree tmux
	brew install olets/tap/zsh-abbr

nerd: ## Install nerd font (Needed for prompt)
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip

neovim: -neovim-install -neovim-plugs ## Install NeoVim & plugins

NEOVIM_SRC_DIR = "$$HOME/workspace/neovim"

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
	$(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo; \
	sudo $(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_INSTALL_PREFIX=/usr/local install; \
	ln -s /usr/local/bin/nvim /usr/local/bin/vi

neovim-plugs: ## Install neovim plugins
	curl -fLo "$${XDG_CONFIG_HOME:-$$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim --headless +PlugInstall +UpdateRemotePlugins +qa

ruby: -rvm-install -ruby-gems ## Install Ruby-related items

RVM_EXISTS = $(shell which -s rvm &>/dev/null; echo $$?)
rvm-install: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

ruby-gems: ## Install default gems
	rvm gemset use global
	gem install solargraph neovim ripper-tags

# TODO: Use XDG_CONFIG_HOME
# zsh:
#   > test -d $XDG_CONFIG_HOME ; echo $?
#   0
stow: ## Link config files
	stow --restow --target=$$HOME tmux
	stow --restow --target=$$XDG_CONFIG_HOME/nvim nvim
	stow --restow --target=$$HOME git
	stow --restow --target=$$HOME ruby
	stow --restow --target=$$HOME zsh

##@ Clean

.PHONY: clean

clean: -homebrew-clean -nerd-clean -rvm-clean -neovim-clean -misc-clean ## Uninstall all the things

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

rvm-clean: ## Uninstall rvm
	rvm implode
	rm -rf $HOME/.rvm

nerd-clean: ## Uninstall nerd fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf

neovim-clean: ## Uninstall neovim
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim
	brew unlink neovim
	stow --delete --target=$$XDG_CONFIG_HOME/nvim nvim

misc-clean: ## Uninstall misc files
	-rm -rf ~/.gnupg
	-rm -rf ~/.config

##@ Helpers

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
