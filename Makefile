.DEFAULT_GOAL:=help
SHELL:=/bin/zsh

##@ Install

.PHONY: install

install: -macos -homebrew -default-formula -fish -nerd -ruby -stow -neovim ## Install all the things

macos: ## macOS-specific pieces
	-xcode-select --install
	./macos

homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

default-formula: ## Install default homebrew formulae
	brew install git tmux gpg ag bat fzf stow tree exa git-delta starship

fish: -fish-install -fish-sh-add -fish-chsh -fisher-install ## Install fish & set default shell

fish-install: ## Install fish shell
	brew install fish

FISH = $(shell which fish)
FISH_IN_ETC = $(shell cat /etc/shells | grep -Fq '$(FISH)'; echo $$?)

fish-sh-add: ## Add fish to /etc/shells
ifneq (0,$(FISH_IN_ETC))
  $(shell which fish | sudo tee -a /etc/shells)
endif
	
fish-chsh: ## Change user's shell to fish
	$(info Changing shell to $(FISH))
	$(shell chsh -s $(FISH))

fisher-install: ## Install fisher plugin manager
	curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
	fish --command 'fisher install jethrokuan/z'
	fish --command 'fisher install jethrokuan/fzf'
	fish --command 'fisher install decors/fish-colored-man'

nerd: ## Install nerd font (Needed for prompt)
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip

neovim: -neovim-install -neovim-plugs ## Install NeoVim & plugins

neovim-install: ## Clone & build neovim from source
	@if [ ! -d "$$HOME/workspace/neovim" ]; then \
	  git clone https://github.com/neovim/neovim.git $$HOME/workspace/neovim; \
	fi; \
	if [[ `which neovim &>/dev/null && $?` != 0 ]]; then \
	  brew install cmake automake; \
	  cd $$HOME/workspace/neovim; \
	  make distclean; \
	  make CMAKE_BUILD_TYPE=RelWithDebInfo; \
	  sudo make CMAKE_INSTALL_PREFIX=/usr/local install; \
	  ln -s /usr/local/bin/nvim /usr/local/bin/vi
	fi

neovim-plugs: ## Install neovim plugins
	nvim --headless +PlugInstall +qa

ruby: -rvm-install -ruby-gems ## Install Ruby-related items

RVM_EXISTS = $(shell which -s rvm &>/dev/null; echo $$?)
rvm-install: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

ruby-gems: ## Install default gems
	gem install solargraph neovim

stow: ## Link config files
	stow -v -R --target=$$HOME tmux
	stow -v -R --target=$$HOME fish
	stow -v -R --target=$$HOME nvim
	stow -v -R --target=$$HOME git
	stow -v -R --target=$$HOME ruby

##@ Clean

.PHONY: clean

clean: -homebrew-rm -nerd-rm -rvm-rm -neovim-rm -misc-rm -fish-clean ## Uninstall all the things

homebrew-rm: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

rvm-rm: ## Uninstall rvm
	rvm implode
	rm -rf $HOME/.rvm

nerd-rm: ## Uninstall nerd fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf

neovim-rm: ## Uninstall neovim
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim

misc-rm: ## Uninstall misc files
	-rm -rf ~/.gnupg
	-rm -rf ~/.config

zsh-chsh: ## Change user's shell to zsh
	chsh -s $(shell which zsh)

fish-rm: ## Remove fish
	brew uninstall fish

fish-sh-rm: ## Remove fish from /etc/shells
	sudo sed -i '' '/fish/d' /etc/shells

fisher-rm: ## Uninstall fisher plugin manager
	rm ~/.config/fish/functions/fisher.fish
	rm -rf ~/.config/fish/fisher_plugins

fish-clean: -fish-rm -fish-sh-rm -zsh-chsh -fisher-rm ## Remove fish & reset default shell

##@ Helpers

.PHONY: help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
